import 'package:flutter/material.dart';

import '../app_colors.dart';
import '../app_spacing.dart';

class MobileFrame extends StatelessWidget {
  const MobileFrame({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: AppColors.authCanvas,
      child: Center(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isCanvas = constraints.maxWidth > 480;
            final canvasPadding = isCanvas ? AppSpacing.lg * 2 : 0.0;
            final frameHeight = isCanvas
                ? (constraints.maxHeight - canvasPadding).clamp(0.0, 852.0)
                : constraints.maxHeight;
            return Padding(
              padding: EdgeInsets.all(isCanvas ? AppSpacing.lg : 0),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: 393,
                  minHeight: frameHeight,
                  maxHeight: frameHeight,
                ),
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: AppColors.background,
                    borderRadius: isCanvas
                        ? BorderRadius.circular(AppRadius.screen)
                        : BorderRadius.zero,
                    border: isCanvas
                        ? Border.all(color: AppColors.border)
                        : null,
                  ),
                  child: ClipRRect(
                    borderRadius: isCanvas
                        ? BorderRadius.circular(AppRadius.screen)
                        : BorderRadius.zero,
                    child: child,
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
