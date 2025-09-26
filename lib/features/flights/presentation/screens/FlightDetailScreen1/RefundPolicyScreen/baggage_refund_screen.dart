import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../../core/theme/app_colors.dart';
import '../../../../../../core/widgets/common_text_widget.dart';

class BaggageRefundSCreen extends StatelessWidget {
  BaggageRefundSCreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 20),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 24),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
            ),
            child: Table(
              border: TableBorder(
                bottom: BorderSide(color: AppColors.greyE2E, width: 1),
                top: BorderSide(color: AppColors.greyE2E, width: 1),
                left: BorderSide(color: AppColors.greyE2E, width: 1),
                right: BorderSide(color: AppColors.greyE2E, width: 1),
                verticalInside: BorderSide(color: AppColors.greyE2E, width: 1),
              ),
              children: [
                TableRow(
                  decoration: BoxDecoration(
                    color: AppColors.grey9B9.withOpacity(0.15),
                  ),
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: 8, left: 8, bottom: 8),
                      child: CommonTextWidget.PoppinsMedium(
                        text: 'Cabin',
                        color: AppColors.black2E2,
                        fontSize: 14,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 8, right: 8, left: 8),
                      child: CommonTextWidget.PoppinsMedium(
                        text: 'Check-in',
                        color: AppColors.black2E2,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
                TableRow(
                  children: [
                    Padding(
                      padding: EdgeInsets.all(10),
                      child: CommonTextWidget.PoppinsMedium(
                        text: 'ADULT',
                        color: AppColors.black2E2,
                        fontSize: 14,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(10),
                      child: CommonTextWidget.PoppinsRegular(
                        text: '7 Kgs (1 piece only)',
                        color: AppColors.black2E2,
                        fontSize: 11,
                      ),
                    ),
                    // Padding(
                    //   padding: EdgeInsets.all(10),
                    //   child: CommonTextWidget.PoppinsRegular(
                    //     text: "15 Kgs (1 piece only)",
                    //     color: black2E2,
                    //     fontSize: 11,
                    //   ),
                    // ),
                  ],
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: 20),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 24),
          child: Container(
            width: Get.width,
            decoration: BoxDecoration(
              color: AppColors.orangeEB9.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(3),
            ),
            child: Padding(
              padding: EdgeInsets.all(10),
              child: CommonTextWidget.PoppinsMedium(
                text:
                    'Important: The Baggage info is indicative. MakeMyTrip does ' 
                    'not guarantee the accuracy of the information. Kindly check ' 
                    'with airline website for accurate cancellation information. ' 
                    'The baggage allowance may vary according to stop-overs ' 
                    'connecting flights and charges in airline rules.',
                color: AppColors.black2E2,
                fontSize: 10,
              ),
            ),
          ),
        ),
      ],
    );
}
