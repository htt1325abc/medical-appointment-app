import 'package:flutter/material.dart';

import '../../core/design_system/app_colors.dart';
import '../../core/models/doctor.dart';
import '../../core/models/specialty.dart';

abstract final class PatientMockData {
  static const specialties = <Specialty>[
    Specialty(name: 'Nội khoa', icon: Icons.favorite_border_rounded),
    Specialty(name: 'Ngoại khoa', icon: Icons.health_and_safety_outlined),
    Specialty(
      name: 'Sản phụ khoa',
      icon: Icons.person_outline_rounded,
      accent: AppColors.danger,
    ),
    Specialty(name: 'Nhi khoa', icon: Icons.person_outline_rounded),
    Specialty(name: 'Da liễu', icon: Icons.health_and_safety_outlined),
    Specialty(
      name: 'Tai mũi họng',
      icon: Icons.favorite_border_rounded,
      accent: AppColors.danger,
    ),
    Specialty(name: 'Răng hàm mặt', icon: Icons.person_outline_rounded),
    Specialty(name: 'Mắt', icon: Icons.visibility_outlined),
    Specialty(name: 'Tim mạch', icon: Icons.favorite_border_rounded),
    Specialty(name: 'Cơ xương khớp', icon: Icons.health_and_safety_outlined),
  ];

  static const doctors = <Doctor>[
    Doctor(
      name: 'BS. Nguyễn Văn Minh',
      specialty: 'Nội khoa',
      hospital: 'Bệnh viện Đà Nẵng',
      rating: 4.9,
      reviewCount: 326,
      avatarColor: Color(0xFFD9ECF3),
      gender: DoctorGender.male,
    ),
    Doctor(
      name: 'BS. Trần Thị Lan',
      specialty: 'Sản phụ khoa',
      hospital: 'Bệnh viện Đà Nẵng',
      rating: 4.9,
      reviewCount: 326,
      avatarColor: Color(0xFFFFE7E4),
      gender: DoctorGender.female,
    ),
    Doctor(
      name: 'BS. Lê Quốc Hưng',
      specialty: 'Tai mũi họng',
      hospital: 'Bệnh viện Đà Nẵng',
      rating: 4.9,
      reviewCount: 326,
      avatarColor: Color(0xFFE2EEF9),
      gender: DoctorGender.male,
    ),
    Doctor(
      name: 'BS. Phạm Thu Hằng',
      specialty: 'Da liễu',
      hospital: 'Bệnh viện Đà Nẵng',
      rating: 4.9,
      reviewCount: 326,
      avatarColor: Color(0xFFFFE9F0),
      gender: DoctorGender.female,
    ),
  ];
}
