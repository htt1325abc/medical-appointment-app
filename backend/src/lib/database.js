import fs from 'node:fs';
import path from 'node:path';
import { randomUUID } from 'node:crypto';

import Database from 'better-sqlite3';
import 'dotenv/config';

const databasePath = path.resolve(
  process.cwd(),
  process.env.DATABASE_PATH ?? './data/medicare.db',
);
fs.mkdirSync(path.dirname(databasePath), { recursive: true });

export const database = new Database(databasePath);
database.pragma('foreign_keys = ON');
database.pragma('journal_mode = WAL');

export function initializeDatabase() {
  database.exec(`
    CREATE TABLE IF NOT EXISTS users (
      id TEXT PRIMARY KEY,
      name TEXT NOT NULL,
      role TEXT NOT NULL DEFAULT 'PATIENT'
    );
    CREATE TABLE IF NOT EXISTS specialties (
      id TEXT PRIMARY KEY,
      name TEXT NOT NULL UNIQUE,
      description TEXT NOT NULL
    );
    CREATE TABLE IF NOT EXISTS doctors (
      id TEXT PRIMARY KEY,
      name TEXT NOT NULL,
      hospital TEXT NOT NULL,
      experience_years INTEGER NOT NULL,
      rating REAL NOT NULL,
      review_count INTEGER NOT NULL,
      fee INTEGER NOT NULL,
      specialty_id TEXT NOT NULL REFERENCES specialties(id)
    );
    CREATE TABLE IF NOT EXISTS doctor_schedules (
      id TEXT PRIMARY KEY,
      doctor_id TEXT NOT NULL REFERENCES doctors(id) ON DELETE CASCADE,
      weekday INTEGER NOT NULL,
      start_time TEXT NOT NULL,
      end_time TEXT NOT NULL,
      slot_duration_min INTEGER NOT NULL DEFAULT 30,
      enabled INTEGER NOT NULL DEFAULT 1,
      UNIQUE(doctor_id, weekday)
    );
    CREATE TABLE IF NOT EXISTS appointments (
      id TEXT PRIMARY KEY,
      patient_id TEXT NOT NULL REFERENCES users(id),
      doctor_id TEXT NOT NULL REFERENCES doctors(id),
      date_time TEXT NOT NULL,
      status TEXT NOT NULL DEFAULT 'PENDING',
      note TEXT,
      rejection_reason TEXT,
      created_at TEXT NOT NULL,
      updated_at TEXT NOT NULL,
      UNIQUE(doctor_id, date_time)
    );
    CREATE INDEX IF NOT EXISTS appointments_patient_date_idx
      ON appointments(patient_id, date_time);
    CREATE INDEX IF NOT EXISTS appointments_doctor_status_date_idx
      ON appointments(doctor_id, status, date_time);
  `);
  seedDatabase();
}

function seedDatabase() {
  database.prepare(`
    INSERT INTO users (id, name, role) VALUES (?, ?, 'PATIENT')
    ON CONFLICT(id) DO UPDATE SET name = excluded.name
  `).run('patient-tuan-tu', 'Huỳnh Tuấn Tú');

  const specialtyStatement = database.prepare(`
    INSERT INTO specialties (id, name, description) VALUES (?, ?, ?)
    ON CONFLICT(id) DO UPDATE SET
      name = excluded.name,
      description = excluded.description
  `);
  const specialties = [
    ['noi-khoa', 'Nội khoa', 'Khám và điều trị bệnh lý nội tổng quát'],
    ['tim-mach', 'Tim mạch', 'Theo dõi và điều trị sức khỏe tim mạch'],
    ['nhi-khoa', 'Nhi khoa', 'Chăm sóc sức khỏe trẻ em'],
  ];
  for (const specialty of specialties) specialtyStatement.run(...specialty);

  const doctorStatement = database.prepare(`
    INSERT INTO doctors (
      id, name, hospital, experience_years, rating, review_count, fee, specialty_id
    ) VALUES (@id, @name, @hospital, @experienceYears, @rating, @reviewCount, @fee, @specialtyId)
    ON CONFLICT(id) DO UPDATE SET
      name = excluded.name,
      hospital = excluded.hospital,
      experience_years = excluded.experience_years,
      rating = excluded.rating,
      review_count = excluded.review_count,
      fee = excluded.fee,
      specialty_id = excluded.specialty_id
  `);
  const doctors = [
    {
      id: 'doc-nguyen-van-minh',
      name: 'BS. Nguyễn Văn Minh',
      specialtyId: 'noi-khoa',
      hospital: 'Bệnh viện Đà Nẵng',
      experienceYears: 12,
      rating: 4.9,
      reviewCount: 326,
      fee: 300000,
    },
    {
      id: 'doc-tran-thi-lan',
      name: 'BS. Trần Thị Lan',
      specialtyId: 'tim-mach',
      hospital: 'Bệnh viện Đà Nẵng',
      experienceYears: 10,
      rating: 4.8,
      reviewCount: 248,
      fee: 350000,
    },
  ];
  const scheduleStatement = database.prepare(`
    INSERT INTO doctor_schedules (
      id, doctor_id, weekday, start_time, end_time, slot_duration_min, enabled
    ) VALUES (?, ?, ?, '08:00', '16:00', 90, 1)
    ON CONFLICT(doctor_id, weekday) DO UPDATE SET enabled = 1
  `);
  for (const doctor of doctors) {
    doctorStatement.run(doctor);
    for (let weekday = 1; weekday <= 6; weekday += 1) {
      scheduleStatement.run(randomUUID(), doctor.id, weekday);
    }
  }
}

initializeDatabase();
