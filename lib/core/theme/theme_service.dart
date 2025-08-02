import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class ThemeService extends GetxService {
  final _box = GetStorage();
  final _key = 'isDarkMode';

  // Get the theme mode from local storage
  bool _loadThemeFromBox() => _box.read(_key) ?? false;

  // Save theme mode to local storage
  _saveThemeToBox(bool isDarkMode) => _box.write(_key, isDarkMode);

  // Get the current theme mode
  ThemeMode get theme => _loadThemeFromBox() ? ThemeMode.dark : ThemeMode.light;

  // Toggle between light and dark theme
  void switchTheme() {
    Get.changeThemeMode(_loadThemeFromBox() ? ThemeMode.light : ThemeMode.dark);
    _saveThemeToBox(!_loadThemeFromBox());
  }

  // Initialize the service
  Future<ThemeService> init() async {
    // Set the initial theme mode
    Get.changeThemeMode(theme);
    return this;
  }
}
