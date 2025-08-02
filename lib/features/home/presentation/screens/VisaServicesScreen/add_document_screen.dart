import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:seemytrip/core/utils/colors.dart';
import 'package:seemytrip/shared/constants/images.dart';
import 'package:seemytrip/core/widgets/common_button_widget.dart';
import 'package:seemytrip/core/widgets/common_text_widget.dart';

class AddDocumentScreen extends StatelessWidget {
  AddDocumentScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
      appBar: AppBar(
        backgroundColor: redCA0,
        automaticallyImplyLeading: false,
        elevation: 0,
        centerTitle: true,
        leading: InkWell(
          onTap: () {
            Get.back();
          },
          child: Icon(Icons.arrow_back, color: white, size: 20),
        ),
        title: CommonTextWidget.PoppinsSemiBold(
          text: "Add Documents",
          color: white,
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
              buttonColor: redCA0,
              onTap: () {
                Get.to(() => AddDocumentScreen());
              },
              text: "SUBMIT APPLICATION",
            ),
          ),
          SizedBox(height: 50),
        ],
      ),
    );
  }
}
