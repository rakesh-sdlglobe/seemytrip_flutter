import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:seemytrip/features/shared/presentation/controllers/language_controller.dart';
import 'package:seemytrip/core/theme/app_colors.dart';
import 'package:seemytrip/core/widgets/common_text_widget.dart';

class LanguageScreen extends StatelessWidget {
  LanguageScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(LanguageController());
    
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.redCA0,
        automaticallyImplyLeading: false,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: Icon(Icons.arrow_back, color: AppColors.white, size: 20),
        ),
        title: CommonTextWidget.PoppinsSemiBold(
          text: 'language'.tr,
          color: AppColors.white,
          fontSize: 18,
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20),
              CommonTextWidget.PoppinsSemiBold(
                text: 'selectLanguage'.tr,
                color: AppColors.black2E2,
                fontSize: 16,
              ),
              SizedBox(height: 30),
              GetBuilder<LanguageController>(
                builder: (controller) {
                  final languageList = controller.getLanguageList();
                  return ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: languageList.length,
                    itemBuilder: (context, index) {
                      final languageEntry = languageList[index];
                      final languageCode = languageEntry.key;
                      final languageData = languageEntry.value;
                      final locale = languageData['locale'] as Locale;
                      final nativeName = languageData['nativeName'] as String;
                      final isSelected = controller.currentLocale.value.languageCode == languageCode;
                      
                      return Padding(
                        padding: EdgeInsets.only(bottom: 30),
                        child: InkWell(
                          onTap: () {
                            controller.onLanguageSelected(locale);
                            // Show a brief success message
                            Get.snackbar(
                              'languageChanged'.tr,
                              '${'languageChanged'.tr} $nativeName',
                              snackPosition: SnackPosition.BOTTOM,
                              duration: Duration(seconds: 2),
                              backgroundColor: AppColors.redCA0.withOpacity(0.1),
                              colorText: AppColors.redCA0,
                            );
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    CommonTextWidget.PoppinsMedium(
                                      text: nativeName,
                                      color: isSelected ? AppColors.redCA0 : AppColors.grey717,
                                      fontSize: 14,
                                    ),
                                    if (languageData['name'] != nativeName)
                                      CommonTextWidget.PoppinsRegular(
                                        text: languageData['name'],
                                        color: AppColors.grey717.withOpacity(0.7),
                                        fontSize: 12,
                                      ),
                                  ],
                                ),
                              ),
                              Container(
                                height: 20,
                                width: 20,
                                decoration: BoxDecoration(
                                  color: AppColors.white,
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: isSelected ? AppColors.redCA0 : AppColors.greyB9B,
                                    width: 2,
                                  ),
                                ),
                                alignment: Alignment.center,
                                child: isSelected
                                    ? Container(
                                        height: 10,
                                        width: 10,
                                        decoration: BoxDecoration(
                                          color: AppColors.redCA0,
                                          shape: BoxShape.circle,
                                        ),
                                      )
                                    : SizedBox.shrink(),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
