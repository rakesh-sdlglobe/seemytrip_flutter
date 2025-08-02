import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:seemytrip/core/utils/colors.dart';
import 'package:seemytrip/core/widgets/common_text_widget.dart';
import 'package:seemytrip/core/widgets/lists_widget.dart';

class NotificationScreen extends StatelessWidget {
  NotificationScreen({Key? key}) : super(key: key);

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
          text: "Notification",
          color: white,
          fontSize: 18,
        ),
      ),
      body: ListView.builder(
        itemCount: Lists.notificationList.length,
        shrinkWrap: true,
        padding: EdgeInsets.only(top: 15),
        itemBuilder: (context, index) => Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 35),
              child: Row(
                children: [
                  Image.asset(Lists.notificationList[index]["image"],
                      height: 20, width: 20),
                  SizedBox(width: 18),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CommonTextWidget.PoppinsSemiBold(
                        text: Lists.notificationList[index]["text1"],
                        color: black2E2,
                        fontSize: 14,
                      ),
                      CommonTextWidget.PoppinsMedium(
                        text: Lists.notificationList[index]["text2"],
                        color: grey717,
                        fontSize: 12,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 12),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24),
              child: CommonTextWidget.PoppinsRegular(
                text:
                    "You have successfully canceled your Booking with on December 24....",
                color: grey717,
                fontSize: 13,
              ),
            ),
            SizedBox(height: 15),
            index == 3
                ? SizedBox.shrink()
                : Divider(thickness: 1, color: greyDED),
            SizedBox(height: 15),
          ],
        ),
      ),
    );
  }
}
