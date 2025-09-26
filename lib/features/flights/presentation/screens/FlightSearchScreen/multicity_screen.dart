import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:seemytrip/core/theme/app_colors.dart';
import 'package:seemytrip/shared/constants/images.dart';
import 'package:seemytrip/features/flights/presentation/screens/FlightSearchScreen/offer_make_your_trip_screen.dart';
import 'package:seemytrip/features/flights/presentation/screens/flight_book_screen.dart';
import 'package:seemytrip/core/widgets/lists_widget.dart';
import 'package:seemytrip/main.dart';

class MulticityScreen extends StatefulWidget {
  MulticityScreen({Key? key}) : super(key: key);

  @override
  State<MulticityScreen> createState() => _MulticityScreenState();
}

class _MulticityScreenState extends State<MulticityScreen> {
  int? selectedFareIndex;
  String travelClass = 'Economy';
  int travelers = 1;
  
  // Multi-city flight segments
  List<FlightSegment> flightSegments = [
    FlightSegment(),
    FlightSegment(),
  ];

  void _addFlightSegment() {
    if (flightSegments.length < 6) {
      setState(() {
        flightSegments.add(FlightSegment());
      });
    }
  }

  void _removeFlightSegment(int index) {
    if (flightSegments.length > 2) {
      setState(() {
        flightSegments.removeAt(index);
      });
    }
  }

  void _selectTravelersAndClass() {
    // Implementation for travelers and class selection dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Select Travelers & Class'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('This would show travelers and class selection'),
              SizedBox(height: 20),
              Text('Current: $travelers travelers, $travelClass class'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
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
              
              // Modern Multi-City Flight Search Card
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Theme.of(context).shadowColor.withOpacity(0.1),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                      spreadRadius: 0,
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header with multi-city icon
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: AppColors.orangeEB9.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            Icons.connecting_airports,
                            color: AppColors.orangeEB9,
                            size: 24,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Multi-City Flight',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w700,
                                  color: Theme.of(context).textTheme.bodyLarge?.color,
                                ),
                              ),
                              Text(
                                'Plan your journey with multiple stops',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Theme.of(context).textTheme.bodyMedium?.color,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),
                    
                    // Flight Segments
                    _buildFlightSegments(context),
                    
                    const SizedBox(height: 24),
                    
                    // Add Flight Segment Button
                    if (flightSegments.length < 6)
                      _buildAddFlightButton(context),
                    
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
  
  Widget _buildFlightSegments(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Flight Segments',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Theme.of(context).textTheme.bodyLarge?.color,
          ),
        ),
        const SizedBox(height: 16),
        ...flightSegments.asMap().entries.map((entry) {
          int index = entry.key;
          FlightSegment segment = entry.value;
          return Column(
            children: [
              _buildFlightSegmentCard(context, segment, index),
              if (index < flightSegments.length - 1) const SizedBox(height: 16),
            ],
          );
        }).toList(),
      ],
    );
  }
  
  Widget _buildFlightSegmentCard(BuildContext context, FlightSegment segment, int index) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.dark
            ? AppColors.grey363.withOpacity(0.3)
            : AppColors.greyEEE.withOpacity(0.5),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.orangeEB9.withOpacity(0.3),
          width: 1.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Segment header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.orangeEB9.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  'Flight ${index + 1}',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.orangeEB9,
                  ),
                ),
              ),
              if (flightSegments.length > 2)
                GestureDetector(
                  onTap: () => _removeFlightSegment(index),
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: AppColors.redCA0.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      Icons.close,
                      color: AppColors.redCA0,
                      size: 16,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 16),
          
          // From and To
          Row(
            children: [
              // From
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    // Navigate to from selection
                  },
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: Theme.of(context).dividerColor,
                        width: 1,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.flight_takeoff,
                              color: AppColors.blue1F9,
                              size: 16,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'From',
                              style: TextStyle(
                                fontSize: 12,
                                color: Theme.of(context).textTheme.bodyMedium?.color,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          segment.fromCity ?? 'Select city',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: segment.fromCity != null 
                                ? Theme.of(context).textTheme.bodyLarge?.color
                                : Theme.of(context).hintColor,
                          ),
                        ),
                        if (segment.fromCode != null)
                          Text(
                            segment.fromCode!,
                            style: TextStyle(
                              fontSize: 12,
                              color: Theme.of(context).textTheme.bodyMedium?.color,
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
              
              const SizedBox(width: 16),
              
              // To
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    // Navigate to to selection
                  },
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: Theme.of(context).dividerColor,
                        width: 1,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.flight_land,
                              color: AppColors.green00A,
                              size: 16,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'To',
                              style: TextStyle(
                                fontSize: 12,
                                color: Theme.of(context).textTheme.bodyMedium?.color,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          segment.toCity ?? 'Select city',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: segment.toCity != null 
                                ? Theme.of(context).textTheme.bodyLarge?.color
                                : Theme.of(context).hintColor,
                          ),
                        ),
                        if (segment.toCode != null)
                          Text(
                            segment.toCode!,
                            style: TextStyle(
                              fontSize: 12,
                              color: Theme.of(context).textTheme.bodyMedium?.color,
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 16),
          
          // Date
          GestureDetector(
            onTap: () {
              // Navigate to date selection
            },
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Theme.of(context).dividerColor,
                  width: 1,
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.calendar_today,
                    color: AppColors.orangeEB9,
                    size: 16,
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Departure Date',
                        style: TextStyle(
                          fontSize: 12,
                          color: Theme.of(context).textTheme.bodyMedium?.color,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        segment.departureDate ?? 'Select date',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: segment.departureDate != null 
                              ? Theme.of(context).textTheme.bodyLarge?.color
                              : Theme.of(context).hintColor,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
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
  
  Widget _buildAddFlightButton(BuildContext context) {
    return GestureDetector(
      onTap: _addFlightSegment,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.orangeEB9.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: AppColors.orangeEB9.withOpacity(0.3),
            width: 1.5,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.add,
              color: AppColors.orangeEB9,
              size: 20,
            ),
            const SizedBox(width: 8),
            Text(
              'Add Another Flight',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColors.orangeEB9,
              ),
            ),
          ],
        ),
      ),
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
    return Container(
      width: double.infinity,
      height: 56,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: LinearGradient(
          colors: [AppColors.redCA0, AppColors.redCA0.withOpacity(0.8)],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.redCA0.withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {
            Get.to(() => FlightBookScreen());
          },
          child: Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.search,
                  color: AppColors.white,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  'Search Multi-City Flights',
                  style: TextStyle(
                    color: AppColors.white,
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
                  'Find Multi-City Deals',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.black2E2,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Explore flexible dates for complex itineraries',
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

class FlightSegment {
  String? fromCity;
  String? fromCode;
  String? toCity;
  String? toCode;
  String? departureDate;
  
  FlightSegment({
    this.fromCity,
    this.fromCode,
    this.toCity,
    this.toCode,
    this.departureDate,
  });
}