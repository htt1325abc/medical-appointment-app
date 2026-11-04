import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:medical_appointment_app/core/design_system/app_theme.dart';
import 'package:medical_appointment_app/core/models/appointment.dart';
import 'package:medical_appointment_app/data/repositories/appointment_repository.dart';
import 'package:medical_appointment_app/features/doctor/presentation/screens/doctor_appointments_api_screen.dart';
import 'package:medical_appointment_app/features/patient/presentation/screens/booking_flow_screen.dart';

void main() {
  Widget app(Widget child) => MaterialApp(theme: AppTheme.light, home: child);

  testWidgets('patient creates a pending appointment', (tester) async {
    await tester.binding.setSurfaceSize(const Size(393, 852));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    final repository = _FakeAppointmentRepository();
    await tester.pumpWidget(
      app(
        BookingFlowScreen(
          repository: repository,
          initialDate: DateTime(2026, 11, 5),
          onBack: () {},
          onViewAppointments: () {},
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('T2'), findsOneWidget);
    expect(find.text('T3'), findsOneWidget);
    await tester.tap(find.text('08:00'));
    await tester.pump();
    await tester.tap(find.text('Kiểm tra thông tin'));
    await tester.pumpAndSettle();
    expect(find.text('Huỳnh Tuấn Tú'), findsOneWidget);

    await tester.tap(find.text('Gửi yêu cầu đặt lịch'));
    await tester.pumpAndSettle();

    expect(repository.created, isTrue);
    expect(find.text('Đã gửi yêu cầu đặt lịch'), findsOneWidget);
    expect(find.text('Chờ bác sĩ xác nhận'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('doctor confirms a pending appointment', (tester) async {
    await tester.binding.setSurfaceSize(const Size(393, 852));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    final repository = _FakeAppointmentRepository();
    await tester.pumpWidget(
      app(DoctorAppointmentsApiScreen(repository: repository, onBack: () {})),
    );
    await tester.pumpAndSettle();

    expect(find.text('Huỳnh Tuấn Tú'), findsOneWidget);
    await tester.tap(find.text('Xác nhận lịch khám'));
    await tester.pumpAndSettle();

    expect(repository.updatedStatus, AppointmentStatus.confirmed);
    expect(
      find.text('Không có yêu cầu nào đang chờ xác nhận.'),
      findsOneWidget,
    );
    expect(tester.takeException(), isNull);
  });
}

class _FakeAppointmentRepository implements AppointmentRepository {
  bool created = false;
  AppointmentStatus? updatedStatus;

  final pending = AppointmentRecord(
    id: 'appointment-demo',
    patientName: 'Huỳnh Tuấn Tú',
    doctorName: 'BS. Nguyễn Văn Minh',
    specialtyName: 'Nội khoa',
    hospital: 'Bệnh viện Đà Nẵng',
    dateTime: DateTime.utc(2026, 11, 5, 8),
    status: AppointmentStatus.pending,
    fee: 300000,
  );

  @override
  Future<AppointmentRecord> create({
    required String patientId,
    required String doctorId,
    required DateTime dateTime,
    String? note,
  }) async {
    created = true;
    return pending;
  }

  @override
  Future<List<AppointmentRecord>> forDoctor(
    String doctorId, {
    AppointmentStatus? status,
  }) async {
    return updatedStatus == null ? [pending] : [];
  }

  @override
  Future<List<AppointmentRecord>> forPatient(String patientId) async {
    return [pending];
  }

  @override
  Future<List<AppointmentSlot>> getSlots(String doctorId, DateTime date) async {
    return [
      AppointmentSlot(
        dateTime: DateTime.utc(date.year, date.month, date.day, 8),
        available: true,
      ),
      AppointmentSlot(
        dateTime: DateTime.utc(date.year, date.month, date.day, 9, 30),
        available: false,
      ),
    ];
  }

  @override
  Future<AppointmentRecord> updateStatus(
    String appointmentId,
    AppointmentStatus status, {
    String? rejectionReason,
  }) async {
    updatedStatus = status;
    return AppointmentRecord(
      id: pending.id,
      patientName: pending.patientName,
      doctorName: pending.doctorName,
      specialtyName: pending.specialtyName,
      hospital: pending.hospital,
      dateTime: pending.dateTime,
      status: status,
      fee: pending.fee,
    );
  }
}
