import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class ThemeService extends GetxController {
  final _box = GetStorage();
  final _key = 'isDarkMode';

  // Reactive state for theme mode
  final RxBool _isDarkMode = false.obs;

  // Get the current theme mode
  ThemeMode get theme => _isDarkMode.value ? ThemeMode.dark : ThemeMode.light;
  
  // Check if dark mode is currently enabled
  bool get isDarkMode => _isDarkMode.value;

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
      print('Theme saved to storage: ${isDarkMode ? "Dark" : "Light"}');
    } catch (e) {
      print('Error saving theme to storage: $e');
    }
  }

  // Toggle between light and dark theme
  Future<void> switchTheme() async {
    final newThemeMode = !_isDarkMode.value;
    _isDarkMode.value = newThemeMode;
    
    // Save to storage
    await _saveThemeToBox(newThemeMode);
    
    // Update GetX theme mode
    Get.changeThemeMode(newThemeMode ? ThemeMode.dark : ThemeMode.light);
    
    // Notify listeners
    update();
  }

  // Set specific theme mode
  Future<void> setThemeMode(bool isDark) async {
    if (_isDarkMode.value != isDark) {
      _isDarkMode.value = isDark;
      
      // Save to storage
      await _saveThemeToBox(isDark);
      
      // Update GetX theme mode
      Get.changeThemeMode(isDark ? ThemeMode.dark : ThemeMode.light);
      
      // Notify listeners
      update();
    }
  }

  // Initialize the service
  Future<ThemeService> init() async {
    // Load theme from storage
    _isDarkMode.value = _loadThemeFromBox();
    
    // Set the initial theme mode
    Get.changeThemeMode(theme);
    
    print('Theme initialized: ${_isDarkMode.value ? "Dark" : "Light"}');
    return this;
  }

  // Get theme mode as string for debugging
  String get themeModeString => _isDarkMode.value ? 'Dark' : 'Light';
}
