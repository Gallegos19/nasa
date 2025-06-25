import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nasa_explorer/app/theme/app_theme.dart';
import 'package:nasa_explorer/core/navigation/cubit/navigation_cubit.dart';
import 'package:nasa_explorer/core/navigation/pages/main_navigation_page.dart';
import 'package:nasa_explorer/di/injection.dart';

class NasaExplorerApp extends StatelessWidget {
  const NasaExplorerApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<NavigationCubit>(),
      child: MaterialApp(
        title: 'NASA Explorer',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.darkTheme,
        home: const MainNavigationPage(),
        builder: (context, child) {
          return MediaQuery(
            data: MediaQuery.of(context).copyWith(
              textScaleFactor: 1.0,
            ),
            child: child!,
          );
        },
      ),
    );
  }
}