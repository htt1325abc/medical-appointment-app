import 'package:flutter/material.dart';

import '../../../../core/design_system/app_colors.dart';

class PatientBottomNavigation extends StatelessWidget {
  const PatientBottomNavigation({
    required this.selectedIndex,
    required this.onSelected,
    super.key,
  });

  final int selectedIndex;
  final ValueChanged<int> onSelected;

  static const _items = <(IconData, String)>[
    (Icons.home_outlined, 'Trang chủ'),
    (Icons.calendar_month_outlined, 'Lịch hẹn'),
    (Icons.notifications_none_rounded, 'Thông báo'),
    (Icons.person_outline_rounded, 'Cá nhân'),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.white,
        border: Border(top: BorderSide(color: AppColors.border)),
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 66,
          child: Row(
            children: [
              for (var index = 0; index < _items.length; index++)
                Expanded(
                  child: InkWell(
                    onTap: () => onSelected(index),
                    child: Semantics(
                      selected: index == selectedIndex,
                      button: true,
                      label: _items[index].$2,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            _items[index].$1,
                            size: 21,
                            color: index == selectedIndex
                                ? AppColors.primary
                                : AppColors.muted,
                          ),
                          const SizedBox(height: 3),
                          Text(
                            _items[index].$2,
                            style: Theme.of(context).textTheme.labelSmall
                                ?.copyWith(
                                  fontSize: 9,
                                  color: index == selectedIndex
                                      ? AppColors.primary
                                      : AppColors.muted,
                                ),
                          ),
                        ],
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
