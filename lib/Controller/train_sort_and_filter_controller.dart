import 'package:get/get.dart';
import 'package:intl/intl.dart';

class TrainSortAndFilterController extends GetxController {
  // Selected filters
  var selectedClasses =
      <String>[].obs; // Store class names like "1A", "2A", etc.
  var selectedDepartureTimes =
      <String>[].obs; // Use strings like "earlyMorning", "morning", etc.
  var selectedArrivalTimes = <String>[].obs; // Use similar strings as above
  var selectedQuota = ''.obs; // Store selected quota
  RxList<String> selectedQuotas = <String>[].obs;
  var isACFilterEnabled = false.obs; // Filter for AC classes
  var isRefundable = false.obs; // Refundable filter

  // Methods for toggling filters
  void toggleClass(String seatClass) {
    if (selectedClasses.contains(seatClass)) {
      selectedClasses.remove(seatClass);
    } else {
      selectedClasses.add(seatClass);
    }
  }

  void toggleQuota(String quota) {
    if (selectedQuotas.contains(quota)) {
      selectedQuotas.remove(quota);
    } else {
      selectedQuotas.add(quota);
    }
  }

  void toggleDepartureTime(String timePeriod) {
    if (selectedDepartureTimes.contains(timePeriod)) {
      selectedDepartureTimes.remove(timePeriod);
    } else {
      selectedDepartureTimes.add(timePeriod);
    }
  }

  void toggleArrivalTime(String timePeriod) {
    if (selectedArrivalTimes.contains(timePeriod)) {
      selectedArrivalTimes.remove(timePeriod);
    } else {
      selectedArrivalTimes.add(timePeriod);
    }
  }

  void toggleACFilter() {
    isACFilterEnabled.value = !isACFilterEnabled.value;
  }

  void toggleRefundable() {
    isRefundable.value = !isRefundable.value;
  }

  String formatTime(String time) {
    final DateFormat inputFormat = DateFormat("HH:mm");
    final DateFormat outputFormat = DateFormat("hh:mm a");
    final DateTime parsedTime = inputFormat.parse(time);
    return outputFormat.format(parsedTime);
  }

  Map<String, String> calculateArrival(
      Map<String, dynamic> train, DateTime selectedDate) {
    final DateFormat format = DateFormat("HH:mm");
    final DateTime departure = DateTime(
      selectedDate.year,
      selectedDate.month,
      selectedDate.day,
      int.parse(train['departureTime'].split(':')[0]),
      int.parse(train['departureTime'].split(':')[1]),
    );
    final List<String> durationParts = train['duration'].split(':');
    final int durationHours = int.parse(durationParts[0]);
    final int durationMinutes = int.parse(durationParts[1]);

    DateTime arrival = departure.add(
      Duration(hours: durationHours, minutes: durationMinutes),
    );

    final DateFormat outputFormat = DateFormat("dd MMM, EE");
    final String formattedArrivalDate = outputFormat.format(arrival);
    final String formattedArrivalTime = formatTime(format.format(arrival));

    return {
      'formattedArrivalDate': formattedArrivalDate,
      'formattedArrivalTime': formattedArrivalTime,
    };
  }

  var isAvailabilityFilterEnabled = false.obs; // Filter for availability
  var isTatkalFilterEnabled = false.obs; // Filter for Tatkal

  void toggleAvailabilityFilter() {
    isAvailabilityFilterEnabled.value = !isAvailabilityFilterEnabled.value;
    print("Availability Filter Enabled: ${isAvailabilityFilterEnabled.value}");
  }

  void toggleTatkalFilter() {
    isTatkalFilterEnabled.value = !isTatkalFilterEnabled.value;
  }

  // Reset all filters
  void resetFilters() {
    selectedClasses.clear();
    selectedDepartureTimes.clear();
    selectedArrivalTimes.clear();
    selectedQuotas.clear();
    isACFilterEnabled.value = false;
    isRefundable.value = false;
  }

  List<dynamic> applyFilters(List<dynamic> trains) {
    var filteredTrains = trains.where((train) {
      // Apply class filter
      bool classMatch = selectedClasses.isEmpty ||
          train['availabilities']?.any(
              (avlDayList) => selectedClasses.contains(avlDayList['enqClass']));
      if (!classMatch) {
        print('Excluded by class filter: ${train['trainNumber']}');
        return false;
      }
      
      bool quotaMatch = false;
      if (selectedQuotas.isNotEmpty) {
        quotaMatch = train['availabilities']?.any((avlDayList) {
              final quota = avlDayList['quota']?.toUpperCase();
              return selectedQuotas
                  .contains(quota); // Match any of the selected quotas
            }) ??
            false;
      } else {
        // Default to GN quota if no specific quotas are selected
        quotaMatch = train['availabilities']?.any((avlDayList) {
              final quota = avlDayList['quota']?.toUpperCase();
              return quota == 'GN';
            }) ??
            false;
      }

      // Apply AC filter and exclude SL
      bool acMatch = !isACFilterEnabled.value ||
          train['availabilities']?.any((avlDayList) =>
              ["1A", "2A", "3A", "3E", "CC", "EC"]
                  .contains(avlDayList['enqClass']) &&
              avlDayList['enqClass'] != "SL");
      if (!acMatch) {
        print('Excluded by AC filter: ${train['trainNumber']}');
        return false;
      }

      // Apply Tatkal filter
      bool tatkalMatch = !isTatkalFilterEnabled.value ||
          train['availabilities']
              ?.any((avlDayList) => avlDayList['quota']?.toUpperCase() == 'TQ');
      if (!tatkalMatch) {
        print('Excluded by Tatkal filter: ${train['trainNumber']}');
        return false;
      }

      // Apply availability filter
      // Apply availability filter
      bool availabilityMatch = !isAvailabilityFilterEnabled.value ||
              train['availabilities']?.any((avlDayList) {
                final availability =
                    avlDayList['availability']?.split('-').first.toUpperCase();
                return availability == 'AVAILABLE';
              }) ??
          false;

     

      // Apply departure time filter
      final DateTime departureTime =
          DateFormat("HH:mm").parse(train['departureTime']);
      int departureHour = departureTime.hour;
      bool departureMatch = selectedDepartureTimes.isEmpty ||
          selectedDepartureTimes.any((timePeriod) {
            if (timePeriod == 'earlyMorning') {
              return departureHour >= 0 && departureHour < 6;
            } else if (timePeriod == 'morning') {
              return departureHour >= 6 && departureHour < 12;
            } else if (timePeriod == 'midDay') {
              return departureHour >= 12 && departureHour < 18;
            } else if (timePeriod == 'night') {
              return departureHour >= 18 && departureHour < 24;
            }
            return false;
          });
      if (!departureMatch) {
        print('Excluded by departure time filter: ${train['trainNumber']}');
        return false;
      }

      // Apply arrival time filter
      final arrivalInfo = calculateArrival(train, DateTime.now());
      final DateTime arrivalTime =
          DateFormat("hh:mm a").parse(arrivalInfo['formattedArrivalTime']!);
      int arrivalHour = arrivalTime.hour;
      bool arrivalMatch = selectedArrivalTimes.isEmpty ||
          selectedArrivalTimes.any((timePeriod) {
            if (timePeriod == 'earlyMorning') {
              return arrivalHour >= 0 && arrivalHour < 6;
            } else if (timePeriod == 'morning') {
              return arrivalHour >= 6 && arrivalHour < 12;
            } else if (timePeriod == 'midDay') {
              return arrivalHour >= 12 && arrivalHour < 18;
            } else if (timePeriod == 'night') {
              return arrivalHour >= 18 && arrivalHour < 24;
            }
            return false;
          });
      if (!arrivalMatch) {
        print('Excluded by arrival time filter: ${train['trainNumber']}');
        return false;
      }

      // Combine all filters
      return true;
    }).toList();

    print('selectedQuotas: $selectedQuotas');

    print("Filtered Trains: $filteredTrains");
    // print("Selected classes: $selectedClasses");
    // print("Selected departure times: $selectedDepartureTimes");
    // print("Selected arrival times: $selectedArrivalTimes");
    // print("AC filter enabled: $isACFilterEnabled");

    return filteredTrains;
  }
}
