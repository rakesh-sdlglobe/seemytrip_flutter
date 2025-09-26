import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../features/shared/presentation/controllers/language_controller.dart';
import '../theme/app_colors.dart';
import 'common_text_widget.dart';

class DynamicLanguageSelector extends StatelessWidget {
  final bool showAsFloatingButton;
  final bool showNativeNames;
  final Color? backgroundColor;
  final Color? textColor;
  final double? fontSize;
  
  const DynamicLanguageSelector({
    Key? key,
    this.showAsFloatingButton = false,
    this.showNativeNames = true,
    this.backgroundColor,
    this.textColor,
    this.fontSize = 14,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final languageController = Get.find<LanguageController>();
    
    if (showAsFloatingButton) {
      return _buildFloatingButton(languageController);
    } else {
      return _buildDropdown(languageController);
    }
  }

  Widget _buildFloatingButton(LanguageController controller) {
    return Obx(() => FloatingActionButton(
      mini: true,
      backgroundColor: backgroundColor ?? AppColors.redCA0,
      onPressed: () => _showLanguageBottomSheet(controller),
      child: Text(
        controller.currentLocale.value.languageCode.toUpperCase(),
        style: TextStyle(
          color: textColor ?? AppColors.white,
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
      ),
    ));
  }

  Widget _buildDropdown(LanguageController controller) {
    return Obx(() {
      final languageList = controller.getLanguageList();
      final currentLanguage = controller.currentLocale.value.languageCode;
      
      return Container(
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        decoration: BoxDecoration(
          color: backgroundColor ?? AppColors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: AppColors.greyE8E),
        ),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            value: currentLanguage,
            icon: Icon(Icons.language, color: textColor ?? AppColors.grey717, size: 16),
            style: TextStyle(color: textColor ?? AppColors.black2E2),
            onChanged: (String? newValue) {
              if (newValue != null) {
                final selectedLanguage = languageList.firstWhere(
                  (element) => element.key == newValue,
                );
                final locale = selectedLanguage.value['locale'] as Locale;
                controller.onLanguageSelected(locale);
                
                // Show success message
                Get.snackbar(
                  'languageChanged'.tr,
                  '${'languageChanged'.tr} ${selectedLanguage.value['nativeName']}',
                  snackPosition: SnackPosition.TOP,
                  duration: Duration(seconds: 2),
                  backgroundColor: AppColors.redCA0.withOpacity(0.1),
                  colorText: AppColors.redCA0,
                  margin: EdgeInsets.all(16),
                );
              }
            },
            items: languageList.map<DropdownMenuItem<String>>((entry) {
              final languageCode = entry.key;
              final languageData = entry.value;
              final nativeName = languageData['nativeName'] as String;
              final name = languageData['name'] as String;
              
              return DropdownMenuItem<String>(
                value: languageCode,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      showNativeNames ? nativeName : name,
                      style: TextStyle(
                        fontSize: fontSize,
                        fontWeight: languageCode == currentLanguage 
                            ? FontWeight.bold 
                            : FontWeight.normal,
                      ),
                    ),
                    if (showNativeNames && name != nativeName) ...[
                      SizedBox(width: 8),
                      Text(
                        '($name)',
                        style: TextStyle(
                          fontSize: fontSize! - 2,
                          color: AppColors.grey717.withOpacity(0.7),
                        ),
                      ),
                    ],
                  ],
                ),
              );
            }).toList(),
          ),
        ),
      );
    });
  }

  void _showLanguageBottomSheet(LanguageController controller) {
    Get.bottomSheet(
      Container(
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              margin: EdgeInsets.only(top: 8),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.greyB9B,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.language, color: AppColors.redCA0),
                      SizedBox(width: 8),
                      CommonTextWidget.PoppinsSemiBold(
                        text: 'selectLanguage'.tr,
                        color: AppColors.black2E2,
                        fontSize: 18,
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Obx(() {
                    final languageList = controller.getLanguageList();
                    return Column(
                      children: languageList.map((entry) {
                        final languageCode = entry.key;
                        final languageData = entry.value;
                        final locale = languageData['locale'] as Locale;
                        final nativeName = languageData['nativeName'] as String;
                        final name = languageData['name'] as String;
                        final isSelected = controller.currentLocale.value.languageCode == languageCode;
                        
                        return Padding(
                          padding: EdgeInsets.only(bottom: 12),
                          child: InkWell(
                            onTap: () {
                              controller.onLanguageSelected(locale);
                              Get.back();
                              
                              // Show success message
                              Get.snackbar(
                                'languageChanged'.tr,
                                '${'languageChanged'.tr} $nativeName',
                                snackPosition: SnackPosition.TOP,
                                duration: Duration(seconds: 2),
                                backgroundColor: AppColors.redCA0.withOpacity(0.1),
                                colorText: AppColors.redCA0,
                                margin: EdgeInsets.all(16),
                              );
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                              decoration: BoxDecoration(
                                color: isSelected ? AppColors.redF9E : AppColors.white,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: isSelected ? AppColors.redCA0 : AppColors.greyE8E,
                                ),
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    width: 20,
                                    height: 20,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: isSelected ? AppColors.redCA0 : AppColors.greyB9B,
                                        width: 2,
                                      ),
                                    ),
                                    child: isSelected
                                        ? Center(
                                            child: Container(
                                              width: 10,
                                              height: 10,
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: AppColors.redCA0,
                                              ),
                                            ),
                                          )
                                        : null,
                                  ),
                                  SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        CommonTextWidget.PoppinsMedium(
                                          text: nativeName,
                                          color: isSelected ? AppColors.redCA0 : AppColors.black2E2,
                                          fontSize: 16,
                                        ),
                                        if (name != nativeName)
                                          CommonTextWidget.PoppinsRegular(
                                            text: name,
                                            color: AppColors.grey717.withOpacity(0.7),
                                            fontSize: 12,
                                          ),
                                      ],
                                    ),
                                  ),
                                  if (languageData['rtl'] == true)
                                    Container(
                                      padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                      decoration: BoxDecoration(
                                        color: AppColors.redCA0.withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: Text(
                                        'RTL',
                                        style: TextStyle(
                                          fontSize: 10,
                                          color: AppColors.redCA0,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    );
                  }),
                ],
              ),
            ),
          ],
        ),
      ),
      isScrollControlled: true,
    );
  }
}

// Quick language switcher for app bar
class QuickLanguageSwitcher extends StatelessWidget {
  const QuickLanguageSwitcher({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final languageController = Get.find<LanguageController>();
    
    return Obx(() => PopupMenuButton<String>(
      icon: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.language, size: 20, color: AppColors.white),
          SizedBox(width: 4),
          Text(
            languageController.currentLocale.value.languageCode.toUpperCase(),
            style: TextStyle(
              color: AppColors.white,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
      onSelected: (String languageCode) {
        final languageList = languageController.getLanguageList();
        final selectedLanguage = languageList.firstWhere(
          (element) => element.key == languageCode,
        );
        final locale = selectedLanguage.value['locale'] as Locale;
        languageController.onLanguageSelected(locale);
        
        // Show success message
        Get.snackbar(
          'languageChanged'.tr,
          '${'languageChanged'.tr} ${selectedLanguage.value['nativeName']}',
          snackPosition: SnackPosition.TOP,
          duration: Duration(seconds: 2),
          backgroundColor: AppColors.redCA0.withOpacity(0.1),
          colorText: AppColors.redCA0,
          margin: EdgeInsets.all(16),
        );
      },
      itemBuilder: (BuildContext context) {
        final languageList = languageController.getLanguageList();
        return languageList.map((entry) {
          final languageCode = entry.key;
          final languageData = entry.value;
          final nativeName = languageData['nativeName'] as String;
          final isSelected = languageController.currentLocale.value.languageCode == languageCode;
          
          return PopupMenuItem<String>(
            value: languageCode,
            child: Row(
              children: [
                if (isSelected)
                  Icon(Icons.check, size: 16, color: AppColors.redCA0)
                else
                  SizedBox(width: 16),
                SizedBox(width: 8),
                Text(
                  nativeName,
                  style: TextStyle(
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    color: isSelected ? AppColors.redCA0 : AppColors.black2E2,
                  ),
                ),
              ],
            ),
          );
        }).toList();
      },
    ));
  }
}
