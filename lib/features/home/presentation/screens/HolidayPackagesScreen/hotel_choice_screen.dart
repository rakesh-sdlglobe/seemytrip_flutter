import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:seemytrip/core/utils/colors.dart';
import 'package:seemytrip/core/widgets/common_button_widget.dart';
import 'package:seemytrip/core/widgets/common_text_widget.dart';
import 'package:seemytrip/core/widgets/lists_widget.dart';

class HotelChoiceScreen extends StatelessWidget {
  HotelChoiceScreen({Key? key}) : super(key: key);

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
          child: Icon(Icons.close, color: white, size: 20),
        ),
        title: CommonTextWidget.PoppinsSemiBold(
          text: "Hotel Choice",
          color: white,
          fontSize: 18,
        ),
        actions: [
          Padding(
            padding: EdgeInsets.only(top: 20, right: 24),
            child: CommonTextWidget.PoppinsMedium(
              text: "CLEAR ALL",
              color: white,
              fontSize: 12,
            ),
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 20),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 24),
            child: CommonTextWidget.PoppinsMedium(
              text: "Hotel Choice",
              color: black2E2,
              fontSize: 14,
            ),
          ),
          GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              childAspectRatio:
                  MediaQuery.of(context).size.aspectRatio * 2 / 0.6,
            ),
            shrinkWrap: true,
            primary: false,
            physics: NeverScrollableScrollPhysics(),
            padding: EdgeInsets.only(top: 15, left: 24, right: 75, bottom: 5),
            itemCount: Lists.hotelChoiceList.length,
            itemBuilder: (context, index) {
              return Container(
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: grey515.withOpacity(0.25),
                      offset: Offset(0, 1),
                      blurRadius: 6,
                    ),
                  ],
                  color: white,
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CommonTextWidget.PoppinsRegular(
                      text: Lists.hotelChoiceList[index]["text1"],
                      color: black2E2,
                      fontSize: 12,
                    ),
                    CommonTextWidget.PoppinsRegular(
                      text: Lists.hotelChoiceList[index]["text2"],
                      color: grey717,
                      fontSize: 12,
                    ),
                  ],
                ),
              );
            },
          ),
          Spacer(),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 24),
            child: CommonButtonWidget.button(
              buttonColor: redCA0,
              onTap: () {},
              text: "APPLY",
            ),
          ),
          SizedBox(height: 60),
        ],
      ),
    );
  }
}
