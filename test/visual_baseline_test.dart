import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:medical_appointment_app/core/design_system/app_theme.dart';
import 'package:medical_appointment_app/features/onboarding/presentation/onboarding_screen.dart';
import 'package:medical_appointment_app/features/patient/presentation/screens/patient_home_screen.dart';

void main() {
  Future<void> setSurface(WidgetTester tester, Size size) async {
    await tester.binding.setSurfaceSize(size);
    addTearDown(() => tester.binding.setSurfaceSize(null));
  }

  Widget app(Widget child) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      home: child,
    );
  }

  PatientHomeScreen home() {
    return PatientHomeScreen(
      onOpenSpecialties: () {},
      onOpenInternalMedicine: () {},
      onOpenProfile: () {},
    );
  }

  testWidgets('onboarding baseline at Figma size', (tester) async {
    await setSurface(tester, const Size(393, 852));
    await tester.pumpWidget(app(OnboardingScreen(onFinished: () {})));
    await tester.pumpAndSettle();

    await expectLater(
      find.byType(OnboardingScreen),
      matchesGoldenFile('goldens/onboarding_393x852.png'),
    );
  });

  testWidgets('patient home at narrow phone size', (tester) async {
    await setSurface(tester, const Size(360, 800));
    await tester.pumpWidget(app(home()));
    await tester.pumpAndSettle();

    await expectLater(
      find.byType(PatientHomeScreen),
      matchesGoldenFile('goldens/patient_home_360x800.png'),
    );
  });

  testWidgets('patient home at large phone size', (tester) async {
    await setSurface(tester, const Size(412, 915));
    await tester.pumpWidget(app(home()));
    await tester.pumpAndSettle();

    await expectLater(
      find.byType(PatientHomeScreen),
      matchesGoldenFile('goldens/patient_home_412x915.png'),
    );
  });

  testWidgets('patient home at tablet width', (tester) async {
    await setSurface(tester, const Size(768, 1024));
    await tester.pumpWidget(app(home()));
    await tester.pumpAndSettle();

    await expectLater(
      find.byType(PatientHomeScreen),
      matchesGoldenFile('goldens/patient_home_768x1024.png'),
    );
  });
}
