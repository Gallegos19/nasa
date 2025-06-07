import 'package:flutter/material.dart';
import 'package:nasa_explorer/core/constants/app_color.dart';
import 'package:nasa_explorer/features/home/presentation/widgets/custom_app_bar.dart';
import '../../../../core/constants/app_text_styles.dart';

class DiscoveryPage extends StatelessWidget {
  const DiscoveryPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const CustomAppBar(
        title: 'Descubrimientos',
        showBackButton: false,
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.explore_rounded,
              size: 64,
              color: AppColors.primary,
            ),
            SizedBox(height: 16),
            Text(
              'Descubrimientos',
              style: AppTextStyles.h3,
            ),
            SizedBox(height: 8),
            Text(
              'Próximamente: Asteroides y objetos cercanos a la Tierra',
              style: AppTextStyles.bodyMedium,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class GalleryPage extends StatelessWidget {
  const GalleryPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const CustomAppBar(
        title: 'Galería',
        showBackButton: false,
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.photo_library_rounded,
              size: 64,
              color: AppColors.secondary,
            ),
            SizedBox(height: 16),
            Text(
              'Galería Mars',
              style: AppTextStyles.h3,
            ),
            SizedBox(height: 8),
            Text(
              'Próximamente: Fotos de los rovers de Marte',
              style: AppTextStyles.bodyMedium,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class SolarSystemPage extends StatelessWidget {
  const SolarSystemPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const CustomAppBar(
        title: 'Sistema Solar',
        showBackButton: false,
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.public_rounded,
              size: 64,
              color: AppColors.accent,
            ),
            SizedBox(height: 16),
            Text(
              'Sistema Solar',
              style: AppTextStyles.h3,
            ),
            SizedBox(height: 8),
            Text(
              'Próximamente: Información de planetas y lunas',
              style: AppTextStyles.bodyMedium,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class ProfilePage extends StatelessWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const CustomAppBar(
        title: 'Perfil',
        showBackButton: false,
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.person_rounded,
              size: 64,
              color: AppColors.primary,
            ),
            SizedBox(height: 16),
            Text(
              'Perfil de Usuario',
              style: AppTextStyles.h3,
            ),
            SizedBox(height: 8),
            Text(
              'Próximamente: Configuraciones y favoritos',
              style: AppTextStyles.bodyMedium,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
