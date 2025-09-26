import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/widgets/common_text_widget.dart';
import '../../../../../core/widgets/lists_widget.dart';

class NotificationScreen extends StatelessWidget {
  NotificationScreen({Key? key}) : super(key: key);

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
          text: 'Notification',
          color: AppColors.white,
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
                  Image.asset(Lists.notificationList[index]['image'],
                      height: 20, width: 20),
                  SizedBox(width: 18),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CommonTextWidget.PoppinsSemiBold(
                        text: Lists.notificationList[index]['text1'],
                        color: AppColors.black2E2,
                        fontSize: 14,
                      ),
                      CommonTextWidget.PoppinsMedium(
                        text: Lists.notificationList[index]['text2'],
                        color: AppColors.grey717,
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
                    'You have successfully canceled your Booking with on December 24....',
                color: AppColors.grey717,
                fontSize: 13,
              ),
            ),
            SizedBox(height: 15),
            index == 3
                ? SizedBox.shrink()
                : Divider(thickness: 1, color: AppColors.greyDED),
            SizedBox(height: 15),
          ],
        ),
      ),
    );
}
