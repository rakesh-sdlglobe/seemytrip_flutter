import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/widgets/common_button_widget.dart';
import '../../../../../core/widgets/common_text_widget.dart';
import '../../../../../shared/constants/images.dart';

class AddDocumentScreen extends StatelessWidget {
  AddDocumentScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Scaffold(
      backgroundColor: AppColors.white,
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
          text: 'Add Documents',
          color: AppColors.white,
          fontSize: 18,
        ),
      ),
      body: Column(
        children: [
          SizedBox(height: 20),
          Image.asset(addDocumentImage, width: Get.width),
          Spacer(),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 24),
            child: CommonButtonWidget.button(
              buttonColor: AppColors.redCA0,
              onTap: () {
                Get.to(() => AddDocumentScreen());
              },
              text: 'SUBMIT APPLICATION',
            ),
          ),
          SizedBox(height: 50),
        ],
      ),
    );
}
