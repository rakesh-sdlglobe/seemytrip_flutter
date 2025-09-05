import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../../../core/utils/colors.dart';
import '../../../../../core/widgets/common_text_widget.dart';
import '../../../../../core/widgets/lists_widget.dart';
import '../../../../../main.dart';
import '../../../../../shared/constants/images.dart';
import '../../controllers/flight_controller.dart';
import 'custom_dialogbox.dart';
import 'datepicker.dart';
import 'flight_from_screen.dart';
import 'flight_to_screen.dart';
import 'from_station_selector.dart';
import 'offer_make_your_trip_screen.dart';
import 'to_station_selector.dart';

class OneWayScreen extends StatefulWidget {
  const OneWayScreen({Key? key}) : super(key: key);

  @override
  State<OneWayScreen> createState() => _OneWayScreenState();
}

class _OneWayScreenState extends State<OneWayScreen> {
  String? selectedFromStation; // To store the selected "From" station
  String? selectedToStation; // To store the selected "To" station
  String formattedDate = 'Select Date'; // Placeholder for selected date
  String dayOfWeek = ''; // Placeholder for day of the week
  DateTime selectedDate = DateTime.now();
  DateTime? returnDate; // To store the return date
  bool isRoundTrip = false; // Toggle between one-way and round-trip
  bool showTravelerClassSelector =
      false; // To show/hide traveler and class selector
  int? selectedFareIndex; // Add this variable to track the selected fare index
  String travelClass = 'Economy'; // Default travel class
  int travelers = 1; // Default number of travelers
  bool isLoading = false; // Track loading state
  bool isReturnDateVisible = false; // Controls visibility of return date picker
  String? fromAirportCode; // Store the selected from airport code
  String? toAirportCode; // Store the selected to airport code
  final FlightController _flightController = Get.find<FlightController>();

  // Search flights method
  Future<void> _searchFlights() async {
    // Validate inputs
    if (fromAirportCode == null || fromAirportCode!.isEmpty) {
      Get.snackbar('Error', 'Please select departure airport');
      return;
    }

    if (toAirportCode == null || toAirportCode!.isEmpty) {
      Get.snackbar('Error', 'Please select arrival airport');
      return;
    }

    if (selectedDate == null) {
      Get.snackbar('Error', 'Please select departure date');
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      // Format date as YYYY-MM-DD
      final formattedDate = DateFormat('yyyy-MM-dd').format(selectedDate);

      // Log the search parameters
      final returnDateFormatted = returnDate != null
          ? DateFormat('yyyy-MM-dd').format(returnDate!)
          : 'Not set';
      print('=== Flight Search Parameters ===');
      print('From Airport: $fromAirportCode');
      print('To Airport: $toAirportCode');
      print('Departure Date: $formattedDate (${selectedDate.toString()})');
      print(
          'Return Date: $returnDateFormatted (${returnDate?.toString() ?? 'null'})');
      print('Travelers: $travelers');
      print('Travel Class: $travelClass');
      print('Is Return Trip: ${returnDate != null}');
      print('==============================');

      // Call searchAndShowFlights which will handle navigation internally
      await _flightController.searchAndShowFlights(
        fromAirport: fromAirportCode!,
        toAirport: toAirportCode!,
        departDate: formattedDate,
        returnDate: isRoundTrip && returnDate != null
            ? DateFormat('yyyy-MM-dd').format(returnDate!)
            : null,
        tripType: isRoundTrip ? 'roundtrip' : 'oneway',
        adults: travelers,
        travelClass: travelClass == 'Business' ? 'B' : 'E',
        flightType: isRoundTrip ? 'R' : 'O',
      );

      // No need to handle results here as the controller handles navigation
    } catch (e) {
      Get.snackbar('Error', 'Failed to search flights: $e');
      print('Error searching flights: $e');
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  Future<void> _navigateToFromScreen() async {
    final result = await Get.to(() => FlightFromScreen());
    if (result != null && result.containsKey('airportName')) {
      setState(() {
        selectedFromStation =
            '${result['airportName']} (${result['airportCode']})';
        fromAirportCode = result['airportCode'];
      });
    }
  }

  Future<void> _navigateToToScreen() async {
    final result = await Get.to(() => FlightToScreen());
    if (result != null && result.containsKey('airportName')) {
      setState(() {
        selectedToStation =
            '${result['airportName']} (${result['airportCode']})';
        toAirportCode = result['airportCode'];
      });
    }
  }

  Future<void> _selectDate(BuildContext context,
      {bool isReturnDate = false}) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate:
          isReturnDate && returnDate != null ? returnDate! : selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        if (isReturnDate) {
          returnDate = picked;
        } else {
          selectedDate = picked;
        }
      });
    }
  }

  void _selectTravelersAndClass() {
    showDialog(
      context: context,
      builder: (BuildContext context) => TravelClassAndTravelerSelector(
        travelClass: travelClass,
        travelers: travelers,
        onClassChanged: (String newClass) {
          setState(() {
            travelClass = newClass;
          });
        },
        onTravelerCountChanged: (int newCount) {
          setState(() {
            travelers = newCount;
          });
        },
      ),
    );
  }

  // Helper method to build station selection card
  Widget _buildStationCard({
    required String title,
    String? station,
    required IconData icon,
    required VoidCallback onTap,
    bool isTop = false,
    bool isBottom = false,
  }) {
    final displayStation = station ?? 'Select ${title.toLowerCase()}';
    final bool isStationSelected = station != null;
    
    return Material(
      color: Colors.grey[50], // Light gray background
      borderRadius: isTop
          ? const BorderRadius.vertical(top: Radius.circular(12))
          : isBottom
              ? const BorderRadius.vertical(bottom: Radius.circular(12))
              : null,
      elevation: 0.5, // Subtle shadow
      child: InkWell(
        onTap: onTap,
        borderRadius: isTop
            ? const BorderRadius.vertical(top: Radius.circular(12))
            : isBottom
                ? const BorderRadius.vertical(bottom: Radius.circular(12))
                : BorderRadius.zero,
        child: Container(
          decoration: BoxDecoration(
            border: Border(
              bottom: isBottom ? BorderSide.none : BorderSide(color: Colors.grey[200]!),
            ),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: isStationSelected 
                      ? Colors.red[50] 
                      : Colors.grey[100],
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon, 
                  size: 20, 
                  color: isStationSelected ? Colors.red : Colors.grey[600],
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey[700],
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      displayStation,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: isStationSelected ? Colors.black : Colors.grey[600],
                        height: 1.3,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward_ios_rounded, size: 16, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }

  // Helper method to build date selection card
  Widget _buildDateCard({
    required String title,
    required String date,
    required String dayOfWeek,
    required VoidCallback onTap,
    bool isLast = false,
  }) => Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: isLast
            ? const BorderRadius.vertical(bottom: Radius.circular(12))
            : null,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.calendar_today_rounded,
                  size: 20,
                  color: Colors.red,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Text(
                          date,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: date == 'Select Date' ? Colors.grey[600] : Colors.black87,
                          ),
                        ),
                        if (dayOfWeek.isNotEmpty) ...[
                          const SizedBox(width: 8),
                          Text(
                            dayOfWeek,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward_ios_rounded, size: 16, color: Colors.grey),
            ],
          ),
        ),
      ),
    );

  @override
  Widget build(BuildContext context) {
    String formattedDepartureDate = DateFormat('dd MMM yyyy').format(selectedDate);
    String formattedReturnDate = returnDate != null
        ? DateFormat('dd MMM yyyy').format(returnDate!)
        : 'Select Return Date';
    String dayOfWeekDeparture = DateFormat('EEEE').format(selectedDate);
    String dayOfWeekReturn =
        returnDate != null ? DateFormat('EEEE').format(returnDate!) : '';

    return ScrollConfiguration(
      behavior: MyBehavior(),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // From/To Station Cards
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    spreadRadius: 1,
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  // From Station
                  _buildStationCard(
                    title: 'FROM',
                    station: selectedFromStation,
                    icon: Icons.flight_takeoff_rounded,
                    onTap: _navigateToFromScreen,
                    isTop: true,
                  ),
                  Divider(height: 1, color: Colors.grey.shade200),
                  // To Station
                  _buildStationCard(
                    title: 'TO',
                    station: selectedToStation,
                    icon: Icons.flight_land_rounded,
                    onTap: _navigateToToScreen,
                    isBottom: true,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Trip Type Toggle
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    spreadRadius: 1,
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'One-way',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: isRoundTrip ? FontWeight.normal : FontWeight.bold,
                      color: isRoundTrip ? Colors.grey[600] : Colors.black87,
                    ),
                  ),
                  Transform.scale(
                    scale: 0.9,
                    child: Switch.adaptive(
                      value: isRoundTrip,
                      onChanged: (value) {
                        setState(() {
                          isRoundTrip = value;
                          if (!isRoundTrip) {
                            returnDate = null;
                          }
                        });
                      },
                      activeColor: Colors.red,
                      activeTrackColor: Colors.red.withOpacity(0.3),
                    ),
                  ),
                  Text(
                    'Round-trip',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: isRoundTrip ? FontWeight.bold : FontWeight.normal,
                      color: isRoundTrip ? Colors.black87 : Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),

            // Date Selection
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    spreadRadius: 1,
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  // Departure Date
                  _buildDateCard(
                    title: 'DEPARTURE',
                    date: formattedDepartureDate,
                    dayOfWeek: dayOfWeekDeparture,
                    onTap: () => _selectDate(context),
                  ),
                  if (isRoundTrip) Divider(height: 1, color: Colors.grey.shade200),
                  // Return Date (only for round-trip)
                  if (isRoundTrip)
                    _buildDateCard(
                      title: 'RETURN',
                      date: returnDate != null ? formattedReturnDate : 'Select Date',
                      dayOfWeek: returnDate != null ? dayOfWeekReturn : '',
                      onTap: () => _selectDate(context, isReturnDate: true),
                      isLast: true,
                    ),
                ],
              ),
            ),

            // Travellers & Class Section
            // Travelers & Class Card
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
              child: GestureDetector(
                onTap: _selectTravelersAndClass,
                child: Container(
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.1),
                        spreadRadius: 1,
                        blurRadius: 10,
                        offset: const Offset(0, 2),
                      ),
                    ],
                    border: Border.all(color: Colors.grey.shade200, width: 1),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.red.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: SvgPicture.asset(
                          user,
                          width: 20,
                          height: 20,
                          color: Colors.red,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'TRAVELLERS & CLASS',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[600],
                                letterSpacing: 0.5,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                Text(
                                  '$travelers ', // Removed the extra comma
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black87,
                                  ),
                                ),
                                Container(
                                  margin: const EdgeInsets.symmetric(horizontal: 8),
                                  height: 16,
                                  width: 1,
                                  color: Colors.grey[300],
                                ),
                                Text(
                                  travelClass,
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey[700],
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const Spacer(),
                                const Icon(
                                  Icons.arrow_forward_ios_rounded,
                                  size: 16,
                                  color: Colors.grey,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            SizedBox(height: 15),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24),
              child: CommonTextWidget.PoppinsMedium(
                text: 'SPECIAL FARES (OPTIONAL)',
                color: grey888,
                fontSize: 14,
              ),
            ),
            SizedBox(
              height: 70,
              width: Get.width,
              child: ScrollConfiguration(
                behavior: MyBehavior(),
                child: ListView.builder(
                  // Removed const here
                  itemCount: Lists.flightSearchList2.length,
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  padding:
                      EdgeInsets.only(top: 13, bottom: 13, left: 24, right: 12),
                  itemBuilder: (context, index) => Padding(
                    padding: EdgeInsets.only(right: 12),
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedFareIndex =
                              index; // Update the selected fare index
                        });
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: selectedFareIndex == index
                              ? redCA0 // Highlight the selected fare
                              : white,
                          border: Border.all(
                            color:
                                selectedFareIndex == index ? redCA0 : greyE2E,
                            width: 1,
                          ),
                        ),
                        child: Center(
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 20),
                            child: CommonTextWidget.PoppinsMedium(
                              text: Lists.flightSearchList2[index],
                              color: selectedFareIndex == index
                                  ? white // Change text color for selected fare
                                  : grey5F5,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 25),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: ElevatedButton(
                onPressed: _searchFlights,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  minimumSize: Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: isLoading
                    ? SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : Text(
                        'SEARCH FLIGHTS',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ),
            ),
            SizedBox(height: 20),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CommonTextWidget.PoppinsSemiBold(
                    text: 'OFFERS',
                    color: black2E2,
                    fontSize: 16,
                  ),
                  Row(
                    children: [
                      CommonTextWidget.PoppinsRegular(
                        text: 'View All',
                        color: redCA0,
                        fontSize: 14,
                      ),
                      SizedBox(width: 8),
                      Icon(Icons.arrow_forward_ios, color: redCA0, size: 18),
                    ],
                  ),
                ],
              ),
            ),
            Divider(color: greyDED, thickness: 1),
            ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: InkWell(
                onTap: () {
                  Get.to(() => OfferMakeYourTripScreen());
                },
                child: CarouselSlider.builder(
                  itemCount: 4,
                  itemBuilder: (context, index, realIndex) => Container(
                    height: 170,
                    width: Get.width,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        image: DecorationImage(
                            image: AssetImage(flightSearchImage),
                            fit: BoxFit.fill,
                            filterQuality: FilterQuality.high)),
                  ),
                  options: CarouselOptions(
                      autoPlay: true,
                      height: 170,
                      enableInfiniteScroll: true,
                      enlargeCenterPage: true,
                      onPageChanged: (index, reason) {
                        // realStateController.sliderIndex.value = index;
                      }),
                ),
              ),
            ),
            SizedBox(height: 20),
            Container(
              width: Get.width,
              color: redF9E,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CommonTextWidget.PoppinsRegular(
                      text:
                          'Explore the cheapest flight from New Delhi to Mumbai',
                      color: black2E2,
                      fontSize: 14,
                    ),
                    Row(
                      children: [
                        CommonTextWidget.PoppinsMedium(
                          text: 'EXPLORE FARE CALENDAR',
                          color: redCA0,
                          fontSize: 14,
                        ),
                        SizedBox(width: 10),
                        Icon(Icons.arrow_forward, color: redCA0, size: 16),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
