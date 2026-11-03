import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:medical_appointment_app/main.dart';

void main() {
  Future<void> openAuth(WidgetTester tester) async {
    await tester.pumpWidget(const MedicalAppointmentApp());
    await tester.pump(const Duration(milliseconds: 1500));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Bỏ qua'));
    await tester.pumpAndSettle();
  }

  testWidgets('shows splash then the Figma onboarding flow', (tester) async {
    await tester.pumpWidget(const MedicalAppointmentApp());

    expect(find.text('MediCare+'), findsOneWidget);
    expect(find.text('Sức khỏe hôm nay\nCuộc sống ngày mai'), findsOneWidget);

    await tester.pump(const Duration(milliseconds: 1500));
    await tester.pumpAndSettle();

    expect(find.text('Đặt lịch khám dễ dàng'), findsOneWidget);
    expect(find.text('Bỏ qua'), findsOneWidget);
  });

  testWidgets('shows the Figma sign-in screen', (tester) async {
    await openAuth(tester);

    expect(find.text('Chào mừng trở lại!'), findsOneWidget);
    expect(find.text('Số điện thoại hoặc email'), findsOneWidget);
    expect(find.text('Đăng nhập'), findsOneWidget);
    expect(find.text('Chưa có tài khoản? Đăng ký'), findsOneWidget);
  });

  testWidgets('opens the password recovery flow', (tester) async {
    await openAuth(tester);

    await tester.tap(find.text('Quên mật khẩu?'));
    await tester.pumpAndSettle();

    expect(find.text('Quên mật khẩu'), findsOneWidget);
    expect(find.text('Gửi mã xác thực'), findsOneWidget);
  });

  testWidgets('opens the registration screen', (tester) async {
    await openAuth(tester);

    await tester.tap(find.text('Chưa có tài khoản? Đăng ký'));
    await tester.pumpAndSettle();

    expect(find.text('Tạo tài khoản'), findsOneWidget);
    expect(find.text('Họ và tên'), findsOneWidget);
    expect(find.text('Đăng ký'), findsOneWidget);
  });

  testWidgets('signs in with mock data and opens patient discovery', (
    tester,
  ) async {
    await openAuth(tester);

    final fields = find.byType(TextFormField);
    await tester.enterText(fields.at(0), 'ly@example.com');
    await tester.enterText(fields.at(1), 'password123');
    await tester.tap(find.text('Đăng nhập'));
    await tester.pumpAndSettle();

    expect(find.text('Xin chào, Huỳnh Tuấn Tú'), findsOneWidget);
    expect(find.text('Chuyên khoa phổ biến'), findsOneWidget);

    await tester.tap(find.text('Nội khoa').first);
    await tester.pumpAndSettle();

    expect(find.text('BS. Nguyễn Văn Minh'), findsOneWidget);
    expect(find.text('Còn lịch trống'), findsNWidgets(4));
  });
}
