import 'package:flutter/material.dart';
import 'package:nasa_explorer/core/constants/app_color.dart';
import '../../../../core/constants/app_text_styles.dart';

class NeoFilterChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final bool isHazardous;
  final VoidCallback onTap;

  const NeoFilterChip({
    Key? key,
    required this.label,
    required this.isSelected,
    required this.onTap,
    this.isHazardous = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          gradient: isSelected 
              ? (isHazardous ? 
                  const LinearGradient(colors: [AppColors.error, Color(0xFFFF6B6B)]) :
                  AppColors.primaryGradient)
              : null,
          color: isSelected ? null : AppColors.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected 
                ? Colors.transparent
                : (isHazardous ? AppColors.error : AppColors.textHint.withOpacity(0.3)),
          ),
        ),
        child: Text(
          label,
          style: AppTextStyles.bodySmall.copyWith(
            color: isSelected 
                ? Colors.white
                : (isHazardous ? AppColors.error : AppColors.textSecondary),
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
          ),
        ),
      ),
    );
  }
}