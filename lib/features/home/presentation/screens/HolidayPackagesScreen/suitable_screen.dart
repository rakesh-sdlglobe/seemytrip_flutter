import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:seemytrip/features/shared/presentation/controllers/suitable_for_controller.dart';
import 'package:seemytrip/core/theme/app_colors.dart';
import 'package:seemytrip/core/widgets/common_button_widget.dart';
import 'package:seemytrip/core/widgets/common_text_widget.dart';
import 'package:seemytrip/core/widgets/lists_widget.dart';

class SuitableScreen extends StatelessWidget {
  SuitableScreen({Key? key}) : super(key: key);

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
          child: Icon(Icons.close, color: AppColors.white, size: 20),
        ),
        title: CommonTextWidget.PoppinsSemiBold(
          text: 'Suitable For',
          color: AppColors.white,
          fontSize: 18,
        ),
        actions: <Widget>[
          Padding(
            padding: EdgeInsets.only(top: 20, right: 24),
            child: CommonTextWidget.PoppinsMedium(
              text: 'CLEAR ALL',
              color: AppColors.white,
              fontSize: 12,
            ),
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(height: 20),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 24),
            child: CommonTextWidget.PoppinsMedium(
              text: 'Suitable For',
              color: AppColors.black2E2,
              fontSize: 14,
            ),
          ),
          GetBuilder<SuitableForController>(
            init: SuitableForController(),
            builder: (controller) => GridView.builder(
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
              itemCount: Lists.suitableForList.length,
              itemBuilder: (BuildContext context, int index) => InkWell(
                  onTap: () {
                    controller.onIndexChange(index);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      boxShadow: <BoxShadow>[
                        BoxShadow(
                          color: AppColors.grey515.withOpacity(0.25),
                          offset: Offset(0, 1),
                          blurRadius: 6,
                        ),
                      ],
                      border: Border.all(
                          color:
                              controller.selectedIndex == index ? AppColors.redCA0 : AppColors.white),
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        CommonTextWidget.PoppinsRegular(
                          text: Lists.suitableForList[index]['text1'],
                          color: controller.selectedIndex == index
                              ? AppColors.redCA0
                              : AppColors.black2E2,
                          fontSize: 12,
                        ),
                        CommonTextWidget.PoppinsRegular(
                          text: Lists.suitableForList[index]['text2'],
                          color: controller.selectedIndex == index
                              ? AppColors.redCA0
                              : AppColors.grey717,
                          fontSize: 12,
                        ),
                      ],
                    ),
                  ),
                ),
            ),
          ),
          Spacer(),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 24),
            child: CommonButtonWidget.button(
              buttonColor: AppColors.redCA0,
              onTap: () {},
              text: 'APPLY',
            ),
          ),
          SizedBox(height: 60),
        ],
      ),
    );
}
