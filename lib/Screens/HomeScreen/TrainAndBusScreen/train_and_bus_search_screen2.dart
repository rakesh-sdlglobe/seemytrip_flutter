import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:seemytrip/Constants/colors.dart';
import 'package:seemytrip/Constants/font_family.dart';
import 'package:seemytrip/Controller/travellerDetailController.dart';
import 'package:seemytrip/Screens/HomeScreen/TrainAndBusScreen/review_booking_screen.dart';
import 'package:seemytrip/Screens/HomeScreen/TrainAndBusScreen/train_and_bus_contact_information_screen.dart';
import 'package:seemytrip/Screens/HomeScreen/TrainAndBusScreen/train_and_bus_contact_information_screen_password.dart';
import 'package:seemytrip/Screens/HomeScreen/TrainAndBusScreen/train_and_bus_contact_information_screen_username.dart';
import 'package:seemytrip/Screens/HomeScreen/TrainAndBusScreen/traveller_detail_screen.dart';
import 'package:seemytrip/components/irctcs_webview.dart';

class TrainAndBusSearchScreen2 extends StatefulWidget {
  final String? trainName;
  final String? trainNumber;
  final String? startStation;
  final String? endStation;
  final String fromStation;
  final String toStation;
  final String? seatClass;
  final double? price;
  final String? duration;
  final String? departureTime;
  final String? arrivalTime;
  final String? departure;
  final String? arrival;

  TrainAndBusSearchScreen2({
    Key? key,
    required this.trainName,
    required this.trainNumber,
    required this.startStation,
    required this.endStation,
    required this.fromStation,
    required this.toStation,
    required this.seatClass,
    required this.price,
    required this.duration,
    required this.departureTime,
    required this.arrivalTime,
    required this.departure,
    required this.arrival,
  }) : super(key: key);

  @override
  State<TrainAndBusSearchScreen2> createState() =>
      _TrainAndBusSearchScreen2State();
}

class _TrainAndBusSearchScreen2State extends State<TrainAndBusSearchScreen2>
    with SingleTickerProviderStateMixin {
  final TravellerDetailController travellerDetailController =
      Get.put(TravellerDetailController());
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController promoCodeController = TextEditingController();
  String irctcUsername = '';
  List<String> selectedTravellers = [];
  late final AnimationController _animationController;
  late final Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    emailController.dispose();
    phoneController.dispose();
    promoCodeController.dispose();
    super.dispose();
  }

  String formatTime(String time) {
    final DateFormat inputFormat = DateFormat("HH:mm");
    final DateFormat outputFormat = DateFormat("hh:mm a");
    final DateTime parsedTime = inputFormat.parse(time);
    return outputFormat.format(parsedTime);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
        ),
        child: Stack(
          children: [
            _buildBody(),
            _buildBottomBar(),
          ],
        ),
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: redCA0,
      foregroundColor: Colors.white,
      elevation: 0,
      // leading: IconButton(
      //   icon: Icon(Icons.arrow_back_ios, color: Colors.white, size: 24),
      //   onPressed: () => Get.back(),
      // ),
      title: Text(
        "Train Booking",
        style: TextStyle(
          fontFamily: FontFamily.PoppinsBold,
          fontSize: 22,
          color: Colors.white,
          shadows: [
            Shadow(color: Colors.black26, blurRadius: 4, offset: Offset(0, 2))
          ],
        ),
      ),
      centerTitle: true,
    );
  }

  Widget _buildBody() {
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          backgroundColor: redCA0,
          elevation: 0,
          pinned: true,
          flexibleSpace: _buildAppBar(),
        ),
        SliverToBoxAdapter(child: SizedBox(height: 16)),
        SliverToBoxAdapter(child: _buildTrainInfoCard()),
        SliverToBoxAdapter(child: SizedBox(height: 16)),
        SliverToBoxAdapter(child: _buildIRCTCCard()),
        SliverToBoxAdapter(child: SizedBox(height: 16)),
        SliverToBoxAdapter(child: _buildTravellerDetailsCard()),
        SliverToBoxAdapter(child: SizedBox(height: 16)),
        SliverToBoxAdapter(child: _buildContactDetailsCard()),
        SliverToBoxAdapter(child: SizedBox(height: 16)),
        SliverToBoxAdapter(child: _buildOffersCard()),
        SliverToBoxAdapter(child: SizedBox(height: 100)),
      ],
    );
  }

  Widget _buildTrainInfoCard() {
    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      margin: EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
              color: Colors.black12, blurRadius: 10, offset: Offset(0, 4)),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.trainName ?? 'Unknown Train',
                  style: TextStyle(
                    fontFamily: FontFamily.PoppinsBold,
                    fontSize: 18,
                    color: black2E2,
                  ),
                ),
                Text(
                  "#${widget.trainNumber ?? '0000'}",
                  style: TextStyle(
                    fontFamily: FontFamily.PoppinsMedium,
                    fontSize: 14,
                    color: greyB8B,
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildScheduleColumn(
                    formatTime(widget.departureTime ?? '00:00'),
                    widget.departure ?? ''),
                _buildDuration(),
                _buildScheduleColumn(formatTime(widget.arrivalTime ?? '00:00'),
                    widget.arrival ?? ''),
              ],
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.fromStation,
                  style: TextStyle(
                    fontFamily: FontFamily.PoppinsMedium,
                    fontSize: 14,
                    color: grey717,
                  ),
                ),
                Text(
                  widget.toStation,
                  style: TextStyle(
                    fontFamily: FontFamily.PoppinsMedium,
                    fontSize: 14,
                    color: grey717,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildScheduleColumn(String time, String date) {
    return Column(
      children: [
        Text(
          time,
          style: TextStyle(
            fontFamily: FontFamily.PoppinsBold,
            fontSize: 18,
            color: black2E2,
          ),
        ),
        SizedBox(height: 4),
        Text(
          date,
          style: TextStyle(
            fontFamily: FontFamily.PoppinsRegular,
            fontSize: 12,
            color: greyB8B,
          ),
        ),
      ],
    );
  }

  Widget _buildDuration() {
    return Row(
      children: [
        Container(
          height: 2,
          width: 50,
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: [redCA0, Colors.orangeAccent]),
          ),
        ),
        SizedBox(width: 12),
        Text(
          widget.duration ?? '',
          style: TextStyle(
            fontFamily: FontFamily.PoppinsMedium,
            fontSize: 14,
            color: grey717,
          ),
        ),
        SizedBox(width: 12),
        Container(
          height: 2,
          width: 50,
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: [Colors.orangeAccent, redCA0]),
          ),
        ),
      ],
    );
  }

  Widget _buildIRCTCCard() {
    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      margin: EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
              color: Colors.black12, blurRadius: 10, offset: Offset(0, 4)),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "IRCTC Username",
              style: TextStyle(
                fontFamily: FontFamily.PoppinsBold,
                fontSize: 18,
                color: black2E2,
              ),
            ),
            SizedBox(height: 12),
            InkWell(
              onTap: () async {
                final result = await Get.bottomSheet(
                  TrainAndBusContactInformationScreen(),
                  backgroundColor: Colors.transparent,
                  isScrollControlled: true,
                );
                if (result != null) {
                  setState(() {
                    irctcUsername = result;
                  });
                }
              },
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.grey[200]!.withOpacity(0.8),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey[300]!),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      irctcUsername.isEmpty
                          ? "Enter IRCTC Username"
                          : irctcUsername,
                      style: TextStyle(
                        fontFamily: FontFamily.PoppinsMedium,
                        fontSize: 14,
                        color: irctcUsername.isEmpty ? grey888 : black2E2,
                      ),
                    ),
                    Icon(Icons.arrow_forward_ios, color: redCA0, size: 18),
                  ],
                ),
              ),
            ),
            SizedBox(height: 12),
            _buildIRCTCOptions(),
          ],
        ),
      ),
    );
  }

  Widget _buildIRCTCOptions() {
    final options = [
      {
        'title': 'Create New IRCTC Account',
        'subtitle': 'Register for a new IRCTC account',
        'icon': Icons.person_add_alt_1_rounded,
        'onTap': () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => IRCTCWebView()),
            ),
      },
      {
        'title': 'Forgot Username',
        'subtitle': 'Recover your IRCTC username',
        'icon': Icons.person_search_rounded,
        'onTap': () => Get.bottomSheet(
              ForgotIRCTCUsernameScreen(),
              isScrollControlled: true,
              backgroundColor: Colors.transparent,
            ),
      },
      {
        'title': 'Forgot Password',
        'subtitle': 'Reset your IRCTC password',
        'icon': Icons.lock_reset_rounded,
        'onTap': () => Get.bottomSheet(
              ForgotIRCTCPasswordScreen(username: irctcUsername),
              isScrollControlled: true,
              backgroundColor: Colors.transparent,
            ),
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4.0, bottom: 12),
          child: Text(
            'Need Help?',
            style: TextStyle(
              fontFamily: FontFamily.PoppinsSemiBold,
              fontSize: 16,
              color: Colors.grey[700],
            ),
          ),
        ),
        ...List.generate(
          options.length,
          (index) => _buildOptionCard(
            title: options[index]['title'] as String,
            subtitle: options[index]['subtitle'] as String,
            icon: options[index]['icon'] as IconData,
            onTap: options[index]['onTap'] as VoidCallback,
            isLast: index == options.length - 1,
          ),
        ),
      ],
    );
  }

  Widget _buildOptionCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required VoidCallback onTap,
    bool isLast = false,
  }) {
    return Padding(
      padding: EdgeInsets.only(bottom: isLast ? 0 : 12),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Ink(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey[200]!),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: redCA0.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    icon,
                    color: redCA0,
                    size: 22,
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
                          fontFamily: FontFamily.PoppinsSemiBold,
                          fontSize: 15,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: TextStyle(
                          fontFamily: FontFamily.PoppinsRegular,
                          fontSize: 13,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 16,
                  color: Colors.grey[400],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTravellerDetailsCard() {
    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      margin: EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
              color: Colors.black12, blurRadius: 10, offset: Offset(0, 4)),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Traveller Details",
              style: TextStyle(
                fontFamily: FontFamily.PoppinsBold,
                fontSize: 18,
                color: black2E2,
              ),
            ),
            SizedBox(height: 12),
            _buildSavedTravellers(),
            SizedBox(height: 12),
            GestureDetector(
              onTap: () => Get.to(() => TravellerDetailScreen()),
              child: Text(
                "+ ADD TRAVELLER",
                style: TextStyle(
                  fontFamily: FontFamily.PoppinsMedium,
                  fontSize: 14,
                  color: redCA0,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSavedTravellers() {
    final TravellerDetailController controller =
        Get.find<TravellerDetailController>();
    return Obx(
      () => Column(
        children: controller.travellers.map((traveller) {
          final name = traveller['passengerName'] ?? 'Unknown';
          final age = traveller['passengerAge'] ?? 'N/A';
          final gender = traveller['passengerGender'] ?? 'N/A';
          final isSelected = selectedTravellers.contains(name);
          return Padding(
            padding: EdgeInsets.only(bottom: 12),
            child: GestureDetector(
              onTap: () {
                setState(() {
                  if (isSelected) {
                    selectedTravellers.remove(name);
                  } else {
                    selectedTravellers.add(name);
                  }
                });
              },
              child: ScaleTransition(
                scale: _scaleAnimation,
                child: Container(
                  padding: EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: isSelected
                        ? redCA0.withOpacity(0.15)
                        : Colors.grey[200]!.withOpacity(0.8),
                    border: Border.all(
                        color: isSelected ? redCA0 : Colors.grey[300]!),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            name,
                            style: TextStyle(
                              fontFamily: FontFamily.PoppinsMedium,
                              fontSize: 16,
                              color: black2E2,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            "Age: $age, Gender: $gender",
                            style: TextStyle(
                              fontFamily: FontFamily.PoppinsRegular,
                              fontSize: 12,
                              color: grey717,
                            ),
                          ),
                        ],
                      ),
                      IconButton(
                        icon: Icon(Icons.edit, color: redCA0, size: 20),
                        onPressed: () => print("Edit tapped for $name"),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildContactDetailsCard() {
    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      margin: EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
              color: Colors.black12, blurRadius: 10, offset: Offset(0, 4)),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Contact Details",
              style: TextStyle(
                fontFamily: FontFamily.PoppinsBold,
                fontSize: 18,
                color: black2E2,
              ),
            ),
            SizedBox(height: 12),
            _buildContactField("Email ID", "Eg. abc@gmail.com", emailController,
                TextInputType.emailAddress),
            SizedBox(height: 12),
            _buildContactField("Phone Number", "95********", phoneController,
                TextInputType.phone),
          ],
        ),
      ),
    );
  }

  Widget _buildContactField(String label, String hintText,
      TextEditingController controller, TextInputType keyboardType) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontFamily: FontFamily.PoppinsMedium,
            fontSize: 14,
            color: black2E2,
          ),
        ),
        SizedBox(height: 8),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: TextStyle(
              fontFamily: FontFamily.PoppinsRegular,
              fontSize: 14,
              color: grey717,
            ),
            filled: true,
            fillColor: Colors.grey[200]!.withOpacity(0.8),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          ),
          style: TextStyle(
            fontFamily: FontFamily.PoppinsRegular,
            fontSize: 14,
            color: black2E2,
          ),
        ),
      ],
    );
  }

  Widget _buildOffersCard() {
    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      margin: EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
              color: Colors.black12, blurRadius: 10, offset: Offset(0, 4)),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Offers & Discounts",
              style: TextStyle(
                fontFamily: FontFamily.PoppinsBold,
                fontSize: 18,
                color: black2E2,
              ),
            ),
            SizedBox(height: 12),
            Row(
              children: [
                Radio(
                  value: 1,
                  groupValue: 1,
                  onChanged: (value) {},
                  activeColor: redCA0,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Zero Cancellation Fee",
                      style: TextStyle(
                        fontFamily: FontFamily.PoppinsMedium,
                        fontSize: 14,
                        color: black2E2,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      "Save Rs. 50 on cancellation fee",
                      style: TextStyle(
                        fontFamily: FontFamily.PoppinsRegular,
                        fontSize: 12,
                        color: grey717,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 12),
            TextFormField(
              controller: promoCodeController,
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                hintText: "Enter promo code here",
                hintStyle: TextStyle(
                  fontFamily: FontFamily.PoppinsRegular,
                  fontSize: 14,
                  color: grey717,
                ),
                filled: true,
                fillColor: Colors.grey[200]!.withOpacity(0.8),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                suffixIcon: TextButton(
                  onPressed: () {},
                  child: Text(
                    "APPLY",
                    style: TextStyle(
                      fontFamily: FontFamily.PoppinsMedium,
                      fontSize: 14,
                      color: redCA0,
                    ),
                  ),
                ),
              ),
              style: TextStyle(
                fontFamily: FontFamily.PoppinsRegular,
                fontSize: 14,
                color: black2E2,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomBar() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.95),
          boxShadow: [
            BoxShadow(
                color: Colors.black12, blurRadius: 10, offset: Offset(0, -4)),
          ],
          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "₹ ${widget.price?.toStringAsFixed(2) ?? '0.00'}",
                  style: TextStyle(
                    fontFamily: FontFamily.PoppinsBold,
                    fontSize: 20,
                    color: black2E2,
                  ),
                ),
                Text(
                  "PER PERSON",
                  style: TextStyle(
                    fontFamily: FontFamily.PoppinsRegular,
                    fontSize: 12,
                    color: grey717,
                  ),
                ),
              ],
            ),
            GestureDetector(
              onTapDown: (_) => _animationController.forward(),
              onTapUp: (_) => _animationController.reverse(),
              onTapCancel: () => _animationController.reverse(),
              onTap: () {
                Get.to(() => ReviewBookingScreen(
                      trainName: widget.trainName ?? 'Unknown Train',
                      trainNumber: widget.trainNumber ?? '0000',
                      startStation: widget.startStation ?? 'Unknown Station',
                      endStation: widget.endStation ?? 'Unknown Station',
                      seatClass: widget.seatClass ?? 'Unknown Class',
                      price: widget.price ?? 0.0,
                    ));
              },
              child: ScaleTransition(
                scale: _scaleAnimation,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                  decoration: BoxDecoration(
                    gradient:
                        LinearGradient(colors: [redCA0, Colors.orangeAccent]),
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                          color: redCA0.withOpacity(0.4),
                          blurRadius: 8,
                          offset: Offset(0, 4)),
                    ],
                  ),
                  child: Text(
                    "CONTINUE",
                    style: TextStyle(
                      fontFamily: FontFamily.PoppinsBold,
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// class MyBehavior extends ScrollBehavior {
//   @override
//   Widget buildOverscrollIndicator(BuildContext context, Widget child, ScrollableDetails details) {
//     return child;
//   }
// }