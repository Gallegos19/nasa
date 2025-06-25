import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'app/my_app.dart';
import 'core/services/cache_service.dart';
import 'di/injection.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize services
  await _initializeServices();
  
  // Set preferred orientations
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  
  // Set system UI overlay style
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: Color(0xFF0A0A0A),
      systemNavigationBarIconBrightness: Brightness.light,
    ),
  );
  
  runApp(const NasaExplorerApp());
}

Future<void> _initializeServices() async {
  try {
    // Initialize dependency injection with Injectable
    configureDependencies();
    
    // Initialize cache service
    await CacheService().init();
    
    debugPrint('✅ All services initialized successfully');
  } catch (e) {
    debugPrint('❌ Error initializing services: $e');
  }
}