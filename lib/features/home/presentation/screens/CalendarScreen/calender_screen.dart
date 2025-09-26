import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/widgets/common_button_widget.dart';
import '../../../../../core/widgets/common_text_widget.dart';
import '../../../../../shared/constants/font_family.dart';
import '../../../../shared/presentation/controllers/calender_controller.dart';

class CalenderScreen extends StatelessWidget {
  CalenderScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Scaffold(
      backgroundColor: AppColors.whiteF2F,
      appBar: AppBar(
        backgroundColor: AppColors.redCA0,
        automaticallyImplyLeading: false,
        elevation: 0,
        centerTitle: true,
        leading: InkWell(
          onTap: () {
            Get.back();
          },
          child: Icon(Icons.arrow_back, color: AppColors.whiteF2F, size: 20),
        ),
        title: CommonTextWidget.PoppinsSemiBold(
          text: 'New Delhi to Mumbai',
          color: AppColors.whiteF2F,
          fontSize: 18,
        ),
      ),
      body: Column(
        children: [
          GetBuilder<CalenderControllerDesign>(
            init: CalenderControllerDesign(),
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
              selectedDayPredicate: (day) => isSameDay(controller.selectedDay, day),
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
                    color: AppColors.grey717),
              ),
              calendarStyle: CalendarStyle(
                selectedDecoration: BoxDecoration(
                    color: AppColors.redCA0, borderRadius: BorderRadius.circular(4)),
                selectedTextStyle: TextStyle(
                  color: AppColors.whiteF2F,
                  fontFamily: FontFamily.PoppinsMedium,
                  fontSize: 16,
                ),
                disabledTextStyle: TextStyle(
                  color: AppColors.grey717,
                  fontFamily: FontFamily.PoppinsRegular,
                  fontSize: 16,
                ),
                todayDecoration: BoxDecoration(
                    color: AppColors.redCA0, borderRadius: BorderRadius.circular(4)),
              ),
              headerStyle: HeaderStyle(
                formatButtonVisible: false,
                titleTextStyle: TextStyle(
                  fontSize: 12,
                  fontFamily: FontFamily.PoppinsRegular,
                  color: AppColors.black2E2,
                ),
                titleCentered: true,
              ),
            ),
          ),
          Spacer(),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 24),
            child: CommonButtonWidget.button(
              buttonColor: AppColors.redCA0,
              onTap: () {},
              text: 'Done',
            ),
          ),
          SizedBox(height: 50),
        ],
      ),
    );
}
