import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/theme_service.dart';
import '../../../../../core/widgets/common_button_widget.dart';
import '../../../../../core/widgets/common_text_widget.dart';
import '../../../../../shared/constants/images.dart';
import 'language_screen.dart';

class SettingScreen extends StatelessWidget {
  SettingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: AppBar(
          backgroundColor: AppColors.redCA0,
          automaticallyImplyLeading: false,
          elevation: 0,
          centerTitle: true,
          leading: InkWell(
            onTap: () {
              Get.back();
            },
            child: Icon(Icons.arrow_back, color: AppColors.white, size: 20),
          ),
          title: CommonTextWidget.PoppinsSemiBold(
            text: 'Settings',
            color: AppColors.white,
            fontSize: 18,
          ),
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  CommonTextWidget.PoppinsMedium(
                    text: 'Country/Region',
                    color: Theme.of(context).textTheme.bodyLarge?.color ?? AppColors.black2E2,
                    fontSize: 16,
                  ),
                  Image.asset(settingImage1, height: 31, width: 109),
                ],
              ),
              SizedBox(height: 35),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  CommonTextWidget.PoppinsMedium(
                    text: 'Language',
                    color: Theme.of(context).textTheme.bodyLarge?.color ?? AppColors.black2E2,
                    fontSize: 16,
                  ),
                  InkWell(
                    onTap: () {
                      Get.to(() => LanguageScreen());
                    },
                    child: Image.asset(settingImage2, height: 31, width: 109),
                  ),
                ],
              ),
              SizedBox(height: 35),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  CommonTextWidget.PoppinsMedium(
                    text: 'Currency',
                    color: Theme.of(context).textTheme.bodyLarge?.color ?? AppColors.black2E2,
                    fontSize: 16,
                  ),
                  CommonTextWidget.PoppinsMedium(
                    text: 'Indian Rupee (₹)',
                    color: AppColors.greyBCB,
                    fontSize: 14,
                  ),
                ],
              ),
              SizedBox(height: 35),   
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Row(
                    children: [
                      GetBuilder<ThemeService>(
                        builder: (ThemeService themeService) => Icon(
                          themeService.isDarkMode
                              ? Icons.dark_mode
                              : Icons.light_mode,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                      SizedBox(width: 10),
                      CommonTextWidget.PoppinsMedium(
                        text: 'Dark Mode',
                        color: Theme.of(context).textTheme.bodyLarge?.color ?? AppColors.black2E2,
                        fontSize: 16,
                      ),
                    ],
                  ),
                  GetBuilder<ThemeService>(
                    builder: (ThemeService themeService) => Switch(
                      value: themeService.isDarkMode,
                      onChanged: (bool value) {
                        themeService.switchTheme();
                      },
                      activeColor: AppColors.redCA0,
                    ),
                  ),
                ],
              ),
              Spacer(),
              CommonButtonWidget.button(
                buttonColor: AppColors.redCA0,
                onTap: () {},
                text: 'APPLY CHANGES',
              ),
              SizedBox(height: 60),
            ],
          ),
        ),
      );
}
