import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart'; // For date formatting
import 'package:makeyourtripapp/Constants/colors.dart';
import 'package:makeyourtripapp/Constants/images.dart';
import 'package:makeyourtripapp/Screens/HomeScreen/TrainAndBusScreen/train_and_bus_detail_screen.dart';
import 'package:makeyourtripapp/Screens/HomeScreen/TrainAndBusScreen/train_and_bus_from_screen.dart';
import 'package:makeyourtripapp/Screens/HomeScreen/TrainAndBusScreen/train_and_bus_to_screen.dart';
import 'package:makeyourtripapp/Screens/Utills/common_button_widget.dart';
import 'package:makeyourtripapp/Screens/Utills/common_text_widget.dart';

class TrainAndBusSearchScreen extends StatefulWidget {
  TrainAndBusSearchScreen({Key? key}) : super(key: key);

  @override
  State<TrainAndBusSearchScreen> createState() =>
      _TrainAndBusSearchScreenState();
}

class _TrainAndBusSearchScreenState extends State<TrainAndBusSearchScreen> {
  int selectedIndex = 0;
  DateTime selectedDate = DateTime.now(); // Initial date
  bool isTomorrowSelected = false; // Flag to track selection
  int selectedDateOption = 0; // 0 for None, 1 for Tomorrow, 2 for Day After

  String? selectedFromStation; // To store the selected "From" station
  String? selectedToStation; // To store the selected "To" station

  // Swap the logic here - from and to stations are swapped in this function
  void _swapStations() {
    setState(() {
      final temp = selectedFromStation;
      selectedFromStation = selectedToStation;
      selectedToStation = temp;
    });
  }

  Future<void> _navigateToFromScreen() async {
    final result = await Get.to(() => TrainAndBusFromScreen());
    if (result != null && result.containsKey('stationName')) {
      setState(() {
        selectedFromStation = result['stationName'];
      });
    }
  }

  Future<void> _navigateToToScreen() async {
    final result = await Get.to(() => TrainAndBusToScreen());
    if (result != null && result.containsKey('stationName')) {
      setState(() {
        selectedToStation = result['stationName'];
      });
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  void _setDateToTomorrow() {
    setState(() {
      selectedDate = DateTime.now().add(Duration(days: 1));
      isTomorrowSelected = true;
      selectedDateOption = 1;
    });
  }

  void _setDateToDayAfter() {
    setState(() {
      selectedDate = DateTime.now().add(Duration(days: 2));
      isTomorrowSelected = false;
      selectedDateOption = 2;
    });
  }

  @override
  Widget build(BuildContext context) {
    String formattedDate = DateFormat('dd MMM').format(selectedDate);
    String dayOfWeek = DateFormat('EEEE').format(selectedDate);

    return Scaffold(
      backgroundColor: white,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 100,
            width: Get.width,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(busAndTrainImage),
                fit: BoxFit.fill,
              ),
            ),
            child: Padding(
              padding: EdgeInsets.only(left: 24, right: 24, top: 50),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: () {
                      Get.back();
                    },
                    child: Icon(Icons.arrow_back, color: white, size: 20),
                  ),
                  CommonTextWidget.PoppinsSemiBold(
                    text: "Train Search",
                    color: white,
                    fontSize: 18,
                  ),
                  Container(),
                ],
              ),
            ),
          ),
          SizedBox(height: 20),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 24),
            child: Stack(
              alignment: Alignment
                  .centerRight, // Align the swap icon at the center of the Stack
              children: [
                Column(
                  children: [
                    GestureDetector(
                      onTap: _navigateToFromScreen,
                      child: Container(
                        width: Get.width,
                        padding:
                            EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          border: Border.all(color: Colors.grey[300]!),
                        ),
                        child: Row(
                          children: [
                            SvgPicture.asset(trainAndBusFromToIcon),
                            SizedBox(width: 15),
                            CommonTextWidget.PoppinsMedium(
                              text:
                                  selectedFromStation ?? "Select From Station",
                              color: selectedFromStation == null
                                  ? grey888
                                  : black2E2,
                              fontSize: 16,
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    GestureDetector(
                      onTap: _navigateToToScreen,
                      child: Container(
                        width: Get.width,
                        padding:
                            EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          border: Border.all(color: Colors.grey[300]!),
                        ),
                        child: Row(
                          children: [
                            SvgPicture.asset(trainAndBusFromToIcon),
                            SizedBox(width: 15),
                            CommonTextWidget.PoppinsMedium(
                              text: selectedToStation ?? "Select To Station",
                              color: selectedToStation == null
                                  ? grey888
                                  : black2E2,
                              fontSize: 16,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                Positioned(
                  // Position the swap icon at the vertical center between the two fields
                  top: 35, // Adjust this value to control the position
                  child: GestureDetector(
                    onTap: _swapStations,
                    child: Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.grey.withOpacity(0.2),
                      ),
                      child:
                          Icon(Icons.swap_vert, size: 24, color: Colors.black),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 18),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 24),
            child: InkWell(
              onTap: () {
                _selectDate(context);
              },
              child: Container(
                width: Get.width,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: Colors.grey.withOpacity(0.15),
                  border: Border.all(color: Colors.grey[300]!, width: 1),
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Row(
                          children: [
                            SvgPicture.asset('assets/icons/calendar_plus.svg'),
                            SizedBox(width: 10),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "DATE",
                                  style: TextStyle(
                                      color: Colors.grey[600],
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500),
                                ),
                                Text(
                                  formattedDate,
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600),
                                ),
                                Text(
                                  dayOfWeek,
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w400),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Row(
                          children: [
                            Expanded(
                              child: GestureDetector(
                                onTap: _setDateToTomorrow,
                                child: Container(
                                  height: 30,
                                  decoration: BoxDecoration(
                                    color: selectedDateOption == 1
                                        ? Colors.red
                                        : Colors.white,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.25),
                                        blurRadius: 6,
                                        offset: Offset(0, 1),
                                      ),
                                    ],
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  child: Center(
                                    child: Text(
                                      "Tomorrow",
                                      style: TextStyle(
                                          color: selectedDateOption == 1
                                              ? Colors.white
                                              : Colors.redAccent,
                                          fontSize: 10),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: 5),
                            Expanded(
                              child: GestureDetector(
                                onTap: _setDateToDayAfter,
                                child: Container(
                                  height: 30,
                                  decoration: BoxDecoration(
                                    color: selectedDateOption == 2
                                        ? Colors.red
                                        : Colors.white,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.25),
                                        blurRadius: 6,
                                        offset: Offset(0, 1),
                                      ),
                                    ],
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  child: Center(
                                    child: Text(
                                      "Day After",
                                      style: TextStyle(
                                          color: selectedDateOption == 2
                                              ? Colors.white
                                              : Colors.redAccent,
                                          fontSize: 10),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Spacer(),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 24),
            child: CommonButtonWidget.button(
              text: "SEARCH",
              buttonColor: redCA0,
              onTap: () {
                Get.to(() => TrainAndBusDetailScreen());
              },
            ),
          ),
          SizedBox(height: 50),
        ],
      ),
    );
  }
}
