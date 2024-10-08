import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:makeyourtripapp/Constants/colors.dart';
import 'package:makeyourtripapp/Screens/Utills/common_button_widget.dart';
import 'package:makeyourtripapp/Screens/Utills/common_container_widget.dart';
import 'package:makeyourtripapp/Screens/Utills/common_text_widget.dart';

class PriceRangeScreen extends StatelessWidget {
  PriceRangeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: redCA0,
        automaticallyImplyLeading: false,
        elevation: 0,
        centerTitle: true,
        leading: InkWell(
          onTap: () {
            Get.back();
          },
          child: Icon(Icons.close, color: white, size: 20),
        ),
        title: CommonTextWidget.PoppinsSemiBold(
          text: "Price Range",
          color: white,
          fontSize: 18,
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 15),
            CommonTextWidget.PoppinsSemiBold(
              text: "Price Per Night",
              color: black2E2,
              fontSize: 16,
            ),
            SizedBox(height: 15),
            Row(
              children: [
                CommonContainerWidget.container(
                  text: "₹0 - ₹2000(851)",
                  borderColor: white,
                  textColor: grey717,
                ),
                SizedBox(width: 10),
                CommonContainerWidget.container(
                  text: "₹2000 - ₹4000(856)  ",
                  borderColor: white,
                  textColor: grey717,
                ),
              ],
            ),
            SizedBox(height: 15),
            Row(
              children: [
                CommonContainerWidget.container(
                  text: "₹4000 - ₹7500 (375) ",
                  borderColor: white,
                  textColor: grey717,
                ),
                SizedBox(width: 11),
                CommonContainerWidget.container(
                  text: "₹7500 - ₹10500(145) ",
                  borderColor: white,
                  textColor: grey717,
                ),
              ],
            ),
            SizedBox(height: 15),
            Row(
              children: [
                CommonContainerWidget.container(
                  text: "₹10500 - ₹1500(85)",
                  borderColor: white,
                  textColor: grey717,
                ),
                SizedBox(width: 10),
                CommonContainerWidget.container(
                  text: "₹15000 - ₹30000(52)",
                  borderColor: white,
                  textColor: grey717,
                ),
              ],
            ),
            SizedBox(height: 15),
            Row(
              children: [
                CommonContainerWidget.container(
                  text: "₹30000+(85)",
                  borderColor: white,
                  textColor: grey717,
                ),
              ],
            ),
            Spacer(),
            CommonButtonWidget.button(
              text: "DONE",
              onTap: () {},
              buttonColor: redCA0,
            ),
            SizedBox(height: 50),
          ],
        ),
      ),
    );
  }
}
