import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:seemytrip/core/utils/colors.dart';
import 'package:seemytrip/core/widgets/common_text_widget.dart';
import 'package:seemytrip/core/widgets/lists_widget.dart';
import 'package:seemytrip/main.dart';

class MyGiftCardScreen extends StatelessWidget {
   MyGiftCardScreen({Key? key}) : super(key: key);

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
          text: "My Gift Card",
          color: white,
          fontSize: 18,
        ),
      ),
      body: ScrollConfiguration(
        behavior: MyBehavior(),
        child: ListView.builder(
          padding: EdgeInsets.only(top: 20),
          shrinkWrap: true,
          itemCount: Lists.giftCardList.length,
          itemBuilder: (context, index) => Padding(
            padding: EdgeInsets.only(bottom: 20),
            child: Image.asset(Lists.giftCardList[index],
                height: 85, width: Get.width),
          ),
        ),
      ),
    );
  }
}
