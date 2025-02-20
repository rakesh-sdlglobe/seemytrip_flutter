import 'package:get/get.dart';
import 'package:table_calendar/table_calendar.dart';

class CalenderControllerDesign extends GetxController {
  // Track the current calendar format (month, week, etc.)
  CalendarFormat calendarFormat = CalendarFormat.month;

  // Track the currently focused and selected day
  DateTime focusedDay = DateTime.now();
  late DateTime selectedDay;

  // Store any events mapped to dates
  Map<DateTime, List> eventsList = {};

  // Store the formatted date (optional use, e.g., for display)
  var formattedDate;

  @override
  void onInit() {
    super.onInit();

    // Initialize the selected day as the focused day
    selectedDay = focusedDay;
  }

  // Update calendar format (month/week view)
  onFormatChange(CalendarFormat format) {
    if (calendarFormat != format) {
      calendarFormat = format;
      update();
    }
  }

  // Update the selected day and focused day when a user selects a date
  onDaySelected(DateTime daySelected, DateTime dayFocus) {
    selectedDay = daySelected;
    focusedDay = dayFocus;

    // Trigger UI update after a date selection
    update();
  }

  // Helper method to check if a given date is the selected day
  bool isSelectedDay(DateTime day) {
    return isSameDay(selectedDay, day);
  }
}
