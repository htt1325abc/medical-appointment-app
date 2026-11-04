import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../core/config/api_config.dart';
import '../../core/models/appointment.dart';

class AppointmentApiService {
  AppointmentApiService({http.Client? client})
    : _client = client ?? http.Client();

  final http.Client _client;

  Future<List<AppointmentSlot>> getSlots({
    required String doctorId,
    required DateTime date,
  }) async {
    final response = await _client.get(
      _uri('/doctors/$doctorId/slots', {'date': _apiDate(date)}),
    );
    final data = _decode(response);
    return (data as List<dynamic>)
        .map((item) => AppointmentSlot.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  Future<AppointmentRecord> createAppointment({
    required String patientId,
    required String doctorId,
    required DateTime dateTime,
    String? note,
  }) async {
    final body = <String, dynamic>{
      'patientId': patientId,
      'doctorId': doctorId,
      'dateTime': dateTime.toUtc().toIso8601String(),
    };
    if (note != null && note.trim().isNotEmpty) {
      body['note'] = note.trim();
    }
    final response = await _client.post(
      _uri('/appointments'),
      headers: const {'content-type': 'application/json'},
      body: jsonEncode(body),
    );
    return AppointmentRecord.fromJson(
      _decode(response) as Map<String, dynamic>,
    );
  }

  Future<List<AppointmentRecord>> getAppointments({
    String? patientId,
    String? doctorId,
    AppointmentStatus? status,
  }) async {
    final query = <String, String>{};
    if (patientId != null) query['patientId'] = patientId;
    if (doctorId != null) query['doctorId'] = doctorId;
    if (status != null) query['status'] = status.apiValue;
    final response = await _client.get(_uri('/appointments', query));
    final data = _decode(response) as List<dynamic>;
    return data
        .map((item) => AppointmentRecord.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  Future<AppointmentRecord> updateStatus({
    required String appointmentId,
    required AppointmentStatus status,
    String? rejectionReason,
  }) async {
    final body = <String, dynamic>{'status': status.apiValue};
    if (rejectionReason != null) {
      body['rejectionReason'] = rejectionReason;
    }
    final response = await _client.patch(
      _uri('/appointments/$appointmentId/status'),
      headers: const {'content-type': 'application/json'},
      body: jsonEncode(body),
    );
    return AppointmentRecord.fromJson(
      _decode(response) as Map<String, dynamic>,
    );
  }

  dynamic _decode(http.Response response) {
    final data = response.body.isEmpty ? null : jsonDecode(response.body);
    if (response.statusCode >= 200 && response.statusCode < 300) return data;
    final message = data is Map<String, dynamic>
        ? data['message'] as String? ?? 'Không thể kết nối máy chủ.'
        : 'Không thể kết nối máy chủ.';
    throw ApiException(message, statusCode: response.statusCode);
  }

  Uri _uri(String path, [Map<String, String>? query]) {
    return Uri.parse('${ApiConfig.baseUrl}$path')
        .replace(queryParameters: query);
  }
}

String _apiDate(DateTime date) {
  String two(int value) => value.toString().padLeft(2, '0');
  return '${date.year}-${two(date.month)}-${two(date.day)}';
}
