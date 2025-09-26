import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/widgets/common_text_widget.dart';
import '../../../../../features/train/presentation/screens/train_booking_screen.dart';

class StationChangeScreen extends StatelessWidget {
  final String trainName;
  final String trainNumber;
  final String startStation;
  final String endStation;
  final String fromStation;
  final String toStation;
  final String seatClass;
  final int price;
  final String duration;
  final String departureTime;
  final String arrivalTime;
  final DateTime departure;
  final DateTime arrival;

  StationChangeScreen({
    Key? key,
    required this.trainName,
    required this.trainNumber,
    required this.startStation,
    required this.endStation,
    required this.fromStation,
    required this.toStation,
    required this.seatClass,
    required this.price,
    required this.duration,
    required this.departureTime,
    required this.arrivalTime,
    required this.departure,
    required this.arrival,
  }) : super(key: key);

  // Function to format time from 24-hour to 12-hour format with AM/PM
  String formatTime(String time) {
    final DateFormat inputFormat = DateFormat('HH:mm');
    final DateFormat outputFormat = DateFormat('hh:mm a');
    final DateTime parsedTime = inputFormat.parse(time);
    return outputFormat.format(parsedTime);
  }

  @override
  Widget build(BuildContext context) => Padding(
      padding: EdgeInsets.only(top: 300),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
        ),
        child: Column(
          children: [
            Container(
              width: Get.width,
              decoration: BoxDecoration(
                color: AppColors.redCA0,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 20),
                child: Center(
                  child: CommonTextWidget.PoppinsMedium(
                    text: 'Station Change',
                    color: AppColors.white,
                    fontSize: 18,
                  ),
                ),
              ),
            ),
            SizedBox(height: 30),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CommonTextWidget.PoppinsMedium(
                    text:
                        'You searched for trains between $startStation and $endStation',
                    color: AppColors.grey888,
                    fontSize: 12,
                  ),
                  SizedBox(height: 5),
                  CommonTextWidget.PoppinsMedium(
                    text:
                        'But this train travels between $trainName ($trainNumber) '
                        'and $endStation',
                    color: AppColors.black2E2,
                    fontSize: 12,
                  ),
                  SizedBox(height: 30),
                  // Image.asset(stationChangeImage),
                  // SizedBox(height: 30),
                  // Image.asset(stationChangeImage2),
                  // SizedBox(height: 30),
                  CommonTextWidget.PoppinsMedium(
                    text: 'Train Schedule',
                    color: AppColors.black2E2,
                    fontSize: 16,
                  ),
                  SizedBox(height: 10),
                  CommonTextWidget.PoppinsMedium(
                    text: 'Departure: ${formatTime(departureTime)}',
                    color: AppColors.grey888,
                    fontSize: 14,
                  ),
                  CommonTextWidget.PoppinsMedium(
                    text: 'Arrival: ${formatTime(arrivalTime)}',
                    color: AppColors.grey888,
                    fontSize: 14,
                  ),
                  SizedBox(height: 20),
                  CommonTextWidget.PoppinsMedium(
                    text: 'Amenities',
                    color: AppColors.black2E2,
                    fontSize: 16,
                  ),
                  SizedBox(height: 10),
                  CommonTextWidget.PoppinsMedium(
                    text: 'WiFi, Food, AC, Charging Points',
                    color: AppColors.grey888,
                    fontSize: 14,
                  ),
                  SizedBox(height: 45),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                        onTap: () {
                          Get.back();
                        },
                        child: CommonTextWidget.PoppinsMedium(
                          text: 'Back',
                          color: AppColors.redCA0,
                          fontSize: 16,
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          Get.to(() => TrainBookingScreen(
                                trainName: trainName,
                                trainNumber: trainNumber,
                                startStation: startStation,
                                endStation: endStation,
                                fromStation: fromStation,
                                toStation: toStation,
                                seatClass: seatClass,
                                price: price.toDouble(),
                                duration: duration,
                                departureTime: departureTime,
                                arrivalTime: arrivalTime,
                                departure:
                                    DateFormat('dd MMM').format(departure),
                                arrival: DateFormat('dd MMM').format(arrival),
                              ));
                        },
                        child: CommonTextWidget.PoppinsMedium(
                          text: 'OK, Go AHEAD',
                          color: AppColors.redCA0,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
}
