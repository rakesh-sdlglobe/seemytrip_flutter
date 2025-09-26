import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../theme/app_colors.dart';
import 'common_text_widget.dart';
import 'dynamic_language_selector.dart';

/// Example screen showing dynamic language switching
class DynamicLanguageDemo extends StatelessWidget {
  const DynamicLanguageDemo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.redCA0,
        title: CommonTextWidget.PoppinsSemiBold(
          text: 'Dynamic Language Demo',
          color: AppColors.white,
          fontSize: 18,
        ),
        actions: [
          // Quick language switcher in app bar
          QuickLanguageSwitcher(),
          SizedBox(width: 16),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header section
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppColors.redCA0.withOpacity(0.1), AppColors.redF9E],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CommonTextWidget.PoppinsBold(
                    text: 'welcomeMessage'.tr,
                    color: AppColors.redCA0,
                    fontSize: 24,
                  ),
                  SizedBox(height: 8),
                  CommonTextWidget.PoppinsRegular(
                    text: 'This text changes instantly when you switch languages!',
                    color: AppColors.grey717,
                    fontSize: 14,
                  ),
                ],
              ),
            ),
            
            SizedBox(height: 30),
            
            // Language selector section
            CommonTextWidget.PoppinsSemiBold(
              text: 'selectLanguage'.tr,
              color: AppColors.black2E2,
              fontSize: 18,
            ),
            SizedBox(height: 15),
            
            // Dropdown style selector
            DynamicLanguageSelector(
              showAsFloatingButton: false,
              showNativeNames: true,
            ),
            
            SizedBox(height: 30),
            
            // Demo content that changes with language
            _buildDemoSection('Travel Services', [
              'flight',
              'hotel',
              'train',
              'bus',
              'offers',
            ]),
            
            SizedBox(height: 20),
            
            _buildDemoSection('Common Actions', [
              'search',
              'bookNow',
              'save',
              'cancel',
              'submit',
            ]),
            
            SizedBox(height: 20),
            
            _buildDemoSection('Status & Messages', [
              'loading',
              'success',
              'error',
              'confirmed',
              'pending',
            ]),
            
            SizedBox(height: 30),
            
            // Floating button style selector
            Center(
              child: Column(
                children: [
                  CommonTextWidget.PoppinsMedium(
                    text: 'Or tap the floating button:',
                    color: AppColors.grey717,
                    fontSize: 14,
                  ),
                  SizedBox(height: 10),
                  DynamicLanguageSelector(
                    showAsFloatingButton: true,
                  ),
                ],
              ),
            ),
            
            SizedBox(height: 50),
          ],
        ),
      ),
    );
  }

  Widget _buildDemoSection(String title, List<String> keys) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.greyE8E),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CommonTextWidget.PoppinsSemiBold(
            text: title,
            color: AppColors.black2E2,
            fontSize: 16,
          ),
          SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: keys.map((key) => Container(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.redF9E,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.redCA0.withOpacity(0.3)),
              ),
              child: CommonTextWidget.PoppinsRegular(
                text: key.tr,
                color: AppColors.redCA0,
                fontSize: 12,
              ),
            )).toList(),
          ),
        ],
      ),
    );
  }
}
