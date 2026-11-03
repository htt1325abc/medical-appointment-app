import 'package:flutter_test/flutter_test.dart';
import 'package:medical_appointment_app/main.dart';

void main() {
  testWidgets('shows the initial patient welcome experience', (tester) async {
    await tester.pumpWidget(const MedicalAppointmentApp());

    expect(find.text('MediPath'), findsOneWidget);
    expect(find.text('Bắt đầu đặt lịch'), findsOneWidget);
    expect(find.text('Tôi đã có tài khoản'), findsOneWidget);
  });
}
