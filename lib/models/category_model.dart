import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

class Category {
  final String name;
  final IconData icon;
  final Color color;
  final List<Color> gradient;

  Category({
    required this.name,
    required this.icon,
    required this.color,
    required this.gradient,
  });
}

class CategoryData {
  static final Map<String, Category> categories = {
    'All': Category(
      name: 'All',
      icon: Icons.dashboard,
      color: AppColors.textSecondary,
      gradient: AppColors.allGradient,
    ),
    'Tech': Category(
      name: 'Tech',
      icon: Icons.computer,
      color: AppColors.primaryBlue,
      gradient: AppColors.techGradient,
    ),
    'Sports': Category(
      name: 'Sports',
      icon: Icons.sports_soccer,
      color: AppColors.successGreen,
      gradient: AppColors.sportsGradient,
    ),
    'Culture': Category(
      name: 'Culture',
      icon: Icons.palette,
      color: AppColors.secondaryPurple,
      gradient: AppColors.cultureGradient,
    ),
    'Music': Category(
      name: 'Music',
      icon: Icons.music_note,
      color: AppColors.accentOrange,
      gradient: AppColors.musicGradient,
    ),
  };
}