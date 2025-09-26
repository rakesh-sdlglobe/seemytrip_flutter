import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class ThemeService extends GetxController {
  final _box = GetStorage();
  final _key = 'isDarkMode';

  // Get the theme mode from local storage
  bool _loadThemeFromBox() {
    try {
      return _box.read(_key) ?? false;
    } catch (e) {
      print('Error loading theme from storage: $e');
      return false; // Default to light theme
    }
  }

  // Save theme mode to local storage
  Future<void> _saveThemeToBox(bool isDarkMode) async {
    try {
      await _box.write(_key, isDarkMode);
    } catch (e) {
      print('Error saving theme to storage: $e');
    }
  }

  // Get the current theme mode
  ThemeMode get theme => _loadThemeFromBox() ? ThemeMode.dark : ThemeMode.light;
  
  // Check if dark mode is currently enabled
  bool get isDarkMode => _loadThemeFromBox();

  // Toggle between light and dark theme
  Future<void> switchTheme() async {
    final isDark = _loadThemeFromBox();
    await _saveThemeToBox(!isDark);
    // Update GetX theme mode
    Get.changeThemeMode(!isDark ? ThemeMode.dark : ThemeMode.light);
    update(); // This notifies all listeners
  }

  // Initialize the service
  Future<ThemeService> init() async {
    // Set the initial theme mode
    Get.changeThemeMode(theme);
    return this;
  }
}
