import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

class SelectCheckInControllerDesign extends GetxController {
  // ADDED: Constructor to accept previously selected dates
  final DateTime? initialStartDate;
  final DateTime? initialEndDate;

  SelectCheckInControllerDesign({this.initialStartDate, this.initialEndDate});

  // --- Reactive State Variables ---
  final calendarFormat = CalendarFormat.month.obs;
  final focusedDay = DateTime.now().obs;
  final rangeStart = Rxn<DateTime>();
  final rangeEnd = Rxn<DateTime>();
  final errorMessage = ''.obs;
  
  // --- Computed Properties (Getters) ---
  
  /// A computed property to check if a valid range is selected.
  bool get isRangeSelected => rangeStart.value != null && rangeEnd.value != null;
  
  /// A computed property to get the number of nights.
  int get numberOfNights {
    if (!isRangeSelected) return 0;
    // Add 1 to include both start and end dates in the count
    return rangeEnd.value!.difference(rangeStart.value!).inDays + 1;
  }
  
  /// A computed property to format the date range for display.
  String get formattedRangeDate {
    if (rangeStart.value == null) return "Select dates";
    
    final startFormat = DateFormat('MMM d');
    final start = startFormat.format(rangeStart.value!);
    
    if (rangeEnd.value == null) return "$start - Select end date";
    
    final end = startFormat.format(rangeEnd.value!);
    final startYear = rangeStart.value!.year;
    final endYear = rangeEnd.value!.year;
    
    // Show year if different years or if it's not the current year
    final showStartYear = startYear != endYear || startYear != DateTime.now().year;
    final showEndYear = startYear != endYear || endYear != DateTime.now().year;
    
    final startStr = showStartYear 
        ? '$start, $startYear' 
        : start;
        
    final endStr = showEndYear 
        ? '$end, $endYear' 
        : end;
    
    return '$startStr - $endStr';
  }

  @override
  void onInit() {
    super.onInit();
    // MODIFIED: Set initial values from the constructor
    if (initialStartDate != null) {
      rangeStart.value = initialStartDate;
      focusedDay.value = initialStartDate!; // Focus the calendar on the start date
    }
    if (initialEndDate != null) {
      rangeEnd.value = initialEndDate;
    }
  }

  /// Called when a date range is selected on the calendar.
  void onRangeSelected(DateTime? start, DateTime? end, DateTime focused) {
    // This is the callback from TableCalendar
    rangeStart.value = start;
    rangeEnd.value = end;
    focusedDay.value = focused;
    errorMessage.value = ''; // Clear any previous errors on a new selection
  }
  
  /// Resets all selections in the calendar.
  void resetSelection() {
    rangeStart.value = null;
    rangeEnd.value = null;
    focusedDay.value = DateTime.now(); // Reset focus to today
    errorMessage.value = '';
  }
}