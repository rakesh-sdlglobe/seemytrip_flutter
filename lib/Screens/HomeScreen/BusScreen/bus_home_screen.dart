import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:seemytrip/Constants/colors.dart';
import 'package:seemytrip/Constants/images.dart';
import 'package:seemytrip/Screens/HomeScreen/BusScreen/bus_leaving_from_screen.dart';
import 'package:seemytrip/Screens/HomeScreen/BusScreen/bus_result_screen.dart';
import 'package:seemytrip/Screens/HomeScreen/BusScreen/bus_going_to_screen.dart';
// import 'package:seemytrip/Screens/Utills/common_button_widget.dart';
import 'package:seemytrip/Screens/Utills/common_text_widget.dart';
// import 'package:seemytrip/Screens/Utills/date_picker_widget.dart';
import 'package:seemytrip/Screens/Utills/lists_widget.dart' as lists_widget;

class BusHomeScreen extends StatefulWidget {
  const BusHomeScreen({Key? key}) : super(key: key);

  @override
  State<BusHomeScreen> createState() => _BusHomeScreenState();
}

class _BusHomeScreenState extends State<BusHomeScreen> {
  int selectedDateIndex = 0;
  int selectedBottomNavIndex = 0;

  final List<Map<String, dynamic>> dates = [
    {'day': '08', 'weekday': 'TUE'},
    {'day': '09', 'weekday': 'WED'},
    {'day': '10', 'weekday': 'THU'},
    {'day': '11', 'weekday': 'FRI'},
    {'day': '12', 'weekday': 'SAT'},
  ];

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
                            Container(
                              height: 40,
                              child: TextField(
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: 'Enter departure city',
                                  hintStyle: TextStyle(
                                    color: Colors.red[200],
                                    fontSize: 16,
                                  ),
                                ),
                                style: TextStyle(fontSize: 16, color: black2E2),
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
                            Container(
                              height: 40,
                              child: TextField(
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: 'Enter destination city',
                                  hintStyle: TextStyle(
                                    color: Colors.red[200],
                                    fontSize: 16,
                                  ),
                                ),
                                style: TextStyle(fontSize: 16, color: black2E2),
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
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: 80,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: dates.length,
                            itemBuilder: (context, index) {
                              bool isSelected = selectedDateIndex == index;
                              return GestureDetector(
                                onTap: () {
                                  setState(() {
                                    selectedDateIndex = index;
                                  });
                                },
                                child: Container(
                                  width: 60,
                                  margin: EdgeInsets.only(right: 12),
                                  decoration: BoxDecoration(
                                    color: isSelected
                                        ? redCA0
                                        : Colors.transparent,
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: isSelected ? redCA0 : Colors.red[100]!,
                                      width: 1.5,
                                    ),
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        dates[index]['day'],
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
                                        dates[index]['weekday'],
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: isSelected
                                              ? Colors.white
                                              : redCA0,
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
                      ),
                      Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          border: Border.all(color: redCA0),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            Text(
                              'Jul',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: redCA0,
                              ),
                            ),
                            SizedBox(width: 4),
                            Icon(Icons.keyboard_arrow_down, size: 20, color: redCA0),
                            SizedBox(width: 8),
                            Text(
                              '2025',
                              style: TextStyle(
                                fontSize: 14,
                                color: redCA0,
                              ),
                            ),
                          ],
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
                      image: DecorationImage(
                        image:
                            NetworkImage('https://via.placeholder.com/80x80'),
                        fit: BoxFit.cover,
                      ),
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
