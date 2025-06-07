import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:nasa_explorer/core/constants/app_color.dart';
import 'package:nasa_explorer/features/home/presentation/widgets/error_widget.dart';
import 'package:nasa_explorer/features/home/presentation/widgets/loading_widget.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../di/injection_container.dart' as di;
import '../cubit/home_cubit.dart';
import '../widgets/apod_card.dart';
import '../widgets/home_header.dart';


class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => di.sl<HomeCubit>()..loadTodayApod(),
      child: const _HomePageContent(),
    );
  }
}

class _HomePageContent extends StatelessWidget {
  const _HomePageContent();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () => context.read<HomeCubit>().refreshApod(),
          backgroundColor: AppColors.surface,
          color: AppColors.primary,
          child: CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: [
              const SliverToBoxAdapter(child: HomeHeader()),
              SliverToBoxAdapter(
                child: BlocBuilder<HomeCubit, HomeState>(
                  builder: (context, state) {
                    if (state is HomeLoading) {
                      return const SizedBox(
                        height: 400,
                        child: Center(child: SpaceLoadingWidget()),
                      );
                    }
                    
                    if (state is HomeError) {
                      return SizedBox(
                        height: 400,
                        child: Center(
                          child: SpaceErrorWidget(
                            message: state.message,
                            onRetry: () => context.read<HomeCubit>().loadTodayApod(),
                          ),
                        ),
                      );
                    }
                    
                    if (state is HomeLoaded || state is HomeRefreshing) {
                      final apod = (state as HomeLoaded).apod;
                      final isRefreshing = state is HomeRefreshing;
                      
                      return Column(
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
                                    'Actualizando...',
                                    style: AppTextStyles.bodySmall.copyWith(
                                      color: AppColors.primary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          const SizedBox(height: 16),
                          ApodCard(apod: apod),
                          const SizedBox(height: 24),
                          _buildExploreSection(context),
                        ],
                      );
                    }
                    
                    return const SizedBox.shrink();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildExploreSection(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Explorar Más',
            style: AppTextStyles.h3.copyWith(
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 16),
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 1.2,
            children: [
              _buildExploreCard(
                title: 'Galería Mars',
                subtitle: 'Fotos de rovers',
                icon: Icons.photo_camera_rounded,
                gradient: AppColors.cosmicGradient,
                onTap: () {
                  // Navigate to Mars gallery
                },
              ),
              _buildExploreCard(
                title: 'Asteroides',
                subtitle: 'Objetos cercanos',
                icon: Icons.scatter_plot_rounded,
                gradient: const LinearGradient(
                  colors: [Color(0xFF6B73FF), Color(0xFF000DFF)],
                ),
                onTap: () {
                  // Navigate to NEO discovery
                },
              ),
              _buildExploreCard(
                title: 'Sistema Solar',
                subtitle: 'Planetas y lunas',
                icon: Icons.public_rounded,
                gradient: const LinearGradient(
                  colors: [Color(0xFFFF6B6B), Color(0xFFFFE66D)],
                ),
                onTap: () {
                  // Navigate to solar system
                },
              ),
              _buildExploreCard(
                title: 'Archivo APOD',
                subtitle: 'Historial de imágenes',
                icon: Icons.archive_rounded,
                gradient: const LinearGradient(
                  colors: [Color(0xFF4ECDC4), Color(0xFF44A08D)],
                ),
                onTap: () {
                  // Navigate to APOD archive
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildExploreCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required Gradient gradient,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          gradient: gradient,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(
                icon,
                color: Colors.white,
                size: 32,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTextStyles.h4.copyWith(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: AppTextStyles.bodySmall.copyWith(
                      color: Colors.white.withOpacity(0.8),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}