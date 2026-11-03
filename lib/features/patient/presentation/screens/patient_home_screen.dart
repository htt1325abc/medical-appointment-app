import 'package:flutter/material.dart';

import '../../../../core/design_system/app_colors.dart';
import '../../../../core/design_system/app_spacing.dart';
import '../../../../core/design_system/widgets/mobile_frame.dart';
import '../../../../data/mock_data/patient_mock_data.dart';
import '../widgets/patient_bottom_navigation.dart';
import '../widgets/specialty_view.dart';

class PatientHomeScreen extends StatelessWidget {
  const PatientHomeScreen({
    required this.onOpenSpecialties,
    required this.onOpenInternalMedicine,
    required this.onOpenProfile,
    super.key,
  });

  final VoidCallback onOpenSpecialties;
  final VoidCallback onOpenInternalMedicine;
  final VoidCallback onOpenProfile;

  @override
  Widget build(BuildContext context) {
    return MobileFrame(
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: SafeArea(
          bottom: false,
          child: ListView(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.lg,
              AppSpacing.md,
              AppSpacing.lg,
              AppSpacing.lg,
            ),
            children: [
              _WelcomeHeader(onAvatarTap: onOpenProfile),
              const SizedBox(height: 22),
              _SearchEntry(onTap: onOpenSpecialties),
              const SizedBox(height: 16),
              _QuickActions(onOpenInternalMedicine: onOpenInternalMedicine),
              const SizedBox(height: 20),
              Text(
                'Chuyên khoa phổ biến',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 12),
              _SpecialtyGrid(
                onOpenSpecialties: onOpenSpecialties,
                onOpenInternalMedicine: onOpenInternalMedicine,
              ),
              const SizedBox(height: 18),
              const _CareBanner(),
            ],
          ),
        ),
        bottomNavigationBar: PatientBottomNavigation(
          selectedIndex: 0,
          onSelected: (index) {
            if (index == 3) {
              onOpenProfile();
              return;
            }
            if (index != 0) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Màn này sẽ có ở đợt tiếp theo')),
              );
            }
          },
        ),
      ),
    );
  }
}

class _WelcomeHeader extends StatelessWidget {
  const _WelcomeHeader({required this.onAvatarTap});

  final VoidCallback onAvatarTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        InkWell(
          onTap: onAvatarTap,
          customBorder: const CircleBorder(),
          child: Container(
            width: 42,
            height: 42,
            decoration: const BoxDecoration(
              color: Color(0xFFFFE8DF),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.face_3_rounded,
              color: AppColors.ink,
              size: 28,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            'Xin chào, Nguyễn Thảo Ly',
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ),
      ],
    );
  }
}

class _SearchEntry extends StatelessWidget {
  const _SearchEntry({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: 'Tìm bác sĩ, chuyên khoa, bệnh viện',
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.control),
        child: Container(
          height: 52,
          padding: const EdgeInsets.symmetric(horizontal: 14),
          decoration: BoxDecoration(
            color: AppColors.soft,
            borderRadius: BorderRadius.circular(AppRadius.control),
            border: Border.all(color: AppColors.border),
          ),
          child: Row(
            children: [
              const Icon(
                Icons.search_rounded,
                size: 20,
                color: AppColors.muted,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Tìm bác sĩ, chuyên khoa, bệnh viện...',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _QuickActions extends StatelessWidget {
  const _QuickActions({required this.onOpenInternalMedicine});

  final VoidCallback onOpenInternalMedicine;

  @override
  Widget build(BuildContext context) {
    const actions = <(IconData, String)>[
      (Icons.calendar_month_outlined, 'Đặt lịch khám'),
      (Icons.video_camera_front_outlined, 'Tư vấn online'),
      (Icons.description_outlined, 'Hồ sơ sức khỏe'),
    ];
    return Row(
      children: [
        for (var index = 0; index < actions.length; index++) ...[
          Expanded(
            child: InkWell(
              onTap: index == 0
                  ? onOpenInternalMedicine
                  : () => ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Màn này sẽ có ở đợt tiếp theo'),
                      ),
                    ),
              borderRadius: BorderRadius.circular(12),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Column(
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: AppColors.soft,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        actions[index].$1,
                        color: AppColors.primary,
                        size: 24,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      actions[index].$2,
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.labelSmall
                          ?.copyWith(color: AppColors.ink),
                    ),
                  ],
                ),
              ),
            ),
          ),
          if (index != actions.length - 1) const SizedBox(width: 8),
        ],
      ],
    );
  }
}

class _SpecialtyGrid extends StatelessWidget {
  const _SpecialtyGrid({
    required this.onOpenSpecialties,
    required this.onOpenInternalMedicine,
  });

  final VoidCallback onOpenSpecialties;
  final VoidCallback onOpenInternalMedicine;

  @override
  Widget build(BuildContext context) {
    final specialties = PatientMockData.specialties.take(7).toList();
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 8,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        mainAxisExtent: 76,
        mainAxisSpacing: 2,
        crossAxisSpacing: 6,
      ),
      itemBuilder: (context, index) {
        if (index == 7) {
          return _SpecialtyItem(
            label: 'Xem thêm',
            icon: Icons.add_rounded,
            onTap: onOpenSpecialties,
          );
        }
        final specialty = specialties[index];
        return _SpecialtyItem(
          label: specialty.name,
          iconWidget: SpecialtyIcon(specialty: specialty, size: 44),
          onTap: index == 0 ? onOpenInternalMedicine : onOpenSpecialties,
        );
      },
    );
  }
}

class _SpecialtyItem extends StatelessWidget {
  const _SpecialtyItem({
    required this.label,
    required this.onTap,
    this.icon,
    this.iconWidget,
  });

  final String label;
  final VoidCallback onTap;
  final IconData? icon;
  final Widget? iconWidget;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Column(
        children: [
          iconWidget ??
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: AppColors.soft,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: AppColors.primary, size: 23),
              ),
          const SizedBox(height: 6),
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.labelSmall
                ?.copyWith(fontSize: 9, color: AppColors.ink),
          ),
        ],
      ),
    );
  }
}

class _CareBanner extends StatelessWidget {
  const _CareBanner();

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minHeight: 96),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.soft,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Chăm sóc sức khỏe\nchủ động mỗi ngày',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.titleMedium
                      ?.copyWith(color: AppColors.deep, height: 1.2),
                ),
                const SizedBox(height: 3),
                Text(
                  'Đặt lịch nhanh · Bác sĩ tận tâm',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.labelSmall
                      ?.copyWith(height: 1.15),
                ),
              ],
            ),
          ),
          const Icon(
            Icons.favorite_rounded,
            size: 48,
            color: Color(0xFFBFE7F2),
          ),
        ],
      ),
    );
  }
}
