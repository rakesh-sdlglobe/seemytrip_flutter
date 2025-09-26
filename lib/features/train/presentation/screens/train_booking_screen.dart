import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../../components/irctcs_webview.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/common/buttons/app_button.dart';
import '../../../../core/widgets/common/cards/app_card.dart';
import '../../../../core/widgets/common/common_app_bar.dart';
import '../../../../shared/constants/font_family.dart';
import '../controllers/travellerDetailController.dart';
import 'train_contact_information_screen.dart';
import 'train_contact_information_screen_password.dart';
import 'train_contact_information_screen_username.dart';
import 'train_review_booking_screen.dart';
import 'traveller_detail_screen.dart';

class TrainBookingScreen extends StatefulWidget {
  TrainBookingScreen({
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
    Key? key,
  }) : super(key: key);
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

  @override
  State<TrainBookingScreen> createState() => _TrainBookingScreenState();
}

class _TrainBookingScreenState extends State<TrainBookingScreen>
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
    final DateFormat inputFormat = DateFormat('HH:mm');
    final DateFormat outputFormat = DateFormat('hh:mm a');
    final DateTime parsedTime = inputFormat.parse(time);
    return outputFormat.format(parsedTime);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: Stack(
          children: [
            _buildBody(),
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: _buildBottomBar(),
            ),
          ],
        ),
      );

  Widget _buildAppBar() => CommonAppBar(
        title: 'Train Booking',
        textColor: AppColors.white,
        showBackButton: true,
      );

  Widget _buildBody() => CustomScrollView(
        slivers: [
          SliverToBoxAdapter(child: _buildAppBar()),
          SliverToBoxAdapter(child: SizedBox(height: 8)),
          SliverToBoxAdapter(child: _buildTrainInfoCard()),
          SliverToBoxAdapter(child: _buildIRCTCCard()),
          SliverToBoxAdapter(child: _buildTravellerDetailsCard()),
          SliverToBoxAdapter(child: _buildContactDetailsCard()),
          SliverToBoxAdapter(child: _buildOffersCard()),
          SliverToBoxAdapter(child: SizedBox(height: 100)),
        ],
      );

  Widget _buildTrainInfoCard() => AppCard(
        margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
                      color: Theme.of(context).textTheme.titleLarge?.color ?? AppColors.black2E2,
                    ),
                  ),
                  Text(
                    "#${widget.trainNumber ?? '0000'}",
                    style: TextStyle(
                      fontFamily: FontFamily.PoppinsMedium,
                      fontSize: 14,
                      color: Theme.of(context).textTheme.bodyMedium?.color ?? AppColors.greyB8B,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Departure',
                            style: TextStyle(
                              fontFamily: FontFamily.PoppinsMedium,
                              fontSize: 12,
                              color: Theme.of(context).textTheme.bodySmall?.color ?? AppColors.grey717,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Text(
                            formatTime(widget.departureTime ?? '00:00'),
                            style: TextStyle(
                              fontFamily: FontFamily.PoppinsMedium,
                              fontSize: 14,
                              color: Theme.of(context).textTheme.titleMedium?.color ?? AppColors.black2E2,
                            ),
                          ),
                          Text(
                            widget.departure ?? '',
                            style: TextStyle(
                              fontFamily: FontFamily.PoppinsMedium,
                              fontSize: 12,
                              color: Theme.of(context).textTheme.bodyMedium?.color ?? AppColors.greyB8B,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  _buildDuration(),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Arrival',
                            style: TextStyle(
                              fontFamily: FontFamily.PoppinsMedium,
                              fontSize: 12,
                              color: Theme.of(context).textTheme.bodySmall?.color ?? AppColors.grey717,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Text(
                            formatTime(widget.arrivalTime ?? '00:00'),
                            style: TextStyle(
                              fontFamily: FontFamily.PoppinsMedium,
                              fontSize: 14,
                              color: Theme.of(context).textTheme.titleMedium?.color ?? AppColors.black2E2,
                            ),
                          ),
                          Text(
                            widget.arrival ?? '',
                            style: TextStyle(
                              fontFamily: FontFamily.PoppinsMedium,
                              fontSize: 12,
                              color: Theme.of(context).textTheme.bodyMedium?.color ?? AppColors.greyB8B,
                              ),
                          ),
                        ],
                      ),
                    ),
                  ),
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
                      color: Theme.of(context).textTheme.bodyMedium?.color ?? AppColors.grey717,
                      overflow: TextOverflow.ellipsis,
                        ),
                  ),
                  Text(
                    widget.toStation,
                    style: TextStyle(
                      fontFamily: FontFamily.PoppinsMedium,
                      fontSize: 14,
                      color: Theme.of(context).textTheme.bodyMedium?.color ?? AppColors.grey717,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );


  Widget _buildDuration() => Row(
        children: [
          Container(
            height: 2,
            width: 50,
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: [AppColors.redCA0, Colors.orangeAccent]),
            ),
          ),
          SizedBox(width: 12),
          Text(
            widget.duration ?? '',
            style: TextStyle(
              fontFamily: FontFamily.PoppinsMedium,
              fontSize: 14,
              color: Theme.of(context).textTheme.bodyMedium?.color ?? AppColors.grey717,
            ),
          ),
          SizedBox(width: 12),
          Container(
            height: 2,
            width: 50,
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: [Colors.orangeAccent, AppColors.redCA0]),
            ),
          ),
        ],
      );

  Widget _buildIRCTCCard() => AppCard(
        margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'IRCTC Username',
                style: TextStyle(
                  fontFamily: FontFamily.PoppinsBold,
                  fontSize: 18,
                  color: Theme.of(context).textTheme.titleLarge?.color ?? AppColors.black2E2,
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
                    color: Theme.of(context).brightness == Brightness.dark 
                      ? Colors.grey[800]!.withValues(alpha: 0.8)
                      : Colors.grey[200]!.withValues(alpha: 0.8),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Theme.of(context).brightness == Brightness.dark 
                        ? Colors.grey[600]!
                        : Colors.grey[300]!
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        irctcUsername.isEmpty
                            ? 'Enter IRCTC Username'
                            : irctcUsername,
                        style: TextStyle(
                          fontFamily: FontFamily.PoppinsMedium,
                          fontSize: 14,
                          color: irctcUsername.isEmpty
                              ? Theme.of(context).hintColor
                              : Theme.of(context).textTheme.bodyLarge?.color ?? AppColors.black2E2,
                        ),
                      ),
                      Icon(Icons.arrow_forward_ios, color: AppColors.redCA0, size: 18),
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
              color: Theme.of(context).textTheme.titleMedium?.color ?? Colors.grey[700],
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
  }) =>
      Padding(
        padding: EdgeInsets.only(bottom: isLast ? 0 : 12),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(12),
            child: Ink(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Theme.of(context).brightness == Brightness.dark 
                    ? Colors.grey[600]!
                    : Colors.grey[200]!
                ),
                boxShadow: [
                  BoxShadow(
                    color: Theme.of(context).shadowColor.withOpacity(0.05),
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
                      color: AppColors.redCA0.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      icon,
                      color: AppColors.redCA0,
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
                            color: Theme.of(context).textTheme.titleMedium?.color ?? Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          subtitle,
                          style: TextStyle(
                            fontFamily: FontFamily.PoppinsRegular,
                            fontSize: 13,
                            color: Theme.of(context).textTheme.bodyMedium?.color ?? Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: 16,
                    color: Theme.of(context).brightness == Brightness.dark 
                      ? Colors.grey[600]
                      : Colors.grey[400],
                  ),
                ],
              ),
            ),
          ),
        ),
      );

  Widget _buildTravellerDetailsCard() => AppCard(
        margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Traveller Details',
                style: TextStyle(
                  fontFamily: FontFamily.PoppinsBold,
                  fontSize: 18,
                  color: Theme.of(context).textTheme.titleLarge?.color ?? AppColors.black2E2,
                ),
              ),
              SizedBox(height: 12),
              _buildSavedTravellers(),
              SizedBox(height: 12),
              GestureDetector(
                onTap: () => Get.to(() => TravellerDetailScreen()),
                child: Text(
                  '+ ADD TRAVELLER',
                  style: TextStyle(
                    fontFamily: FontFamily.PoppinsMedium,
                    fontSize: 14,
                    color: AppColors.redCA0,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ],
          ),
        ),
      );

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
                        ? AppColors.redCA0.withOpacity(0.15)
                        : Theme.of(context).brightness == Brightness.dark 
                          ? Colors.grey[800]!.withOpacity(0.8)
                          : Colors.grey[200]!.withOpacity(0.8),
                    border: Border.all(
                        color: isSelected 
                          ? AppColors.redCA0 
                          : Theme.of(context).brightness == Brightness.dark 
                            ? Colors.grey[600]!
                            : Colors.grey[300]!),
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
                              color: Theme.of(context).textTheme.titleMedium?.color ?? AppColors.black2E2,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Age: $age, Gender: $gender',
                            style: TextStyle(
                              fontFamily: FontFamily.PoppinsRegular,
                              fontSize: 12,
                              color: Theme.of(context).textTheme.bodySmall?.color ?? AppColors.grey717,
                            ),
                          ),
                        ],
                      ),
                      IconButton(
                        icon: Icon(Icons.edit, color: AppColors.redCA0, size: 20),
                        onPressed: () => print('Edit tapped for $name'),
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

  Widget _buildContactDetailsCard() => AppCard(
        margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Contact Details',
                style: TextStyle(
                  fontFamily: FontFamily.PoppinsBold,
                  fontSize: 18,
                  color: Theme.of(context).textTheme.titleLarge?.color ?? AppColors.black2E2,
                ),
              ),
              SizedBox(height: 12),
              _buildContactField('Email ID', 'Eg. abc@gmail.com',
                  emailController, TextInputType.emailAddress),
              SizedBox(height: 12),
              _buildContactField('Phone Number', '95********', phoneController,
                  TextInputType.phone),
            ],
          ),
        ),
      );

  Widget _buildContactField(String label, String hintText,
          TextEditingController controller, TextInputType keyboardType) =>
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontFamily: FontFamily.PoppinsMedium,
              fontSize: 14,
              color: Theme.of(context).textTheme.titleMedium?.color ?? AppColors.black2E2,
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
                color: Theme.of(context).hintColor,
              ),
              filled: true,
              fillColor: Theme.of(context).brightness == Brightness.dark 
                ? Colors.grey[800]!.withValues(alpha: 0.8)
                : Colors.grey[200]!.withValues(alpha: 0.8),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            ),
            style: TextStyle(
              fontFamily: FontFamily.PoppinsRegular,
              fontSize: 14,
              color: Theme.of(context).textTheme.bodyLarge?.color ?? AppColors.black2E2,
            ),
          ),
        ],
      );

  Widget _buildOffersCard() => AppCard(
        margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Offers & Discounts',
                style: TextStyle(
                  fontFamily: FontFamily.PoppinsBold,
                  fontSize: 18,
                  color: Theme.of(context).textTheme.titleLarge?.color ?? AppColors.black2E2,
                ),
              ),
              SizedBox(height: 12),
              Row(
                children: [
                  Radio(
                    value: 1,
                    groupValue: 1,
                    onChanged: (value) {},
                    activeColor: AppColors.redCA0,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Zero Cancellation Fee',
                        style: TextStyle(
                          fontFamily: FontFamily.PoppinsMedium,
                          fontSize: 14,
                          color: Theme.of(context).textTheme.titleMedium?.color ?? AppColors.black2E2,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Save Rs. 50 on cancellation fee',
                        style: TextStyle(
                          fontFamily: FontFamily.PoppinsRegular,
                          fontSize: 12,
                          color: Theme.of(context).textTheme.bodySmall?.color ?? AppColors.grey717,
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
                  hintText: 'Enter promo code here',
                  hintStyle: TextStyle(
                    fontFamily: FontFamily.PoppinsRegular,
                    fontSize: 14,
                    color: Theme.of(context).hintColor,
                  ),
                  filled: true,
                  fillColor: Theme.of(context).brightness == Brightness.dark 
                    ? Colors.grey[800]!.withValues(alpha: 0.8)
                    : Colors.grey[200]!.withValues(alpha: 0.8),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  suffixIcon: TextButton(
                    onPressed: () {},
                    child: Text(
                      'APPLY',
                      style: TextStyle(
                        fontFamily: FontFamily.PoppinsMedium,
                        fontSize: 14,
                        color: AppColors.redCA0,
                      ),
                    ),
                  ),
                ),
                style: TextStyle(
                  fontFamily: FontFamily.PoppinsRegular,
                  fontSize: 14,
                  color: Theme.of(context).textTheme.bodyLarge?.color ?? AppColors.black2E2,
                ),
              ),
            ],
          ),
        ),
      );

  Widget _buildBottomBar() => Container(
        decoration: BoxDecoration(
          color: Theme.of(context).bottomAppBarTheme.color ?? Theme.of(context).cardColor,
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).shadowColor.withOpacity(0.12),
              blurRadius: 10,
              offset: Offset(0, -2),
            ),
          ],
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
          ),
        ),
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: SafeArea(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Total Fare',
                    style: TextStyle(
                      color: Theme.of(context).textTheme.bodyMedium?.color ?? AppColors.grey888,
                      fontSize: 14,
                      fontFamily: FontFamily.PoppinsRegular,
                    ),
                  ),
                  SizedBox(height: 2),
                  Text(
                    '₹${widget.price?.toStringAsFixed(2) ?? '0.00'}',
                    style: TextStyle(
                      color: AppColors.redCA0,
                      fontSize: 22,
                      fontFamily: FontFamily.PoppinsBold,
                    ),
                  ),
                ],
              ),
              SizedBox(width: 16),
              Expanded(
                child: Container(
                  height: 50, // Fixed height for the button
                  child: AppButton.primary(
                    text: 'Continue to Payment',
                    onPressed: () {
                      // Validate form before proceeding
                      if (_validateForm()) {
                        Get.to(() => TrainReviewBookingScreen(
                              trainName: widget.trainName ?? 'Unknown Train',
                              trainNumber: widget.trainNumber ?? '0000',
                              startStation:
                                  widget.startStation ?? 'Unknown Station',
                              endStation:
                                  widget.endStation ?? 'Unknown Station',
                              seatClass: widget.seatClass ?? 'Unknown Class',
                              price: widget.price ?? 0.0,
                            ));
                      }
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      );

  bool _validateForm() {
    if (emailController.text.isEmpty) {
      Get.snackbar(
        'Error',
        'Please enter your email address',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
    }

    if (phoneController.text.isEmpty) {
      Get.snackbar(
        'Error',
        'Please enter your phone number',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
    }

    if (travellerDetailController.travellers.isEmpty) {
      Get.snackbar(
        'Error',
        'Please add at least one traveller',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
    }

    return true;
  }
}
