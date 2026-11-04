enum AppointmentStatus {
  pending,
  confirmed,
  completed,
  rejected,
  cancelled;

  static AppointmentStatus fromApi(String value) {
    return switch (value) {
      'CONFIRMED' => confirmed,
      'COMPLETED' => completed,
      'REJECTED' => rejected,
      'CANCELLED' => cancelled,
      _ => pending,
    };
  }

  String get apiValue => name.toUpperCase();

  String get label => switch (this) {
    pending => 'Chờ bác sĩ xác nhận',
    confirmed => 'Đã xác nhận',
    completed => 'Đã hoàn tất',
    rejected => 'Đã từ chối',
    cancelled => 'Đã hủy',
  };
}

class AppointmentSlot {
  const AppointmentSlot({required this.dateTime, required this.available});

  factory AppointmentSlot.fromJson(Map<String, dynamic> json) {
    return AppointmentSlot(
      dateTime: DateTime.parse(json['dateTime'] as String),
      available: json['available'] as bool,
    );
  }

  final DateTime dateTime;
  final bool available;
}

class AppointmentRecord {
  const AppointmentRecord({
    required this.id,
    required this.patientName,
    required this.doctorName,
    required this.specialtyName,
    required this.hospital,
    required this.dateTime,
    required this.status,
    required this.fee,
    this.note,
    this.rejectionReason,
  });

  factory AppointmentRecord.fromJson(Map<String, dynamic> json) {
    return AppointmentRecord(
      id: json['id'] as String,
      patientName: json['patientName'] as String,
      doctorName: json['doctorName'] as String,
      specialtyName: json['specialtyName'] as String,
      hospital: json['hospital'] as String,
      dateTime: DateTime.parse(json['dateTime'] as String),
      status: AppointmentStatus.fromApi(json['status'] as String),
      fee: json['fee'] as int,
      note: json['note'] as String?,
      rejectionReason: json['rejectionReason'] as String?,
    );
  }

  final String id;
  final String patientName;
  final String doctorName;
  final String specialtyName;
  final String hospital;
  final DateTime dateTime;
  final AppointmentStatus status;
  final int fee;
  final String? note;
  final String? rejectionReason;
}

class ApiException implements Exception {
  const ApiException(this.message, {this.statusCode});

  final String message;
  final int? statusCode;

  @override
  String toString() => message;
}
