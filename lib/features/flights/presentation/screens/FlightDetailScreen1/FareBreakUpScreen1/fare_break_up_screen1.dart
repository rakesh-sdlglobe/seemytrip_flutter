import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../../core/theme/app_colors.dart';
import '../../../../../../core/widgets/common_text_widget.dart';
import '../../../../../../core/widgets/lists_widget.dart';

class FareBreakUpScreen1 extends StatelessWidget {
   FareBreakUpScreen1({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Scaffold(
      backgroundColor: AppColors.redF9E,
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
          text: 'Fare Breakup',
          color: AppColors.white,
          fontSize: 18,
        ),
      ),
      body: Padding(
        padding:  EdgeInsets.only(top: 15,left: 24,right: 24,bottom: 30),
        child: Container(
          height: Get.height,
          width: Get.width,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: AppColors.white,
          ),
          child: Column(
            children: [
              ListView.builder(
                shrinkWrap: true,
                itemCount: Lists.fareBreakList.length,
                padding: EdgeInsets.only(top: 20),
                itemBuilder: (context, index) => Column(
                  children: [
                    ListTile(
                      title: CommonTextWidget.PoppinsMedium(
                        text: Lists.fareBreakList[index]['text1'],
                        color: AppColors.black2E2,
                        fontSize: 12,
                      ),
                      subtitle: CommonTextWidget.PoppinsMedium(
                        text: Lists.fareBreakList[index]['text2'],
                        color: AppColors.black2E2,
                        fontSize: 12,
                      ),
                      trailing: CommonTextWidget.PoppinsMedium(
                        text: Lists.fareBreakList[index]['text3'],
                        color: AppColors.black2E2,
                        fontSize: 12,
                      ),
                      horizontalTitleGap: -3,
                    ),
                    index == 2
                        ? SizedBox.shrink()
                        : Divider(color: AppColors.greyE8E, thickness: 1),
                  ],
                ),
              ),
              Spacer(),
              Container(
                width: Get.width,
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.greyE8E,width: 1),
                  color: AppColors.white,
                ),
                child: Padding(
                  padding:  EdgeInsets.all(15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CommonTextWidget.PoppinsSemiBold(
                        text: 'Total Amount',
                        color: AppColors.black2E2,
                        fontSize: 12,
                      ),
                      CommonTextWidget.PoppinsSemiBold(
                        text: '₹ 8,623',
                        color: AppColors.black2E2,
                        fontSize: 16,
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
}
