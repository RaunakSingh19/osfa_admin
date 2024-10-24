import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ThemeController extends GetxController {
  // Define your custom light and dark themes using ThemeData
  final ThemeData lightTheme = ThemeData(
    colorScheme: ColorScheme.light(
      primary: Colors.deepPurple, // Custom primary color for light theme
      secondary: Colors.deepPurpleAccent,
      background: Colors.white,
      surface: Colors.grey.shade200,
    ),
    scaffoldBackgroundColor: Colors.white,
    appBarTheme: AppBarTheme(
      color: Colors.grey.shade100, // Custom app bar color for light theme
    ),
  );

  final ThemeData darkTheme = ThemeData(
    colorScheme: ColorScheme.dark(
      primary: Colors.indigo, // Custom primary color for dark theme
      secondary: Colors.indigo,
      background: Colors.black,
      surface: Colors.grey.shade900,
    ),
    scaffoldBackgroundColor: Colors.black,
    appBarTheme: AppBarTheme(
      color: Colors.indigo, // Custom app bar color for dark theme
    ),
  );

  // Observable for theme management
  Rx<ThemeData> themeData = ThemeData.light().obs;

  @override
  void onInit() {
    super.onInit();
    // Set initial theme to light theme
    themeData.value = lightTheme;
  }

  // Toggle between light and dark themes
  void toggleTheme() {
    if (themeData.value == lightTheme) {
      themeData.value = darkTheme;
    } else {
      themeData.value = lightTheme;
    }
  }

  // Check if current theme is dark mode
  bool get isDarkMode => themeData.value == darkTheme;
}
