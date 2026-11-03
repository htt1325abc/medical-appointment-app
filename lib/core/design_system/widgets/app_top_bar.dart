import 'package:flutter/material.dart';

import '../app_colors.dart';

class AppTopBar extends StatelessWidget {
  const AppTopBar({
    required this.title,
    this.onBack,
    this.actions = const [],
    super.key,
  });

  final String title;
  final VoidCallback? onBack;
  final List<Widget> actions;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 56,
      child: Row(
        children: [
          if (onBack != null)
            IconButton(
              onPressed: onBack,
              tooltip: 'Quay lại',
              icon: const Icon(
                Icons.arrow_back_ios_new_rounded,
                size: 18,
                color: AppColors.ink,
              ),
            )
          else
            const SizedBox(width: 8),
          Expanded(
            child: Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
          ...actions,
          const SizedBox(width: 8),
        ],
      ),
    );
  }
}
