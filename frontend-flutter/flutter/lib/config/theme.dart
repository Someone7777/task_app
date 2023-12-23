import 'package:task_app/config/app_colors.dart';
import 'package:flutter/material.dart';

/// Default [ThemeData]
class AppTheme {
  @visibleForTesting
  static NavigationRailThemeData navigationRailTheme =
      const NavigationRailThemeData(
          selectedIconTheme: IconThemeData(color: Colors.white),
          unselectedIconTheme: IconThemeData(color: Colors.white54),
          backgroundColor: Color.fromARGB(255, 70, 70, 70));

  @visibleForTesting
  static BottomNavigationBarThemeData bottomNavigationBarTheme =
      const BottomNavigationBarThemeData(
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.white54,
          backgroundColor: Color.fromARGB(255, 70, 70, 70));

  /// Light [ThemeData]
  static ThemeData lightTheme = darkTheme;

  /// Dark [ThemeData]
  static ThemeData darkTheme = ThemeData(
      brightness: Brightness.dark,
      primaryColor: AppColors.primaryColor,
      scaffoldBackgroundColor: const Color.fromARGB(255, 31, 31, 31),
      navigationRailTheme: navigationRailTheme,
      bottomNavigationBarTheme: bottomNavigationBarTheme,
      primaryTextTheme: const TextTheme().apply(
        bodyColor: Colors.white,
        displayColor: Colors.white,
        decorationColor: Colors.white,
      ),
      // Text widget theme
      textTheme: const TextTheme().apply(
        bodyColor: Colors.white,
        displayColor: Colors.white,
        decorationColor: Colors.white,
      ),
      colorScheme: ColorScheme.fromSwatch(primarySwatch: AppColors.primaryColor)
          .copyWith(
              brightness: Brightness.dark, background: AppColors.primaryColor));
}
