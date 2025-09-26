import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../theme/app_colors.dart';
import 'common_text_widget.dart';

class ComingSoonScreen extends StatelessWidget {
  final String moduleName;
  
  const ComingSoonScreen({
    Key? key,
    required this.moduleName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.scaffoldBg,
      appBar: AppBar(
        backgroundColor: context.scaffoldBg,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: context.primaryText,
          ),
          onPressed: () => Get.back(),
        ),
        title: CommonTextWidget.PoppinsSemiBold(
          text: moduleName,
          color: context.primaryText,
          fontSize: 18,
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: 120,
                width: 120,
                decoration: BoxDecoration(
                  color: AppColors.redCA0.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.construction,
                  size: 60,
                  color: AppColors.redCA0,
                ),
              ),
              SizedBox(height: 32),
              CommonTextWidget.PoppinsBold(
                text: 'Coming Soon!',
                color: context.primaryText,
                fontSize: 24,
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 16),
              CommonTextWidget.PoppinsMedium(
                text: '$moduleName is currently under development.',
                color: context.secondaryText,
                fontSize: 16,
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 8),
              CommonTextWidget.PoppinsRegular(
                text: 'We are working hard to bring you the best experience.',
                color: context.secondaryText,
                fontSize: 14,
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 32),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                decoration: BoxDecoration(
                  color: AppColors.redCA0.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: AppColors.redCA0.withOpacity(0.3),
                    width: 1,
                  ),
                ),
                child: CommonTextWidget.PoppinsMedium(
                  text: 'Stay tuned for updates!',
                  color: AppColors.redCA0,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
