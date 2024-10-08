import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:makeyourtripapp/Constants/colors.dart';
import 'package:makeyourtripapp/Screens/Utills/common_button_widget.dart';
import 'package:makeyourtripapp/Screens/Utills/common_container_widget.dart';
import 'package:makeyourtripapp/Screens/Utills/common_text_widget.dart';

class PopularFilterScreen extends StatelessWidget {
  PopularFilterScreen({Key? key}) : super(key: key);

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
          text: "Popular filters",
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
              text: "Suggested For You",
              color: black2E2,
              fontSize: 16,
            ),
            SizedBox(height: 15),
            CommonContainerWidget.container(
              text: "Reted Excellent by Travellers(256)",
              borderColor: redCA0,
              textColor: redCA0,
             ),
            SizedBox(height: 15),
            Row(
              children: [
                CommonContainerWidget.container(
                  text: "3 Star Properties(253)",
                  borderColor: redCA0,
                  textColor: redCA0,
                ),
                SizedBox(width: 10),
                CommonContainerWidget.container(
                  text: "North Goa",
                  borderColor: redCA0,
                  textColor: redCA0,
                ),
              ],
            ),
            SizedBox(height: 15),
            CommonContainerWidget.container(
              text: "Rated Excellent on Value for Money(458)",
              borderColor: white,
              textColor: grey717,
            ),
            SizedBox(height: 15),
            CommonContainerWidget.container(
              text: "MMT ValueStay - Top Rated Affordable(25)",
              borderColor: white,
              textColor: grey717,
            ),
            SizedBox(height: 15),
            Row(
              children: [
                CommonContainerWidget.container(
                  text: "Beachfont(569)",
                  borderColor: white,
                  textColor: grey717,
                ),
                SizedBox(width: 10),
                CommonContainerWidget.container(
                  text: "Free Breakfast(526)",
                  borderColor: white,
                  textColor: grey717,
                ),
              ],
            ),
            SizedBox(height: 15),
            Row(
              children: [
                CommonContainerWidget.container(
                  text: "Entire Property(454)",
                  borderColor: white,
                  textColor: grey717,
                ),
                SizedBox(width: 10),
                CommonContainerWidget.container(
                  text: "Villas(458)",
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
