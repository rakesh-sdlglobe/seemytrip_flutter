import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/widgets/common_text_widget.dart';
import '../../../../../core/widgets/lists_widget.dart';
import '../../../../../main.dart';

class UpComingTripScreen extends StatelessWidget {
  UpComingTripScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => ScrollConfiguration(
      behavior: MyBehavior(),
      child: ListView.builder(
        padding: EdgeInsets.only(top: 20, left: 24, right: 24),
        itemCount: Lists.myTripList.length,
        shrinkWrap: true,
        itemBuilder: (context, index) => Padding(
          padding: EdgeInsets.only(bottom: 15),
          child: Container(
            height: 100,
            width: Get.width,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: AppColors.whiteF2F,
              boxShadow: [
                BoxShadow(
                  color: AppColors.grey656.withValues(alpha: 0.25),
                  blurRadius: 5,
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  height: 100,
                  width: 100,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(5),
                      bottomLeft: Radius.circular(5),
                    ),
                    image: DecorationImage(
                      image: AssetImage(
                        Lists.myTripList[index],
                      ),
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CommonTextWidget.PoppinsSemiBold(
                          text:
                              'Top 5 Indian Destinations for a Fun Family Trip ',
                          color: AppColors.black2E2,
                          fontSize: 13,
                        ),
                        CommonTextWidget.PoppinsRegular(
                          text: 'Explore Himachal Pradesh & 4 more places',
                          color: AppColors.grey5F5,
                          fontSize: 12,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
}
