import 'package:flutter/material.dart';

import '../../models/doctor.dart';
import '../app_colors.dart';

class DoctorAvatar extends StatelessWidget {
  const DoctorAvatar({required this.doctor, this.size = 64, super.key});

  final Doctor doctor;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'Ảnh ${doctor.name}',
      image: true,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: doctor.avatarColor,
          shape: BoxShape.circle,
          border: Border.all(color: AppColors.white, width: 2),
        ),
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            Positioned(
              top: size * .14,
              child: Icon(
                doctor.gender == DoctorGender.female
                    ? Icons.face_3_rounded
                    : Icons.face_6_rounded,
                size: size * .48,
                color: AppColors.ink,
              ),
            ),
            Icon(
              Icons.medical_services_rounded,
              size: size * .48,
              color: AppColors.white,
              shadows: const [Shadow(color: AppColors.primary, blurRadius: 1)],
            ),
          ],
        ),
      ),
    );
  }
}
