import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:makeyourtripapp/Constants/colors.dart';
import 'package:makeyourtripapp/Constants/font_family.dart';
import 'package:makeyourtripapp/Controller/calender_controller.dart';
import 'package:makeyourtripapp/Screens/Utills/common_text_widget.dart';
import 'package:makeyourtripapp/main.dart';
import 'package:table_calendar/table_calendar.dart';

class TrainTravelDateScreen extends StatefulWidget {
  TrainTravelDateScreen({Key? key}) : super(key: key);

  @override
  State<TrainTravelDateScreen> createState() => _TrainTravelDateScreenState();
}

class _TrainTravelDateScreenState extends State<TrainTravelDateScreen> {
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
          child: CustomScrollView(
            slivers: [
              SliverPersistentHeader(
                pinned: true,
                delegate: _StickyWeekdaysHeaderDelegate(),
              ),
              SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 15),
                    CommonTextWidget.PoppinsMedium(
                      text: "SET START DATE",
                      color: redCA0,
                      fontSize: 14,
                    ),
                    SizedBox(height: 15),
                    GetBuilder<CalenderControllerDesign>(
                      init: CalenderControllerDesign(),
                      builder: (controller) {
                        return Column(
                          children: List.generate(3, (index) {
                            DateTime focusedDay =
                                DateTime.now().add(Duration(days: 30 * index));
                            return Padding(
                              padding: EdgeInsets.only(bottom: 20),
                              child: TableCalendar(
                                availableCalendarFormats: {
                                  CalendarFormat.month: 'Month',
                                },
                                availableGestures: AvailableGestures.none,
                                firstDay: DateTime.utc(2021, 1, 1),
                                lastDay: DateTime.now().add(Duration(days: 60)),
                                focusedDay: focusedDay,
                                calendarFormat: controller.calendarFormat,
                                onFormatChanged: (format) {
                                  controller.onFormatChange(format);
                                },
                                selectedDayPredicate: (day) {
                                  // Ensure the previously selected date is displayed
                                  return isSameDay(controller.selectedDay, day);
                                },
                                onDaySelected: (selectedDay, focusedDay) {
                                  if (!isSameDay(
                                      controller.selectedDay, selectedDay)) {
                                    controller.onDaySelected(
                                        selectedDay, focusedDay);

                                    // Send the selected date back to the previous screen
                                    Get.back(result: {
                                      'selectedDate': selectedDay,
                                    });
                                  }
                                },
                                onPageChanged: (focusedDay) {
                                  controller.focusedDay = focusedDay;
                                },
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
                                    color: const Color.fromARGB(
                                        135, 113, 113, 113),
                                    fontFamily: FontFamily.PoppinsRegular,
                                    fontSize: 16,
                                  ),
                                  todayDecoration: BoxDecoration(
                                      color: redCA0,
                                      borderRadius: BorderRadius.circular(4)),
                                ),
                                headerStyle: HeaderStyle(
                                  formatButtonVisible: false,
                                  leftChevronVisible: false,
                                  rightChevronVisible: false,
                                  titleTextStyle: TextStyle(
                                    fontSize: 13,
                                    fontFamily: FontFamily.PoppinsRegular,
                                    color: const Color.fromARGB(255, 0, 0, 0),
                                  ),
                                  titleCentered: true,
                                ),
                                daysOfWeekVisible: false,
                              ),
                            );
                          }),
                        );
                      },
                    ),
                    SizedBox(height: 30),
                    SizedBox(height: 60),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Sticky Weekdays Header
class _StickyWeekdaysHeaderDelegate extends SliverPersistentHeaderDelegate {
  @override
  double get maxExtent => 40.0;
  @override
  double get minExtent => 40.0;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: white,
      padding: EdgeInsets.symmetric(horizontal: 1),
      alignment: Alignment.center,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildWeekdayHeader("Sun"),
          _buildWeekdayHeader("Mon"),
          _buildWeekdayHeader("Tue"),
          _buildWeekdayHeader("Wed"),
          _buildWeekdayHeader("Thu"),
          _buildWeekdayHeader("Fri"),
          _buildWeekdayHeader("Sat"),
        ],
      ),
    );
  }

  Widget _buildWeekdayHeader(String weekday) {
    return Expanded(
      child: Text(
        weekday,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontFamily: FontFamily.PoppinsRegular,
          fontSize: 14,
          color: black2E2,
        ),
      ),
    );
  }

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return false;
  }
}
