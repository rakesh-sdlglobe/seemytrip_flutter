import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/common_text_widget.dart';
import '../../../../core/widgets/dynamic_language_selector.dart';
import '../../../../core/widgets/global_language_fab.dart';
import '../../../shared/presentation/controllers/language_controller.dart';

class LanguageDemoScreen extends StatelessWidget {
  const LanguageDemoScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final languageController = Get.find<LanguageController>();
    
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.redCA0,
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: Icon(Icons.arrow_back, color: AppColors.white),
        ),
        title: CommonTextWidget.PoppinsSemiBold(
          text: 'Dynamic Language Demo',
          color: AppColors.white,
          fontSize: 18,
        ),
        actions: [
          QuickLanguageSwitcher(),
          SizedBox(width: 16),
        ],
      ),
      body: ScreenWithLanguageFAB(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Real-time language display
              Obx(() => Container(
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
                    Row(
                      children: [
                        Icon(Icons.language, color: AppColors.redCA0),
                        SizedBox(width: 8),
                        CommonTextWidget.PoppinsBold(
                          text: 'Current Language: ${languageController.getCurrentLanguageName()}',
                          color: AppColors.redCA0,
                          fontSize: 18,
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    CommonTextWidget.PoppinsRegular(
                      text: 'Code: ${languageController.currentLocale.value.languageCode.toUpperCase()}',
                      color: AppColors.grey717,
                      fontSize: 14,
                    ),
                    if (languageController.isCurrentLanguageRTL())
                      Padding(
                        padding: EdgeInsets.only(top: 8),
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppColors.redCA0.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            'RTL Language',
                            style: TextStyle(
                              color: AppColors.redCA0,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              )),
              
              SizedBox(height: 30),
              
              // Welcome message that changes dynamically
              CommonTextWidget.PoppinsBold(
                text: 'welcomeMessage'.tr,
                color: AppColors.black2E2,
                fontSize: 24,
              ),
              
              SizedBox(height: 20),
              
              // Language selector
              CommonTextWidget.PoppinsSemiBold(
                text: 'selectLanguage'.tr,
                color: AppColors.black2E2,
                fontSize: 18,
              ),
              SizedBox(height: 15),
              
              DynamicLanguageSelector(
                showAsFloatingButton: false,
                showNativeNames: true,
              ),
              
              SizedBox(height: 30),
              
              // Travel services that update dynamically
              _buildDynamicSection(
                'Travel Services',
                [
                  {'key': 'flight', 'icon': Icons.flight},
                  {'key': 'hotel', 'icon': Icons.hotel},
                  {'key': 'train', 'icon': Icons.train},
                  {'key': 'bus', 'icon': Icons.directions_bus},
                  {'key': 'cab', 'icon': Icons.local_taxi},
                ],
              ),
              
              SizedBox(height: 20),
              
              _buildDynamicSection(
                'Actions',
                [
                  {'key': 'search', 'icon': Icons.search},
                  {'key': 'bookNow', 'icon': Icons.book_online},
                  {'key': 'save', 'icon': Icons.save},
                  {'key': 'cancel', 'icon': Icons.cancel},
                  {'key': 'help', 'icon': Icons.help},
                ],
              ),
              
              SizedBox(height: 30),
              
              // Instructions
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.redF9E.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppColors.redCA0.withOpacity(0.3)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.info, color: AppColors.redCA0, size: 20),
                        SizedBox(width: 8),
                        CommonTextWidget.PoppinsSemiBold(
                          text: 'How to test:',
                          color: AppColors.redCA0,
                          fontSize: 16,
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    CommonTextWidget.PoppinsRegular(
                      text: '1. Use the dropdown above to change language\n'
                            '2. Use the app bar language selector\n'
                            '3. Use the floating button (bottom right)\n'
                            '4. Notice all text changes instantly!',
                      color: AppColors.grey717,
                      fontSize: 14,
                    ),
                  ],
                ),
              ),
              
              SizedBox(height: 100), // Space for FAB
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDynamicSection(String title, List<Map<String, dynamic>> items) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.greyE8E),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 5,
            offset: Offset(0, 2),
          ),
        ],
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
            spacing: 12,
            runSpacing: 12,
            children: items.map((item) => Container(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.redF9E,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.redCA0.withOpacity(0.3)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    item['icon'],
                    color: AppColors.redCA0,
                    size: 16,
                  ),
                  SizedBox(width: 6),
                  CommonTextWidget.PoppinsRegular(
                    text: (item['key'] as String).tr,
                    color: AppColors.redCA0,
                    fontSize: 12,
                  ),
                ],
              ),
            )).toList(),
          ),
        ],
      ),
    );
  }
}
