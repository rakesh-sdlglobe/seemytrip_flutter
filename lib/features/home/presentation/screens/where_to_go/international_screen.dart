import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/widgets/common_text_widget.dart';
import '../../../../../core/widgets/lists_widget.dart';
import '../../../../../main.dart';
import 'international_detail_screen1.dart';
import 'international_select_city_screen.dart';

class InterNationalScreen extends StatelessWidget {
  InterNationalScreen({Key? key}) : super(key: key);

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
          text: 'From Ahmedabad',
          color: AppColors.white,
          fontSize: 18,
        ),
        actions: [
          InkWell(
            onTap: () {
              Get.to(() => InternationalSelectCityScreenScreen());
            },
            child: Padding(
              padding: EdgeInsets.only(right: 24),
              child: Icon(CupertinoIcons.search, color: AppColors.white),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          SizedBox(height: 20),
          Expanded(
            child: ScrollConfiguration(
              behavior: MyBehavior(),
              child: ListView.builder(
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                itemCount: Lists.internationalList.length,
                itemBuilder: (context, index) => Padding(
                  padding: EdgeInsets.only(bottom: 20),
                  child: InkWell(
                    onTap: () {
                      Get.to(() => InterNationalDetailScreen1());
                    },
                    child: Image.asset(Lists.internationalList[index],
                        height: 310, width: Get.width),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
}
