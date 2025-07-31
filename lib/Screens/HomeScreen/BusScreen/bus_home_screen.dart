import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import 'package:seemytrip/Controller/bus_controller.dart';
import 'package:seemytrip/Screens/HomeScreen/BusScreen/bus_leaving_from_screen.dart';
import 'package:seemytrip/Screens/HomeScreen/BusScreen/bus_going_to_screen.dart';
import 'package:seemytrip/Screens/HomeScreen/BusScreen/widgets/bus_home_widgets.dart';
import 'package:seemytrip/Screens/HomeScreen/BusScreen/widgets/search_form.dart';
import 'package:seemytrip/Screens/HomeScreen/BusScreen/widgets/bottom_nav_bar.dart';

class BusHomeScreen extends StatefulWidget {
  const BusHomeScreen({Key? key}) : super(key: key);

  @override
  State<BusHomeScreen> createState() => _BusHomeScreenState();
}

class _BusHomeScreenState extends State<BusHomeScreen> {
  final BusController _busController = Get.put(BusController());
  final RxString selectedDepartureCity = 'Select city'.obs;
  final RxString selectedDestinationCity = 'Select city'.obs;
  final RxInt departureCityId = 0.obs;
  final RxInt destinationCityId = 0.obs;
  DateTime _selectedDate = DateTime.now();
  final RxBool _isLoading = false.obs;

  // Navigation
  int selectedBottomNavIndex = 0;

  // Handle departure city selection
  Future<Map<String, dynamic>?> _selectDepartureCity() async {
    final selectedCity = await Get.to<Map<String, dynamic>>(
      () => const BusLeavingFromScreen(),
    );
    if (selectedCity != null) {
      selectedDepartureCity.value =
          selectedCity['name']?.toString() ?? 'Select city';
      departureCityId.value =
          int.tryParse(selectedCity['id']?.toString() ?? '0') ?? 0;
    }
    return selectedCity;
  }

  // Handle destination city selection
  Future<Map<String, dynamic>?> _selectDestinationCity() async {
    final selectedCity = await Get.to<Map<String, dynamic>>(
      () => const BusGoingToScreen(),
    );
    if (selectedCity != null) {
      selectedDestinationCity.value =
          selectedCity['name']?.toString() ?? 'Select city';
      destinationCityId.value =
          int.tryParse(selectedCity['id']?.toString() ?? '0') ?? 0;
    }
    return selectedCity;
  }

  // Handle swap
  void _swapCities() {
    final tempName = selectedDepartureCity.value;
    final tempId = departureCityId.value;

    selectedDepartureCity.value = selectedDestinationCity.value;
    departureCityId.value = destinationCityId.value;

    selectedDestinationCity.value = tempName;
    destinationCityId.value = tempId;
  }

  // Handle date selection
  void _onDateSelected(DateTime date) {
    setState(() => _selectedDate = date);
  }

  // Handle search button press
  Future<void> _onSearchPressed() async {
    if (departureCityId.value == 0 || destinationCityId.value == 0) {
      Get.snackbar(
        'Error',
        'Please select both departure and destination cities',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    try {
      _isLoading.value = true;

      final dateStr = DateFormat('yyyy-MM-dd').format(_selectedDate);

      // Print search parameters
      print('=== Bus Search Parameters ===');
      print('Departure City ID: ${departureCityId.value}');
      print('Destination City ID: ${destinationCityId.value}');
      print('Date of Journey: $dateStr');
      print('End User IP: ${_busController.endUserIp.value}');
      print('Booking Mode: 1');
      print('Token ID: ${_busController.tokenId.value}');
      print('Preferred Currency: INR');
      print('===========================');

      // --- FIX: Await the searchBuses call to wait for completion ---
      await _busController.searchBuses(
        dateOfJourney: dateStr,
        originId: departureCityId.value,
        destinationId: destinationCityId.value,
        endUserIp: _busController.endUserIp.value,
        bookingMode: 1,
        tokenId: _busController.tokenId.value,
        preferredCurrency: "INR",
      );
    } catch (e) {
      print('Error during search: $e');
      Get.snackbar(
        'Error',
        'Failed to search for buses. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      // This will now only run after the await is finished
      _isLoading.value = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      // --- FIX: Wrap the body in Obx and Stack to show a loading overlay ---
      body: Obx(
        () => Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                children: [
                  // Top banner with back button
                  TopBanner(onBackPressed: () => Get.back()),

                  // const TrustIndicator(),
                  // const DiscountBanner(),

                  // Search form
                  SearchForm(
                    selectedDates: [
                      _selectedDate
                    ], // Wrap in a list since it expects List<DateTime>
                    onDateTapped: _onDateSelected,
                    onSearchPressed: _onSearchPressed,
                    departureCity: selectedDepartureCity,
                    destinationCity: selectedDestinationCity,
                    onDepartureTap: _selectDepartureCity,
                    onDestinationTap: _selectDestinationCity,
                    onSwapPressed: _swapCities,
                    isLoading: _isLoading.value,
                  ),

                  // const PromoSection(),

                  // SpecialOffersHeader(
                  //   onViewAll: () {
                  //     // TODO: Implement offer viewing
                  //   },
                  // ),
                  const SizedBox(height: 20),
                ],
              ),
            ),

            // --- FIX: Add a conditional loading overlay ---
            // if (_isLoading.value)
            //   Container(
            //     color: Colors.black.withOpacity(0.5),
            //     child: const Center(
            //       child: CircularProgressIndicator(
            //         valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            //       ),
            //     ),
            //   ),
          ],
        ),
      ),
    );
  }
}

// bottomNavigationBar: BusBottomNavBar(
      //   selectedIndex: selectedBottomNavIndex,
      //   onItemTapped: (index) {
      //     setState(() => selectedBottomNavIndex = index);
      //   },
      // ),
