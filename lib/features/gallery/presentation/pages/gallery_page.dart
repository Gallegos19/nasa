import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:nasa_explorer/core/constants/app_color.dart';
import 'package:nasa_explorer/features/gallery/presentation/widgets/rover_selector.dart';
import 'package:nasa_explorer/features/gallery/presentation/widgets/mars_photo_card.dart';
import 'package:nasa_explorer/features/gallery/presentation/widgets/photo_detail_modal.dart';
import 'package:nasa_explorer/features/home/presentation/widgets/custom_app_bar.dart';
import 'package:nasa_explorer/features/home/presentation/widgets/error_widget.dart';
import 'package:nasa_explorer/features/home/presentation/widgets/loading_widget.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../di/injection_container.dart' as di;
import '../cubit/gallery_cubit.dart';

class GalleryPage extends StatelessWidget {
  const GalleryPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => di.sl<GalleryCubit>()..loadLatestPhotos(),
      child: const _GalleryPageContent(),
    );
  }
}

class _GalleryPageContent extends StatelessWidget {
  const _GalleryPageContent();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: CustomAppBar(
        title: 'Galería Mars',
        showBackButton: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.search_rounded),
            onPressed: () {
              // TODO: Implement search functionality
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () => context.read<GalleryCubit>().refresh(),
        backgroundColor: AppColors.surface,
        color: AppColors.primary,
        child: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            // Rover Selector
            SliverToBoxAdapter(
              child: Container(
                padding: const EdgeInsets.all(16),
                child: const RoverSelector(),
              ),
            ),
            
            // Photos Grid
            BlocBuilder<GalleryCubit, GalleryState>(
              builder: (context, state) {
                if (state is GalleryLoading) {
                  return const SliverFillRemaining(
                    child: Center(child: SpaceLoadingWidget(message: 'Cargando fotos de Marte...')),
                  );
                }
                
                if (state is GalleryError) {
                  return SliverFillRemaining(
                    child: Center(
                      child: SpaceErrorWidget(
                        message: state.message,
                        onRetry: () => context.read<GalleryCubit>().loadLatestPhotos(),
                      ),
                    ),
                  );
                }
                
                if (state is GalleryLoaded || state is GalleryRefreshing) {
                  final photos = (state as GalleryLoaded).photos;
                  final isRefreshing = state is GalleryRefreshing;
                  
                  if (photos.isEmpty) {
                    return const SliverFillRemaining(
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.photo_library_outlined,
                              size: 64,
                              color: AppColors.textHint,
                            ),
                            SizedBox(height: 16),
                            Text(
                              'No hay fotos disponibles',
                              style: AppTextStyles.h4,
                            ),
                            SizedBox(height: 8),
                            Text(
                              'Intenta seleccionar otro rover',
                              style: AppTextStyles.bodyMedium,
                            ),
                          ],
                        ),
                      ),
                    );
                  }
                  
                  return SliverToBoxAdapter(
                    child: Column(
                      children: [
                        if (isRefreshing)
                          Container(
                            margin: const EdgeInsets.symmetric(horizontal: 16),
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: AppColors.primary.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: AppColors.primary.withOpacity(0.3),
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                SizedBox(
                                  width: 16,
                                  height: 16,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      AppColors.primary,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'Actualizando galería...',
                                  style: AppTextStyles.bodySmall.copyWith(
                                    color: AppColors.primary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        const SizedBox(height: 16),
                        _buildPhotosInfo(state.currentRover, photos.length),
                        const SizedBox(height: 16),
                        _buildPhotosGrid(context, photos),
                        const SizedBox(height: 24),
                      ],
                    ),
                  );
                }
                
                return const SliverToBoxAdapter(child: SizedBox.shrink());
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPhotosInfo(String roverName, int photoCount) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: AppColors.cosmicGradient,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(
            _getRoverIcon(roverName),
            color: Colors.white,
            size: 24,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  roverName.toUpperCase(),
                  style: AppTextStyles.h4.copyWith(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
                Text(
                  '$photoCount fotos disponibles',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: Colors.white.withOpacity(0.8),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPhotosGrid(BuildContext context, List photos) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: StaggeredGrid.count(
        crossAxisCount: 2,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        children: photos.asMap().entries.map((entry) {
          final index = entry.key;
          final photo = entry.value;
          
          return StaggeredGridTile.count(
            crossAxisCellCount: 1,
            mainAxisCellCount: index % 3 == 0 ? 1.4 : 1.0,
            child: MarsPhotoCard(
              photo: photo,
              onTap: () => _showPhotoDetail(context, photo, photos),
            ),
          );
        }).toList(),
      ),
    );
  }

  IconData _getRoverIcon(String roverName) {
    switch (roverName.toLowerCase()) {
      case 'curiosity':
        return Icons.precision_manufacturing_rounded;
      case 'perseverance':
        return Icons.android_rounded;
      case 'opportunity':
        return Icons.settings_rounded;
      case 'spirit':
        return Icons.explore_rounded;
      default:
        return Icons.device_unknown_rounded;
    }
  }

  void _showPhotoDetail(BuildContext context, dynamic photo, List photos) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => PhotoDetailModal(
        photo: photo,
        allPhotos: photos.cast(),
      ),
    );
  }
}