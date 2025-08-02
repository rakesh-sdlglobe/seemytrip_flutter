// ignore_for_file: avoid_redundant_argument_values

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../../../../core/utils/colors.dart';
import '../../../../core/widgets/common/buttons/app_button.dart';
import '../../../../core/widgets/common/common_app_bar.dart';
import '../../../../shared/constants/images.dart';
import '../controllers/train_detail_controller.dart';
import 'train_detail_screen.dart';
import 'train_from_screen.dart';
import 'train_to_screen.dart';
import 'train_traveldate_screen.dart';

class TrainSearchScreen extends StatefulWidget {
  @override
  _TrainSearchScreenState createState() =>
      _TrainSearchScreenState();
}

class _TrainSearchScreenState extends State<TrainSearchScreen> {
  int selectedIndex = 0;
  DateTime selectedDate = DateTime.now();
  bool isTomorrowSelected = false;
  int selectedDateOption = 0;
  String? selectedFromStation;
  String? selectedToStation;
  final TrainDetailController _controller = TrainDetailController();
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
    final result = await Get.to(() => TrainFromScreen(),
        transition: Transition.cupertino);
    if (result != null && result.containsKey('stationName')) {
      setState(() {
        selectedFromStation = result['stationName'];
      });
    }
  }

  Future<void> _navigateToToScreen() async {
    final result = await Get.to(() => TrainToScreen(),
        transition: Transition.cupertino);
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
      builder: (context, child) => Theme(
          data: ThemeData.light().copyWith(
            colorScheme: ColorScheme.light(
              primary: Color(0xFFD32F2F),
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Color(0xFF1A1A1A),
            ),
            textTheme: GoogleFonts.interTextTheme(),
            dialogBackgroundColor: Colors.white,
          ),
          child: child!,
        ),
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
    String formattedDate = DateFormat('dd MMM yyyy').format(selectedDate);
    String dayOfWeek = DateFormat('EEEE').format(selectedDate);
    bool isFormValid = selectedFromStation != null && selectedToStation != null;

    return Scaffold(
      backgroundColor: Color(0xFFF5F7FA),
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(),
                  SizedBox(height: 28),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: _buildStationSelection(),
                  ),
                  SizedBox(height: 20),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: _buildDateSelection(formattedDate, dayOfWeek),
                  ),
                  SizedBox(height: 28),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: _buildSearchButton(),
                  ),
                  SizedBox(height: 40),
                ],
              ),
            ),
            // Loading indicator removed as per request
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() => CommonAppBar(
        title: 'Train Search',
        subtitle: 'Plan your journey with ease',
        textColor: white,
        showBackButton: true,
      );

  Widget _buildStationSelection() => Container(
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.95),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
        border: Border.all(color: Colors.grey[200]!, width: 1),
      ),
      child: Stack(
        alignment: Alignment.centerRight,
        children: [
          Column(
            children: [
              _buildStationField(
                "From",
                selectedFromStation,
                _navigateToFromScreen,
              ),
              Container(
                height: 1,
                color: Colors.grey[100],
                margin: EdgeInsets.symmetric(horizontal: 16),
              ),
              _buildStationField(
                "To",
                selectedToStation,
                _navigateToToScreen,
              ),
            ],
          ),
          Positioned(
            right: 16,
            child: GestureDetector(
              onTap: _swapStations,
              child: AnimatedContainer(
                duration: Duration(milliseconds: 200),
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Color(0xFFD32F2F).withValues(alpha: 0.2),
                      blurRadius: 8,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Icon(
                  Icons.swap_vert,
                  color: Color(0xFFD32F2F),
                  size: 24,
                ),
              ),
            ),
          ),
        ],
      ),
    );

  Widget _buildStationField(String label, String? station, VoidCallback onTap) => Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        onTap: onTap,
        child: AnimatedContainer(
          duration: Duration(milliseconds: 200),
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 18),
          child: Row(
            children: [
              SvgPicture.asset(
                trainAndBusFromToIcon,
                height: 22,
                color: Color(0xFFD32F2F),
              ),
              SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey[500],
                      ),
                    ),
                    SizedBox(height: 6),
                    Text(
                      station ?? "Select $label Station",
                      style: GoogleFonts.inter(
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                        color: station == null
                            ? Colors.grey[400]
                            : Color(0xFF1A1A1A),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );

  Widget _buildDateSelection(String formattedDate, String dayOfWeek) => Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.95),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
        border: Border.all(color: Colors.grey[200]!, width: 1),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: _navigateToCalendarScreen,
          child: AnimatedContainer(
            duration: Duration(milliseconds: 200),
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 18),
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

  Future<void> _navigateToCalendarScreen() async {
    final result = await Get.to(() => TrainTravelDateScreen(),
        transition: Transition.cupertino);
    if (result != null && result.containsKey('selectedDate')) {
      setState(() {
        selectedDate = result['selectedDate'];
      });
    }
  }

  Widget _buildDateInfo(String formattedDate, String dayOfWeek) => Expanded(
      child: Row(
        children: [
          Icon(
            Icons.calendar_today_outlined,
            color: Color(0xFFD32F2F),
            size: 22,
          ),
          SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Travel Date",
                style: GoogleFonts.inter(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey[500],
                ),
              ),
              SizedBox(height: 6),
              Text(
                formattedDate,
                style: GoogleFonts.inter(
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1A1A1A),
                ),
              ),
              Text(
                dayOfWeek,
                style: GoogleFonts.inter(
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  color: Colors.grey[500],
                ),
              ),
            ],
          ),
        ],
      ),
    );

  Widget _buildDateOptions() => Row(
      children: [
        _buildDateOption("Tomorrow", 1, _setDateToTomorrow),
        SizedBox(width: 12),
        _buildDateOption("Day After", 2, _setDateToDayAfter),
      ],
    );

  Widget _buildDateOption(String label, int option, VoidCallback onTap) => GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color:
              selectedDateOption == option ? Color(0xFFD32F2F) : Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: selectedDateOption == option
                ? Color(0xFFD32F2F)
                : Colors.grey[300]!,
            width: 1.5,
          ),
          boxShadow: selectedDateOption == option
              ? [
                  BoxShadow(
                    color: Color(0xFFD32F2F).withOpacity(0.3),
                    blurRadius: 6,
                    offset: Offset(0, 2),
                  ),
                ]
              : [],
        ),
        child: Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color:
                selectedDateOption == option ? Colors.white : Color(0xFFD32F2F),
          ),
        ),
      ),
    );

  Widget _buildSearchButton() {
    bool isFormValid = selectedFromStation != null && selectedToStation != null;
    
    return Column(
      children: [
        if (!isFormValid)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.only(bottom: 8.0, left: 4.0),
            child: const Text(
              'Please select both From and To stations',
              style: TextStyle(
                color: Color(0xFFD32F2F),
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        AppButton.primary(
          text: isFormValid ? 'Search Trains' : 'Select Stations',
          onPressed: isFormValid ? _handleSearch : null,
          isLoading: isLoading,
          isEnabled: isFormValid,
          backgroundColor: isFormValid ? null : Colors.grey[400],
          prefixIcon: isFormValid 
              ? const Icon(
                  Icons.train_rounded,
                  color: Colors.white,
                  size: 22,
                )
              : null,
        ),
      ],
    );
  }

  Future<void> _handleSearch() async {
    if (selectedFromStation == null || selectedToStation == null) {
      Get.snackbar(
        'Missing Information',
        'Please select both From and To stations',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFFD32F2F),
        colorText: Colors.white,
        margin: const EdgeInsets.all(20),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        borderRadius: 16,
        snackStyle: SnackStyle.FLOATING,
        duration: Duration(seconds: 3),
        icon: const Icon(Icons.error_outline, color: Colors.white),
        shouldIconPulse: true,
      );
      return;
    }

    setState(() => isLoading = true);
    await _controller.getTrains(
      selectedFromStation ?? '',
      selectedToStation ?? '',
      selectedDate.toIso8601String(),
    );
    
    if (!mounted) return;
    
    await Get.to(
      () => TrainDetailScreen(
        trains: _controller.trains.value,
        selectedDate: selectedDate,
        fromStation: selectedFromStation?.split(' - ')[0] ?? '',
        toStation: selectedToStation?.split(' - ')[0] ?? '',
      ),
      transition: Transition.cupertino,
      duration: Duration(milliseconds: 400),
    );
    
    if (mounted) setState(() => isLoading = false);
  }
}
