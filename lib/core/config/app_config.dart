import 'package:flutter/foundation.dart';

class AppConfig {
  static bool get isDebug => kDebugMode;
  static bool get isRelease => kReleaseMode;
  
  // Environment
  static const String environment = String.fromEnvironment(
    'ENVIRONMENT',
    defaultValue: 'development',
  );
  
  // Features Flags
  static const bool enableLogging = true;
  static const bool enableCaching = true;
  static const bool enableOfflineMode = true;
  
  // Network
  static const bool enableMockData = false; // Para testing
  static const bool enableNetworkLogging = true;
  
  // UI
  static const bool enableAnimations = true;
  static const bool enableHapticFeedback = true;
  
  // Cache Settings
  static const int maxCacheSize = 100; // MB
  static const int imageCacheSize = 200; // Number of images
  
  static bool get isDevelopment => environment == 'development';
  static bool get isProduction => environment == 'production';
}