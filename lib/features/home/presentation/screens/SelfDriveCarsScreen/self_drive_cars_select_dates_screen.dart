import 'package:flutter/material.dart';
import 'package:flutter_toggle_tab/flutter_toggle_tab.dart';
import 'package:get/get.dart';
import 'package:seemytrip/features/shared/presentation/controllers/calender_controller.dart';
import 'package:seemytrip/core/utils/colors.dart';
import 'package:seemytrip/shared/constants/font_family.dart';
import 'package:seemytrip/shared/constants/images.dart';
import 'package:seemytrip/core/widgets/common_button_widget.dart';
import 'package:seemytrip/core/widgets/common_text_widget.dart';
import 'package:seemytrip/main.dart';
import 'package:table_calendar/table_calendar.dart';

class SelfDriveCarsSelectTravelDateScreen extends StatefulWidget {
  SelfDriveCarsSelectTravelDateScreen({Key? key}) : super(key: key);

  @override
  State<SelfDriveCarsSelectTravelDateScreen> createState() =>
      _SelfDriveCarsSelectTravelDateScreenState();
}

class _SelfDriveCarsSelectTravelDateScreenState
    extends State<SelfDriveCarsSelectTravelDateScreen> {
  var _tabTextIndexSelected = 1;
  var listHeightText = ["AM", "PM"];

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
          text: "Select Travel Dates",
          color: white,
          fontSize: 18,
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24),
        child: ScrollConfiguration(
          behavior: MyBehavior(),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Image.asset(selectTravelDateImage1, height: 86),
                    Image.asset(selectTravelDateImage2, height: 86),
                  ],
                ),
                SizedBox(height: 15),
                Divider(color: greyE8E, thickness: 1),
                SizedBox(height: 15),
                CommonTextWidget.PoppinsMedium(
                  text: "SET START DATE",
                  color: redCA0,
                  fontSize: 14,
                ),
                SizedBox(height: 15),
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
                          color: redCA0,
                          borderRadius: BorderRadius.circular(4)),
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
                          color: redCA0,
                          borderRadius: BorderRadius.circular(4)),
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
                SizedBox(height: 25),
                Divider(color: greyE8E, thickness: 1),
                SizedBox(height: 22),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CommonTextWidget.PoppinsMedium(
                      text: "SET START DATE",
                      color: redCA0,
                      fontSize: 14,
                    ),
                    Container(
                      height: 35,
                      width: 130,
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            offset: Offset(0, 1),
                            blurRadius: 6,
                            color: grey515.withOpacity(0.25),
                          ),
                        ],
                        color: white,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(4),
                        child: FlutterToggleTab(
                          width: 30,
                          height: 30,
                          borderRadius: 30,
                          selectedIndex: _tabTextIndexSelected,
                          selectedTextStyle: TextStyle(
                              color: white,
                              fontSize: 14,
                              fontFamily: FontFamily.PoppinsMedium),
                          unSelectedTextStyle: TextStyle(
                              color: black2E2,
                              fontSize: 14,
                              fontFamily: FontFamily.PoppinsMedium),
                          // labels: listHeightText,
                          selectedBackgroundColors: [redCA0],
                          unSelectedBackgroundColors: [white],
                          selectedLabelIndex: (index) {
                            setState(() {
                              _tabTextIndexSelected = index;
                            });
                          }, dataTabs: [],
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 30),
                Image.asset(selectTravelDateImage3),
                SizedBox(height: 135),
                CommonButtonWidget.button(
                  buttonColor: redCA0,
                  onTap: () {},
                  text: "SET DROP OFF DATE/TIME",
                ),
                SizedBox(height: 60),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
