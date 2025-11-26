import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:seemytrip/core/config/app_config.dart';
import 'package:intl/intl.dart';

class TrainDetailController extends GetxController {
  var isLoading = false.obs;
  var trains = [].obs;
  var selectedIndex = 0.obs;

  String? fromStation;
  String? toStation;
  DateTime? travelDate;

  static List<dynamic> trainAndBusDetailList1 = List.generate(8, (index) {
    DateTime date = DateTime.now().add(Duration(days: index));
    return "${[
      "Mon",
      "Tue",
      "Wed",
      "Thu",
      "Fri",
      "Sat",
      "Sun",
    ][date.weekday - 1]}, ${date.day}";
  });

  // Filter-related properties
  final RxList<dynamic> _filteredTrains = RxList<dynamic>([]);
  
  // Getter for filtered trains
  List<dynamic> get filteredTrains => _filteredTrains;

  // Method to apply filters
  void applyFilters(List<dynamic> trains) {
    // Start with all trains
    _filteredTrains.value = List.from(trains);
    
    // Add your filter logic here if needed
    // For example:
    // if (someFilterCondition) {
    //   _filteredTrains.value = _filteredTrains.where((train) => /* filter condition */).toList();
    // }
  }

  void setStations(String? fromStation, String? toStation) {
    this.fromStation = fromStation;
    this.toStation = toStation;
    _performLogic();
  }

  void setDate(DateTime date) {
    travelDate = date;
    _performLogic();
  }

  void _performLogic() {
    if (fromStation != null && toStation != null && travelDate != null) {
      getTrains(fromStation!, toStation!, travelDate!.toIso8601String());
    }
  }

  Future<void> getTrains(
      String fromStation, String toStation, String date) async {
    isLoading.value = true;
    try {
      final fromStnCode = fromStation.split(' - ').last;
      final toStnCode = toStation.split(' - ').last;
      final formattedDate = DateFormat('yyyyMMdd').format(DateTime.parse(date).toLocal());
      
      print('API Request - From: $fromStnCode, To: $toStnCode, Date: $formattedDate');

      final requestBody = {
        'fromStnCode': fromStnCode,
        'toStnCode': toStnCode,
        'journeyDate': formattedDate
      };

      print('Request body: $requestBody');

      final response = await http.post(
        Uri.parse(AppConfig.trainsList),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(requestBody),
      );

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        print('API Response data: $data');
        trains.value = data['trainBtwnStnsList'] ?? [];
        applyFilters(trains.value);
        // Print first train's availability if exists
        if (trains.value.isNotEmpty) {
          print("First train availability: ${trains.value[0]['availabilities']}");
        }
      } else {
        print('Failed to fetch trains: ${response.statusCode}');
        Get.snackbar('Error', 'Failed to fetch trains');
      }
    } catch (e) {
      print('Error occurred: $e');
      Get.snackbar('Error', 'An error occurred');
    } finally {
      isLoading.value = false;
    }
  }

  void setSelectedDate(DateTime date) {
    travelDate = date;
    print("Selected date: ${DateFormat('dd MMM, yyyy').format(date)}");
    _performLogic();
  }

  void onIndexChange(int index) {
    selectedIndex.value = index;
    print('Selected index changed to: $index');
  }

  void setInitialSelectedIndex(DateTime selectedDate) {
    for (int i = 0;
        i < TrainDetailController.trainAndBusDetailList1.length;
        i++) {
      try {
        if (DateFormat('d, E').format(selectedDate) ==
            TrainDetailController.trainAndBusDetailList1[i]) {
          selectedIndex.value = i;
          break;
        }
      } catch (e) {
        print('Error parsing date: $e');
      }
    }
  }


  //seat block

  Future<Map<String, dynamic>?> blockSeats({
  required String trainNumber,
  required String journeyDate,
  required String fromStnCode,
  required String toStnCode,
  required String jClass,
  required String jQuota,
  required List<Map<String, dynamic>> passengers,
  required String boardingStationCode,
}) async {
  try {
    isLoading.value = true;

    final url = Uri.parse(AppConfig.trainSeatBlock); // backend URL

    final requestBody = {
      "trainNumber": trainNumber,
      "journeyDate": journeyDate,
      "fromStnCode": fromStnCode,
      "toStnCode": toStnCode,
      "jClass": jClass,
      "jQuota": jQuota,
      "boardingStation": boardingStationCode,
      "passengerList": passengers
    };

    print("Seat Block Request: $requestBody");

    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(requestBody),
    );

    print("Seat Block Response: ${response.body}");

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data;
    } else {
      Get.snackbar("Error", "Seat block failed");
      return null;
    }
  } catch (e) {
    print("Seat Block Error: $e");
    Get.snackbar("Error", "Something went wrong");
    return null;
  } finally {
    isLoading.value = false;
  }
}


}
