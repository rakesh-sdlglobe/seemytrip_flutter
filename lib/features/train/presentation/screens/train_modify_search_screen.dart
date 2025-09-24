import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:seemytrip/core/utils/colors.dart';
import 'package:seemytrip/shared/constants/images.dart';
import 'package:seemytrip/features/train/presentation/controllers/train_detail_controller.dart';
import 'package:seemytrip/features/train/presentation/screens/train_detail_screen.dart';
import 'package:seemytrip/features/train/presentation/screens/train_from_screen.dart';
import 'package:seemytrip/features/train/presentation/screens/train_to_screen.dart';
import 'package:seemytrip/core/widgets/common_button_widget.dart';
import 'package:seemytrip/core/widgets/common_text_widget.dart';

class TrainModifySearchScreen extends StatefulWidget {
  final String startStation;
  final String endStation;
  final DateTime selectedDate;

  TrainModifySearchScreen({
    Key? key,
    required this.startStation,
    required this.endStation,
    required this.selectedDate,
  }) : super(key: key);

  @override
  State<TrainModifySearchScreen> createState() =>
      _TrainModifySearchScreenState();
}

class _TrainModifySearchScreenState extends State<TrainModifySearchScreen> {
  int selectedIndex = 0;
  DateTime selectedDate = DateTime.now();
  bool isTomorrowSelected = false;
  int selectedDateOption = 0;

  String? selectedFromStation;
  String? selectedToStation;

  final TrainDetailController _controller = TrainDetailController();

  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    selectedFromStation = widget.startStation;
    selectedToStation = widget.endStation;
    selectedDate = widget.selectedDate;
  }

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
    final result = await Get.to(() => TrainFromScreen());
    if (result != null && result.containsKey('stationName')) {
      setState(() {
        selectedFromStation = result['stationName'];
      });
    }
  }

  Future<void> _navigateToToScreen() async {
    final result = await Get.to(() => TrainToScreen());
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
              _buildModifySearchButton(),
              SizedBox(height: 50),
            ],
          ),
          if (isLoading)
            Center(
              child: LoadingAnimationWidget.dotsTriangle(
                color: redCA0,
                size: 20,
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
              onTap: () {
                Get.back();
              },
              child: Icon(Icons.close, color: white, size: 20),
            ),
            CommonTextWidget.PoppinsSemiBold(
              text: "Modify Search",
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

  Widget _buildStationField(String label, String? station, Function() onTap) {
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
                          fontWeight: FontWeight.w500),
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
    );
  }

  Widget _buildDateOptions() {
    return Expanded(
      child: Row(
        children: [
          _buildDateOption(
              "Tomorrow", _setDateToTomorrow, selectedDateOption == 1),
          SizedBox(width: 5),
          _buildDateOption(
              "Day After", _setDateToDayAfter, selectedDateOption == 2),
        ],
      ),
    );
  }

  Widget _buildDateOption(String label, Function() onTap, bool isSelected) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          height: 30,
          decoration: BoxDecoration(
            color: isSelected ? Colors.red : Colors.white,
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
                  color: isSelected ? Colors.white : Colors.redAccent,
                  fontSize: 10),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildModifySearchButton() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24),
      child: CommonButtonWidget.button(
        text: "MODIFY SEARCH",
        buttonColor: redCA0,
        onTap: () async {
          setState(() {
            isLoading = true;
          });
          print(
              'From: $selectedFromStation, To: $selectedToStation, Date: $selectedDate');
          await _controller.getTrains(
            selectedFromStation ?? '',
            selectedToStation ?? '',
            selectedDate.toIso8601String(),
          );
          print('Trains: ${_controller.trains}');
          setState(() {
            isLoading = false;
          });
         
          Get.to(() => TrainDetailScreen(
              trains: _controller.trains.value,
              selectedDate: selectedDate,
              fromStation: selectedFromStation?.split(' - ')[0] ?? '',
              toStation: selectedToStation?.split(' - ')[0] ?? '',
            ));

        },
      ),
    );
  }
}
