import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../core/utils/common_textfeild_widget.dart';
import 'package:seemytrip/core/theme/app_colors.dart';
import '../../../../../core/widgets/common_text_widget.dart';

class OutStationCabFromToScreen extends StatelessWidget {
  OutStationCabFromToScreen({Key? key}) : super(key: key);
  final TextEditingController fromController = TextEditingController();
  final TextEditingController toController = TextEditingController();
  final TextEditingController currentLocationController =
      TextEditingController();

  @override
  Widget build(BuildContext context) => Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        automaticallyImplyLeading: false,
        elevation: 0,
        centerTitle: true,
        leading: Padding(
          padding:  EdgeInsets.only(left: 30),
          child: InkWell(
            onTap: () {
              Get.back();
            },
            child: Icon(Icons.arrow_back, color: AppColors.black2E2, size: 20),
          ),
        ),
        title: CommonTextWidget.PoppinsSemiBold(
          text: 'Outstation Cabs',
          color: AppColors.black2E2,
          fontSize: 18,
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          children: [
            SizedBox(height: 25),
            CommonTextFieldWidget(
              hintText: 'FROM',
              controller: fromController,
              keyboardType: TextInputType.text,
              prefixIcon: Padding(
                padding: EdgeInsets.only(bottom: 25),
                child: Icon(Icons.circle_outlined, color: AppColors.black2E2, size: 15),
              ),
            ),
            SizedBox(height: 20),
            CommonTextFieldWidget(
              hintText: 'To',
              controller: toController,
              keyboardType: TextInputType.text,
              prefixIcon: Padding(
                padding: EdgeInsets.only(bottom: 25),
                child: Icon(Icons.circle_outlined, color: AppColors.black2E2, size: 15),
              ),
            ),
            SizedBox(height: 20),
            CommonTextFieldWidget(
              hintText: 'Use current Location',
              controller: currentLocationController,
              keyboardType: TextInputType.text,
              prefixIcon: Padding(
                padding: EdgeInsets.only(bottom: 25),
                child: Icon(Icons.my_location, color: AppColors.redFD3, size: 20),
              ),
            ),
          ],
        ),
      ),
    );
}
