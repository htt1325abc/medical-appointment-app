import 'package:flutter/material.dart';

class Doctor {
  const Doctor({
    required this.name,
    required this.specialty,
    required this.hospital,
    required this.rating,
    required this.reviewCount,
    required this.avatarColor,
    required this.gender,
  });

  final String name;
  final String specialty;
  final String hospital;
  final double rating;
  final int reviewCount;
  final Color avatarColor;
  final DoctorGender gender;
}

enum DoctorGender { male, female }
