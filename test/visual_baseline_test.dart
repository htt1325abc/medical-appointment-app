import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:medical_appointment_app/core/design_system/app_theme.dart';
import 'package:medical_appointment_app/data/mock_data/feature_screen_catalog.dart';
import 'package:medical_appointment_app/features/onboarding/presentation/onboarding_screen.dart';
import 'package:medical_appointment_app/features/patient/presentation/screens/patient_home_screen.dart';
import 'package:medical_appointment_app/features/shared/presentation/feature_preview_screen.dart';

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
      onOpenBooking: () {},
      onOpenConsultation: () {},
      onOpenHealthRecord: () {},
      onOpenAppointments: () {},
      onOpenNotifications: () {},
      onOpenProfile: () {},
      onOpenCatalog: () {},
    );
  }

  Widget feature(String id) {
    return FeaturePreviewScreen(
      spec: FeatureScreenCatalog.find(id)!,
      onOpenScreen: (_) {},
      onOpenCatalog: () {},
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

  testWidgets('patient booking baseline at Figma size', (tester) async {
    await setSurface(tester, const Size(393, 852));
    await tester.pumpWidget(app(feature('P15')));
    await tester.pumpAndSettle();

    await expectLater(
      find.byType(FeaturePreviewScreen),
      matchesGoldenFile('goldens/patient_booking_393x852.png'),
    );
  });

  testWidgets('doctor dashboard baseline at Figma size', (tester) async {
    await setSurface(tester, const Size(393, 852));
    await tester.pumpWidget(app(feature('D03')));
    await tester.pumpAndSettle();

    await expectLater(
      find.byType(FeaturePreviewScreen),
      matchesGoldenFile('goldens/doctor_dashboard_393x852.png'),
    );
  });

  testWidgets('admin dashboard baseline at desktop width', (tester) async {
    await setSurface(tester, const Size(1280, 900));
    await tester.pumpWidget(app(feature('A01')));
    await tester.pumpAndSettle();

    await expectLater(
      find.byType(FeaturePreviewScreen),
      matchesGoldenFile('goldens/admin_dashboard_1280x900.png'),
    );
  });
}
