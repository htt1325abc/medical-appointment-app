import 'package:flutter/material.dart';

import '../../models/screen_spec.dart';
import '../app_colors.dart';

class RoleBottomNavigation extends StatelessWidget {
  const RoleBottomNavigation({
    required this.role,
    required this.onHome,
    required this.onCatalog,
    super.key,
  });

  final AppRole role;
  final VoidCallback onHome;
  final VoidCallback onCatalog;

  @override
  Widget build(BuildContext context) {
    final items = switch (role) {
      AppRole.patient => const <(IconData, String)>[
        (Icons.home_outlined, 'Trang chủ'),
        (Icons.calendar_month_outlined, 'Lịch hẹn'),
        (Icons.notifications_none_rounded, 'Thông báo'),
        (Icons.person_outline_rounded, 'Cá nhân'),
      ],
      AppRole.doctor => const <(IconData, String)>[
        (Icons.home_outlined, 'Trang chủ'),
        (Icons.calendar_month_outlined, 'Lịch khám'),
        (Icons.forum_outlined, 'Tư vấn'),
        (Icons.person_outline_rounded, 'Cá nhân'),
      ],
      AppRole.admin => const <(IconData, String)>[
        (Icons.space_dashboard_outlined, 'Tổng quan'),
        (Icons.calendar_month_outlined, 'Lịch hẹn'),
        (Icons.groups_outlined, 'Người dùng'),
        (Icons.settings_outlined, 'Cài đặt'),
      ],
    };
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.white,
        border: Border(top: BorderSide(color: AppColors.border)),
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 64,
          child: Row(
            children: [
              for (var index = 0; index < items.length; index++)
                Expanded(
                  child: InkWell(
                    onTap: index == 0 ? onHome : onCatalog,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          items[index].$1,
                          size: 21,
                          color: index == 0
                              ? AppColors.primary
                              : AppColors.muted,
                        ),
                        const SizedBox(height: 3),
                        Text(
                          items[index].$2,
                          maxLines: 1,
                          style: Theme.of(context).textTheme.labelSmall
                              ?.copyWith(
                                fontSize: 9,
                                color: index == 0
                                    ? AppColors.primary
                                    : AppColors.muted,
                              ),
                        ),
                      ],
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
