import 'package:flutter/material.dart';

import '../../../../core/design_system/app_colors.dart';
import '../../../../core/design_system/app_spacing.dart';
import '../../../../core/design_system/widgets/app_state_view.dart';
import '../../../../core/design_system/widgets/app_top_bar.dart';
import '../../../../core/design_system/widgets/doctor_avatar.dart';
import '../../../../core/design_system/widgets/mobile_frame.dart';
import '../../../../core/models/doctor.dart';
import '../../../../data/mock_data/patient_mock_data.dart';

class InternalMedicineScreen extends StatefulWidget {
  const InternalMedicineScreen({
    required this.onBack,
    required this.onOpenDoctor,
    super.key,
  });

  final VoidCallback onBack;
  final ValueChanged<Doctor> onOpenDoctor;

  @override
  State<InternalMedicineScreen> createState() => _InternalMedicineScreenState();
}

class _InternalMedicineScreenState extends State<InternalMedicineScreen> {
  int _selectedFilter = 0;

  @override
  Widget build(BuildContext context) {
    var doctors = [...PatientMockData.doctors];
    if (_selectedFilter == 2) {
      doctors.sort((a, b) => b.rating.compareTo(a.rating));
    }

    return MobileFrame(
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: SafeArea(
          child: Column(
            children: [
              AppTopBar(title: 'Nội khoa', onBack: widget.onBack),
              _FilterTabs(
                selectedIndex: _selectedFilter,
                onSelected: (index) => setState(() => _selectedFilter = index),
              ),
              Expanded(
                child: AppStateView(
                  state: AppViewState.content,
                  child: ListView.separated(
                    padding: const EdgeInsets.fromLTRB(
                      AppSpacing.lg,
                      AppSpacing.sm,
                      AppSpacing.lg,
                      AppSpacing.lg,
                    ),
                    itemCount: doctors.length,
                    separatorBuilder: (_, _) => const SizedBox(height: 12),
                    itemBuilder: (context, index) => DoctorListCard(
                      doctor: doctors[index],
                      onTap: () => widget.onOpenDoctor(doctors[index]),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FilterTabs extends StatelessWidget {
  const _FilterTabs({required this.selectedIndex, required this.onSelected});

  final int selectedIndex;
  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context) {
    const labels = ['Tất cả', 'Gần nhất', 'Đánh giá cao'];
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      child: Row(
        children: [
          for (var index = 0; index < labels.length; index++)
            Expanded(
              child: InkWell(
                onTap: () => onSelected(index),
                child: Container(
                  height: 40,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: selectedIndex == index
                            ? AppColors.primary
                            : Colors.transparent,
                        width: 2,
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
      ),
    );
  }
}

class DoctorListCard extends StatelessWidget {
  const DoctorListCard({required this.doctor, required this.onTap, super.key});

  final Doctor doctor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.white,
      shape: RoundedRectangleBorder(
        side: const BorderSide(color: AppColors.border),
        borderRadius: BorderRadius.circular(14),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              DoctorAvatar(doctor: doctor, size: 66),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      doctor.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.labelLarge,
                    ),
                    const SizedBox(height: 3),
                    Text(
                      '${doctor.specialty} · ${doctor.hospital}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.labelSmall,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '★ ${doctor.rating.toStringAsFixed(1)}  (${doctor.reviewCount} đánh giá)',
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: AppColors.warning,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      'Còn lịch trống',
                      style: Theme.of(context).textTheme.labelSmall
                          ?.copyWith(color: AppColors.success),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
