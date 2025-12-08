import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

/// Gestionnaire de styles de texte avec les polices Poppins locales
class AppTextStyles {
  // Titres principaux (Display)
  static TextStyle displayLarge(BuildContext context) {
    return const TextStyle(
      fontFamily: 'Poppins',
      fontSize: 32,
      fontWeight: FontWeight.w700, // Bold
      color: AppColors.textPrimary,
      height: 1.2,
    );
  }

  static TextStyle displayMedium(BuildContext context) {
    return const TextStyle(
      fontFamily: 'Poppins',
      fontSize: 28,
      fontWeight: FontWeight.w700, // Bold
      color: AppColors.textPrimary,
      height: 1.2,
    );
  }

  static TextStyle displaySmall(BuildContext context) {
    return const TextStyle(
      fontFamily: 'Poppins',
      fontSize: 24,
      fontWeight: FontWeight.w700, // Bold
      color: AppColors.textPrimary,
      height: 1.3,
    );
  }

  // Titres de section (Headline)
  static TextStyle headlineLarge(BuildContext context) {
    return const TextStyle(
      fontFamily: 'Poppins',
      fontSize: 22,
      fontWeight: FontWeight.w700, // Bold
      color: AppColors.textPrimary,
      height: 1.3,
    );
  }

  static TextStyle headlineMedium(BuildContext context) {
    return const TextStyle(
      fontFamily: 'Poppins',
      fontSize: 20,
      fontWeight: FontWeight.w600, // Medium/Bold
      color: AppColors.textPrimary,
      height: 1.3,
    );
  }

  static TextStyle headlineSmall(BuildContext context) {
    return const TextStyle(
      fontFamily: 'Poppins',
      fontSize: 18,
      fontWeight: FontWeight.w600, // Medium
      color: AppColors.textPrimary,
      height: 1.4,
    );
  }

  // Titres (Title)
  static TextStyle titleLarge(BuildContext context) {
    return const TextStyle(
      fontFamily: 'Poppins',
      fontSize: 18,
      fontWeight: FontWeight.w600, // Medium
      color: AppColors.textPrimary,
      height: 1.4,
    );
  }

  static TextStyle titleMedium(BuildContext context) {
    return const TextStyle(
      fontFamily: 'Poppins',
      fontSize: 16,
      fontWeight: FontWeight.w500, // Medium
      color: AppColors.textPrimary,
      height: 1.4,
    );
  }

  static TextStyle titleSmall(BuildContext context) {
    return const TextStyle(
      fontFamily: 'Poppins',
      fontSize: 14,
      fontWeight: FontWeight.w500, // Medium
      color: AppColors.textPrimary,
      height: 1.4,
    );
  }

  // Corps de texte (Body)
  static TextStyle bodyLarge(BuildContext context) {
    return const TextStyle(
      fontFamily: 'Poppins',
      fontSize: 16,
      fontWeight: FontWeight.w400, // Regular
      color: AppColors.textPrimary,
      height: 1.5,
    );
  }

  static TextStyle bodyMedium(BuildContext context) {
    return const TextStyle(
      fontFamily: 'Poppins',
      fontSize: 14,
      fontWeight: FontWeight.w400, // Regular
      color: AppColors.textSecondary,
      height: 1.5,
    );
  }

  static TextStyle bodySmall(BuildContext context) {
    return const TextStyle(
      fontFamily: 'Poppins',
      fontSize: 12,
      fontWeight: FontWeight.w400, // Regular
      color: AppColors.textSecondary,
      height: 1.5,
    );
  }

  // Labels
  static TextStyle labelLarge(BuildContext context) {
    return const TextStyle(
      fontFamily: 'Poppins',
      fontSize: 14,
      fontWeight: FontWeight.w500, // Medium
      color: AppColors.textPrimary,
      height: 1.4,
    );
  }

  static TextStyle labelMedium(BuildContext context) {
    return const TextStyle(
      fontFamily: 'Poppins',
      fontSize: 12,
      fontWeight: FontWeight.w500, // Medium
      color: AppColors.textSecondary,
      height: 1.4,
    );
  }

  static TextStyle labelSmall(BuildContext context) {
    return const TextStyle(
      fontFamily: 'Poppins',
      fontSize: 11,
      fontWeight: FontWeight.w500, // Medium
      color: AppColors.textSecondary,
      height: 1.4,
    );
  }

  // Styles spéciaux
  static TextStyle button(BuildContext context) {
    return const TextStyle(
      fontFamily: 'Poppins',
      fontSize: 16,
      fontWeight: FontWeight.w600, // Medium/Bold
      color: AppColors.white,
      height: 1.4,
    );
  }

  static TextStyle caption(BuildContext context) {
    return const TextStyle(
      fontFamily: 'Poppins',
      fontSize: 12,
      fontWeight: FontWeight.w400, // Regular
      color: AppColors.textLight,
      height: 1.4,
    );
  }

  static TextStyle overline(BuildContext context) {
    return const TextStyle(
      fontFamily: 'Poppins',
      fontSize: 10,
      fontWeight: FontWeight.w500, // Medium
      color: AppColors.textSecondary,
      height: 1.4,
      letterSpacing: 1.5,
    );
  }
}

