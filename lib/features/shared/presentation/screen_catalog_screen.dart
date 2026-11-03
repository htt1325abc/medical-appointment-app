import 'package:flutter/material.dart';

import '../../../core/design_system/app_colors.dart';
import '../../../core/design_system/app_spacing.dart';
import '../../../core/models/screen_spec.dart';
import '../../../data/mock_data/feature_screen_catalog.dart';

class ScreenCatalogScreen extends StatelessWidget {
  const ScreenCatalogScreen({
    required this.onOpenScreen,
    required this.onOpenExisting,
    super.key,
  });

  final ValueChanged<String> onOpenScreen;
  final ValueChanged<String> onOpenExisting;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('MediCare+ · 96 màn hình'),
        backgroundColor: AppColors.background,
        surfaceTintColor: Colors.transparent,
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
        children: [
          _SummaryCard(
            onOpenPatient: () => onOpenExisting('/patient/home'),
            onOpenDoctor: () => onOpenScreen('D03'),
            onOpenAdmin: () => onOpenScreen('A01'),
          ),
          const SizedBox(height: 18),
          _ExistingSection(onOpen: onOpenExisting),
          const SizedBox(height: 12),
          _RoleSection(
            title: 'Patient · 27 màn còn lại',
            icon: Icons.person_outline_rounded,
            color: AppColors.primary,
            screens: FeatureScreenCatalog.patient,
            onOpen: onOpenScreen,
          ),
          const SizedBox(height: 12),
          _RoleSection(
            title: 'Doctor · 28 màn',
            icon: Icons.medical_services_outlined,
            color: AppColors.deep,
            screens: FeatureScreenCatalog.doctor,
            onOpen: onOpenScreen,
          ),
          const SizedBox(height: 12),
          _RoleSection(
            title: 'Admin · 27 màn',
            icon: Icons.admin_panel_settings_outlined,
            color: const Color(0xFF3659B8),
            screens: FeatureScreenCatalog.admin,
            onOpen: onOpenScreen,
          ),
        ],
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({
    required this.onOpenPatient,
    required this.onOpenDoctor,
    required this.onOpenAdmin,
  });

  final VoidCallback onOpenPatient;
  final VoidCallback onOpenDoctor;
  final VoidCallback onOpenAdmin;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.deep, AppColors.primary],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Kho giao diện FE',
            style: Theme.of(context).textTheme.headlineSmall
                ?.copyWith(color: AppColors.white),
          ),
          const SizedBox(height: 6),
          Text(
            'Patient 41 · Doctor 28 · Admin 27',
            style: Theme.of(context).textTheme.bodyMedium
                ?.copyWith(color: AppColors.white.withValues(alpha: .86)),
          ),
          const SizedBox(height: 18),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _RoleChip(label: 'Mở Patient', onTap: onOpenPatient),
              _RoleChip(label: 'Mở Doctor', onTap: onOpenDoctor),
              _RoleChip(label: 'Mở Admin', onTap: onOpenAdmin),
            ],
          ),
        ],
      ),
    );
  }
}

class _RoleChip extends StatelessWidget {
  const _RoleChip({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ActionChip(
      onPressed: onTap,
      backgroundColor: AppColors.white,
      side: BorderSide.none,
      label: Text(label, style: const TextStyle(color: AppColors.deep)),
    );
  }
}

class _ExistingSection extends StatelessWidget {
  const _ExistingSection({required this.onOpen});

  final ValueChanged<String> onOpen;

  static const entries = <(String, String)>[
    ('01 · Splash', '/'),
    ('02–04 · Onboarding', '/onboarding'),
    ('05–10 · Xác thực Patient', '/auth'),
    ('11 · Trang chủ Patient', '/patient/home'),
    ('12 · Tìm kiếm chuyên khoa', '/patient/specialties'),
    ('13 · Nội khoa', '/patient/specialties/internal-medicine'),
    ('14 · Hồ sơ bác sĩ', '/patient/doctor-profile'),
  ];

  @override
  Widget build(BuildContext context) {
    return _CatalogCard(
      child: ExpansionTile(
        initiallyExpanded: false,
        leading: const Icon(
          Icons.check_circle_outline_rounded,
          color: AppColors.success,
        ),
        title: const Text('Patient · 14 màn đã hoàn thiện'),
        subtitle: const Text('Onboarding, xác thực và khám phá bác sĩ'),
        children: [
          for (final entry in entries)
            ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 20),
              title: Text(entry.$1),
              trailing: const Icon(Icons.chevron_right_rounded),
              onTap: () => onOpen(entry.$2),
            ),
        ],
      ),
    );
  }
}

class _RoleSection extends StatelessWidget {
  const _RoleSection({
    required this.title,
    required this.icon,
    required this.color,
    required this.screens,
    required this.onOpen,
  });

  final String title;
  final IconData icon;
  final Color color;
  final List<ScreenSpec> screens;
  final ValueChanged<String> onOpen;

  @override
  Widget build(BuildContext context) {
    return _CatalogCard(
      child: ExpansionTile(
        leading: Icon(icon, color: color),
        title: Text(title),
        subtitle: Text('${screens.length} frame có thể mở và tương tác'),
        children: [
          for (final screen in screens)
            ListTile(
              contentPadding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.lg,
                vertical: 2,
              ),
              leading: CircleAvatar(
                radius: 18,
                backgroundColor: color.withValues(alpha: .1),
                child: Icon(screen.icon, size: 18, color: color),
              ),
              title: Text('${screen.id} · ${screen.title}'),
              subtitle: Text(
                screen.subtitle,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              trailing: const Icon(Icons.chevron_right_rounded),
              onTap: () => onOpen(screen.id),
            ),
        ],
      ),
    );
  }
}

class _CatalogCard extends StatelessWidget {
  const _CatalogCard({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: AppColors.border),
      ),
      clipBehavior: Clip.antiAlias,
      child: child,
    );
  }
}
