import 'package:flutter/material.dart';

import '../app_colors.dart';
import '../app_spacing.dart';

enum AppButtonStyle { primary, secondary, danger }

class AppButton extends StatelessWidget {
  const AppButton({
    required this.label,
    required this.onPressed,
    this.style = AppButtonStyle.primary,
    this.isLoading = false,
    super.key,
  });

  final String label;
  final VoidCallback? onPressed;
  final AppButtonStyle style;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    final colors = switch (style) {
      AppButtonStyle.primary => (AppColors.primary, AppColors.white),
      AppButtonStyle.secondary => (AppColors.white, AppColors.deep),
      AppButtonStyle.danger => (AppColors.danger, AppColors.white),
    };

    return SizedBox(
      width: double.infinity,
      height: 52,
      child: FilledButton(
        onPressed: isLoading ? null : onPressed,
        style: FilledButton.styleFrom(
          backgroundColor: colors.$1,
          foregroundColor: colors.$2,
          side: style == AppButtonStyle.secondary
              ? const BorderSide(color: AppColors.border)
              : BorderSide.none,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.control),
          ),
        ),
        child: isLoading
            ? const SizedBox.square(
                dimension: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: AppColors.white,
                ),
              )
            : Text(label),
      ),
    );
  }
}
