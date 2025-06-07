import 'package:flutter/material.dart';

class AppColors {
  // Primary Colors - Tema espacial
  static const Color primary = Color(0xFF1B263B);
  static const Color primaryLight = Color(0xFF415A77);
  static const Color primaryDark = Color(0xFF0D1B2A);
  
  // Secondary Colors - Azules cósmicos
  static const Color secondary = Color(0xFF278F8F);
  static const Color secondaryLight = Color(0xFF48CAE4);
  static const Color secondaryDark = Color(0xFF023047);
  
  // Accent Colors - Dorados como estrellas
  static const Color accent = Color(0xFFFFB703);
  static const Color accentLight = Color(0xFFFFD60A);
  static const Color accentDark = Color(0xFFB08A00);
  
  // Background Colors
  static const Color background = Color(0xFF0A0A0A);
  static const Color backgroundLight = Color(0xFF1A1A1A);
  static const Color surface = Color(0xFF1E1E1E);
  static const Color surfaceLight = Color(0xFF2A2A2A);
  
  // Text Colors
  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFFB0B0B0);
  static const Color textHint = Color(0xFF808080);
  static const Color textDisabled = Color(0xFF606060);
  
  // Status Colors
  static const Color success = Color(0xFF4CAF50);
  static const Color warning = Color(0xFFFF9800);
  static const Color error = Color(0xFFE74C3C);
  static const Color info = Color(0xFF2196F3);
  
  // Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primary, primaryLight],
  );
  
  static const LinearGradient spaceGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color(0xFF0D1B2A),
      Color(0xFF1B263B),
      Color(0xFF2D3E50),
    ],
  );
  
  static const LinearGradient cosmicGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF1B263B),
      Color(0xFF278F8F),
      Color(0xFF48CAE4),
    ],
  );
}
