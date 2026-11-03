import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'app_spacing.dart';

abstract final class AppTheme {
  static ThemeData get light {
    const colorScheme = ColorScheme.light(
      primary: AppColors.primary,
      onPrimary: AppColors.white,
      secondary: AppColors.deep,
      onSecondary: AppColors.white,
      surface: AppColors.background,
      onSurface: AppColors.ink,
      error: AppColors.danger,
      onError: AppColors.white,
      outline: AppColors.border,
    );

    const textTheme = TextTheme(
      headlineSmall: TextStyle(
        fontSize: 20,
        height: 1.45,
        fontWeight: FontWeight.w600,
        color: AppColors.ink,
      ),
      titleLarge: TextStyle(
        fontSize: 18,
        height: 1.45,
        fontWeight: FontWeight.w600,
        color: AppColors.ink,
      ),
      titleMedium: TextStyle(
        fontSize: 16,
        height: 1.45,
        fontWeight: FontWeight.w600,
        color: AppColors.ink,
      ),
      bodyLarge: TextStyle(
        fontSize: 16,
        height: 1.45,
        fontWeight: FontWeight.w400,
        color: AppColors.ink,
      ),
      bodyMedium: TextStyle(
        fontSize: 14,
        height: 1.45,
        fontWeight: FontWeight.w400,
        color: AppColors.ink,
      ),
      bodySmall: TextStyle(
        fontSize: 12,
        height: 1.45,
        fontWeight: FontWeight.w400,
        color: AppColors.muted,
      ),
      labelLarge: TextStyle(
        fontSize: 14,
        height: 1.45,
        fontWeight: FontWeight.w600,
        color: AppColors.ink,
      ),
      labelMedium: TextStyle(
        fontSize: 12,
        height: 1.45,
        fontWeight: FontWeight.w600,
        color: AppColors.ink,
      ),
      labelSmall: TextStyle(
        fontSize: 10,
        height: 1.45,
        fontWeight: FontWeight.w500,
        color: AppColors.muted,
      ),
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      fontFamily: 'Inter',
      colorScheme: colorScheme,
      scaffoldBackgroundColor: AppColors.background,
      textTheme: textTheme,
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.soft,
        hintStyle: textTheme.bodyMedium?.copyWith(color: AppColors.muted),
        errorStyle: textTheme.bodySmall?.copyWith(color: AppColors.danger),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: 15,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.input),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.input),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.input),
          borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.input),
          borderSide: const BorderSide(color: AppColors.danger),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.input),
          borderSide: const BorderSide(color: AppColors.danger, width: 1.5),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          minimumSize: const Size.fromHeight(52),
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.white,
          disabledBackgroundColor: AppColors.border,
          disabledForegroundColor: AppColors.muted,
          textStyle: textTheme.labelLarge,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.control),
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.deep,
          minimumSize: const Size(48, 48),
          textStyle: textTheme.labelMedium,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.control),
          ),
        ),
      ),
    );
  }
}
