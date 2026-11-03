import 'package:flutter/material.dart';

void main() {
  runApp(const MedicalAppointmentApp());
}

class AppColors {
  const AppColors._();

  static const ink = Color(0xFF12312B);
  static const care = Color(0xFF1F7A68);
  static const mint = Color(0xFFDFF3EC);
  static const apricot = Color(0xFFFFB86B);
  static const cloud = Color(0xFFF7FAF9);
  static const danger = Color(0xFFC94A4A);
}

class MedicalAppointmentApp extends StatelessWidget {
  const MedicalAppointmentApp({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: AppColors.care,
      brightness: Brightness.light,
      primary: AppColors.care,
      onPrimary: Colors.white,
      secondary: AppColors.apricot,
      surface: Colors.white,
      onSurface: AppColors.ink,
      error: AppColors.danger,
    );

    return MaterialApp(
      title: 'Medical Appointment',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: colorScheme,
        scaffoldBackgroundColor: AppColors.cloud,
        textTheme: ThemeData.light().textTheme.apply(
          bodyColor: AppColors.ink,
          displayColor: AppColors.ink,
        ),
        filledButtonTheme: FilledButtonThemeData(
          style: FilledButton.styleFrom(
            minimumSize: const Size.fromHeight(52),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
        ),
      ),
      home: const WelcomeScreen(),
    );
  }
}

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final contentWidth = constraints.maxWidth > 600 ? 520.0 : 440.0;

            return Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(24, 32, 24, 24),
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: contentWidth),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const _BrandMark(),
                      const SizedBox(height: 44),
                      Text(
                        'Chăm sóc đúng lịch,\nnhẹ lòng hơn mỗi ngày.',
                        style: Theme.of(context).textTheme.headlineLarge
                            ?.copyWith(
                              fontSize: 38,
                              height: 1.12,
                              fontWeight: FontWeight.w800,
                              letterSpacing: -1.2,
                            ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Tìm bác sĩ phù hợp, chọn giờ khám thuận tiện và theo dõi hành trình chăm sóc của bạn ở một nơi.',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          height: 1.55,
                          color: AppColors.ink.withValues(alpha: 0.72),
                        ),
                      ),
                      const SizedBox(height: 36),
                      const _CarePath(),
                      const SizedBox(height: 36),
                      FilledButton(
                        onPressed: () {},
                        child: const Text('Bắt đầu đặt lịch'),
                      ),
                      const SizedBox(height: 12),
                      Center(
                        child: TextButton(
                          onPressed: () {},
                          child: const Text('Tôi đã có tài khoản'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _BrandMark extends StatelessWidget {
  const _BrandMark();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: AppColors.ink,
            borderRadius: BorderRadius.circular(14),
          ),
          child: const Icon(Icons.favorite_rounded, color: AppColors.mint),
        ),
        const SizedBox(width: 12),
        const Text(
          'MediPath',
          style: TextStyle(
            color: AppColors.ink,
            fontSize: 20,
            fontWeight: FontWeight.w800,
            letterSpacing: -0.4,
          ),
        ),
      ],
    );
  }
}

class _CarePath extends StatelessWidget {
  const _CarePath();

  @override
  Widget build(BuildContext context) {
    const steps = [
      (Icons.search_rounded, 'Tìm bác sĩ'),
      (Icons.calendar_month_rounded, 'Chọn lịch'),
      (Icons.verified_rounded, 'An tâm khám'),
    ];

    return Semantics(
      label: 'Quy trình gồm tìm bác sĩ, chọn lịch và đến khám',
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 22),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: AppColors.mint),
        ),
        child: Row(
          children: [
            for (var index = 0; index < steps.length; index++) ...[
              Expanded(
                child: _CareStep(
                  icon: steps[index].$1,
                  label: steps[index].$2,
                  highlighted: index == 0,
                ),
              ),
              if (index < steps.length - 1)
                Container(width: 28, height: 2, color: AppColors.mint),
            ],
          ],
        ),
      ),
    );
  }
}

class _CareStep extends StatelessWidget {
  const _CareStep({
    required this.icon,
    required this.label,
    required this.highlighted,
  });

  final IconData icon;
  final String label;
  final bool highlighted;

  @override
  Widget build(BuildContext context) {
    final background = highlighted ? AppColors.care : AppColors.mint;
    final foreground = highlighted ? Colors.white : AppColors.ink;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(color: background, shape: BoxShape.circle),
          child: Icon(icon, color: foreground, size: 22),
        ),
        const SizedBox(height: 10),
        Text(
          label,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.labelMedium
              ?.copyWith(fontWeight: FontWeight.w700),
        ),
      ],
    );
  }
}
