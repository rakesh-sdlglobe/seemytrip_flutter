import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:makeyourtripapp/Screens/Utills/lists_widget.dart';

class TrainAndBusDetailController extends GetxController {
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

  void setStations(String? fromStation, String? toStation) {
    this.fromStation = fromStation;
    this.toStation = toStation;
    _performLogic();
  }

  void setDate(DateTime date) {
    this.travelDate = date;
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

      final requestBody = {
        'fromStnCode': fromStnCode,
        'toStnCode': toStnCode,
        'journeyDate':
            DateFormat('yyyyMMdd').format(DateTime.parse(date).toLocal())
      };

      final response = await http.post(
        Uri.parse('http://192.168.0.57:3002/api/trains/getTrains'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(requestBody),
      );

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        trains.value = data['trainBtwnStnsList'] ?? [];
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
        i < TrainAndBusDetailController.trainAndBusDetailList1.length;
        i++) {
      try {
        if (DateFormat('d, E').format(selectedDate) ==
            TrainAndBusDetailController.trainAndBusDetailList1[i]) {
          selectedIndex.value = i;
          break;
        }
      } catch (e) {
        print('Error parsing date: $e');
      }
    }
  }
}
