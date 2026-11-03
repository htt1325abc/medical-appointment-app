import 'package:flutter/material.dart';

import '../../../../core/design_system/app_colors.dart';
import '../../../../core/design_system/app_spacing.dart';
import '../../../../core/design_system/widgets/app_button.dart';
import '../../../../core/design_system/widgets/app_top_bar.dart';
import '../../../../core/design_system/widgets/doctor_avatar.dart';
import '../../../../core/design_system/widgets/mobile_frame.dart';
import '../../../../core/models/doctor.dart';

class DoctorProfileScreen extends StatefulWidget {
  const DoctorProfileScreen({
    required this.doctor,
    required this.onBack,
    required this.onBook,
    super.key,
  });

  final Doctor doctor;
  final VoidCallback onBack;
  final VoidCallback onBook;

  @override
  State<DoctorProfileScreen> createState() => _DoctorProfileScreenState();
}

class _DoctorProfileScreenState extends State<DoctorProfileScreen> {
  int _selectedTab = 0;

  @override
  Widget build(BuildContext context) {
    return MobileFrame(
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: SafeArea(
          child: Column(
            children: [
              AppTopBar(title: 'Hồ sơ bác sĩ', onBack: widget.onBack),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.lg,
                  ),
                  child: Column(
                    children: [
                      const SizedBox(height: 16),
                      DoctorAvatar(doctor: widget.doctor, size: 112),
                      const SizedBox(height: 16),
                      Text(
                        widget.doctor.name,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 5),
                      Text(
                        '${widget.doctor.specialty} · ${widget.doctor.hospital}',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      const SizedBox(height: 5),
                      Text(
                        '★ ${widget.doctor.rating.toStringAsFixed(1)} (${widget.doctor.reviewCount} đánh giá)',
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: AppColors.warning,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 14),
                      _ProfileTabs(
                        selectedIndex: _selectedTab,
                        onSelected: (index) =>
                            setState(() => _selectedTab = index),
                      ),
                      const SizedBox(height: 12),
                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 160),
                        child: switch (_selectedTab) {
                          0 => const _Introduction(key: ValueKey('intro')),
                          1 => const _Schedule(key: ValueKey('schedule')),
                          _ => const _Reviews(key: ValueKey('reviews')),
                        },
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.lg,
                  AppSpacing.sm,
                  AppSpacing.lg,
                  AppSpacing.lg,
                ),
                child: AppButton(
                  label: 'Đặt lịch khám',
                  onPressed: widget.onBook,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ProfileTabs extends StatelessWidget {
  const _ProfileTabs({required this.selectedIndex, required this.onSelected});

  final int selectedIndex;
  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context) {
    const labels = ['Giới thiệu', 'Lịch khám', 'Đánh giá'];
    return Row(
      children: [
        for (var index = 0; index < labels.length; index++)
          Expanded(
            child: InkWell(
              onTap: () => onSelected(index),
              child: Container(
                height: 38,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: selectedIndex == index
                          ? AppColors.primary
                          : AppColors.border,
                      width: selectedIndex == index ? 2 : 1,
                    ),
                  ),
                ),
                child: Text(
                  labels[index],
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: selectedIndex == index
                        ? AppColors.primary
                        : AppColors.muted,
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}

class _Introduction extends StatelessWidget {
  const _Introduction({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        _InfoRow(
          icon: Icons.person_outline_rounded,
          text: '10 năm kinh nghiệm',
        ),
        _InfoRow(
          icon: Icons.description_outlined,
          text: 'Chuyên điều trị tiểu đường, huyết áp\nvà các bệnh nội khoa',
        ),
        _InfoRow(
          icon: Icons.health_and_safety_outlined,
          text: 'Học vấn: Đại học Y Hà Nội',
        ),
        _InfoRow(
          icon: Icons.chat_bubble_outline_rounded,
          text: 'Ngôn ngữ: Tiếng Việt, Tiếng Anh',
        ),
      ],
    );
  }
}

class _Schedule extends StatelessWidget {
  const _Schedule({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        _InfoRow(
          icon: Icons.calendar_today_outlined,
          text: 'Thứ Hai – Thứ Sáu',
        ),
        _InfoRow(
          icon: Icons.schedule_rounded,
          text: '08:00 – 11:30 · 13:30 – 17:00',
        ),
      ],
    );
  }
}

class _Reviews extends StatelessWidget {
  const _Reviews({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        _InfoRow(
          icon: Icons.star_outline_rounded,
          text: '4.9/5 từ 326 lượt đánh giá',
        ),
        _InfoRow(
          icon: Icons.format_quote_rounded,
          text: 'Bác sĩ tận tâm, giải thích rõ ràng.',
        ),
      ],
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      constraints: const BoxConstraints(minHeight: 62),
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: AppColors.border)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: AppColors.primary, size: 22),
          const SizedBox(width: 14),
          Expanded(
            child: Text(text, style: Theme.of(context).textTheme.bodyMedium),
          ),
        ],
      ),
    );
  }
}
