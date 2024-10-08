import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:makeyourtripapp/Constants/colors.dart';
import 'package:makeyourtripapp/Screens/Utills/common_text_widget.dart';
import 'package:makeyourtripapp/Screens/Utills/common_textfeild_widget.dart';

class OutStationCabFromToScreen extends StatelessWidget {
  OutStationCabFromToScreen({Key? key}) : super(key: key);
  final TextEditingController fromController = TextEditingController();
  final TextEditingController toController = TextEditingController();
  final TextEditingController currentLocationController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
      appBar: AppBar(
        backgroundColor: white,
        automaticallyImplyLeading: false,
        elevation: 0,
        centerTitle: true,
        leading: Padding(
          padding:  EdgeInsets.only(left: 30),
          child: InkWell(
            onTap: () {
              Get.back();
            },
            child: Icon(Icons.arrow_back, color: black2E2, size: 20),
          ),
        ),
        title: CommonTextWidget.PoppinsSemiBold(
          text: "Outstation Cabs",
          color: black2E2,
          fontSize: 18,
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          children: [
            SizedBox(height: 25),
            CommonTextFieldWidget.TextFormField7(
              hintText: "FROM",
              controller: fromController,
              keyboardType: TextInputType.text,
              preffixIcon: Padding(
                padding: EdgeInsets.only(bottom: 25),
                child: Icon(Icons.circle_outlined, color: black2E2, size: 15),
              ),
            ),
            SizedBox(height: 20),
            CommonTextFieldWidget.TextFormField7(
              hintText: "To",
              controller: toController,
              keyboardType: TextInputType.text,
              preffixIcon: Padding(
                padding: EdgeInsets.only(bottom: 25),
                child: Icon(Icons.circle_outlined, color: black2E2, size: 15),
              ),
            ),
            SizedBox(height: 20),
            CommonTextFieldWidget.TextFormField7(
              hintText: "Use current Location",
              controller: currentLocationController,
              keyboardType: TextInputType.text,
              preffixIcon: Padding(
                padding: EdgeInsets.only(bottom: 25),
                child: Icon(Icons.my_location, color: redFD3, size: 20),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
