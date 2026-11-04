# MediCare+ Appointment API

Backend MVP cho luồng đặt lịch thật. Các module thanh toán, chat, video, AI và báo cáo vẫn là mock ở Flutter.

## Khởi động

```bash
cd backend
cp .env.example .env
npm install
npm run db:setup
npm run dev
```

API chạy tại `http://127.0.0.1:3000`. Kiểm tra bằng:

```bash
curl http://127.0.0.1:3000/health
```

## Endpoint MVP

- `GET /specialties`
- `GET /doctors?specialtyId=noi-khoa`
- `GET /doctors/:id`
- `GET /doctors/:id/slots?date=2026-11-05`
- `POST /appointments`
- `GET /appointments?patientId=patient-tuan-tu`
- `GET /appointments?doctorId=doc-nguyen-van-minh&status=PENDING`
- `PATCH /appointments/:id/status`

Trạng thái hợp lệ: `PENDING -> CONFIRMED|REJECTED|CANCELLED`, `CONFIRMED -> COMPLETED|CANCELLED`.

## Chạy Flutter

Web dùng localhost mặc định:

```bash
flutter run -d chrome --dart-define=API_BASE_URL=http://127.0.0.1:3000
```

Thiết bị Android thật cần chuyển tiếp cổng trước khi chạy:

```bash
adb reverse tcp:3000 tcp:3000
flutter run --dart-define=API_BASE_URL=http://127.0.0.1:3000
```
