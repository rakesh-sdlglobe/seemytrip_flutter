import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:seemytrip/core/theme/app_colors.dart';
import 'package:seemytrip/features/hotels/presentation/controllers/select_checkin_date_controller.dart'; // Ensure path is correct
import 'package:table_calendar/table_calendar.dart';

class SelectCheckInDateScreen extends StatelessWidget {

  SelectCheckInDateScreen({
    Key? key,
    this.initialStartDate,
    this.initialEndDate,
  })  : controller = Get.put(SelectCheckInControllerDesign(
          initialStartDate: initialStartDate,
          initialEndDate: initialEndDate,
        )),
        super(key: key);

  final DateTime? initialStartDate;
  final DateTime? initialEndDate;

  final SelectCheckInControllerDesign controller;

  @override
  Widget build(BuildContext context) {
    // Initialize dates when widget is first built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (controller.rangeStart.value == null && initialStartDate != null) {
        controller.rangeStart.value = initialStartDate;
        controller.focusedDay.value = initialStartDate!;
      }
      if (controller.rangeEnd.value == null && initialEndDate != null) {
        controller.rangeEnd.value = initialEndDate;
      }
    });

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: AppColors.redCA0,
        automaticallyImplyLeading: false,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: Icon(Icons.arrow_back, color: AppColors.white),
        ),
        title: Text('Select Your Dates',
            style: TextStyle(
                color: AppColors.white, fontSize: 18, fontWeight: FontWeight.w600)),
        actions: [
          TextButton(
            onPressed: controller.resetSelection,
            child: Text('Reset', style: TextStyle(color: AppColors.white, fontSize: 14)),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  _buildCalendarHeader(context),
                  _buildCalendar(context),
                  _buildDateSelectionInfo(context),
                ],
              ),
            ),
          ),
          _buildBottomButton(context),
        ],
      ),
    );
  }

  Widget _buildCalendarHeader(BuildContext context) => Container(
      padding: const EdgeInsets.all(16),
      color: AppColors.grey50,
      child: Row(
        children: [
          Icon(Icons.info_outline, size: 18, color: AppColors.grey717),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'Select a check-in and check-out date',
              style: TextStyle(color: AppColors.grey717, fontSize: 12),
            ),
          ),
        ],
      ),
    );

  Widget _buildCalendar(BuildContext context) => Obx(
      () => TableCalendar(
        firstDay: DateTime.now().subtract(const Duration(days: 30)),
        lastDay: DateTime.now().add(const Duration(days: 365 * 2)),
        focusedDay: controller.focusedDay.value,
        selectedDayPredicate: (day) =>
            isSameDay(day, controller.rangeStart.value) ||
            isSameDay(day, controller.rangeEnd.value),
        rangeStartDay: controller.rangeStart.value,
        rangeEndDay: controller.rangeEnd.value,
        rangeSelectionMode: RangeSelectionMode.enforced,
        onRangeSelected: controller.onRangeSelected,
        onPageChanged: (focusedDay) {
          controller.focusedDay.value = focusedDay;
        },
        // Enable today and future dates
        enabledDayPredicate: (day) {
          final today = DateTime.now();
          final normalizedToday = DateTime(today.year, today.month, today.day);
          final normalizedDay = DateTime(day.year, day.month, day.day);
          return !normalizedDay.isBefore(normalizedToday);
        },
        calendarStyle: CalendarStyle(
          rangeHighlightColor: AppColors.redCA0.withOpacity(0.2),
          rangeStartDecoration:
              BoxDecoration(color: AppColors.redCA0, shape: BoxShape.circle),
          rangeEndDecoration:
              BoxDecoration(color: AppColors.redCA0, shape: BoxShape.circle),
          todayDecoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: AppColors.redCA0),
          ),
          todayTextStyle: TextStyle(color: AppColors.redCA0),
          selectedTextStyle: const TextStyle(color: Colors.white),
          disabledTextStyle: TextStyle(color: Colors.grey.shade400),
          outsideDaysVisible: false,
        ),
        headerStyle: HeaderStyle(
          titleCentered: true,
          formatButtonVisible: false,
          titleTextStyle: TextStyle(
              color: Theme.of(context).textTheme.bodyLarge?.color ?? AppColors.black2E2, fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),
    );

  Widget _buildDateSelectionInfo(BuildContext context) => Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      child: Obx(() {
        if (controller.isRangeSelected) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Selected Stay: ${controller.formattedRangeDate}',
                style: TextStyle(
                    color: Theme.of(context).textTheme.bodyLarge?.color ?? AppColors.black2E2, fontSize: 14, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 4),
              Text(
                "${controller.numberOfNights} night${controller.numberOfNights != 1 ? 's' : ''}",
                style: TextStyle(color: AppColors.grey717, fontSize: 12),
              ),
            ],
          );
        }
        // Shows a prompt if only the start date is selected
        if (controller.rangeStart.value != null) {
          return Text(
            'Please select a check-out date',
            style: TextStyle(color: AppColors.black2E2, fontSize: 14),
          );
        }
        return const SizedBox.shrink();
      }),
    );

  // Update the bottom button to return the selected dates
  Widget _buildBottomButton(BuildContext context) => Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Obx(() => ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.redCA0,
              foregroundColor: AppColors.white,
              minimumSize: const Size(double.infinity, 50),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              disabledBackgroundColor: AppColors.grey575,
            ),
            onPressed: controller.isRangeSelected
                ? () {
                    // Return the selected date range
                    Get.back(result: {
                      'startDate': controller.rangeStart.value!,
                      'endDate': controller.rangeEnd.value!,
                    });
                  }
                : null,
            child: Text(
              controller.isRangeSelected
                  ? 'Confirm ${controller.numberOfNights} Nights'
                  : 'Select Dates',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: AppColors.white,
              ),
            ),
          )),
    );
}
