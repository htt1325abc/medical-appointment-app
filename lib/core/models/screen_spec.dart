import 'package:flutter/material.dart';

enum AppRole { patient, doctor, admin }

enum ScreenLayout {
  dashboard,
  list,
  detail,
  form,
  success,
  chat,
  calendar,
  video,
  profile,
  settings,
  metrics,
  auth,
}

@immutable
class ScreenSpec {
  const ScreenSpec({
    required this.id,
    required this.role,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.layout,
    this.items = const [],
    this.primaryAction,
    this.secondaryAction,
    this.nextScreenId,
    this.isDestructive = false,
  });

  final String id;
  final AppRole role;
  final String title;
  final String subtitle;
  final IconData icon;
  final ScreenLayout layout;
  final List<String> items;
  final String? primaryAction;
  final String? secondaryAction;
  final String? nextScreenId;
  final bool isDestructive;
}
