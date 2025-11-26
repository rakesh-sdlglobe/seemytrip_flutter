import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../../components/irctcs_webview.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/common/buttons/app_button.dart';
import '../../../../core/widgets/common/cards/app_card.dart';
import '../../../../shared/constants/font_family.dart';
import '../../../auth/presentation/controllers/login_controller.dart';
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
    required this.journeyDate,
    this.jQuota,
    this.boardingStationCode,
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
  final String journeyDate; // yyyyMMdd format
  final String? jQuota;
  final String? boardingStationCode;

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
    _fetchUserContactDetails();
  }

  Future<void> _fetchUserContactDetails() async {
    final LoginController loginController = Get.find<LoginController>();
    // Fetch user profile if not already loaded
    if (loginController.userData.isEmpty) {
      await loginController.fetchUserProfile();
    }
    // Initialize controllers with user data
    if (mounted) {
      final email = loginController.userEmail;
      final phone = loginController.userPhone;
      if (email.isNotEmpty && emailController.text.isEmpty) {
        emailController.text = email;
      }
      if (phone.isNotEmpty && phoneController.text.isEmpty) {
        phoneController.text = phone;
      }
    }
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
      appBar: _buildAppBar(),
      body: SingleChildScrollView(
        child: _buildBody(),
        padding: const EdgeInsets.only(bottom: 12),
      ),
      bottomNavigationBar: _buildBottomBar(),
    );

  AppBar _buildAppBar() => AppBar(
        title: Text(
          'Train Booking',
          style: TextStyle(
            fontFamily: FontFamily.PoppinsSemiBold,
            fontSize: 16,
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_rounded, size: 20),
          onPressed: () => Navigator.of(context).pop(),
        ),
        elevation: 0,
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
      );

  Widget _buildBody() => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
        child: Column(
          children: [
            _buildTrainInfoCard(),
            _buildIRCTCCard(),
            _buildTravellerDetailsCard(),
            _buildContactDetailsCard(),
            _buildOffersCard(),
            SizedBox(height: 100),
          ],
        ),
      );

  Widget _buildTrainInfoCard() => AppCard(
        margin: const EdgeInsets.only(bottom: 8),
        child: Padding(
          padding: const EdgeInsets.all(16),
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
                      fontSize: 16,
                      color: Theme.of(context).textTheme.titleLarge?.color ??
                          AppColors.black2E2,
                    ),
                  ),
                  Text(
                    "#${widget.trainNumber ?? '0000'}",
                    style: TextStyle(
                      fontFamily: FontFamily.PoppinsMedium,
                      fontSize: 12,
                      color: Theme.of(context).textTheme.bodyMedium?.color ??
                          AppColors.greyB8B,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 12),
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
                              fontSize: 10,
                              color: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.color ??
                                  AppColors.grey717,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Text(
                            formatTime(widget.departureTime ?? '00:00'),
                            style: TextStyle(
                              fontFamily: FontFamily.PoppinsMedium,
                              fontSize: 12,
                              color: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.color ??
                                  AppColors.black2E2,
                            ),
                          ),
                          Text(
                            widget.departure ?? '',
                            style: TextStyle(
                              fontFamily: FontFamily.PoppinsMedium,
                              fontSize: 10,
                              color: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.color ??
                                  AppColors.greyB8B,
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
                              fontSize: 10,
                              color: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.color ??
                                  AppColors.grey717,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Text(
                            formatTime(widget.arrivalTime ?? '00:00'),
                            style: TextStyle(
                              fontFamily: FontFamily.PoppinsMedium,
                              fontSize: 12,
                              color: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.color ??
                                  AppColors.black2E2,
                            ),
                          ),
                          Text(
                            widget.arrival ?? '',
                            style: TextStyle(
                              fontFamily: FontFamily.PoppinsMedium,
                              fontSize: 10,
                              color: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.color ??
                                  AppColors.greyB8B,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    widget.fromStation,
                    style: TextStyle(
                      fontFamily: FontFamily.PoppinsMedium,
                      fontSize: 12,
                      color: Theme.of(context)
                          .textTheme
                          .bodyMedium
                          ?.color ??
                          AppColors.grey717,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Text(
                    widget.toStation,
                    style: TextStyle(
                      fontFamily: FontFamily.PoppinsMedium,
                      fontSize: 12,
                      color: Theme.of(context)
                          .textTheme
                          .bodyMedium
                          ?.color ??
                          AppColors.grey717,
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
              fontSize: 12,
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
        margin: const EdgeInsets.only(bottom: 8),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'IRCTC Username',
                style: TextStyle(
                  fontFamily: FontFamily.PoppinsBold,
                  fontSize: 16,
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
                  padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                  decoration: BoxDecoration(
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Colors.grey[800]!.withOpacity(0.8)
                        : Colors.grey[200]!.withOpacity(0.8),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Theme.of(context).brightness == Brightness.dark
                          ? Colors.grey[600]!
                          : Colors.grey[300]!,
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
                          fontSize: 12,
                          color: irctcUsername.isEmpty
                              ? Theme.of(context).hintColor
                              : Theme.of(context).textTheme.bodyLarge?.color ?? AppColors.black2E2,
                        ),
                      ),
                      Icon(Icons.arrow_forward_ios, color: AppColors.redCA0, size: 16),
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
              fontSize: 14,
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
  }) => Column(
      children: [
        ListTile(
          dense: true,
          contentPadding: const EdgeInsets.symmetric(vertical: 2, horizontal: 0),
          minLeadingWidth: 32,
          leading: Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: AppColors.redCA0.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: AppColors.redCA0,
              size: 18,
            ),
          ),
          title: Text(
            title,
            style: TextStyle(
              fontFamily: FontFamily.PoppinsSemiBold,
              fontSize: 13,
              color: Theme.of(context).textTheme.titleMedium?.color ?? Colors.black87,
            ),
          ),
          subtitle: Text(
            subtitle,
            style: TextStyle(
              fontFamily: FontFamily.PoppinsRegular,
              fontSize: 11,
              color: Theme.of(context).textTheme.bodyMedium?.color ?? Colors.grey[600],
            ),
          ),
          trailing: Icon(
            Icons.arrow_forward_ios_rounded,
            size: 14,
            color: Theme.of(context).brightness == Brightness.dark
                ? Colors.grey[600]!
                : Colors.grey[400]!,
          ),
          onTap: onTap,
        ),
        if (!isLast) Divider(height: 0.5, thickness: 0.5),
      ],
    );

  Widget _buildTravellerDetailsCard() => AppCard(
        margin: const EdgeInsets.only(bottom: 16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Traveller Details',
                    style: TextStyle(
                      fontFamily: FontFamily.PoppinsSemiBold,
                      fontSize: 18,
                      color: Theme.of(context).textTheme.titleLarge?.color ?? AppColors.black2E2,
                    ),
                  ),
                  _buildAddTravellerButton(),
                ],
              ),
              const SizedBox(height: 16),
              _buildSavedTravellers(),
            ],
          ),
        ),
      );

  Widget _buildAddTravellerButton() => GestureDetector(
        onTap: () => Get.to(() => TravellerDetailScreen()),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: AppColors.redCA0.withOpacity(0.1),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppColors.redCA0, width: 1),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.add, color: AppColors.redCA0, size: 16),
              const SizedBox(width: 4),
              Text(
                'Add Traveller',
                style: TextStyle(
                  fontFamily: FontFamily.PoppinsMedium,
                  fontSize: 12,
                  color: AppColors.redCA0,
                ),
              ),
            ],
          ),
        ),
      );

  Widget _buildSavedTravellers() {
    final TravellerDetailController controller = Get.find<TravellerDetailController>();
    
    return Obx(() {
      if (controller.travellers.isEmpty) {
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 24),
          alignment: Alignment.center,
          child: Column(
            children: [
              Icon(Icons.person_add_alt_1_outlined, 
                size: 48, 
                color: Theme.of(context).hintColor.withOpacity(0.5)),
              const SizedBox(height: 12),
              Text(
                'No travelers added yet',
                style: TextStyle(
                  fontFamily: FontFamily.PoppinsMedium,
                  color: Theme.of(context).hintColor,
                ),
              ),
            ],
          ),
        );
      }
      
      return Column(
        children: controller.travellers.map((traveller) {
          // Map API fields to local variables using the exact field names from the backend
          final name = traveller['passengerName'] ?? traveller['firstname'] ?? 'Unknown';
          final passengerAge = traveller['passengerAge'] ?? traveller['age'];
          final age = passengerAge != null ? passengerAge.toString() : 'N/A';
          final berth = traveller['passengerBerthChoice'] ?? '';
          // Get gender from API response
          final gender = traveller['passengerGender']?.toString() ?? 'M';
          final mobile = traveller['passengerMobileNumber'] ?? traveller['mobile'] ?? '';
          final foodPreference = traveller['passengerFoodChoice'] ?? '';
          final isSelected = selectedTravellers.contains(name);
          
          return AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            margin: const EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isSelected 
                  ? AppColors.redCA0 
                  : Theme.of(context).dividerColor.withOpacity(0.5),
                width: isSelected ? 1.5 : 1,
              ),
              boxShadow: isSelected
                  ? [
                      BoxShadow(
                        color: AppColors.redCA0.withOpacity(0.1),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      )
                    ]
                  : null,
            ),
            child: Material(
              color: isSelected
                  ? AppColors.redCA0.withOpacity(0.05)
                  : Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(12),
              child: InkWell(
                onTap: () {
                  setState(() {
                    if (isSelected) {
                      selectedTravellers.remove(name);
                    } else {
                      selectedTravellers.add(name);
                    }
                  });
                },
                borderRadius: BorderRadius.circular(12),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: isSelected 
                              ? AppColors.redCA0.withOpacity(0.1) 
                              : Theme.of(context).highlightColor,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.person_outline,
                          color: isSelected ? AppColors.redCA0 : Theme.of(context).hintColor,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              name,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontFamily: FontFamily.PoppinsSemiBold,
                                fontSize: 15,
                                color: isSelected 
                                    ? AppColors.redCA0 
                                    : Theme.of(context).textTheme.titleMedium?.color,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Wrap(
                              spacing: 8,
                              runSpacing: 4,
                              children: [
                                if (age != 'N/A' && age.isNotEmpty) _buildInfoChip('$age yrs'),
                                if (gender.isNotEmpty && gender != 'N/A') 
                                  _buildInfoChip(gender == 'M' ? 'Male' : gender == 'F' ? 'Female' : gender),
                                if (berth.isNotEmpty) _buildInfoChip(berth),
                                if (foodPreference.isNotEmpty) _buildInfoChip(foodPreference),
                              ],
                            ),
                            if (mobile.isNotEmpty) ...[
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  Icon(Icons.phone_outlined, size: 12, color: Theme.of(context).hintColor),
                                  const SizedBox(width: 4),
                                  Text(
                                    mobile,
                                    style: TextStyle(
                                      fontSize: 11,
                                      fontFamily: FontFamily.PoppinsRegular,
                                      color: Theme.of(context).hintColor,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ],
                        ),
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.edit_outlined, 
                          size: 20,
                          color: Theme.of(context).hintColor,
                        ),
                        onPressed: () => _editTraveller(traveller),
                        splashRadius: 20,
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      );
    });
  }

  Widget _buildInfoChip(String text) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
        decoration: BoxDecoration(
          color: Theme.of(context).highlightColor,
          borderRadius: BorderRadius.circular(4),
        ),
        child: Text(
          text,
          style: TextStyle(
            fontSize: 10,
            fontFamily: FontFamily.PoppinsMedium,
            color: Theme.of(context).hintColor,
          ),
        ),
      );

  String _getGenderFromBerth(String berthCode) {
    switch (berthCode) {
      case 'LB':
      case 'MB':
      case 'UB':
        return 'Male';
      case 'SL':
      case 'SU':
        return 'Female';
      default:
        return 'Other';
    }
  }

  void _editTraveller(Map<String, dynamic> traveller) {
    Get.to(() => TravellerDetailScreen(traveller: traveller));
  }

  Widget _buildContactDetailsCard() {
    final LoginController loginController = Get.find<LoginController>();
    
    return Obx(() {
      // Update controllers when user data changes
      final email = loginController.userEmail;
      final phone = loginController.userPhone;
      
      // Update controllers if they're empty and we have data
      if (email.isNotEmpty && emailController.text.isEmpty) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
            emailController.text = email;
          }
        });
      }
      if (phone.isNotEmpty && phoneController.text.isEmpty) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
            phoneController.text = phone;
          }
        });
      }
      
      final hasContactData = email.isNotEmpty || phone.isNotEmpty;
      
      return AppCard(
        margin: const EdgeInsets.only(bottom: 8),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Contact Details',
                    style: TextStyle(
                      fontFamily: FontFamily.PoppinsBold,
                      fontSize: 16,
                      color: Theme.of(context).textTheme.titleLarge?.color ?? AppColors.black2E2,
                    ),
                  ),
                  if (hasContactData)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.green.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        'Auto-filled from profile',
                        style: TextStyle(
                          fontSize: 10,
                          color: Colors.green,
                          fontFamily: FontFamily.PoppinsMedium,
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 16),
              _buildContactField(
                'Email ID',
                'Eg. abc@gmail.com',
                emailController,
                TextInputType.emailAddress,
                initialValue: email,
                prefixIcon: Icons.email_outlined,
              ),
              const SizedBox(height: 12),
              _buildContactField(
                'Phone Number',
                '95********',
                phoneController,
                TextInputType.phone,
                initialValue: phone,
                prefixIcon: Icons.phone_outlined,
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildContactField(
    String label, 
    String hintText,
    TextEditingController controller, 
    TextInputType keyboardType, {
    String initialValue = '',
    IconData? prefixIcon,
  }) =>
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontFamily: FontFamily.PoppinsMedium,
              fontSize: 12,
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
                fontSize: 12,
                color: Theme.of(context).hintColor,
              ),
              prefixIcon: prefixIcon != null ? Icon(
                prefixIcon,
                size: 20,
                color: Theme.of(context).hintColor,
              ) : null,
              filled: true,
              fillColor: Theme.of(context).brightness == Brightness.dark
                  ? Colors.grey[800]!.withOpacity(0.8)
                  : Colors.grey[200]!.withOpacity(0.8),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 12,
              ),
            ),
            style: TextStyle(
              fontFamily: FontFamily.PoppinsRegular,
              fontSize: 12,
              color: Theme.of(context).textTheme.bodyLarge?.color ?? AppColors.black2E2,
            ),
          ),
        ],
      );

  Widget _buildOffersCard() => AppCard(
        margin: const EdgeInsets.only(bottom: 8),
        child: Padding(
          padding: const EdgeInsets.all(16),
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
                    ? Colors.grey[800]!.withOpacity(0.8)
                    : Colors.grey[200]!.withOpacity(0.8),
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
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
                  height: 44, // Fixed height for the button
                  child: AppButton.primary(
                    text: 'Continue to Payment',
                    onPressed: () {
                      // Validate form before proceeding
                      if (_validateForm()) {
                        // Get selected travellers and format as passengers
                        final TravellerDetailController controller = Get.find<TravellerDetailController>();
                        print('🔍 Debug Info:');
                        print('  Selected travellers names: $selectedTravellers');
                        print('  Total available travellers: ${controller.travellers.length}');
                        print('  Available travellers: ${controller.travellers.map((t) => t['passengerName'] ?? t['firstname'] ?? 'Unknown').toList()}');
                        
                        final List<Map<String, dynamic>> passengers = controller.travellers
                            .where((traveller) {
                              final name = traveller['passengerName'] ?? traveller['firstname'] ?? 'Unknown';
                              final isSelected = selectedTravellers.contains(name);
                              print('  Checking traveller: $name -> Selected: $isSelected');
                              return isSelected;
                            })
                            .map((traveller) {
                              final passengerAge = traveller['passengerAge'] ?? traveller['age'];
                              final passengerMap = {
                                'passengerName': traveller['passengerName'] ?? traveller['firstname'] ?? 'Unknown',
                                'passengerAge': passengerAge != null ? passengerAge.toString() : '0',
                                'passengerGender': traveller['passengerGender']?.toString() ?? 'M',
                                'mobileNumber': traveller['passengerMobileNumber'] ?? traveller['mobile'] ?? '',
                                'berthChoice': traveller['passengerBerthChoice'] ?? 'LB',
                                'nationality': traveller['passengerNationality'] ?? traveller['nationality'] ?? 'IN',
                              };
                              print('  Mapped passenger: $passengerMap');
                              return passengerMap;
                            })
                            .toList();

                        // Validate that at least one passenger is selected
                        if (passengers.isEmpty) {
                          Get.snackbar(
                            'Error',
                            'Please select at least one traveller',
                            snackPosition: SnackPosition.BOTTOM,
                            backgroundColor: Colors.red,
                            colorText: Colors.white,
                          );
                          return;
                        }

                        // Debug print to verify all values being passed
                        print('🚂 Passing values to TrainReviewBookingScreen:');
                        print('  trainNumber: ${widget.trainNumber}');
                        print('  journeyDate: ${widget.journeyDate}');
                        print('  fromStnCode: ${widget.startStation}');
                        print('  toStnCode: ${widget.endStation}');
                        print('  jClass: ${widget.seatClass}');
                        print('  jQuota: ${widget.jQuota}');
                        print('  boardingStationCode: ${widget.boardingStationCode ?? widget.startStation}');
                        print('  passengers: ${passengers.length} passenger(s)');
                        print('  📋 Passenger Details:');
                        for (int i = 0; i < passengers.length; i++) {
                          final passenger = passengers[i];
                          print('    Passenger ${i + 1}:');
                          print('      passengerName: ${passenger['passengerName']}');
                          print('      passengerAge: ${passenger['passengerAge']}');
                          print('      passengerGender: ${passenger['passengerGender']}');
                          print('      mobileNumber: ${passenger['mobileNumber']}');
                          print('      berthChoice: ${passenger['berthChoice']}');
                          print('      nationality: ${passenger['nationality']}');
                        }
                        print('  📦 Full passengers JSON: ${passengers.toString()}');

                        Get.to(() => TrainReviewBookingScreen(
                              trainName: widget.trainName ?? 'Unknown Train',
                              trainNumber: widget.trainNumber ?? '0000',
                              startStation:
                                  widget.startStation ?? 'Unknown Station',
                              endStation:
                                  widget.endStation ?? 'Unknown Station',
                              seatClass: widget.seatClass ?? 'Unknown Class',
                              price: widget.price ?? 0.0,
                              trainNumberParam: widget.trainNumber ?? '0000',
                              journeyDate: widget.journeyDate,
                              fromStnCode: widget.startStation ?? '',
                              toStnCode: widget.endStation ?? '',
                              jClass: widget.seatClass ?? '',
                              jQuota: widget.jQuota ?? 'GN',
                              boardingStationCode: widget.boardingStationCode ?? widget.startStation ?? '',
                              passengers: passengers,
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

    if (selectedTravellers.isEmpty) {
      Get.snackbar(
        'Error',
        'Please select at least one traveller',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
    }

    return true;
  }
}
