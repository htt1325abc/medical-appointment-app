import 'package:flutter/material.dart';

import '../app_colors.dart';

class AppBrandMark extends StatelessWidget {
  const AppBrandMark({this.size = 104, super.key});

  final double size;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'MediCare+',
      image: true,
      child: SizedBox.square(
        dimension: size,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Icon(
              Icons.favorite_rounded,
              size: size,
              color: AppColors.primary,
              shadows: const [
                Shadow(
                  color: Color(0x22006DA5),
                  blurRadius: 10,
                  offset: Offset(0, 5),
                ),
              ],
            ),
            Icon(Icons.add_rounded, size: size * .52, color: AppColors.white),
          ],
        ),
      ),
    );
  }
}
