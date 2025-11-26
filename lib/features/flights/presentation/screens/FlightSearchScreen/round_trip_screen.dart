import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import 'package:seemytrip/core/theme/app_colors.dart';
import '../../../../../core/widgets/lists_widget.dart';
import '../../../../../main.dart';
import '../../../../../shared/constants/images.dart';
import '../../controllers/flight_controller.dart';
import '../../controllers/flight_search_controller.dart';
import 'custom_dialogbox.dart';
import 'flight_from_screen.dart';
import 'flight_to_screen.dart';
import 'offer_make_your_trip_screen.dart';

class RoundTripScreen extends StatefulWidget {
  RoundTripScreen({Key? key}) : super(key: key);

  @override
  State<RoundTripScreen> createState() => _RoundTripScreenState();
}

class _RoundTripScreenState extends State<RoundTripScreen> {
  // Add the controller
  final FlightSearchController flightSearchController = Get.put(FlightSearchController());
  final FlightController flightController = Get.put(FlightController());
  
  @override
  void initState() {
    super.initState();
    // Initialize the travelers value in the controller
    flightSearchController.travelers.value = 1;
  }
  
  String? selectedFromStation; // To store the selected "From" station name
  String? selectedFromCode;    // To store the selected "From" station code
  String? selectedToStation;   // To store the selected "To" station name
  String? selectedToCode;      // To store the selected "To" station code
  String formattedDate = 'Select Date'; // Placeholder for selected date
  String dayOfWeek = ''; // Placeholder for day of the week
  DateTime selectedDate = DateTime.now();
  DateTime? returnDate; // To store the return date
  int? selectedFareIndex; // Add this variable to track the selected fare index
  String travelClass = 'Economy'; // Default travel class
  int travelers = 1; // Default number of travelers

  Future<void> _navigateToFromScreen() async {
    try {
      final result = await Get.to(() => FlightFromScreen());
      print('Returned from FlightFromScreen with result: $result');
      
      if (result != null && result is Map) {
        setState(() {
          selectedFromStation = result['stationName'] ?? result['airportName'];
          selectedFromCode = result['stationCode'] ?? result['airportCode'];
          // Also update the controller
          var params = flightController.getLastSearchParams();
          params['fromAirport'] = selectedFromCode;
        });
        print('Updated selectedFromStation to: $selectedFromStation');
      }
    } catch (e) {
      print('Error in _navigateToFromScreen: $e');
      Get.snackbar(
        'Error',
        'Failed to select departure airport',
        backgroundColor: AppColors.redCA0,
        colorText: AppColors.white,
      );
    }
  }

  Future<void> _navigateToToScreen() async {
    try {
      final result = await Get.to(() => FlightToScreen());
      
      if (result != null && result is Map) {
        setState(() {
          selectedToStation = result['stationName'] ?? result['airportName'];
          selectedToCode = result['stationCode'] ?? result['airportCode'];
          // Also update the controller
          var params = flightController.getLastSearchParams();
          params['toAirport'] = selectedToCode;
        });
      }
    } catch (e) {
      print('Error in _navigateToToScreen: $e');
      Get.snackbar(
        'Error',
        'Failed to select arrival airport',
        backgroundColor: AppColors.redCA0,
        colorText: AppColors.white,
      );
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


  bool get _isFormValid {
    if (selectedFromStation == null || selectedFromCode == null) return false;
    if (selectedToStation == null || selectedToCode == null) return false;
    if (selectedFromCode == selectedToCode) return false;
    if (returnDate == null) return false;
    if (!returnDate!.isAfter(selectedDate)) return false;
    return true;
  }

  void _selectTravelersAndClass() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return TravelClassAndTravelerSelector(
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
        );
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    String formattedDepartureDate = DateFormat('dd MMM').format(selectedDate);
    String formattedReturnDate = returnDate != null
        ? DateFormat('dd MMM').format(returnDate!)
        : 'Select Return Date';
    String dayOfWeekDeparture = DateFormat('EEEE').format(selectedDate);
    String dayOfWeekReturn =
        returnDate != null ? DateFormat('EEEE').format(returnDate!) : '';
        
    return ScrollConfiguration(
      behavior: MyBehavior(),
      child: SingleChildScrollView(
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Theme.of(context).brightness == Brightness.dark
                    ? AppColors.grey363
                    : AppColors.whiteF2F,
                Theme.of(context).scaffoldBackgroundColor,
              ],
            ),
          ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
              const SizedBox(height: 20),
              
              // Modern Flight Search Card
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Theme.of(context).brightness == Brightness.dark
                          ? Colors.black.withOpacity(0.4)
                          : Theme.of(context).shadowColor.withOpacity(0.1),
                      blurRadius: Theme.of(context).brightness == Brightness.dark ? 16 : 20,
                      offset: const Offset(0, 8),
                      spreadRadius: 0,
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header with round trip icon
                    ConstrainedBox(
                      constraints: BoxConstraints(
                        maxWidth: MediaQuery.of(context).size.width - 88, // Account for padding and icon
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: AppColors.blue1F9.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(
                              Icons.compare_arrows,
                              color: AppColors.blue1F9,
                              size: 24,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Flexible(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Round Trip Flight',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w700,
                                    color: Theme.of(context).textTheme.bodyLarge?.color,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  'Book your departure & return journey',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Theme.of(context).textTheme.bodyMedium?.color,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 32),
                    
                    // From and To Selection with modern design
                    _buildModernRouteSelector(context),
                    
                    const SizedBox(height: 24),
                    
                    // Date Selection with modern design (both departure and return)
                    _buildModernDateSelectors(context, formattedDepartureDate, dayOfWeekDeparture, formattedReturnDate, dayOfWeekReturn),
                    
                    const SizedBox(height: 24),
                    
                    // Travelers & Class with modern design
                    _buildModernTravelersSelector(context),
                    
                    const SizedBox(height: 32),
                    
                    // Modern Search Button
                    _buildModernSearchButton(context),
                  ],
                ),
              ),
              
              const SizedBox(height: 32),
              
              // Special Fares Section with modern design
              _buildModernSpecialFares(context),
              
              const SizedBox(height: 32),
              
              // Modern Offers Section
              _buildModernOffersSection(context),
              
              const SizedBox(height: 24),
              
              // Modern Fare Calendar Section
              _buildModernFareCalendar(context),
              
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _buildModernRouteSelector(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.dark
            ? AppColors.grey363.withOpacity(0.3)
            : AppColors.greyEEE.withOpacity(0.5),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          // From Section
          GestureDetector(
            onTap: _navigateToFromScreen,
            child: Container(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.blue1F9.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      Icons.flight_takeoff,
                      color: AppColors.blue1F9,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'From',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: Theme.of(context).textTheme.bodyMedium?.color,
                            letterSpacing: 0.5,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          selectedFromStation ?? 'Select departure city',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: selectedFromStation != null 
                                ? Theme.of(context).textTheme.bodyLarge?.color
                                : Theme.of(context).hintColor,
                          ),
                        ),
                        if (selectedFromCode != null)
                          Text(
                            selectedFromCode!,
                            style: TextStyle(
                              fontSize: 12,
                              color: Theme.of(context).textTheme.bodyMedium?.color,
                            ),
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    Icons.chevron_right,
                    color: Theme.of(context).textTheme.bodyMedium?.color,
                  ),
                ],
              ),
            ),
          ),
          
          // Divider with swap button
          Stack(
            alignment: Alignment.center,
            children: [
              Container(
                height: 1,
                margin: const EdgeInsets.symmetric(horizontal: 20),
                color: Theme.of(context).dividerColor,
              ),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: Theme.of(context).dividerColor,
                    width: 1,
                  ),
                ),
                    child: GestureDetector(
                      onTap: () {
                    // Swap from and to
                        setState(() {
                      final tempStation = selectedFromStation;
                      final tempCode = selectedFromCode;
                      selectedFromStation = selectedToStation;
                      selectedFromCode = selectedToCode;
                      selectedToStation = tempStation;
                      selectedToCode = tempCode;
                        });
                      },
                  child: Icon(
                    Icons.swap_vert,
                    color: AppColors.redCA0,
                    size: 20,
                  ),
                ),
              ),
            ],
          ),
          
          // To Section
          GestureDetector(
            onTap: _navigateToToScreen,
                      child: Container(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                      color: AppColors.green00A.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      Icons.flight_land,
                      color: AppColors.green00A,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'To',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: Theme.of(context).textTheme.bodyMedium?.color,
                            letterSpacing: 0.5,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          selectedToStation ?? 'Select destination city',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: selectedToStation != null 
                                ? Theme.of(context).textTheme.bodyLarge?.color
                                : Theme.of(context).hintColor,
                          ),
                        ),
                        if (selectedToCode != null)
                          Text(
                            selectedToCode!,
                            style: TextStyle(
                              fontSize: 12,
                              color: Theme.of(context).textTheme.bodyMedium?.color,
                            ),
                          ),
                      ],
                    ),
                  ),
                  Icon(
                    Icons.chevron_right,
                    color: Theme.of(context).textTheme.bodyMedium?.color,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildModernDateSelectors(BuildContext context, String formattedDepartureDate, String dayOfWeekDeparture, String formattedReturnDate, String dayOfWeekReturn) {
    return Column(
      children: [
        // Departure Date
        GestureDetector(
          onTap: () => _selectDate(context),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Theme.of(context).brightness == Brightness.dark
                  ? AppColors.grey363.withOpacity(0.3)
                  : AppColors.greyEEE.withOpacity(0.5),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.orangeFFB.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.calendar_today,
                    color: AppColors.orangeEB9,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Departure Date',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: Theme.of(context).textTheme.bodyMedium?.color,
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        formattedDepartureDate,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Theme.of(context).textTheme.bodyLarge?.color,
                        ),
                      ),
                      Text(
                        dayOfWeekDeparture,
                        style: TextStyle(
                          fontSize: 12,
                          color: Theme.of(context).textTheme.bodyMedium?.color,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.chevron_right,
                  color: Theme.of(context).textTheme.bodyMedium?.color,
                ),
              ],
            ),
          ),
        ),
        
        const SizedBox(height: 16),
        
        // Return Date
        GestureDetector(
          onTap: () => _selectDate(context, isReturnDate: true),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Theme.of(context).brightness == Brightness.dark
                  ? AppColors.grey363.withOpacity(0.3)
                  : AppColors.greyEEE.withOpacity(0.5),
              borderRadius: BorderRadius.circular(16),
              border: returnDate == null 
                  ? Border.all(
                      color: AppColors.redCA0.withOpacity(0.3),
                      width: 1.5,
                    )
                  : null,
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.blue1F9.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.event_available,
                    color: AppColors.blue1F9,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            'Return Date',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: Theme.of(context).textTheme.bodyMedium?.color,
                              letterSpacing: 0.5,
                            ),
                          ),
                          if (returnDate == null) ...[
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color: AppColors.redCA0.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                'Required',
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.redCA0,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        formattedReturnDate,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: returnDate != null 
                              ? Theme.of(context).textTheme.bodyLarge?.color
                              : Theme.of(context).hintColor,
                        ),
                      ),
                      if (returnDate != null)
                        Text(
                          dayOfWeekReturn,
                          style: TextStyle(
                            fontSize: 12,
                            color: Theme.of(context).textTheme.bodyMedium?.color,
                          ),
                        ),
                    ],
                  ),
                ),
                Icon(
                  Icons.chevron_right,
                  color: Theme.of(context).textTheme.bodyMedium?.color,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
  
  Widget _buildModernTravelersSelector(BuildContext context) {
    return GestureDetector(
      onTap: _selectTravelersAndClass,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Theme.of(context).brightness == Brightness.dark
              ? AppColors.grey363.withOpacity(0.3)
              : AppColors.greyEEE.withOpacity(0.5),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.redCA0.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                Icons.people,
                color: AppColors.redCA0,
                size: 20,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Travelers & Class',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Theme.of(context).textTheme.bodyMedium?.color,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '$travelers Traveler${travelers > 1 ? 's' : ''}',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).textTheme.bodyLarge?.color,
                    ),
                  ),
                  Text(
                    travelClass,
                    style: TextStyle(
                      fontSize: 12,
                      color: Theme.of(context).textTheme.bodyMedium?.color,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right,
              color: Theme.of(context).textTheme.bodyMedium?.color,
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildModernSearchButton(BuildContext context) {
    return Obx(() {
      final FlightController flightController = Get.find<FlightController>();
      final bool isFormComplete = _isFormValid;
      
      return Container(
        width: double.infinity,
        height: 56,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: isFormComplete 
              ? LinearGradient(
                  colors: [AppColors.redCA0, AppColors.redCA0.withOpacity(0.8)],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                )
              : LinearGradient(
                  colors: [AppColors.greyB9B, AppColors.greyB9B.withOpacity(0.8)],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
          boxShadow: isFormComplete ? [
            BoxShadow(
              color: AppColors.redCA0.withOpacity(0.3),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ] : [],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: isFormComplete ? () async {
              if (selectedFromStation == null || selectedToStation == null) {
                      Get.snackbar(
                  'Missing Information',
                        'Please select both departure and arrival airports',
                        backgroundColor: AppColors.redCA0,
                  colorText: Colors.white,
                  icon: const Icon(Icons.info_outline, color: Colors.white),
                  snackPosition: SnackPosition.TOP,
                );
                return;
              }
              
              if (returnDate == null) {
                Get.snackbar(
                  'Missing Return Date',
                  'Please select your return date',
                  backgroundColor: AppColors.redCA0,
                  colorText: Colors.white,
                  icon: const Icon(Icons.calendar_today, color: Colors.white),
                  snackPosition: SnackPosition.TOP,
                      );
                      return;
                    }

                    try {
                final String formattedDepartDate = DateFormat('yyyy-MM-dd').format(selectedDate);
                final String formattedReturnDate = DateFormat('yyyy-MM-dd').format(returnDate!);

                      await flightController.searchAndShowFlights(
                        fromAirportCode: selectedFromCode!,
                        toAirportCode: selectedToCode!,
                  departDate: formattedDepartDate,
                  returnDate: formattedReturnDate,
                        adults: travelers,
                  travelClass: travelClass == 'Economy' ? 'E' : travelClass == 'Business' ? 'B' : 'F',
                  flightType: 'R',
                );
                    } catch (e) {
                      Get.snackbar(
                  'searchError'.tr,
                        '${'failedToSearchFlights'.tr}: ${e.toString()}',
                        backgroundColor: AppColors.redCA0,
                  colorText: Colors.white,
                  icon: const Icon(Icons.error_outline, color: Colors.white),
                  snackPosition: SnackPosition.TOP,
                      );
                    }
            } : null,
            child: Center(
                  child: flightController.isLoading.value
                      ? LoadingAnimationWidget.threeRotatingDots(
                          color: AppColors.white,
                          size: 24,
                        )
                  : Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.search,
                          color: isFormComplete ? AppColors.white : AppColors.grey717,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'searchRoundTripFlights'.tr,
                          style: TextStyle(
                            color: isFormComplete ? AppColors.white : AppColors.grey717,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ],
                    ),
            ),
                          ),
                        ),
                );
    });
  }
  
  Widget _buildModernSpecialFares(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            'Special Fares',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: Theme.of(context).textTheme.bodyLarge?.color,
            ),
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 50,
          child: ScrollConfiguration(
            behavior: MyBehavior(),
            child: ListView.builder(
              itemCount: Lists.flightSearchList2.length,
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemBuilder: (BuildContext context, int index) => Padding(
                padding: const EdgeInsets.only(right: 12),
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedFareIndex = selectedFareIndex == index ? null : index;
                    });
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                      color: selectedFareIndex == index
                          ? AppColors.redCA0
                          : Theme.of(context).cardColor,
                      border: Border.all(
                        color: selectedFareIndex == index
                            ? AppColors.redCA0
                            : Theme.of(context).dividerColor,
                        width: 1.5,
                      ),
                      boxShadow: selectedFareIndex == index
                          ? [
                              BoxShadow(
                                color: AppColors.redCA0.withOpacity(0.3),
                                blurRadius: 8,
                                offset: const Offset(0, 4),
                              ),
                            ]
                          : [],
                    ),
                    child: Text(
                      Lists.flightSearchList2[index],
                      style: TextStyle(
                        color: selectedFareIndex == index
                            ? AppColors.white
                            : Theme.of(context).textTheme.bodyMedium?.color,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
  
  Widget _buildModernOffersSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
            Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
              Text(
                'Special Offers',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Theme.of(context).textTheme.bodyLarge?.color,
                ),
              ),
              GestureDetector(
                onTap: () => Get.to(() => OfferMakeYourTripScreen()),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppColors.redCA0.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'View All',
                        style: TextStyle(
                          color: AppColors.redCA0,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Icon(
                        Icons.arrow_forward_ios,
                        color: AppColors.redCA0,
                        size: 14,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 20),
          height: 180,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
                child: CarouselSlider.builder(
                  itemCount: 4,
                  itemBuilder: (context, index, realIndex) => Container(
                    width: Get.width,
                    decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Theme.of(context).shadowColor.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Stack(
                    children: [
                      Image.asset(
                        flightSearchImage,
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: double.infinity,
                      ),
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              Colors.black.withOpacity(0.3),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                  ),
                  options: CarouselOptions(
                      autoPlay: true,
                height: 180,
                viewportFraction: 0.9,
                      enableInfiniteScroll: true,
                      enlargeCenterPage: true,
                autoPlayInterval: const Duration(seconds: 4),
              ),
            ),
          ),
        ),
      ],
    );
  }
  
  Widget _buildModernFareCalendar(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.redF9E,
            AppColors.redF9E.withOpacity(0.7),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
            Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              Icons.calendar_month,
              color: AppColors.redCA0,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                Text(
                  'Find Better Round Trip Deals',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                      color: AppColors.black2E2,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Explore flexible dates for round trip savings',
                  style: TextStyle(
                          fontSize: 14,
                    color: AppColors.grey717,
                        ),
                    ),
                  ],
                ),
              ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.redCA0,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Explore',
                  style: TextStyle(
                    color: AppColors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(width: 4),
                Icon(
                  Icons.arrow_forward,
                  color: AppColors.white,
                  size: 16,
            ),
          ],
        ),
          ),
        ],
      ),
    );
  }
}
