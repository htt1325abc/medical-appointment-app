import { randomUUID } from 'node:crypto';

import cors from 'cors';
import express from 'express';
import { z } from 'zod';

import { database } from './lib/database.js';

const appointmentStatuses = [
  'PENDING',
  'CONFIRMED',
  'COMPLETED',
  'REJECTED',
  'CANCELLED',
];

const allowedTransitions = {
  PENDING: ['CONFIRMED', 'REJECTED', 'CANCELLED'],
  CONFIRMED: ['COMPLETED', 'CANCELLED'],
  COMPLETED: [],
  REJECTED: [],
  CANCELLED: [],
};

const createAppointmentSchema = z.object({
  patientId: z.string().min(1),
  doctorId: z.string().min(1),
  dateTime: z.string().datetime(),
  note: z.string().trim().max(500).optional(),
});

const updateStatusSchema = z.object({
  status: z.enum(appointmentStatuses),
  rejectionReason: z.string().trim().min(3).max(300).optional(),
});

export function createApp() {
  const app = express();
  app.use(cors());
  app.use(express.json());

  app.get('/health', (_request, response) => {
    response.json({ status: 'ok', service: 'medicare-appointment-api' });
  });

  app.get('/specialties', (_request, response, next) => {
    try {
      const specialties = database.prepare(`
        SELECT s.id, s.name, s.description, COUNT(d.id) AS doctorCount
        FROM specialties s
        LEFT JOIN doctors d ON d.specialty_id = s.id
        GROUP BY s.id
        ORDER BY s.name ASC
      `).all();
      response.json(specialties);
    } catch (error) {
      next(error);
    }
  });

  app.get('/doctors', (request, response, next) => {
    try {
      const specialtyId = request.query.specialtyId?.toString();
      const where = specialtyId ? 'WHERE d.specialty_id = ?' : '';
      const doctors = database.prepare(`
        SELECT d.id, d.name, d.hospital,
          d.experience_years AS experienceYears,
          d.rating, d.review_count AS reviewCount, d.fee,
          s.id AS specialtyId, s.name AS specialtyName
        FROM doctors d
        JOIN specialties s ON s.id = d.specialty_id
        ${where}
        ORDER BY d.rating DESC, d.name ASC
      `).all(...(specialtyId ? [specialtyId] : []));
      response.json(doctors);
    } catch (error) {
      next(error);
    }
  });

  app.get('/doctors/:id', (request, response, next) => {
    try {
      const doctor = findDoctor(request.params.id);
      if (!doctor) return response.status(404).json({ message: 'Không tìm thấy bác sĩ.' });
      return response.json(doctor);
    } catch (error) {
      return next(error);
    }
  });

  app.get('/doctors/:id/slots', (request, response, next) => {
    try {
      const date = request.query.date?.toString();
      if (!date || !/^\d{4}-\d{2}-\d{2}$/.test(date)) {
        return response.status(400).json({ message: 'Ngày khám phải có định dạng YYYY-MM-DD.' });
      }
      const dayStart = new Date(`${date}T00:00:00.000Z`);
      if (Number.isNaN(dayStart.getTime())) {
        return response.status(400).json({ message: 'Ngày khám không hợp lệ.' });
      }
      const schedule = database.prepare(`
        SELECT start_time AS startTime, end_time AS endTime,
          slot_duration_min AS slotDurationMin
        FROM doctor_schedules
        WHERE doctor_id = ? AND weekday = ? AND enabled = 1
      `).get(request.params.id, dayStart.getUTCDay());
      if (!schedule) return response.json([]);

      const bookedRows = database.prepare(`
        SELECT date_time AS dateTime FROM appointments
        WHERE doctor_id = ?
          AND substr(date_time, 1, 10) = ?
          AND status IN ('PENDING', 'CONFIRMED')
      `).all(request.params.id, date);
      const booked = new Set(bookedRows.map((item) => item.dateTime));
      const slots = buildSlots(date, schedule).map((dateTime) => ({
        dateTime,
        available: !booked.has(dateTime),
      }));
      return response.json(slots);
    } catch (error) {
      return next(error);
    }
  });

  app.post('/appointments', (request, response, next) => {
    try {
      const input = createAppointmentSchema.parse(request.body);
      const doctor = findDoctor(input.doctorId);
      const patient = database.prepare('SELECT id, name, role FROM users WHERE id = ?').get(input.patientId);
      if (!doctor || !patient) {
        return response.status(404).json({ message: 'Không tìm thấy bác sĩ hoặc bệnh nhân.' });
      }

      const now = new Date().toISOString();
      const id = randomUUID();
      try {
        database.prepare(`
          INSERT INTO appointments (
            id, patient_id, doctor_id, date_time, status, note, created_at, updated_at
          ) VALUES (?, ?, ?, ?, 'PENDING', ?, ?, ?)
        `).run(id, input.patientId, input.doctorId, input.dateTime, input.note ?? null, now, now);
      } catch (error) {
        if (error.code === 'SQLITE_CONSTRAINT_UNIQUE') {
          return response.status(409).json({ message: 'Khung giờ này vừa được đặt. Vui lòng chọn giờ khác.' });
        }
        throw error;
      }
      return response.status(201).json(findAppointment(id));
    } catch (error) {
      if (error instanceof z.ZodError) {
        return response.status(400).json({ message: 'Thông tin lịch hẹn chưa hợp lệ.', issues: error.issues });
      }
      return next(error);
    }
  });

  app.get('/appointments', (request, response, next) => {
    try {
      const clauses = [];
      const values = [];
      for (const [queryName, column] of [
        ['patientId', 'a.patient_id'],
        ['doctorId', 'a.doctor_id'],
        ['status', 'a.status'],
      ]) {
        const value = request.query[queryName]?.toString();
        if (value) {
          clauses.push(`${column} = ?`);
          values.push(value);
        }
      }
      const where = clauses.length ? `WHERE ${clauses.join(' AND ')}` : '';
      const appointments = database.prepare(`${appointmentSelect} ${where} ORDER BY a.date_time ASC`).all(...values);
      response.json(appointments);
    } catch (error) {
      next(error);
    }
  });

  app.get('/appointments/:id', (request, response, next) => {
    try {
      const appointment = findAppointment(request.params.id);
      if (!appointment) return response.status(404).json({ message: 'Không tìm thấy lịch hẹn.' });
      return response.json(appointment);
    } catch (error) {
      return next(error);
    }
  });

  app.patch('/appointments/:id/status', (request, response, next) => {
    try {
      const input = updateStatusSchema.parse(request.body);
      const current = findAppointment(request.params.id);
      if (!current) return response.status(404).json({ message: 'Không tìm thấy lịch hẹn.' });
      if (!allowedTransitions[current.status]?.includes(input.status)) {
        return response.status(409).json({ message: `Không thể chuyển từ ${current.status} sang ${input.status}.` });
      }
      if (input.status === 'REJECTED' && !input.rejectionReason) {
        return response.status(400).json({ message: 'Vui lòng nhập lý do từ chối.' });
      }
      database.prepare(`
        UPDATE appointments
        SET status = ?, rejection_reason = ?, updated_at = ?
        WHERE id = ?
      `).run(
        input.status,
        input.status === 'REJECTED' ? input.rejectionReason : null,
        new Date().toISOString(),
        request.params.id,
      );
      return response.json(findAppointment(request.params.id));
    } catch (error) {
      if (error instanceof z.ZodError) {
        return response.status(400).json({ message: 'Trạng thái chưa hợp lệ.', issues: error.issues });
      }
      return next(error);
    }
  });

  app.use((error, _request, response, _next) => {
    console.error(error);
    response.status(500).json({ message: 'Máy chủ gặp lỗi. Vui lòng thử lại.' });
  });

  return app;
}

const appointmentSelect = `
  SELECT a.id, a.patient_id AS patientId, a.doctor_id AS doctorId,
    a.date_time AS dateTime, a.status, a.note,
    a.rejection_reason AS rejectionReason,
    a.created_at AS createdAt, a.updated_at AS updatedAt,
    p.name AS patientName,
    d.name AS doctorName, d.hospital, d.fee,
    s.name AS specialtyName
  FROM appointments a
  JOIN users p ON p.id = a.patient_id
  JOIN doctors d ON d.id = a.doctor_id
  JOIN specialties s ON s.id = d.specialty_id
`;

function findDoctor(id) {
  return database.prepare(`
    SELECT d.id, d.name, d.hospital,
      d.experience_years AS experienceYears,
      d.rating, d.review_count AS reviewCount, d.fee,
      s.id AS specialtyId, s.name AS specialtyName
    FROM doctors d
    JOIN specialties s ON s.id = d.specialty_id
    WHERE d.id = ?
  `).get(id);
}

function findAppointment(id) {
  return database.prepare(`${appointmentSelect} WHERE a.id = ?`).get(id);
}

function buildSlots(date, schedule) {
  const [startHour, startMinute] = schedule.startTime.split(':').map(Number);
  const [endHour, endMinute] = schedule.endTime.split(':').map(Number);
  const cursor = new Date(`${date}T00:00:00.000Z`);
  cursor.setUTCHours(startHour, startMinute, 0, 0);
  const end = new Date(`${date}T00:00:00.000Z`);
  end.setUTCHours(endHour, endMinute, 0, 0);
  const slots = [];
  while (cursor < end) {
    slots.push(cursor.toISOString());
    cursor.setUTCMinutes(cursor.getUTCMinutes() + schedule.slotDurationMin);
  }
  return slots;
}
