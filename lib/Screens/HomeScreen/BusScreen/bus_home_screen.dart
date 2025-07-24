import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:seemytrip/Constants/colors.dart';
import 'package:seemytrip/Controller/bus_controller.dart';
import 'package:seemytrip/Screens/HomeScreen/BusScreen/bus_leaving_from_screen.dart';
import 'package:seemytrip/Screens/HomeScreen/BusScreen/bus_going_to_screen.dart';
import 'package:seemytrip/Screens/HomeScreen/BusScreen/widgets/bus_calendar_widget.dart';

class BusCity {
  final int cityId;
  final String cityName;

  BusCity({required this.cityId, required this.cityName});

  factory BusCity.fromJson(Map<String, dynamic> json) {
    return BusCity(
      cityId: json['CityId'] ?? 0,
      cityName: json['CityName'] ?? '',
    );
  }
}


class BusHomeScreen extends StatefulWidget {
  const BusHomeScreen({Key? key}) : super(key: key);

  @override
  State<BusHomeScreen> createState() => _BusHomeScreenState();
}

class _BusHomeScreenState extends State<BusHomeScreen> {
  int selectedBottomNavIndex = 0;
  
  // Date selection state
  DateTime _selectedDate = DateTime.now();
  bool _showCalendar = false;

  // Generate dates for the next 7 days
  late final List<Map<String, dynamic>> dates;

  @override
  void initState() {
    super.initState();
    dates = List.generate(7, (index) {
      final date = DateTime.now().add(Duration(days: index));
      return {
        'date': date,
        'day': date.day.toString().padLeft(2, '0'),
        'weekday': _getWeekday(date.weekday),
      };
    });
  }

  String _getWeekday(int weekday) {
    switch (weekday) {
      case 1:
        return 'MON';
      case 2:
        return 'TUE';
      case 3:
        return 'WED';
      case 4:
        return 'THU';
      case 5:
        return 'FRI';
      case 6:
        return 'SAT';
      case 7:
        return 'SUN';
      default:
        return '';
    }
  }

  final BusController controller = Get.put(BusController());
  RxString selectedDepartureCity = 'Enter departure city'.obs;
  RxString selectedDestinationCity = 'Enter destination city'.obs;

  // Helper method to get month name
  String _getMonthName(int month) {
    const months = [
      'JAN',
      'FEB',
      'MAR',
      'APR',
      'MAY',
      'JUN',
      'JUL',
      'AUG',
      'SEP',
      'OCT',
      'NOV',
      'DEC'
    ];
    return months[month - 1];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Red theme top banner
            Stack(
              children: [
                Container(
                  height: 155,
                  width: Get.width,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [redCA0, Colors.red.shade100],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: Stack(
                    children: [
                      Positioned(
                        left: 24,
                        top: 48,
                        child: Text(
                          "Book Bus Tickets\nAnywhere, Anytime",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            height: 1.2,
                          ),
                        ),
                      ),
                      Positioned(
                        right: 24,
                        bottom: 0,
                        child: Icon(Icons.directions_bus, color: Colors.white.withOpacity(0.2), size: 90),
                      ),
                    ],
                  ),
                ),
                // Back icon (top left)
                Positioned(
                  top: 32,
                  left: 12,
                  child: InkWell(
                    onTap: () => Get.back(),
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      padding: EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.18),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(Icons.arrow_back, color: Colors.white, size: 22),
                    ),
                  ),
                ),
              ],
            ),
            // Trust indicator
            Container(
              margin: EdgeInsets.all(16),
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.red[50],
                borderRadius: BorderRadius.circular(25),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.verified, color: redCA0, size: 20),
                  SizedBox(width: 8),
                  Text(
                    'Trusted by ',
                    style: TextStyle(
                      color: redCA0,
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    '10 crore+ ',
                    style: TextStyle(
                      color: redCA0,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Indian travellers ',
                    style: TextStyle(
                      color: redCA0,
                      fontSize: 16,
                    ),
                  ),
                  Text('🇮🇳', style: TextStyle(fontSize: 16)),
                ],
              ),
            ),
            // Discount banner
            Container(
              margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: redCA0.withOpacity(0.08),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: redCA0,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.percent, color: Colors.white, size: 22),
                  ),
                  SizedBox(width: 12),
                  Text(
                    'Save upto ₹300* on Bus Bookings',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: redCA0,
                    ),
                  ),
                ],
              ),
            ),
            // Search form
            Container(
              margin: EdgeInsets.all(16),
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.red.withOpacity(0.07),
                    spreadRadius: 1,
                    blurRadius: 10,
                    offset: Offset(0, 2),
                  ),
                ],
                border: Border.all(color: redCA0.withOpacity(0.12), width: 1),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // From field
                  Row(
                    children: [
                      Icon(Icons.navigation, color: redCA0, size: 22),
                      SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Leaving from',
                              style: TextStyle(
                                color: redCA0,
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            SizedBox(height: 4),
                            GestureDetector(
                              onTap: () async {
                                final selectedCity =
                                    await Get.to<Map<String, dynamic>>(
                                        () => const BusLeavingFromScreen());
                                if (selectedCity != null) {
                                  selectedDepartureCity.value =
                                      selectedCity['name'] ?? 'Select city';
                                }
                              },
                              child: Container(
                                height: 40,
                                alignment: Alignment.centerLeft,
                                child: Obx(() => Text(
                                      selectedDepartureCity.value,
                                      style: TextStyle(
                                    fontSize: 16,
                                        color: selectedDepartureCity.value ==
                                                'Enter departure city'
                                            ? Colors.red[200]
                                            : black2E2,
                                  ),
                                    )),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  // Swap button
                  Align(
                    alignment: Alignment.centerRight,
                    child: Container(
                      margin: EdgeInsets.symmetric(vertical: 8),
                      child: CircleAvatar(
                        radius: 20,
                        backgroundColor: redCA0,
                        child: Icon(
                          Icons.swap_vert,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ),
                  ),
                  // To field
                  Row(
                    children: [
                      Icon(Icons.location_on, color: redCA0, size: 22),
                      SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Going To',
                              style: TextStyle(
                                color: redCA0,
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            SizedBox(height: 4),
                            GestureDetector(
                              onTap: () async {
                                final selectedCity =
                                    await Get.to<Map<String, dynamic>>(
                                        () => const BusGoingToScreen());
                                if (selectedCity != null) {
                                  selectedDestinationCity.value =
                                      selectedCity['name'] ?? 'Select city';
                                }
                              },
                              child: Container(
                                height: 40,
                                alignment: Alignment.centerLeft,
                                child: Obx(() => Text(
                                      selectedDestinationCity.value,
                                      style: TextStyle(
                                    fontSize: 16,
                                        color: selectedDestinationCity.value ==
                                                'Enter destination city'
                                            ? Colors.red[200]
                                            : black2E2,
                                  ),
                                    )),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  // Departure section
                  Text(
                    'Departure',
                    style: TextStyle(
                      color: redCA0,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 12),
                  // Date selector
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Date chips
                      SizedBox(
                        height: 80,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: dates.length,
                          itemBuilder: (context, index) {
                            final date = dates[index];
                            final isSelected =
                                _selectedDate.day == date['date'].day &&
                                    _selectedDate.month == date['date'].month &&
                                    _selectedDate.year == date['date'].year;

                            return GestureDetector(
                              onTap: () {
                                setState(() {
                                  _selectedDate = date['date'];
                                  _showCalendar = false;
                                });
                              },
                              child: Container(
                                width: 60,
                                margin: EdgeInsets.only(right: 12),
                                decoration: BoxDecoration(
                                  color:
                                      isSelected ? redCA0 : Colors.transparent,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color:
                                        isSelected ? redCA0 : Colors.red[100]!,
                                    width: 1.5,
                                  ),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      date['day'],
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: isSelected
                                            ? Colors.white
                                            : black2E2,
                                      ),
                                    ),
                                    SizedBox(height: 4),
                                    Text(
                                      date['weekday'],
                                      style: TextStyle(
                                        fontSize: 12,
                                        color:
                                            isSelected ? Colors.white : redCA0,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      
                      // Calendar toggle button
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _showCalendar = !_showCalendar;
                          });
                        },
                        child: Container(
                          width: 160,
                          padding:
                              EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          margin: EdgeInsets.only(top: 8),
                          decoration: BoxDecoration(
                            border: Border.all(color: redCA0),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                '${_getMonthName(_selectedDate.month)} ${_selectedDate.year}',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: redCA0,
                                ),
                              ),
                              SizedBox(width: 4),
                              Icon(
                                  _showCalendar
                                      ? Icons.keyboard_arrow_up
                                      : Icons.keyboard_arrow_down,
                                  size: 20,
                                  color: redCA0),
                            ],
                          ),
                        ),
                      ),
                      
                      // Calendar widget
                      if (_showCalendar)
                        Padding(
                          padding: const EdgeInsets.only(top: 16.0),
                          child: BusCalendarWidget(
                            selectedDate: _selectedDate,
                            onDateSelected: (date) {
                              setState(() {
                                _selectedDate = date;
                                _showCalendar = false;
                              });
                            },
                          ),
                        ),
                    ],
                  ),
                  SizedBox(height: 24),
                  // Search button
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: redCA0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        'SEARCH BUSES',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Promotional section
            Container(
              margin: EdgeInsets.all(16),
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [redCA0.withOpacity(0.08), Colors.red[50]!],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: Colors.red[100], // Light red background color
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Save up to',
                          style: TextStyle(
                            fontSize: 16,
                            color: redCA0,
                          ),
                        ),
                        Text(
                          '₹300*',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: redCA0,
                          ),
                        ),
                        Text(
                          'on your Bus Booking',
                          style: TextStyle(
                            fontSize: 14,
                            color: redCA0,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          border: Border.all(color: redCA0, width: 2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          'IX300',
                          style: TextStyle(
                            color: redCA0,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      SizedBox(height: 8),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: redCA0,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          'Copy',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // Special Offers section
            Container(
              margin: EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Special Offers',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: redCA0,
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      border: Border.all(color: redCA0),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      'View All',
                      style: TextStyle(
                        color: redCA0,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        margin: EdgeInsets.all(16),
        padding: EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(25),
          boxShadow: [
            BoxShadow(
              color: redCA0.withOpacity(0.13),
              spreadRadius: 1,
              blurRadius: 10,
              offset: Offset(0, -2),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildBottomNavItem(Icons.luggage, 'Bookings', 0),
            _buildBottomNavItem(Icons.account_balance_wallet, 'Cash', 1),
            _buildBottomNavItem(Icons.headset_mic, 'Help', 2),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomNavItem(IconData icon, String label, int index) {
    bool isSelected = selectedBottomNavIndex == index;
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedBottomNavIndex = index;
        });
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: isSelected ? redCA0 : Colors.grey[600],
            size: 24,
          ),
          SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: isSelected ? redCA0 : Colors.grey[600],
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
