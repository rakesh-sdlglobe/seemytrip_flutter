import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/widgets/common_button_widget.dart';
import '../../../../../core/widgets/common_text_widget.dart';
import '../../../../../shared/constants/images.dart';
import '../../../../shared/presentation/controllers/language_controller.dart';
import '../../controllers/welcome2_controller.dart';
import '../login_screen.dart';

class WelcomeScreen2 extends StatelessWidget {
  WelcomeScreen2({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Scaffold(
      backgroundColor: Theme.of(context).brightness == Brightness.dark 
          ? AppColors.backgroundDark 
          : AppColors.white,
      body: Stack(
        children: <Widget>[
          // Top Image Container
          Container(
            height: 350,
            width: Get.width,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(welcome2Image),
                fit: BoxFit.fill,
              ),
            ),
            child: Stack(
              children: <Widget>[
                Image.asset(welcome2Canvas,
                    width: Get.width, fit: BoxFit.cover),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      SizedBox(height: 40),
                      Expanded(
                        child: Align(
                          alignment: Alignment.topRight,
                          child: InkWell(
                            onTap: () {
                              Get.to(() => LogInScreen());
                            },
                            child: CommonTextWidget.PoppinsSemiBold(
                              text: 'SKIP',
                              color: AppColors.white,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          CommonTextWidget.PoppinsSemiBold(
                            text: 'welcome'.tr,
                            color: AppColors.white,
                            fontSize: 35,
                          ),
                          CommonTextWidget.PoppinsMedium(
                            text: 'selectLanguage'.tr,
                            color: AppColors.white,
                            fontSize: 20,
                          ),
                          CommonTextWidget.PoppinsRegular(
                            text: 'You can also change language in App Settings after signing in',
                            color: Theme.of(context).brightness == Brightness.dark 
                                ? AppColors.white.withValues(alpha: 0.8)
                                : AppColors.greyCAC,
                            fontSize: 14,
                          ),
                          SizedBox(height: 50),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Scrollable Content
          Padding(
            padding: EdgeInsets.only(top: 320),
            child: Container(
              width: Get.width,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(30),
                  topLeft: Radius.circular(30),
                ),
                color: Theme.of(context).brightness == Brightness.dark 
                    ? AppColors.surfaceDark 
                    : AppColors.white,
                boxShadow: <BoxShadow>[
                  BoxShadow(
                    color: Theme.of(context).brightness == Brightness.dark 
                        ? AppColors.black262.withValues(alpha: 0.2)
                        : AppColors.black262.withValues(alpha: 0.08),
                    blurRadius: 15,
                    spreadRadius: 0,
                    offset: Offset(0, -3),
                  ),
                ],
              ),
              child: Padding(
                padding: EdgeInsets.only(
                  top: 20,
                  left: 24,
                  right: 24,
                  bottom: 100, // Added extra padding for button
                ),
                child: GetBuilder<Welcome2Controller>(
                  init: Welcome2Controller(),
                  builder: (Welcome2Controller welcomeController) {
                    final LanguageController languageController = Get.find<LanguageController>();
                    final List<MapEntry<String, Map<String, dynamic>>> languageList = languageController.getLanguageList();
                    
                    return ListView.builder(
                      padding: EdgeInsets.zero,
                      itemCount: languageList.length,
                      itemBuilder: (BuildContext context, int index) {
                        final MapEntry<String, Map<String, dynamic>> languageEntry = languageList[index];
                        final Map<String, dynamic> languageData = languageEntry.value;
                        final Locale locale = languageData['locale'] as Locale;
                        final String nativeName = languageData['nativeName'] as String;
                        final String name = languageData['name'] as String;
                        final bool isSelected = welcomeController.selectedIndex == index;
                        
                        return Padding(
                          padding: EdgeInsets.only(bottom: 15),
                          child: InkWell(
                            onTap: () {
                              welcomeController.onIndexChange(index);
                              languageController.onLanguageSelected(locale);
                            },
                            child: Container(
                              height: 60,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                border: Border.all(
                                    color: isSelected
                                        ? AppColors.redCA0
                                        : (Theme.of(context).brightness == Brightness.dark 
                                            ? AppColors.borderDark 
                                            : AppColors.greyB9B),
                                    width: 1),
                                color: isSelected
                                    ? AppColors.redF9E
                                    : (Theme.of(context).brightness == Brightness.dark 
                                        ? AppColors.cardDark 
                                        : AppColors.white),
                                boxShadow: <BoxShadow>[
                                  BoxShadow(
                                    color: Theme.of(context).brightness == Brightness.dark 
                                        ? AppColors.black262.withValues(alpha: 0.1)
                                        : AppColors.black262.withValues(alpha: 0.04),
                                    blurRadius: 4,
                                    spreadRadius: 0,
                                    offset: Offset(0, 1),
                                  ),
                                ],
                              ),
                              child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: 15),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Row(
                                      children: <Widget>[
                                        SvgPicture.asset(
                                            isSelected
                                                ? selectedIcon
                                                : unSelectedIcon),
                                        SizedBox(width: 20),
                                        CommonTextWidget.PoppinsMedium(
                                          text: name,
                                          color: Theme.of(context).brightness == Brightness.dark 
                                              ? AppColors.textPrimaryDark 
                                              : AppColors.black2E2,
                                          fontSize: 14,
                                        ),
                                      ],
                                    ),
                                    CommonTextWidget.PoppinsMedium(
                                      text: nativeName,
                                      color: isSelected
                                          ? AppColors.redCA0
                                          : (Theme.of(context).brightness == Brightness.dark 
                                              ? AppColors.textSecondaryDark 
                                              : AppColors.greyC8C),
                                      fontSize: 16,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ),
          ),

          // Fixed Bottom Button
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              color: Theme.of(context).brightness == Brightness.dark 
                  ? AppColors.surfaceDark 
                  : AppColors.white,
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: CommonButtonWidget.button(
                text: 'CONTINUE',
                buttonColor: AppColors.redCA0,
                onTap: () {
                  Get.to(() => LogInScreen());
                },
              ),
            ),
          ),
        ],
      ),
    );
}
