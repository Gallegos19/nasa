import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nasa_explorer/core/constants/app_color.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/constants/app_constants.dart';
import '../cubit/gallery_cubit.dart';

class RoverSelector extends StatelessWidget {
  const RoverSelector({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GalleryCubit, GalleryState>(
      builder: (context, state) {
        final currentRover = context.read<GalleryCubit>().currentRover;
        
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Selecciona un Rover',
              style: AppTextStyles.h4.copyWith(
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 120,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: AppConstants.marsRovers.length,
                itemBuilder: (context, index) {
                  final rover = AppConstants.marsRovers[index];
                  final isSelected = rover == currentRover;
                  
                  return Container(
                    width: 100,
                    margin: EdgeInsets.only(
                      right: index < AppConstants.marsRovers.length - 1 ? 12 : 0,
                    ),
                    child: GestureDetector(
                      onTap: () => context.read<GalleryCubit>().changeRover(rover),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          gradient: isSelected 
                              ? AppColors.cosmicGradient
                              : null,
                          color: isSelected 
                              ? null 
                              : AppColors.surface,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: isSelected 
                                ? Colors.transparent
                                : AppColors.textHint.withOpacity(0.3),
                          ),
                          boxShadow: isSelected ? [
                            BoxShadow(
                              color: AppColors.primary.withOpacity(0.3),
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                            ),
                          ] : null,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              _getRoverIcon(rover),
                              size: 32,
                              color: isSelected 
                                  ? Colors.white
                                  : AppColors.textSecondary,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              rover.toUpperCase(),
                              style: AppTextStyles.bodySmall.copyWith(
                                color: isSelected 
                                    ? Colors.white
                                    : AppColors.textSecondary,
                                fontWeight: isSelected 
                                    ? FontWeight.w600
                                    : FontWeight.w500,
                              ),
                              textAlign: TextAlign.center,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }

  IconData _getRoverIcon(String roverName) {
    switch (roverName.toLowerCase()) {
      case 'curiosity':
        return Icons.precision_manufacturing_rounded;
      case 'perseverance':
        return Icons.android_rounded;
      case 'opportunity':
        return Icons.lightbulb_outline_rounded;
      case 'spirit':
        return Icons.explore_rounded;
      default:
        return Icons.question_mark_rounded; // Default icon for unknown rovers
    }
  } 
}