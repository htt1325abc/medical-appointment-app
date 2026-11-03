import 'package:flutter/material.dart';

import '../app_colors.dart';
import '../app_spacing.dart';
import 'app_button.dart';

enum AppViewState { loading, content, empty, error, offline }

class AppStateView extends StatelessWidget {
  const AppStateView({
    required this.state,
    required this.child,
    this.onRetry,
    this.emptyMessage = 'Chưa có dữ liệu để hiển thị',
    super.key,
  });

  final AppViewState state;
  final Widget child;
  final VoidCallback? onRetry;
  final String emptyMessage;

  @override
  Widget build(BuildContext context) {
    return switch (state) {
      AppViewState.content => child,
      AppViewState.loading => const Center(
        child: CircularProgressIndicator(color: AppColors.primary),
      ),
      AppViewState.empty => _MessageState(
        icon: Icons.inbox_outlined,
        message: emptyMessage,
      ),
      AppViewState.error => _MessageState(
        icon: Icons.error_outline_rounded,
        message: 'Không thể tải dữ liệu. Vui lòng thử lại.',
        onRetry: onRetry,
      ),
      AppViewState.offline => _MessageState(
        icon: Icons.wifi_off_rounded,
        message: 'Bạn đang ngoại tuyến. Kiểm tra kết nối rồi thử lại.',
        onRetry: onRetry,
      ),
    };
  }
}

class _MessageState extends StatelessWidget {
  const _MessageState({
    required this.icon,
    required this.message,
    this.onRetry,
  });

  final IconData icon;
  final String message;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 48, color: AppColors.muted),
            const SizedBox(height: AppSpacing.md),
            Text(
              message,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium
                  ?.copyWith(color: AppColors.muted),
            ),
            if (onRetry != null) ...[
              const SizedBox(height: AppSpacing.lg),
              SizedBox(
                width: 180,
                child: AppButton(label: 'Thử lại', onPressed: onRetry),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
