import 'package:flutter/material.dart';

import 'core/design_system/app_theme.dart';
import 'core/models/doctor.dart';
import 'data/mock_data/feature_screen_catalog.dart';
import 'data/mock_data/patient_mock_data.dart';
import 'data/repositories/appointment_repository.dart';
import 'data/services/appointment_api_service.dart';
import 'features/auth/presentation/auth_flow.dart';
import 'features/doctor/presentation/screens/doctor_appointments_api_screen.dart';
import 'features/onboarding/presentation/onboarding_screen.dart';
import 'features/onboarding/presentation/splash_screen.dart';
import 'features/patient/presentation/screens/booking_flow_screen.dart';
import 'features/patient/presentation/screens/doctor_profile_screen.dart';
import 'features/patient/presentation/screens/internal_medicine_screen.dart';
import 'features/patient/presentation/screens/patient_appointments_api_screen.dart';
import 'features/patient/presentation/screens/patient_home_screen.dart';
import 'features/patient/presentation/screens/specialty_search_screen.dart';
import 'features/shared/presentation/feature_preview_screen.dart';
import 'features/shared/presentation/screen_catalog_screen.dart';

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
  static const bookingApi = '/patient/booking-api';
  static const patientAppointmentsApi = '/patient/appointments-api';
  static const doctorAppointmentsApi = '/doctor/appointments-api';
  static const featurePreview = '/feature/preview';
  static const showcase = '/screen-catalog';
}

class MedicalAppointmentApp extends StatelessWidget {
  const MedicalAppointmentApp({super.key});

  static final AppointmentRepository _appointmentRepository =
      ApiAppointmentRepository(AppointmentApiService());

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
            onOpenBooking: () =>
                Navigator.of(context).pushNamed(AppRoutes.bookingApi),
            onOpenConsultation: () => _openFeature(context, 'P21'),
            onOpenHealthRecord: () => _openFeature(context, 'P27'),
            onOpenAppointments: () =>
                Navigator.of(context)
                    .pushNamed(AppRoutes.patientAppointmentsApi),
            onOpenNotifications: () => _openFeature(context, 'P34'),
            onOpenProfile: () => _openFeature(context, 'P36'),
            onOpenCatalog: () =>
                Navigator.of(context).pushNamed(AppRoutes.showcase),
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
            onBook: () => Navigator.of(context).pushNamed(AppRoutes.bookingApi),
          ),
          AppRoutes.bookingApi => BookingFlowScreen(
            repository: _appointmentRepository,
            onBack: () => Navigator.of(context).pop(),
            onViewAppointments: () =>
                Navigator.of(context)
                    .pushReplacementNamed(AppRoutes.patientAppointmentsApi),
          ),
          AppRoutes.patientAppointmentsApi => PatientAppointmentsApiScreen(
            repository: _appointmentRepository,
            onBack: () => Navigator.of(context).pop(),
            onBook: () => Navigator.of(context).pushNamed(AppRoutes.bookingApi),
          ),
          AppRoutes.doctorAppointmentsApi => DoctorAppointmentsApiScreen(
            repository: _appointmentRepository,
            onBack: () => Navigator.of(context).pop(),
          ),
          AppRoutes.featurePreview => _buildFeaturePreview(context, settings),
          AppRoutes.showcase => ScreenCatalogScreen(
            onOpenScreen: (id) => _openFeature(context, id),
            onOpenExisting: (route) => Navigator.of(context).pushNamed(route),
          ),
          _ => const _UnknownRouteScreen(),
        };
      },
    );
  }

  Widget _buildFeaturePreview(BuildContext context, RouteSettings settings) {
    final spec = FeatureScreenCatalog.find(settings.arguments as String?);
    if (spec == null) return const _UnknownRouteScreen();
    return FeaturePreviewScreen(
      spec: spec,
      onOpenScreen: (id) => _openFeature(context, id),
      onOpenCatalog: () => Navigator.of(context).pushNamed(AppRoutes.showcase),
    );
  }

  void _openFeature(BuildContext context, String id) {
    if (id == 'P15') {
      Navigator.of(context).pushNamed(AppRoutes.bookingApi);
      return;
    }
    if (id == 'P20') {
      Navigator.of(context).pushNamed(AppRoutes.patientAppointmentsApi);
      return;
    }
    if (id == 'D04' || id == 'D06') {
      Navigator.of(context).pushNamed(AppRoutes.doctorAppointmentsApi);
      return;
    }
    Navigator.of(context).pushNamed(AppRoutes.featurePreview, arguments: id);
  }
}

class _UnknownRouteScreen extends StatelessWidget {
  const _UnknownRouteScreen();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: Text('Không tìm thấy màn hình')));
  }
}
