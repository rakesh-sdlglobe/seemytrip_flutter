// ignore_for_file: unnecessary_import

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class DatePickerWidget extends StatelessWidget {
  final String formattedDate;
  final String dayOfWeek;
  final Function onTap;
  final String title; // Add this parameter for "Date" or "Return Date"

  DatePickerWidget({
    required this.formattedDate,
    required this.dayOfWeek,
    required this.onTap,
    required this.title, // Initialize title
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24),
      child: InkWell(
        onTap: () => onTap(),
        child: Container(
          width: Get.width,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: Colors.grey.withOpacity(0.15),
            border: Border.all(color: Colors.grey[300]!, width: 1),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            child: Row(
              children: [
                SvgPicture.asset('assets/images/calendarPlus.svg'),
                SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title, // Display "Date" or "Return Date"
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      formattedDate,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      dayOfWeek,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
