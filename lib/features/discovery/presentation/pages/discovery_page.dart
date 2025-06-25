import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nasa_explorer/core/constants/app_color.dart';
import 'package:nasa_explorer/di/injection.dart';
import 'package:nasa_explorer/features/home/presentation/widgets/custom_app_bar.dart';
import 'package:nasa_explorer/features/home/presentation/widgets/error_widget.dart';
import 'package:nasa_explorer/features/home/presentation/widgets/loading_widget.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../di/injection_container.dart' as di;
import '../cubit/discovery_cubit.dart';
import '../widgets/neo_card.dart';
import '../widgets/discovery_header.dart';
import '../widgets/neo_filter_chip.dart';

class DiscoveryPage extends StatelessWidget {
  const DiscoveryPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<DiscoveryCubit>()..loadTodayNeos(),
      child: const _DiscoveryPageContent(),
    );
  }
}

class _DiscoveryPageContent extends StatelessWidget {
  const _DiscoveryPageContent();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: CustomAppBar(
        title: 'Descubrimientos',
        showBackButton: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.calendar_today_rounded),
            onPressed: () => _showDatePicker(context),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () => context.read<DiscoveryCubit>().refresh(),
        backgroundColor: AppColors.surface,
        color: AppColors.primary,
        child: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            const SliverToBoxAdapter(child: DiscoveryHeader()),
            
            BlocBuilder<DiscoveryCubit, DiscoveryState>(
              builder: (context, state) {
                if (state is DiscoveryLoading) {
                  return const SliverFillRemaining(
                    child: Center(
                      child: SpaceLoadingWidget(
                        message: 'Explorando asteroides cercanos...',
                      ),
                    ),
                  );
                }
                
                if (state is DiscoveryError) {
                  return SliverFillRemaining(
                    child: Center(
                      child: SpaceErrorWidget(
                        message: state.message,
                        onRetry: () => context.read<DiscoveryCubit>().loadTodayNeos(),
                      ),
                    ),
                  );
                }
                
                if (state is DiscoveryLoaded || state is DiscoveryRefreshing) {
                  final neos = (state as DiscoveryLoaded).neos;
                  final isRefreshing = state is DiscoveryRefreshing;
                  
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
                                  'Actualizando datos...',
                                  style: AppTextStyles.bodySmall.copyWith(
                                    color: AppColors.primary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        const SizedBox(height: 16),
                        _buildNeoFilters(neos),
                        const SizedBox(height: 16),
                        _buildNeosList(neos),
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

  Widget _buildNeoFilters(List neos) {
    final hazardousCount = neos.where((neo) => neo.isPotentiallyHazardous).length;
    final closeCount = neos.where((neo) => 
      neo.nextCloseApproach?.missDistance != null && 
      neo.nextCloseApproach!.missDistance < 1000000
    ).length;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Filtros de Asteroides',
            style: AppTextStyles.h4.copyWith(
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              NeoFilterChip(
                label: 'Todos (${neos.length})',
                isSelected: true,
                onTap: () {},
              ),
              const SizedBox(width: 8),
              NeoFilterChip(
                label: 'Peligrosos ($hazardousCount)',
                isSelected: false,
                isHazardous: true,
                onTap: () {},
              ),
              const SizedBox(width: 8),
              NeoFilterChip(
                label: 'Cercanos ($closeCount)',
                isSelected: false,
                onTap: () {},
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildNeosList(List neos) {
    if (neos.isEmpty) {
      return const Center(
        child: Column(
          children: [
            Icon(
              Icons.scatter_plot_rounded,
              size: 64,
              color: AppColors.textHint,
            ),
            SizedBox(height: 16),
            Text(
              'No hay asteroides para hoy',
              style: AppTextStyles.h4,
            ),
            SizedBox(height: 8),
            Text(
              'Intenta seleccionar otro rango de fechas',
              style: AppTextStyles.bodyMedium,
            ),
          ],
        ),
      );
    }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Asteroides Cercanos (${neos.length})',
            style: AppTextStyles.h4.copyWith(
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 12),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: neos.length,
            separatorBuilder: (context, index) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final neo = neos[index];
              return NeoCard(
                neo: neo,
                onTap: () => _showNeoDetails(context, neo),
              );
            },
          ),
        ],
      ),
    );
  }

  void _showDatePicker(BuildContext context) async {
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2015),
      lastDate: DateTime.now().add(const Duration(days: 7)),
      currentDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.dark(
              primary: AppColors.primary,
              surface: AppColors.surface,
              background: AppColors.background,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && context.mounted) {
      final startDate = '${picked.start.year}-${picked.start.month.toString().padLeft(2, '0')}-${picked.start.day.toString().padLeft(2, '0')}';
      final endDate = '${picked.end.year}-${picked.end.month.toString().padLeft(2, '0')}-${picked.end.day.toString().padLeft(2, '0')}';
      
      context.read<DiscoveryCubit>().loadNeosByDateRange(startDate, endDate);
    }
  }

  void _showNeoDetails(BuildContext context, dynamic neo) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _NeoDetailModal(neo: neo),
    );
  }
}

// Simple Neo Detail Modal
class _NeoDetailModal extends StatelessWidget {
  final dynamic neo;

  const _NeoDetailModal({required this.neo});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.7,
      decoration: const BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: Column(
        children: [
          // Handle bar
          Container(
            margin: const EdgeInsets.only(top: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: AppColors.textHint,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    neo.name,
                    style: AppTextStyles.h2.copyWith(
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Detalles del asteroide próximamente...',
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}