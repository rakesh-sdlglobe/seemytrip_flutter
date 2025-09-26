import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:seemytrip/core/theme/theme_service.dart';
import 'package:seemytrip/core/theme/app_colors.dart';

/// A test widget to demonstrate theme switching and persistence functionality
class ThemeTestWidget extends StatelessWidget {
  const ThemeTestWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeService = Get.find<ThemeService>();
    
    return GetBuilder<ThemeService>(
      builder: (controller) => Card(
        margin: const EdgeInsets.all(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Theme Test Widget',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 16),
              
              // Current theme status
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: themeService.isDarkMode 
                      ? AppColors.primary.withOpacity(0.1)
                      : AppColors.primary.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: themeService.isDarkMode 
                        ? AppColors.primary.withOpacity(0.3)
                        : AppColors.primary.withOpacity(0.2),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      themeService.isDarkMode ? Icons.dark_mode : Icons.light_mode,
                      color: AppColors.primary,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Current Theme: ${themeService.themeModeString}',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 16),
              
              // Theme toggle buttons
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () => themeService.setThemeMode(false),
                      icon: const Icon(Icons.light_mode),
                      label: const Text('Light Theme'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: themeService.isDarkMode 
                            ? AppColors.surfaceDark 
                            : AppColors.primary,
                        foregroundColor: themeService.isDarkMode 
                            ? AppColors.white 
                            : AppColors.white,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () => themeService.setThemeMode(true),
                      icon: const Icon(Icons.dark_mode),
                      label: const Text('Dark Theme'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: themeService.isDarkMode 
                            ? AppColors.primary 
                            : AppColors.surface,
                        foregroundColor: themeService.isDarkMode 
                            ? AppColors.white 
                            : AppColors.primary,
                      ),
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 12),
              
              // Toggle button
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () => themeService.switchTheme(),
                  icon: Icon(
                    themeService.isDarkMode ? Icons.light_mode : Icons.dark_mode,
                  ),
                  label: Text(
                    'Switch to ${themeService.isDarkMode ? 'Light' : 'Dark'} Theme',
                  ),
                ),
              ),
              
              const SizedBox(height: 16),
              
              // Theme persistence info
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: themeService.isDarkMode 
                      ? AppColors.cardDark.withOpacity(0.5)
                      : AppColors.surface.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Theme Persistence Info:',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '• Theme preference is saved in SharedPreferences\n'
                      '• Theme state persists across app restarts\n'
                      '• Theme changes are applied immediately\n'
                      '• Uses GetStorage for efficient storage',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
