// lib/core/theme/theme_demo_widget.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'theme_extensions.dart';
import 'theme_service.dart';

/// Demo widget showing how to use the theme system
/// This can be used as a reference for implementing theme-aware widgets
class ThemeDemoWidget extends StatelessWidget {
  const ThemeDemoWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final themeService = Get.find<ThemeService>();
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Theme Demo'),
        backgroundColor: context.appBarBg,
        foregroundColor: context.appBarFg,
        actions: [
          // Theme toggle button
          IconButton(
            icon: Icon(
              themeService.isDarkMode ? Icons.light_mode : Icons.dark_mode,
            ),
            onPressed: () async {
              await themeService.switchTheme();
            },
            tooltip: 'Toggle Theme',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Text(
              'Theme System Demo',
              style: context.headlineMedium,
            ),
            const SizedBox(height: 8),
            Text(
              'This demonstrates theme-aware components',
              style: context.bodyMedium?.copyWith(color: context.textSecondary),
            ),
            const SizedBox(height: 24),
            
            // Color Swatches
            _buildSection(
              context,
              title: 'Colors',
              child: Wrap(
                spacing: 12,
                runSpacing: 12,
                children: [
                  _buildColorSwatch(context, 'Primary', context.primary),
                  _buildColorSwatch(context, 'Secondary', context.secondary),
                  _buildColorSwatch(context, 'Surface', context.surface),
                  _buildColorSwatch(context, 'Error', context.error),
                  _buildColorSwatch(context, 'Success', context.success),
                  _buildColorSwatch(context, 'Warning', context.warning),
                ],
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Cards
            _buildSection(
              context,
              title: 'Cards',
              child: Column(
                children: [
                  Container(
                    decoration: context.cardDecoration(),
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Theme-Aware Card',
                          style: context.bodyLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'This card automatically adapts to the current theme',
                          style: context.bodyMedium,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    decoration: context.cardDecoration(
                      borderRadius: 20,
                      withShadow: false,
                    ),
                    padding: const EdgeInsets.all(16),
                    child: Text(
                      'Custom radius, no shadow',
                      style: context.bodyMedium,
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Buttons
            _buildSection(
              context,
              title: 'Buttons',
              child: Wrap(
                spacing: 12,
                runSpacing: 12,
                children: [
                  ElevatedButton(
                    onPressed: () {},
                    child: const Text('Elevated Button'),
                  ),
                  OutlinedButton(
                    onPressed: () {},
                    child: const Text('Outlined Button'),
                  ),
                  TextButton(
                    onPressed: () {},
                    child: const Text('Text Button'),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Input Fields
            _buildSection(
              context,
              title: 'Input Fields',
              child: Column(
                children: [
                  TextField(
                    decoration: context.themedInputDecoration(
                      hintText: 'Enter text',
                      labelText: 'Label',
                      prefixIcon: const Icon(Icons.search),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    decoration: context.themedInputDecoration(
                      hintText: 'With suffix',
                      suffixIcon: const Icon(Icons.visibility),
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Text Styles
            _buildSection(
              context,
              title: 'Text Styles',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Display Large', style: context.displayLarge),
                  const SizedBox(height: 8),
                  Text('Headline Large', style: context.headlineLarge),
                  const SizedBox(height: 8),
                  Text('Headline Medium', style: context.headlineMedium),
                  const SizedBox(height: 8),
                  Text('Body Large', style: context.bodyLarge),
                  const SizedBox(height: 8),
                  Text('Body Medium', style: context.bodyMedium),
                  const SizedBox(height: 8),
                  Text('Body Small', style: context.bodySmall),
                  const SizedBox(height: 8),
                  Text('Label Large', style: context.labelLarge),
                ],
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Theme Info
            _buildSection(
              context,
              title: 'Current Theme',
              child: Container(
                decoration: context.cardDecoration(),
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildInfoRow(
                      context,
                      'Mode',
                      context.isDark ? 'Dark' : 'Light',
                    ),
                    const Divider(),
                    _buildInfoRow(
                      context,
                      'Primary Color',
                      context.primary.toString(),
                    ),
                    const Divider(),
                    _buildInfoRow(
                      context,
                      'Background',
                      context.scaffold.toString(),
                    ),
                    const Divider(),
                    _buildInfoRow(
                      context,
                      'Surface',
                      context.surface.toString(),
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
  
  Widget _buildSection(
    BuildContext context, {
    required String title,
    required Widget child,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: context.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        child,
      ],
    );
  }
  
  Widget _buildColorSwatch(BuildContext context, String label, Color color) {
    return Column(
      children: [
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: context.border),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: context.bodySmall,
        ),
      ],
    );
  }
  
  Widget _buildInfoRow(BuildContext context, String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: context.bodyMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        Flexible(
          child: Text(
            value,
            style: context.bodySmall?.copyWith(
              color: context.textSecondary,
            ),
            textAlign: TextAlign.right,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}

