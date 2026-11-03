import 'package:flutter/material.dart';

import '../../../../core/design_system/app_colors.dart';
import '../../../../core/design_system/app_spacing.dart';
import '../../../../core/design_system/widgets/app_state_view.dart';
import '../../../../core/design_system/widgets/app_top_bar.dart';
import '../../../../core/design_system/widgets/mobile_frame.dart';
import '../../../../core/models/specialty.dart';
import '../../../../data/mock_data/patient_mock_data.dart';

class SpecialtySearchScreen extends StatefulWidget {
  const SpecialtySearchScreen({
    required this.onBack,
    required this.onOpenInternalMedicine,
    super.key,
  });

  final VoidCallback onBack;
  final VoidCallback onOpenInternalMedicine;

  @override
  State<SpecialtySearchScreen> createState() => _SpecialtySearchScreenState();
}

class _SpecialtySearchScreenState extends State<SpecialtySearchScreen> {
  final _searchController = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final items = PatientMockData.specialties
        .where(
          (specialty) => specialty.name.toLowerCase().contains(
            _query.trim().toLowerCase(),
          ),
        )
        .toList();

    return MobileFrame(
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: SafeArea(
          child: Column(
            children: [
              AppTopBar(title: 'Tìm kiếm chuyên khoa', onBack: widget.onBack),
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.lg,
                  AppSpacing.xs,
                  AppSpacing.lg,
                  AppSpacing.xs,
                ),
                child: TextField(
                  controller: _searchController,
                  onChanged: (value) => setState(() => _query = value),
                  textInputAction: TextInputAction.search,
                  style: Theme.of(context).textTheme.bodyMedium,
                  decoration: InputDecoration(
                    hintText: 'Tìm chuyên khoa...',
                    prefixIcon: const Icon(
                      Icons.search_rounded,
                      color: AppColors.muted,
                      size: 20,
                    ),
                    suffixIcon: _query.isEmpty
                        ? null
                        : IconButton(
                            onPressed: () {
                              _searchController.clear();
                              setState(() => _query = '');
                            },
                            tooltip: 'Xóa tìm kiếm',
                            icon: const Icon(Icons.close_rounded, size: 18),
                          ),
                  ),
                ),
              ),
              Expanded(
                child: AppStateView(
                  state: items.isEmpty
                      ? AppViewState.empty
                      : AppViewState.content,
                  emptyMessage: 'Không tìm thấy chuyên khoa phù hợp',
                  child: ListView.separated(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.lg,
                    ),
                    itemCount: items.length,
                    separatorBuilder: (_, _) =>
                        const Divider(height: 1, color: AppColors.border),
                    itemBuilder: (context, index) => _SpecialtyRow(
                      specialty: items[index],
                      onTap: items[index].name == 'Nội khoa'
                          ? widget.onOpenInternalMedicine
                          : () => ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  '${items[index].name} sẽ có dữ liệu ở đợt tiếp theo',
                                ),
                              ),
                            ),
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

class _SpecialtyRow extends StatelessWidget {
  const _SpecialtyRow({required this.specialty, required this.onTap});

  final Specialty specialty;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: SizedBox(
        height: 52,
        child: Row(
          children: [
            Icon(
              specialty.icon,
              color: specialty.accent ?? AppColors.primary,
              size: 23,
            ),
            const SizedBox(width: 16),
            Text(specialty.name, style: Theme.of(context).textTheme.bodyMedium),
          ],
        ),
      ),
    );
  }
}
