import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:seemytrip/Constants/colors.dart';
import 'package:seemytrip/Constants/font_family.dart';
import 'package:seemytrip/Controller/calender_controller.dart';
import 'package:seemytrip/Screens/Utills/common_text_widget.dart';
import 'package:seemytrip/main.dart';
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
      backgroundColor: Color(0xFFF8FAFD),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () => Get.back(),
            borderRadius: BorderRadius.circular(12),
            child: Container(
              margin: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Color(0xFFFEE8E8),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                Icons.arrow_back_ios_new_rounded,
                color: Color(0xFFD32F2F),
                size: 20,
              ),
            ),
          ),
        ),
        title: Text(
          "Select Travel Date",
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Color(0xFF1A1A1A),
            letterSpacing: 0.5,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              final today = DateTime.now();
              Get.back(result: {'selectedDate': today});
            },
            child: Text(
              'Today',
              style: GoogleFonts.inter(
                color: Color(0xFFD32F2F),
                fontWeight: FontWeight.w600,
                fontSize: 15,
              ),
            ),
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 20,
              offset: Offset(0, -4),
            ),
          ],
        ),
        child: ScrollConfiguration(
          behavior: MyBehavior(),
          child: CustomScrollView(
            physics: BouncingScrollPhysics(),
            slivers: [
              SliverToBoxAdapter(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  child: Text(
                    'Select your preferred travel date',
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      color: Color(0xFF666666),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
              SliverPersistentHeader(
                pinned: true,
                delegate: _StickyWeekdaysHeaderDelegate(),
              ),
              SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 8),
                    GetBuilder<CalenderControllerDesign>(
                      init: CalenderControllerDesign(),
                      builder: (controller) {
                        return Column(
                          children: List.generate(3, (index) {
                            DateTime focusedDay = DateTime.now().add(Duration(days: 30 * index));
                            return Padding(
                              padding: EdgeInsets.only(bottom: 24),
                              child: Container(
                                margin: EdgeInsets.symmetric(horizontal: 16),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(16),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.04),
                                      blurRadius: 15,
                                      offset: Offset(0, 6),
                                    ),
                                  ],
                                ),
                                child: TableCalendar(
                                  availableCalendarFormats: {
                                    CalendarFormat.month: 'Month',
                                  },
                                  availableGestures: AvailableGestures.all,
                                  firstDay: DateTime.now().subtract(Duration(days: 365)),
                                  lastDay: DateTime.now().add(Duration(days: 365)),
                                  focusedDay: focusedDay,
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
                                      // Send the selected date back to the previous screen
                                      Get.back(result: {'selectedDate': selectedDay});
                                    }
                                  },
                                  onPageChanged: (focusedDay) {
                                    controller.focusedDay = focusedDay;
                                  },
                                  calendarStyle: CalendarStyle(
                                    defaultTextStyle: GoogleFonts.inter(
                                      fontSize: 15,
                                      color: Color(0xFF333333),
                                      fontWeight: FontWeight.w500,
                                    ),
                                    weekendTextStyle: GoogleFonts.inter(
                                      fontSize: 15,
                                      color: Color(0xFFFF5252),
                                      fontWeight: FontWeight.w500,
                                    ),
                                    selectedDecoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [Color(0xFFD32F2F), Color(0xFFFF5252)],
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                      ),
                                      borderRadius: BorderRadius.circular(12),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Color(0xFFFF5252).withOpacity(0.3),
                                          blurRadius: 8,
                                          offset: Offset(0, 4),
                                        ),
                                      ],
                                    ),
                                    selectedTextStyle: TextStyle(
                                      color: Colors.white,
                                      fontFamily: FontFamily.PoppinsSemiBold,
                                      fontSize: 15,
                                    ),
                                    todayDecoration: BoxDecoration(
                                      color: Color(0xFFFEE8E8),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    todayTextStyle: TextStyle(
                                      color: Color(0xFFD32F2F),
                                      fontFamily: FontFamily.PoppinsSemiBold,
                                      fontSize: 15,
                                    ),
                                    disabledTextStyle: GoogleFonts.inter(
                                      color: Colors.grey[300],
                                      fontSize: 15,
                                    ),
                                    outsideDaysVisible: false,
                                    cellMargin: EdgeInsets.all(4),
                                  ),
                                  headerStyle: HeaderStyle(
                                    formatButtonVisible: false,
                                    titleCentered: true,
                                    titleTextStyle: GoogleFonts.poppins(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xFF1A1A1A),
                                    ),
                                    leftChevronIcon: Icon(
                                      Icons.chevron_left_rounded,
                                      color: Color(0xFF666666),
                                      size: 28,
                                    ),
                                    rightChevronIcon: Icon(
                                      Icons.chevron_right_rounded,
                                      color: Color(0xFF666666),
                                      size: 28,
                                    ),
                                    headerPadding: EdgeInsets.symmetric(vertical: 12),
                                  ),
                                  daysOfWeekStyle: DaysOfWeekStyle(
                                    weekdayStyle: GoogleFonts.inter(
                                      color: Color(0xFF666666),
                                      fontWeight: FontWeight.w500,
                                    ),
                                    weekendStyle: GoogleFonts.inter(
                                      color: Color(0xFFFF5252),
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  calendarBuilders: CalendarBuilders(
                                    defaultBuilder: (context, day, focusedDay) {
                                      return Center(
                                        child: Text(
                                          '${day.day}',
                                          style: GoogleFonts.inter(
                                            color: day.weekday == DateTime.sunday
                                                ? Color(0xFFFF5252)
                                                : Color(0xFF333333),
                                            fontWeight: FontWeight.w500,
                                            fontSize: 15,
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),
                            );
                          }),
                        );
                      },
                    ),
                    SizedBox(height: 30),
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
  double get maxExtent => 48.0;
  @override
  double get minExtent => 48.0;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.symmetric(horizontal: 16),
      alignment: Alignment.bottomCenter,
      child: Container(
        height: 40,
        decoration: BoxDecoration(
          color: Color(0xFFF5F7FA),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildWeekdayHeader("S", isWeekend: true),
            _buildWeekdayHeader("M"),
            _buildWeekdayHeader("T"),
            _buildWeekdayHeader("W"),
            _buildWeekdayHeader("T"),
            _buildWeekdayHeader("F"),
            _buildWeekdayHeader("S", isWeekend: true),
          ],
        ),
      ),
    );
  }

  Widget _buildWeekdayHeader(String weekday, {bool isWeekend = false}) {
    return Container(
      width: 36,
      alignment: Alignment.center,
      child: Text(
        weekday,
        style: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: isWeekend ? Color(0xFFFF5252) : Color(0xFF666666),
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return false;
  }
}
