import 'package:get/get.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';

class SelectCheckInControllerDesign extends GetxController {
  // Calendar related variables
  CalendarFormat calendarFormat = CalendarFormat.month;
  DateTime focusedDay = DateTime.now();
  DateTime? selectedDay;
  DateTime? rangeStart;
  DateTime? rangeEnd;
  DateTime? previouslySelectedDate;  // Track previously selected date
  
  // State variables
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;
  
  // Formatted date strings
  String get formattedSelectedDate => selectedDay != null 
      ? DateFormat('dd MMM yyyy').format(selectedDay!)
      : '';
      
  String get formattedRangeDate {
    if (rangeStart != null && rangeEnd != null) {
      return '${DateFormat('dd MMM').format(rangeStart!)} - ${DateFormat('dd MMM yyyy').format(rangeEnd!)}';
    }
    return '';
  }
  
  // Number of nights selected
  int get numberOfNights {
    if (rangeStart == null || rangeEnd == null) return 0;
    return rangeEnd!.difference(rangeStart!).inDays;
  }

  @override
  void onInit() {
    selectedDay = focusedDay;
    super.onInit();
  }

  // Format change handler
  void onFormatChange(CalendarFormat format) {
    if (calendarFormat != format) {
      calendarFormat = format;
      update();
    }
  }

  // Single date selection handler
  void onDaySelected(DateTime selectedDate, DateTime focusDate) {
    if (!isSameDay(selectedDay, selectedDate)) {
      selectedDay = selectedDate;
      focusedDay = focusDate;
      rangeStart = null;
      rangeEnd = null;
      update();
    }
  }

  // Range selection handlers
  void onRangeSelected(DateTime? start, DateTime? end, DateTime focusDate) {
    rangeStart = start;
    rangeEnd = end;
    selectedDay = null;
    focusedDay = focusDate;
    
    if (start != null) {
      previouslySelectedDate = start;  // Track the previous selection
    }
    
    // Ensure UI updates immediately
    if (start != null && end != null) {
      // Both dates are selected, update immediately
      update();
    } else if (start != null) {
      // Only start date selected, update to show it
      update();
    } else {
      // Reset selection
      rangeStart = null;
      rangeEnd = null;
      update();
    }
  }

  // Validation methods
  bool isDateSelectable(DateTime day) {
    // Allow current date and future dates
    return !day.isBefore(DateTime.now());
  }

  // Reset selection
  void resetSelection() {
    selectedDay = focusedDay;
    rangeStart = null;
    rangeEnd = null;
    errorMessage.value = '';
    update();
  }

  // Confirm selection
  bool confirmSelection() {
    if (selectedDay == null && (rangeStart == null || rangeEnd == null)) {
      errorMessage.value = 'Please select a date or date range';
      return false;
    }
    
    if (rangeStart != null && rangeEnd != null && numberOfNights > 30) {
      errorMessage.value = 'Maximum stay duration is 30 nights';
      return false;
    }
    
    return true;
  }
}