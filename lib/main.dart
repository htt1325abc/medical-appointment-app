import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'core/design_system/app_theme.dart';
import 'core/models/doctor.dart';
import 'data/mock_data/patient_mock_data.dart';
import 'features/auth/presentation/auth_flow.dart';
import 'features/onboarding/presentation/onboarding_screen.dart';
import 'features/onboarding/presentation/splash_screen.dart';
import 'features/patient/presentation/screens/doctor_profile_screen.dart';
import 'features/patient/presentation/screens/internal_medicine_screen.dart';
import 'features/patient/presentation/screens/patient_home_screen.dart';
import 'features/patient/presentation/screens/specialty_search_screen.dart';

void main() {
  runApp(const MedicalAppointmentApp());
}

abstract final class AppRoutes {
  static const splash = '/';
  static const onboarding = '/onboarding';
  static const auth = '/auth';
  static const patientHome = '/patient/home';
  static const specialties = '/patient/specialties';
  static const internalMedicine = '/patient/specialties/internal-medicine';
  static const doctorProfile = '/patient/doctor-profile';
  static const showcase = '/debug/showcase';
}

class MedicalAppointmentApp extends StatelessWidget {
  const MedicalAppointmentApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MediCare+',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      initialRoute: AppRoutes.splash,
      onGenerateRoute: _onGenerateRoute,
    );
  }

  Route<void> _onGenerateRoute(RouteSettings settings) {
    return MaterialPageRoute<void>(
      settings: settings,
      builder: (context) {
        return switch (settings.name) {
          AppRoutes.splash => SplashScreen(
            onFinished: () =>
                Navigator.of(context)
                    .pushReplacementNamed(AppRoutes.onboarding),
          ),
          AppRoutes.onboarding => OnboardingScreen(
            onFinished: () =>
                Navigator.of(context).pushReplacementNamed(AppRoutes.auth),
          ),
          AppRoutes.auth => AuthFlow(
            onSignedIn: () => Navigator.of(context)
                .pushNamedAndRemoveUntil(AppRoutes.patientHome, (_) => false),
          ),
          AppRoutes.patientHome => PatientHomeScreen(
            onOpenSpecialties: () =>
                Navigator.of(context).pushNamed(AppRoutes.specialties),
            onOpenInternalMedicine: () =>
                Navigator.of(context).pushNamed(AppRoutes.internalMedicine),
            onOpenProfile: () => ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Hồ sơ cá nhân sẽ có ở đợt tiếp theo'),
              ),
            ),
          ),
          AppRoutes.specialties => SpecialtySearchScreen(
            onBack: () => Navigator.of(context).pop(),
            onOpenInternalMedicine: () =>
                Navigator.of(context).pushNamed(AppRoutes.internalMedicine),
          ),
          AppRoutes.internalMedicine => InternalMedicineScreen(
            onBack: () => Navigator.of(context).pop(),
            onOpenDoctor: (doctor) =>
                Navigator.of(context)
                    .pushNamed(AppRoutes.doctorProfile, arguments: doctor),
          ),
          AppRoutes.doctorProfile => DoctorProfileScreen(
            doctor: settings.arguments is Doctor
                ? settings.arguments! as Doctor
                : PatientMockData.doctors.first,
            onBack: () => Navigator.of(context).pop(),
            onBook: () => ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Luồng đặt lịch sẽ được triển khai ở Đợt 2'),
              ),
            ),
          ),
          AppRoutes.showcase when kDebugMode => const _DebugShowcaseScreen(),
          _ => const _UnknownRouteScreen(),
        };
      },
    );
  }
}

class _DebugShowcaseScreen extends StatelessWidget {
  const _DebugShowcaseScreen();

  @override
  Widget build(BuildContext context) {
    const entries = <(String, String)>[
      ('01 · Splash', AppRoutes.splash),
      ('02–04 · Onboarding', AppRoutes.onboarding),
      ('05–10 · Xác thực', AppRoutes.auth),
      ('11 · Trang chủ Patient', AppRoutes.patientHome),
      ('12 · Tìm kiếm chuyên khoa', AppRoutes.specialties),
      ('13 · Nội khoa', AppRoutes.internalMedicine),
      ('14 · Hồ sơ bác sĩ', AppRoutes.doctorProfile),
    ];
    return Scaffold(
      appBar: AppBar(title: const Text('MediCare+ screen catalog')),
      body: ListView.separated(
        itemCount: entries.length,
        separatorBuilder: (_, _) => const Divider(height: 1),
        itemBuilder: (context, index) => ListTile(
          title: Text(entries[index].$1),
          trailing: const Icon(Icons.chevron_right_rounded),
          onTap: () => Navigator.of(context).pushNamed(entries[index].$2),
        ),
      ),
    );
  }
}

class _UnknownRouteScreen extends StatelessWidget {
  const _UnknownRouteScreen();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: Text('Không tìm thấy màn hình')));
  }
}
