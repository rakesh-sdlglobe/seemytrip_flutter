import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:seemytrip/core/theme/app_colors.dart';
import 'package:seemytrip/core/widgets/common_button_widget.dart';
import 'package:seemytrip/core/widgets/common_text_widget.dart';
import 'package:seemytrip/core/widgets/lists_widget.dart';

class EditYourSearchScreen extends StatelessWidget {
  EditYourSearchScreen({Key? key}) : super(key: key);

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
          text: 'Edit your search',
          color: AppColors.white,
          fontSize: 18,
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          children: [
            SizedBox(height: 20),
            ListView.builder(
              itemCount: Lists.editYourSearchList.length,
              shrinkWrap: true,
              padding: EdgeInsets.zero,
              physics: NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) => Padding(
                padding: EdgeInsets.only(bottom: 15),
                child: Container(
                  width: Get.width,
                  decoration: BoxDecoration(
                    color: AppColors.grey9B9.withValues(alpha: 0.15),
                    border: Border.all(color: AppColors.greyE2E, width: 1),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: ListTile(
                    leading: SvgPicture.asset(
                      Lists.editYourSearchList[index]["image"],
                    ),
                    title: CommonTextWidget.PoppinsMedium(
                      text: Lists.editYourSearchList[index]["text1"],
                      color: AppColors.grey888,
                      fontSize: 14,
                    ),
                    subtitle: CommonTextWidget.PoppinsSemiBold(
                      text: Lists.editYourSearchList[index]["text2"],
                      color: AppColors.black2E2,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
            ),
            Spacer(),
            CommonButtonWidget.button(
              text: 'SEARCH',
              onTap: () {},
              buttonColor: AppColors.redCA0,
            ),
            SizedBox(height: 60),
          ],
        ),
      ),
    );
}
