import 'package:flutter/material.dart';

class Specialty {
  const Specialty({required this.name, required this.icon, this.accent});

  final String name;
  final IconData icon;
  final Color? accent;
}
