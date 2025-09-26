import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../features/shared/presentation/controllers/language_controller.dart';
import '../theme/app_colors.dart';

class GlobalLanguageFAB extends StatelessWidget {
  final bool showOnAllScreens;
  final Offset? position;
  
  const GlobalLanguageFAB({
    Key? key,
    this.showOnAllScreens = true,
    this.position,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final languageController = Get.find<LanguageController>();
    
    return Positioned(
      right: position?.dx ?? 16,
      bottom: position?.dy ?? 80,
      child: Obx(() => FloatingActionButton.small(
        heroTag: "language_fab",
        backgroundColor: AppColors.redCA0.withOpacity(0.9),
        elevation: 4,
        onPressed: () => _showQuickLanguageSelector(context, languageController),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.language, color: AppColors.white, size: 16),
            Text(
              languageController.currentLocale.value.languageCode.toUpperCase(),
              style: TextStyle(
                color: AppColors.white,
                fontSize: 8,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      )),
    );
  }

  void _showQuickLanguageSelector(BuildContext context, LanguageController controller) {
    
    showDialog(
      context: context,
      barrierDismissible: true,
      barrierColor: Colors.transparent,
      builder: (context) => Stack(
        children: [
          // Transparent barrier
          GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: Container(
              width: double.infinity,
              height: double.infinity,
              color: Colors.transparent,
            ),
          ),
          // Language selector positioned near FAB
          Positioned(
            right: 70,
            bottom: position?.dy ?? 80,
            child: Material(
              elevation: 8,
              borderRadius: BorderRadius.circular(12),
              child: Container(
                width: 200,
                constraints: BoxConstraints(maxHeight: 300),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      offset: Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.redCA0.withOpacity(0.1),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(12),
                          topRight: Radius.circular(12),
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.language, color: AppColors.redCA0, size: 16),
                          SizedBox(width: 8),
                          Text(
                            'selectLanguage'.tr,
                            style: TextStyle(
                              color: AppColors.redCA0,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Flexible(
                      child: SingleChildScrollView(
                        child: Obx(() {
                          final languageList = controller.getLanguageList();
                          return Column(
                            children: languageList.map((entry) {
                              final languageCode = entry.key;
                              final languageData = entry.value;
                              final locale = languageData['locale'] as Locale;
                              final nativeName = languageData['nativeName'] as String;
                              final isSelected = controller.currentLocale.value.languageCode == languageCode;
                              
                              return InkWell(
                                onTap: () {
                                  controller.onLanguageSelected(locale);
                                  Navigator.of(context).pop();
                                  
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
                                  width: double.infinity,
                                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                  decoration: BoxDecoration(
                                    color: isSelected ? AppColors.redF9E : Colors.transparent,
                                  ),
                                  child: Row(
                                    children: [
                                      Container(
                                        width: 16,
                                        height: 16,
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
                                                  width: 8,
                                                  height: 8,
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
                                        child: Text(
                                          nativeName,
                                          style: TextStyle(
                                            color: isSelected ? AppColors.redCA0 : AppColors.black2E2,
                                            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                            fontSize: 14,
                                          ),
                                        ),
                                      ),
                                      if (languageData['rtl'] == true)
                                        Container(
                                          padding: EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                                          decoration: BoxDecoration(
                                            color: AppColors.redCA0.withOpacity(0.1),
                                            borderRadius: BorderRadius.circular(3),
                                          ),
                                          child: Text(
                                            'RTL',
                                            style: TextStyle(
                                              fontSize: 8,
                                              color: AppColors.redCA0,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                              );
                            }).toList(),
                          );
                        }),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Widget to wrap any screen with global language FAB
class ScreenWithLanguageFAB extends StatelessWidget {
  final Widget child;
  final bool showFAB;
  final Offset? fabPosition;
  
  const ScreenWithLanguageFAB({
    Key? key,
    required this.child,
    this.showFAB = true,
    this.fabPosition,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        if (showFAB) GlobalLanguageFAB(position: fabPosition),
      ],
    );
  }
}
