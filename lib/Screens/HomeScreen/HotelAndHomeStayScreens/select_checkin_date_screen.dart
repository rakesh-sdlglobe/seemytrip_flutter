import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:makeyourtripapp/Constants/colors.dart';
import 'package:makeyourtripapp/Constants/font_family.dart';
import 'package:makeyourtripapp/Controller/select_checkin_date_controller.dart';
import 'package:makeyourtripapp/Screens/Utills/common_button_widget.dart';
import 'package:makeyourtripapp/Screens/Utills/common_text_widget.dart';
import 'package:table_calendar/table_calendar.dart';

class SelectCheckInDateScreen extends StatelessWidget {
  final SelectCheckInControllerDesign controller =
      Get.put(SelectCheckInControllerDesign());

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
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: const Icon(Icons.arrow_back, color: Colors.white, size: 20),
        ),
        title: CommonTextWidget.PoppinsSemiBold(
          text: "Select Your Dates",
          color: white,
          fontSize: 18,
        ),
        actions: [
          TextButton(
            onPressed: controller.resetSelection,
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
          _buildCalendarHeader(),
          _buildCalendar(),
          _buildDateSelectionInfo(),
          const Spacer(),
          _buildBottomButtons(context),
        ],
      ),
    );
  }

  Widget _buildCalendarHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.grey[50],
      child: GetBuilder<SelectCheckInControllerDesign>(
        builder: (controller) => Row(
          children: [
            Icon(Icons.info_outline, size: 18, color: grey717),
            const SizedBox(width: 8),
            Expanded(
              child: CommonTextWidget.PoppinsRegular(
                text: "Select check-in and check-out dates",
                color: grey717,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCalendar() {
    return GetBuilder<SelectCheckInControllerDesign>(
      builder: (controller) => TableCalendar(
        availableCalendarFormats: const {
          CalendarFormat.month: 'Month',
        },
        firstDay: DateTime.now(),
        lastDay: DateTime.now().add(const Duration(days: 365)),
        focusedDay: controller.focusedDay,
        calendarFormat: controller.calendarFormat,
        rangeStartDay: controller.rangeStart,
        rangeEndDay: controller.rangeEnd,
        rangeSelectionMode: RangeSelectionMode.enforced,
        onRangeSelected: controller.onRangeSelected,
        onPageChanged: (focusedDay) {
          controller.focusedDay = focusedDay;
        },
        enabledDayPredicate: controller.isDateSelectable,
        calendarStyle: CalendarStyle(
          selectedDecoration: BoxDecoration(
            color: redCA0,
            shape: BoxShape.circle,
          ),
          rangeStartDecoration: BoxDecoration(
            color: redCA0,
            shape: BoxShape.circle,
          ),
          rangeEndDecoration: BoxDecoration(
            color: redCA0,
            shape: BoxShape.circle,
          ),
          withinRangeDecoration: BoxDecoration(
            color: redCA0.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          todayDecoration: BoxDecoration(
            color: Colors.transparent,
            shape: BoxShape.circle,
            border: Border.all(color: redCA0, width: 1),
          ),
          defaultDecoration: BoxDecoration(
            shape: BoxShape.circle,
          ),
          withinRangeTextStyle: const TextStyle(color: Colors.black),
          rangeStartTextStyle: const TextStyle(color: Colors.white),
          rangeEndTextStyle: const TextStyle(color: Colors.white),
          todayTextStyle: TextStyle(color: redCA0),
          defaultTextStyle: TextStyle(color: black2E2),
          weekendTextStyle: TextStyle(color: black2E2),
          outsideTextStyle: TextStyle(color: grey717),
          rangeHighlightColor: redCA0.withOpacity(0.1),
          outsideDaysVisible: false,
        ),
        headerStyle: HeaderStyle(
          titleCentered: true,
          formatButtonVisible: false,
          leftChevronIcon: Icon(Icons.chevron_left, color: black2E2),
          rightChevronIcon: Icon(Icons.chevron_right, color: black2E2),
          titleTextStyle: TextStyle(
            color: black2E2,
            fontSize: 16,
            fontFamily: FontFamily.PoppinsSemiBold,
          ),
        ),
      ),
    );
  }

  Widget _buildDateSelectionInfo() {
    return GetBuilder<SelectCheckInControllerDesign>(
      builder: (controller) => Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (controller.rangeStart != null &&
                controller.rangeEnd != null) ...[
              CommonTextWidget.PoppinsSemiBold(
                text: "Selected Stay: ${controller.formattedRangeDate}",
                color: black2E2,
                fontSize: 14,
              ),
              const SizedBox(height: 4),
              CommonTextWidget.PoppinsRegular(
                text:
                    "${controller.numberOfNights} night${controller.numberOfNights != 1 ? 's' : ''}",
                color: grey717,
                fontSize: 12,
              ),
            ],
            Obx(() {
              if (controller.errorMessage.isNotEmpty) {
                return Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: CommonTextWidget.PoppinsRegular(
                    text: controller.errorMessage.value,
                    color: Colors.red,
                    fontSize: 12,
                  ),
                );
              }
              return const SizedBox.shrink();
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomButtons(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: CommonButtonWidget.button(
              onTap: () {
                if (controller.confirmSelection()) {
                  Get.back(result: {
                    'startDate': controller.rangeStart,
                    'endDate': controller.rangeEnd,
                    'numberOfNights': controller.numberOfNights,
                  });
                }
              },
              text: "Confirm Selection",
              buttonColor: redCA0,
            ),
          ),
        ],
      ),
    );
  }
}
