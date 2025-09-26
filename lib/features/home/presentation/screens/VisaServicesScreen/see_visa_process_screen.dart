import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../shared/constants/images.dart';
import 'add_document_screen.dart';
import '../../../../../core/widgets/common_button_widget.dart';
import '../../../../../core/widgets/common_text_widget.dart';
import '../../../../../main.dart';

class SeeVisaProcessScreen extends StatelessWidget {
  SeeVisaProcessScreen({Key? key}) : super(key: key);

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
          text: 'See Visa Process',
          color: AppColors.white,
          fontSize: 18,
        ),
      ),
      body: ScrollConfiguration(
        behavior: MyBehavior(),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 20),
              Image.asset(seeVisaProcessImage, width: Get.width),
              SizedBox(height: 30),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 24),
                child: CommonButtonWidget.button(
                  buttonColor: AppColors.redCA0,
                  onTap: () {
                    Get.to(() => AddDocumentScreen());
                  },
                  text: 'APPLY',
                ),
              ),
              SizedBox(height: 50),
            ],
          ),
        ),
      ),
    );
}
