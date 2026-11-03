import 'package:flutter_test/flutter_test.dart';
import 'package:medical_appointment_app/main.dart';

void main() {
  testWidgets('shows the Figma sign-in screen', (tester) async {
    await tester.pumpWidget(const MedicalAppointmentApp());

    expect(find.text('Chào mừng trở lại!'), findsOneWidget);
    expect(find.text('Số điện thoại hoặc email'), findsOneWidget);
    expect(find.text('Đăng nhập'), findsOneWidget);
    expect(find.text('Chưa có tài khoản? Đăng ký'), findsOneWidget);
  });

  testWidgets('opens the password recovery flow', (tester) async {
    await tester.pumpWidget(const MedicalAppointmentApp());

    await tester.tap(find.text('Quên mật khẩu?'));
    await tester.pumpAndSettle();

    expect(find.text('Quên mật khẩu'), findsOneWidget);
    expect(find.text('Gửi mã xác thực'), findsOneWidget);
  });

  testWidgets('opens the registration screen', (tester) async {
    await tester.pumpWidget(const MedicalAppointmentApp());

    await tester.tap(find.text('Chưa có tài khoản? Đăng ký'));
    await tester.pumpAndSettle();

    expect(find.text('Tạo tài khoản'), findsOneWidget);
    expect(find.text('Họ và tên'), findsOneWidget);
    expect(find.text('Đăng ký'), findsOneWidget);
  });
}
