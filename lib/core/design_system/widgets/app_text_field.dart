import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../app_colors.dart';

class AppTextField extends StatelessWidget {
  const AppTextField({
    required this.controller,
    required this.hintText,
    required this.icon,
    this.keyboardType,
    this.textInputAction,
    this.obscureText = false,
    this.validator,
    this.onFieldSubmitted,
    this.inputFormatters,
    this.suffixIcon,
    super.key,
  });

  final TextEditingController controller;
  final String hintText;
  final IconData icon;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final bool obscureText;
  final String? Function(String?)? validator;
  final ValueChanged<String>? onFieldSubmitted;
  final List<TextInputFormatter>? inputFormatters;
  final Widget? suffixIcon;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      obscureText: obscureText,
      validator: validator,
      onFieldSubmitted: onFieldSubmitted,
      inputFormatters: inputFormatters,
      style: Theme.of(context).textTheme.bodyMedium,
      decoration: InputDecoration(
        hintText: hintText,
        prefixIcon: Icon(icon, color: AppColors.muted, size: 18),
        prefixIconConstraints: const BoxConstraints(
          minWidth: 44,
          minHeight: 52,
        ),
        suffixIcon: suffixIcon,
      ),
    );
  }
}
