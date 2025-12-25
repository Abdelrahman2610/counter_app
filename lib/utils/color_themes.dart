import 'package:flutter/material.dart';

class ColorThemes {
  static const Map<String, ColorScheme> lightThemes = {
    'indigo': ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xFF6366F1),
      onPrimary: Colors.white,
      secondary: Color(0xFF8B5CF6),
      onSecondary: Colors.white,
      error: Color(0xFFEF4444),
      onError: Colors.white,
      surface: Colors.white,
      onSurface: Color(0xFF1E293B),
    ),
    'emerald': ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xFF10B981),
      onPrimary: Colors.white,
      secondary: Color(0xFF059669),
      onSecondary: Colors.white,
      error: Color(0xFFEF4444),
      onError: Colors.white,
      surface: Colors.white,
      onSurface: Color(0xFF1E293B),
    ),
    'rose': ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xFFE11D48),
      onPrimary: Colors.white,
      secondary: Color(0xFFF43F5E),
      onSecondary: Colors.white,
      error: Color(0xFFDC2626),
      onError: Colors.white,
      surface: Colors.white,
      onSurface: Color(0xFF1E293B),
    ),
    'amber': ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xFFF59E0B),
      onPrimary: Colors.white,
      secondary: Color(0xFFFBBF24),
      onSecondary: Colors.white,
      error: Color(0xFFEF4444),
      onError: Colors.white,
      surface: Colors.white,
      onSurface: Color(0xFF1E293B),
    ),
    'cyan': ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xFF06B6D4),
      onPrimary: Colors.white,
      secondary: Color(0xFF0891B2),
      onSecondary: Colors.white,
      error: Color(0xFFEF4444),
      onError: Colors.white,
      surface: Colors.white,
      onSurface: Color(0xFF1E293B),
    ),
  };

  static const Map<String, ColorScheme> darkThemes = {
    'indigo': ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xFF818CF8),
      onPrimary: Color(0xFF1E1B4B),
      secondary: Color(0xFFA78BFA),
      onSecondary: Color(0xFF3B0764),
      error: Color(0xFFF87171),
      onError: Color(0xFF7F1D1D),
      surface: Color(0xFF1E293B),
      onSurface: Color(0xFFF1F5F9),
    ),
    'emerald': ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xFF34D399),
      onPrimary: Color(0xFF064E3B),
      secondary: Color(0xFF10B981),
      onSecondary: Color(0xFF065F46),
      error: Color(0xFFF87171),
      onError: Color(0xFF7F1D1D),
      surface: Color(0xFF1E293B),
      onSurface: Color(0xFFF1F5F9),
    ),
    'rose': ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xFFFB7185),
      onPrimary: Color(0xFF881337),
      secondary: Color(0xFFFDA4AF),
      onSecondary: Color(0xFF9F1239),
      error: Color(0xFFF87171),
      onError: Color(0xFF7F1D1D),
      surface: Color(0xFF1E293B),
      onSurface: Color(0xFFF1F5F9),
    ),
    'amber': ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xFFFBBF24),
      onPrimary: Color(0xFF78350F),
      secondary: Color(0xFFFCD34D),
      onSecondary: Color(0xFF92400E),
      error: Color(0xFFF87171),
      onError: Color(0xFF7F1D1D),
      surface: Color(0xFF1E293B),
      onSurface: Color(0xFFF1F5F9),
    ),
    'cyan': ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xFF22D3EE),
      onPrimary: Color(0xFF164E63),
      secondary: Color(0xFF06B6D4),
      onSecondary: Color(0xFF155E75),
      error: Color(0xFFF87171),
      onError: Color(0xFF7F1D1D),
      surface: Color(0xFF1E293B),
      onSurface: Color(0xFFF1F5F9),
    ),
  };

  static List<String> get themeNames => lightThemes.keys.toList();

  static Color getPrimaryColor(String theme, bool isDark) {
    if (isDark) {
      return darkThemes[theme]?.primary ?? darkThemes['indigo']!.primary;
    }
    return lightThemes[theme]?.primary ?? lightThemes['indigo']!.primary;
  }
}
