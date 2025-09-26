import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/widgets/common_text_widget.dart';
import '../../../../../core/widgets/lists_widget.dart';
import '../../../../../main.dart';

class MyGiftCardScreen extends StatelessWidget {
   MyGiftCardScreen({Key? key}) : super(key: key);

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
          text: 'My Gift Card',
          color: AppColors.white,
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
