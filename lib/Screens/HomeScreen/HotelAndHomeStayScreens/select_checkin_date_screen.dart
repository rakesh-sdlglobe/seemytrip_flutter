import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:makeyourtripapp/Constants/colors.dart';
import 'package:makeyourtripapp/Constants/font_family.dart';
import 'package:makeyourtripapp/Constants/images.dart';
import 'package:makeyourtripapp/Controller/select_checkin_date_controller.dart';
import 'package:makeyourtripapp/Screens/Utills/common_button_widget.dart';
import 'package:makeyourtripapp/Screens/Utills/common_text_widget.dart';
import 'package:table_calendar/table_calendar.dart';

class SelectCheckInDateScreen extends StatelessWidget {
  SelectCheckInDateScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
      appBar: AppBar(
        backgroundColor: redCA0,
        automaticallyImplyLeading: false,
        elevation: 0,
        centerTitle: true,
        leading: InkWell(
          onTap: () {
            Get.back();
          },
          child: Icon(Icons.arrow_back, color: white, size: 20),
        ),
        title: CommonTextWidget.PoppinsSemiBold(
          text: "Select check-In Date",
          color: white,
          fontSize: 18,
        ),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 20, top: 20),
            child: CommonTextWidget.PoppinsMedium(
              text: "Reset",
              color: white,
              fontSize: 12,
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          GetBuilder<SelectCheckInControllerDesign>(
            init: SelectCheckInControllerDesign(),
            builder: (controller) => TableCalendar(
              availableCalendarFormats: {
                CalendarFormat.month: 'Month',
              },
              availableGestures: AvailableGestures.none,
              firstDay: DateTime.utc(2021, 1, 1),
              lastDay: DateTime.utc(2030, 12, 31),
              focusedDay: controller.focusedDay,
              calendarFormat: controller.calendarFormat,
              onFormatChanged: (format) {
                controller.onFormatChange(format);
              },
              selectedDayPredicate: (day) {
                return isSameDay(controller.selectedDay, day);
              },
              onDaySelected: (selectedDay, focusedDay) {
                if (!isSameDay(controller.selectedDay, selectedDay)) {
                  controller.onDaySelected(selectedDay, focusedDay);
                }
                print(selectedDay);
              },
              onPageChanged: (focusedDay) {
                controller.focusedDay = focusedDay;
              },
              daysOfWeekStyle: DaysOfWeekStyle(
                weekdayStyle: TextStyle(
                    fontSize: 12,
                    fontFamily: FontFamily.PoppinsRegular,
                    color: grey717),
              ),
              calendarStyle: CalendarStyle(
                selectedDecoration: BoxDecoration(
                    color: redCA0, borderRadius: BorderRadius.circular(4)),
                selectedTextStyle: TextStyle(
                  color: white,
                  fontFamily: FontFamily.PoppinsMedium,
                  fontSize: 16,
                ),
                disabledTextStyle: TextStyle(
                  color: grey717,
                  fontFamily: FontFamily.PoppinsRegular,
                  fontSize: 16,
                ),
                todayDecoration: BoxDecoration(
                    color: redCA0, borderRadius: BorderRadius.circular(4)),
              ),
              headerStyle: HeaderStyle(
                formatButtonVisible: false,
                titleTextStyle: TextStyle(
                  fontSize: 12,
                  fontFamily: FontFamily.PoppinsRegular,
                  color: black2E2,
                ),
                titleCentered: true,
              ),
            ),
          ),
          Spacer(),
          Container(
            decoration: BoxDecoration(
              color: white,
              boxShadow: [
                BoxShadow(
                  blurRadius: 4,
                  color: grey4B4.withOpacity(0.25),
                ),
              ],
            ),
            child: Column(
              children: [
                SizedBox(height: 20),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24),
                  child: Image.asset(selectCheckInDateImage),
                ),
                SizedBox(height: 20),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24),
                  child: CommonButtonWidget.button(
                    buttonColor: redCA0,
                    onTap: () {
                      Get.back();
                    },
                    text: "Done",
                  ),
                ),
                SizedBox(height: 50),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
