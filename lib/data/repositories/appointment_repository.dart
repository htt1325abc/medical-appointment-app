import '../../core/models/appointment.dart';
import '../services/appointment_api_service.dart';

abstract interface class AppointmentRepository {
  Future<List<AppointmentSlot>> getSlots(String doctorId, DateTime date);

  Future<AppointmentRecord> create({
    required String patientId,
    required String doctorId,
    required DateTime dateTime,
    String? note,
  });

  Future<List<AppointmentRecord>> forPatient(String patientId);

  Future<List<AppointmentRecord>> forDoctor(
    String doctorId, {
    AppointmentStatus? status,
  });

  Future<AppointmentRecord> updateStatus(
    String appointmentId,
    AppointmentStatus status, {
    String? rejectionReason,
  });
}

class ApiAppointmentRepository implements AppointmentRepository {
  ApiAppointmentRepository(this._service);

  final AppointmentApiService _service;

  @override
  Future<List<AppointmentSlot>> getSlots(String doctorId, DateTime date) {
    return _service.getSlots(doctorId: doctorId, date: date);
  }

  @override
  Future<AppointmentRecord> create({
    required String patientId,
    required String doctorId,
    required DateTime dateTime,
    String? note,
  }) {
    return _service.createAppointment(
      patientId: patientId,
      doctorId: doctorId,
      dateTime: dateTime,
      note: note,
    );
  }

  @override
  Future<List<AppointmentRecord>> forPatient(String patientId) {
    return _service.getAppointments(patientId: patientId);
  }

  @override
  Future<List<AppointmentRecord>> forDoctor(
    String doctorId, {
    AppointmentStatus? status,
  }) {
    return _service.getAppointments(doctorId: doctorId, status: status);
  }

  @override
  Future<AppointmentRecord> updateStatus(
    String appointmentId,
    AppointmentStatus status, {
    String? rejectionReason,
  }) {
    return _service.updateStatus(
      appointmentId: appointmentId,
      status: status,
      rejectionReason: rejectionReason,
    );
  }
}
