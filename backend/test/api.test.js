import assert from 'node:assert/strict';
import { beforeEach, after, test } from 'node:test';
import request from 'supertest';

import { createApp } from '../src/app.js';
import { database } from '../src/lib/database.js';

const app = createApp();

beforeEach(() => {
  database.prepare('DELETE FROM appointments').run();
});

after(() => {
  database.close();
});

test('health and discovery endpoints return demo data', async () => {
  const health = await request(app).get('/health').expect(200);
  assert.equal(health.body.status, 'ok');

  const specialties = await request(app).get('/specialties').expect(200);
  assert.ok(specialties.body.length >= 3);

  const doctors = await request(app).get('/doctors?specialtyId=noi-khoa').expect(200);
  assert.equal(doctors.body[0].id, 'doc-nguyen-van-minh');
});

test('booking starts pending, protects slots, and supports confirmation', async () => {
  const slots = await request(app)
    .get('/doctors/doc-nguyen-van-minh/slots?date=2026-11-05')
    .expect(200);
  assert.ok(slots.body.length > 0);

  const payload = {
    patientId: 'patient-tuan-tu',
    doctorId: 'doc-nguyen-van-minh',
    dateTime: slots.body[0].dateTime,
    note: 'Đau bụng nhẹ sau bữa ăn.',
  };
  const created = await request(app).post('/appointments').send(payload).expect(201);
  assert.equal(created.body.status, 'PENDING');

  await request(app).post('/appointments').send(payload).expect(409);

  const confirmed = await request(app)
    .patch(`/appointments/${created.body.id}/status`)
    .send({ status: 'CONFIRMED' })
    .expect(200);
  assert.equal(confirmed.body.status, 'CONFIRMED');
});

test('rejecting an appointment requires a reason', async () => {
  const created = await request(app)
    .post('/appointments')
    .send({
      patientId: 'patient-tuan-tu',
      doctorId: 'doc-nguyen-van-minh',
      dateTime: '2026-11-06T08:00:00.000Z',
    })
    .expect(201);

  await request(app)
    .patch(`/appointments/${created.body.id}/status`)
    .send({ status: 'REJECTED' })
    .expect(400);
});
