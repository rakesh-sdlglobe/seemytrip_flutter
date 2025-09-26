import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/theme_service.dart';
import '../../../../../core/widgets/common_text_widget.dart';
import '../../../../../shared/constants/images.dart';
import 'language_screen.dart';

class SettingScreen extends StatelessWidget {
  SettingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: Theme.of(context).brightness == Brightness.dark 
            ? AppColors.backgroundDark 
            : AppColors.whiteF2F,
        appBar: _buildModernAppBar(context),
        body: SingleChildScrollView(
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSettingsSection(
                context: context,
                title: 'General',
                children: [
                  _buildSettingCard(
                    context: context,
                    icon: Icons.public,
                    title: 'Country/Region',
                    subtitle: 'India',
                    trailing: Image.asset(settingImage1, height: 24, width: 80),
                    onTap: () {},
                  ),
                  _buildSettingCard(
                    context: context,
                    icon: Icons.language,
                    title: 'Language',
                    subtitle: 'English',
                    trailing: Image.asset(settingImage2, height: 24, width: 80),
                    onTap: () => Get.to(() => LanguageScreen()),
                  ),
                  _buildSettingCard(
                    context: context,
                    icon: Icons.attach_money,
                    title: 'Currency',
                    subtitle: 'Indian Rupee (₹)',
                    trailing: Icon(
                      Icons.arrow_forward_ios,
                      size: 16,
                      color: Theme.of(context).brightness == Brightness.dark 
                          ? AppColors.textSecondaryDark 
                          : AppColors.greyBCB,
                    ),
                    onTap: () {},
                  ),
                ],
              ),
              SizedBox(height: 24),
              _buildSettingsSection(
                context: context,
                title: 'Appearance',
                children: [
                  _buildThemeToggle(context),
                ],
              ),
              SizedBox(height: 24),
              _buildSettingsSection(
                context: context,
                title: 'Account',
                children: [
                  _buildSettingCard(
                    context: context,
                    icon: Icons.person_outline,
                    title: 'Profile',
                    subtitle: 'Manage your profile',
                    trailing: Icon(
                      Icons.arrow_forward_ios,
                      size: 16,
                      color: Theme.of(context).brightness == Brightness.dark 
                          ? AppColors.textSecondaryDark 
                          : AppColors.greyBCB,
                    ),
                    onTap: () {},
                  ),
                  _buildSettingCard(
                    context: context,
                    icon: Icons.notifications_outlined,
                    title: 'Notifications',
                    subtitle: 'Manage notifications',
                    trailing: Icon(
                      Icons.arrow_forward_ios,
                      size: 16,
                      color: Theme.of(context).brightness == Brightness.dark 
                          ? AppColors.textSecondaryDark 
                          : AppColors.greyBCB,
                    ),
                    onTap: () {},
                  ),
                  _buildSettingCard(
                    context: context,
                    icon: Icons.security,
                    title: 'Privacy & Security',
                    subtitle: 'Manage your privacy',
                    trailing: Icon(
                      Icons.arrow_forward_ios,
                      size: 16,
                      color: Theme.of(context).brightness == Brightness.dark 
                          ? AppColors.textSecondaryDark 
                          : AppColors.greyBCB,
                    ),
                    onTap: () {},
                  ),
                ],
              ),
              SizedBox(height: 24),
              _buildSettingsSection(
                context: context,
                title: 'Support',
                children: [
                  _buildSettingCard(
                    context: context,
                    icon: Icons.help_outline,
                    title: 'Help Center',
                    subtitle: 'Get help and support',
                    trailing: Icon(
                      Icons.arrow_forward_ios,
                      size: 16,
                      color: Theme.of(context).brightness == Brightness.dark 
                          ? AppColors.textSecondaryDark 
                          : AppColors.greyBCB,
                    ),
                    onTap: () {},
                  ),
                  _buildSettingCard(
                    context: context,
                    icon: Icons.info_outline,
                    title: 'About',
                    subtitle: 'App version 1.0.0',
                    trailing: Icon(
                      Icons.arrow_forward_ios,
                      size: 16,
                      color: Theme.of(context).brightness == Brightness.dark 
                          ? AppColors.textSecondaryDark 
                          : AppColors.greyBCB,
                    ),
                    onTap: () {},
                  ),
                ],
              ),
              SizedBox(height: 40),
            ],
          ),
        ),
      );

  PreferredSizeWidget _buildModernAppBar(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return AppBar(
      backgroundColor: isDark ? AppColors.backgroundDark : AppColors.whiteF2F,
      automaticallyImplyLeading: false,
      elevation: 0,
      centerTitle: true,
      leading: Container(
        margin: EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: isDark 
              ? AppColors.surfaceDark.withValues(alpha: 0.8)
              : AppColors.white.withValues(alpha: 0.9),
          borderRadius: BorderRadius.circular(12),
          border: isDark 
              ? Border.all(color: AppColors.borderDark.withValues(alpha: 0.3))
              : null,
          boxShadow: [
            BoxShadow(
              color: isDark 
                  ? AppColors.shadowDark.withValues(alpha: 0.2)
                  : AppColors.black.withValues(alpha: 0.1),
              blurRadius: 8,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: InkWell(
          onTap: () => Get.back(),
          borderRadius: BorderRadius.circular(12),
          child: Icon(
            Icons.arrow_back_ios_new,
            color: isDark ? AppColors.textPrimaryDark : AppColors.black2E2,
            size: 18,
          ),
        ),
      ),
      title: CommonTextWidget.PoppinsBold(
        text: 'Settings',
        color: isDark ? AppColors.textPrimaryDark : AppColors.black2E2,
        fontSize: 20,
      ),
    );
  }

  Widget _buildSettingsSection({
    required BuildContext context,
    required String title,
    required List<Widget> children,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 4, bottom: 12),
          child: CommonTextWidget.PoppinsSemiBold(
            text: title,
            color: isDark ? AppColors.textPrimaryDark : AppColors.black2E2,
            fontSize: 16,
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: isDark ? AppColors.surfaceDark : AppColors.white,
            borderRadius: BorderRadius.circular(16),
            border: isDark 
                ? Border.all(color: AppColors.borderDark.withValues(alpha: 0.3))
                : null,
            boxShadow: [
              BoxShadow(
                color: isDark 
                    ? AppColors.shadowDark.withValues(alpha: 0.3)
                    : AppColors.black.withValues(alpha: 0.08),
                blurRadius: 12,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Column(children: children),
        ),
      ],
    );
  }

  Widget _buildSettingCard({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String subtitle,
    required Widget trailing,
    required VoidCallback onTap,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: isDark 
                  ? AppColors.borderDark.withValues(alpha: 0.2)
                  : AppColors.greyD9D.withValues(alpha: 0.3),
              width: 0.5,
            ),
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppColors.redCA0.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: AppColors.redCA0,
                size: 20,
              ),
            ),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CommonTextWidget.PoppinsMedium(
                    text: title,
                    color: isDark ? AppColors.textPrimaryDark : AppColors.black2E2,
                    fontSize: 16,
                  ),
                  SizedBox(height: 2),
                  CommonTextWidget.PoppinsRegular(
                    text: subtitle,
                    color: isDark ? AppColors.textSecondaryDark : AppColors.grey656,
                    fontSize: 13,
                  ),
                ],
              ),
            ),
            trailing,
          ],
        ),
      ),
    );
  }

  Widget _buildThemeToggle(BuildContext context) {
    return GetBuilder<ThemeService>(
      builder: (ThemeService themeService) {
        final isDark = themeService.isDarkMode;
        
        return InkWell(
          onTap: () => themeService.switchTheme(),
          child: Container(
            padding: EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppColors.redCA0.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    isDark ? Icons.dark_mode : Icons.light_mode,
                    color: AppColors.redCA0,
                    size: 20,
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CommonTextWidget.PoppinsMedium(
                        text: 'Dark Mode',
                        color: isDark ? AppColors.textPrimaryDark : AppColors.black2E2,
                        fontSize: 16,
                      ),
                      SizedBox(height: 2),
                      CommonTextWidget.PoppinsRegular(
                        text: isDark ? 'Enabled' : 'Disabled',
                        color: isDark ? AppColors.textSecondaryDark : AppColors.grey656,
                        fontSize: 13,
                      ),
                    ],
                  ),
                ),
                Switch(
                  value: isDark,
                  onChanged: (bool value) => themeService.setThemeMode(value),
                  activeColor: AppColors.redCA0,
                  activeTrackColor: AppColors.redCA0.withValues(alpha: 0.3),
                  inactiveThumbColor: isDark ? AppColors.textSecondaryDark : AppColors.greyBCB,
                  inactiveTrackColor: isDark 
                      ? AppColors.borderDark.withValues(alpha: 0.3)
                      : AppColors.greyD9D.withValues(alpha: 0.3),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
