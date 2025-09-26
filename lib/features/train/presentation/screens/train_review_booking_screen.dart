import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:seemytrip/core/theme/app_colors.dart';
import 'package:seemytrip/core/widgets/common_text_widget.dart';
import 'package:seemytrip/main.dart';

class TrainReviewBookingScreen extends StatelessWidget {

  TrainReviewBookingScreen({
    Key? key,
    required this.trainName,
    required this.trainNumber,
    required this.startStation,
    required this.endStation,
    required this.seatClass,
    required this.price,
  }) : super(key: key);
  final String trainName;
  final String trainNumber;
  final String startStation;
  final String endStation;
  final String seatClass;
  final double price;

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
          text: 'Review Booking',
          color: AppColors.white,
          fontSize: 18,
        ),
      ),
      body: Stack(
        children: [
          ScrollConfiguration(
            behavior: MyBehavior(),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    width: Get.width,
                    color: AppColors.yellowF7C.withValues(alpha: 0.3),
                    child: Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: 15, horizontal: 24),
                      child: CommonTextWidget.PoppinsRegular(
                        text: 'Review booking, complete payment and enter '
                            'IRCTC login password in 10 mins.',
                        color: AppColors.black2E2,
                        fontSize: 14,
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CommonTextWidget.PoppinsMedium(
                                  text: 'Boarding station',
                                  color: AppColors.black2E2,
                                  fontSize: 14,
                                ),
                                CommonTextWidget.PoppinsRegular(
                                  text: startStation,
                                  color: AppColors.grey717,
                                  fontSize: 14,
                                ),
                              ],
                            ),
                            CommonTextWidget.PoppinsMedium(
                              text: '5:40 PM (4 Oct)',
                              color: AppColors.black2E2,
                              fontSize: 14,
                            ),
                          ],
                        ),
                        SizedBox(height: 20),
                        Container(
                          width: Get.width,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: AppColors.white,
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.grey515.withValues(alpha: 0.25),
                                blurRadius: 6,
                                offset: Offset(0, 1),
                              ),
                            ],
                          ),
                          child: ListTile(
                            title: CommonTextWidget.PoppinsSemiBold(
                              text: '$trainName, $trainNumber',
                              color: AppColors.black2E2,
                              fontSize: 16,
                            ),
                            subtitle: CommonTextWidget.PoppinsRegular(
                              text: seatClass,
                              color: AppColors.grey717,
                              fontSize: 14,
                            ),
                          ),
                        ),
                        SizedBox(height: 20),
                        CommonTextWidget.PoppinsRegular(
                          text: 'Price Breakup',
                          color: AppColors.black2E2,
                          fontSize: 18,
                        ),
                        SizedBox(height: 20),
                        CommonTextWidget.PoppinsSemiBold(
                          text: 'Base Fare',
                          color: AppColors.black2E2,
                          fontSize: 14,
                        ),
                        SizedBox(height: 18),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            CommonTextWidget.PoppinsRegular(
                              text: 'Ticket Charge',
                              color: AppColors.black2E2,
                              fontSize: 14,
                            ),
                            CommonTextWidget.PoppinsMedium(
                              text: '₹ $price',
                              color: AppColors.black2E2,
                              fontSize: 14,
                            ),
                          ],
                        ),
                        // ... (rest of the code remains the same)
                      ],
                    ),
                  ),
                  SizedBox(height: 110),
                ],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 40),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    height: 60,
                    width: Get.width,
                    color: AppColors.black2E2,
                    child: Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CommonTextWidget.PoppinsSemiBold(
                            text: '₹ $price',
                            color: AppColors.white,
                            fontSize: 16,
                          ),
                          MaterialButton(
                            onPressed: () {
                              Get.to(() => TrainReviewBookingScreen(
                                trainName: trainName,
                                trainNumber: trainNumber,
                                startStation: startStation,
                                endStation: endStation,
                                seatClass: seatClass,
                                price: price,
                              ));
                            },
                            height: 40,
                            minWidth: 140,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(40),
                            ),
                            color: AppColors.redCA0,
                            child: CommonTextWidget.PoppinsSemiBold(
                              fontSize: 16,
                              text: 'Pay and Book',
                              color: AppColors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
}
