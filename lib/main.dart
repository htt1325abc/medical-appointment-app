import 'package:flutter/material.dart';

import 'core/design_system/app_theme.dart';
import 'features/auth/presentation/auth_flow.dart';

void main() {
  runApp(const MedicalAppointmentApp());
}

class MedicalAppointmentApp extends StatelessWidget {
  const MedicalAppointmentApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MediCare+',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      home: const AuthFlow(),
    );
  }
}
