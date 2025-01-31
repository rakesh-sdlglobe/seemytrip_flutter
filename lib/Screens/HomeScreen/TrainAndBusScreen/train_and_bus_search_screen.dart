import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:makeyourtripapp/Constants/colors.dart';
import 'package:makeyourtripapp/Constants/images.dart';
import 'package:makeyourtripapp/Controller/train_and_bus_detail_controller.dart';
import 'package:makeyourtripapp/Screens/HomeScreen/TrainAndBusScreen/train_and_bus_detail_screen.dart';
import 'package:makeyourtripapp/Screens/HomeScreen/TrainAndBusScreen/train_and_bus_from_screen.dart';
import 'package:makeyourtripapp/Screens/HomeScreen/TrainAndBusScreen/train_and_bus_to_screen.dart';
import 'package:makeyourtripapp/Screens/Utills/common_button_widget.dart';
import 'package:makeyourtripapp/Screens/Utills/common_text_widget.dart';

class TrainAndBusSearchScreen extends StatefulWidget {
  @override
  _TrainAndBusSearchScreenState createState() =>
      _TrainAndBusSearchScreenState();
}

class _TrainAndBusSearchScreenState extends State<TrainAndBusSearchScreen> {
  int selectedIndex = 0;
  DateTime selectedDate = DateTime.now();
  bool isTomorrowSelected = false;
  int selectedDateOption = 0;

  String? selectedFromStation;
  String? selectedToStation;

  final TrainAndBusDetailController _controller = TrainAndBusDetailController();
  bool isLoading = false;

  void _swapStations() {
    setState(() {
      final temp = selectedFromStation;
      selectedFromStation = selectedToStation;
      selectedToStation = temp;
    });
    _controller.setStations(selectedFromStation, selectedToStation);
    _controller.setDate(selectedDate);
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
      body: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              SizedBox(height: 20),
              _buildStationSelection(),
              SizedBox(height: 18),
              _buildDateSelection(formattedDate, dayOfWeek),
              Spacer(),
              _buildSearchButton(),
              SizedBox(height: 50),
            ],
          ),
          if (isLoading)
            Center(
              child: CircularProgressIndicator.adaptive(
                valueColor: AlwaysStoppedAnimation<Color>(redCA0),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
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
              onTap: () => Get.back(),
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
    );
  }

  Widget _buildStationSelection() {
    return Stack(
      alignment: Alignment.centerRight,
      children: [
        Column(
          children: [
            _buildStationField(
                "From", selectedFromStation, _navigateToFromScreen),
            SizedBox(height: 10),
            _buildStationField("To", selectedToStation, _navigateToToScreen),
          ],
        ),
        Positioned(
          top: 55,
          right: 39,
          child: GestureDetector(
            onTap: _swapStations,
            child: Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.all(Radius.circular(5.0)),
                color: Colors.grey.withOpacity(0.2),
              ),
              child: Icon(Icons.swap_vert, size: 24, color: Colors.black),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStationField(String label, String? station, VoidCallback onTap) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.grey.withOpacity(0.15),
            borderRadius: BorderRadius.circular(5),
            border: Border.all(width: 1, color: greyE2E),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 12),
            child: Row(
              children: [
                SvgPicture.asset(trainAndBusFromToIcon),
                SizedBox(width: 15),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      station ?? "Select $label Station",
                      style: TextStyle(
                        color: station == null ? grey888 : black2E2,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDateSelection(String formattedDate, String dayOfWeek) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24),
      child: InkWell(
        onTap: () => _selectDate(context),
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
                _buildDateInfo(formattedDate, dayOfWeek),
                _buildDateOptions(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDateInfo(String formattedDate, String dayOfWeek) {
    return Expanded(
      child: Row(
        children: [
          SvgPicture.asset('assets/images/calendarPlus.svg'),
          SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "DATE",
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                formattedDate,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                dayOfWeek,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDateOptions() {
    return Expanded(
      child: Row(
        children: [
          _buildDateOption("Tomorrow", 1, _setDateToTomorrow),
          SizedBox(width: 5),
          _buildDateOption("Day After", 2, _setDateToDayAfter),
        ],
      ),
    );
  }

  Widget _buildDateOption(String label, int option, VoidCallback onTap) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          height: 30,
          decoration: BoxDecoration(
            color: selectedDateOption == option ? Colors.red : Colors.white,
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
              label,
              style: TextStyle(
                color: selectedDateOption == option
                    ? Colors.white
                    : Colors.redAccent,
                fontSize: 10,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSearchButton() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24),
      child: CommonButtonWidget.button(
        text: "SEARCH",
        buttonColor: redCA0,
        onTap: () async {
          if (selectedFromStation == null || selectedToStation == null) {
            Get.snackbar(
              'Error',
              'Please select both From and To stations',
              snackPosition: SnackPosition.BOTTOM,
              backgroundColor: const Color.fromARGB(255, 248, 30, 15),
              colorText: Colors.white,
            );
            return;
          }
          setState(() {
            isLoading = true;
          });

          await _controller.getTrains(
            selectedFromStation ?? '',
            selectedToStation ?? '',
            selectedDate.toIso8601String(),
          );

            Get.to(() => TrainAndBusDetailScreen(
              trains: _controller.trains.value,
              selectedDate: selectedDate,
              fromStation: selectedFromStation?.split(' - ')[0] ?? '',
              toStation: selectedToStation?.split(' - ')[0] ?? '',
            ));

          setState(() {
            isLoading = false;
          });
        },
      ),
    );
  }
}
