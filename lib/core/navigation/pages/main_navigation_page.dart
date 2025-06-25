import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nasa_explorer/core/constants/app_color.dart';
import 'package:nasa_explorer/core/navigation/cubit/navigation_cubit.dart';
import 'package:nasa_explorer/di/injection.dart';
import 'package:nasa_explorer/features/discovery/presentation/pages/discovery_page.dart';
import 'package:nasa_explorer/features/gallery/presentation/pages/gallery_page.dart';
import 'package:nasa_explorer/features/home/presentation/pages/home_page.dart';
import 'package:nasa_explorer/features/home/presentation/pages/placeholde_pages.dart' 
    show SolarSystemPage, ProfilePage;

class MainNavigationPage extends StatelessWidget {
  final NavigationTab initialTab;
  
  const MainNavigationPage({
    Key? key,
    this.initialTab = NavigationTab.home,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<NavigationCubit>(),
      child: BlocBuilder<NavigationCubit, NavigationState>(
        builder: (context, state) {
          return Scaffold(
            backgroundColor: AppColors.background,
            body: _buildCurrentPage(state.currentTab),
            bottomNavigationBar: _buildBottomNavigationBar(context, state),
          );
        },
      ),
    );
  }

  Widget _buildCurrentPage(NavigationTab currentTab) {
    switch (currentTab) {
      case NavigationTab.home:
        return const HomePage();
      case NavigationTab.discovery:
        return const DiscoveryPage();
      case NavigationTab.gallery:
        return const GalleryPage();
      case NavigationTab.solarSystem:
        return const SolarSystemPage();
      case NavigationTab.profile:
        return const ProfilePage();
    }
  }

  Widget _buildBottomNavigationBar(BuildContext context, NavigationState state) {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFF1A1A1A),
            Color(0xFF0A0A0A),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, -8),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(
                context: context,
                tab: NavigationTab.home,
                currentTab: state.currentTab,
                icon: Icons.home_rounded,
                label: 'Inicio',
              ),
              _buildNavItem(
                context: context,
                tab: NavigationTab.discovery,
                currentTab: state.currentTab,
                icon: Icons.explore_rounded,
                label: 'Descubrir',
              ),
              _buildNavItem(
                context: context,
                tab: NavigationTab.gallery,
                currentTab: state.currentTab,
                icon: Icons.photo_library_rounded,
                label: 'Galería',
              ),
              _buildNavItem(
                context: context,
                tab: NavigationTab.solarSystem,
                currentTab: state.currentTab,
                icon: Icons.public_rounded,
                label: 'Sistema Solar',
              ),
              _buildNavItem(
                context: context,
                tab: NavigationTab.profile,
                currentTab: state.currentTab,
                icon: Icons.person_rounded,
                label: 'Perfil',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required BuildContext context,
    required NavigationTab tab,
    required NavigationTab currentTab,
    required IconData icon,
    required String label,
  }) {
    final isSelected = tab == currentTab;

    return GestureDetector(
      onTap: () => context.read<NavigationCubit>().changeTab(tab),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          gradient: isSelected ? AppColors.cosmicGradient : null,
          color: isSelected ? null : Colors.transparent,
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppColors.primary.withOpacity(0.3),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ]
              : null,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isSelected 
                    ? Colors.white.withOpacity(0.2)
                    : Colors.transparent,
              ),
              child: Icon(
                icon,
                size: 24,
                color: isSelected ? AppColors.textPrimary : AppColors.textHint,
              ),
            ),
            const SizedBox(height: 4),
            AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 300),
              style: TextStyle(
                fontSize: 11,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                color: isSelected ? AppColors.textPrimary : AppColors.textHint,
                fontFamily: 'SpaceGrotesk',
              ),
              child: Text(label),
            ),
          ],
        ),
      ),
    );
  }
}