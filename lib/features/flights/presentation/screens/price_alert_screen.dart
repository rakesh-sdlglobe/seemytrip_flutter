import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/common_text_widget.dart';
import '../../../../main.dart';

class PriceAlertScreen extends StatelessWidget {
  PriceAlertScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Padding(
      padding: EdgeInsets.only(top: 400),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
        ),
        child: Padding(
          padding: EdgeInsets.only(left: 24, right: 24, top: 22, bottom: 45),
          child: ScrollConfiguration(
            behavior: MyBehavior(),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CommonTextWidget.PoppinsSemiBold(
                    text: 'Price Alert Created!',
                    color: AppColors.black2E2,
                    fontSize: 18,
                  ),
                  SizedBox(height: 6),
                  Container(
                    height: 4,
                    width: 30,
                    color: AppColors.redCA0,
                  ),
                  SizedBox(height: 20),
                  CommonTextWidget.PoppinsRegular(
                    text: 'We will notify you very time flight prices '
                        'on this sector increases or decrease.',
                    color: AppColors.grey888,
                    fontSize: 16,
                  ),
                  SizedBox(height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                        onTap: () {
                          Get.back();
                        },
                        child: CommonTextWidget.PoppinsSemiBold(
                          text: 'GOT IT!',
                          color: AppColors.redCA0,
                          fontSize: 16,
                        ),
                      ),
                      MaterialButton(
                        onPressed: () {
                          Get.back();
                        },
                        height: 40,
                        minWidth: 140,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(40),
                        ),
                        color: AppColors.redCA0,
                        child: CommonTextWidget.PoppinsSemiBold(
                          fontSize: 16,
                          text: 'REMOVE ALERT',
                          color: AppColors.white,
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
}
