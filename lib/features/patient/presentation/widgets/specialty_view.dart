import 'package:flutter/material.dart';

import '../../../../core/design_system/app_colors.dart';
import '../../../../core/models/specialty.dart';

class SpecialtyIcon extends StatelessWidget {
  const SpecialtyIcon({required this.specialty, this.size = 48, super.key});

  final Specialty specialty;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: AppColors.soft,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(
        specialty.icon,
        size: size * .48,
        color: specialty.accent ?? AppColors.primary,
      ),
    );
  }
}
