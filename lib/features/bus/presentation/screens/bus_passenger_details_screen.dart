// ignore_for_file: avoid_classes_with_only_static_members

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../core/theme/app_colors.dart' as AppTheme;
import '../../../payment/easebuzz_payment_widget.dart';
import '../controllers/bus_controller.dart';
import '../../../auth/presentation/controllers/login_controller.dart';
import '../../../train/presentation/controllers/travellerDetailController.dart';
import '../../../train/presentation/screens/traveller_detail_screen.dart';
import '../../../../core/widgets/common/traveller_form_widget.dart';
import '../../../../core/models/traveller_form_config.dart';
import 'passenger_form.dart';
import 'bus_seat_layout_screen.dart';

// Theme extensions for common styles
extension ThemeStyles on BuildContext {
  // Theme shortcuts
  ThemeData get theme => Theme.of(this);
  TextTheme get currentTextTheme => theme.textTheme;
  ColorScheme get colorScheme => theme.colorScheme;
  IconThemeData get iconTheme => theme.iconTheme;

  // Colors
  Color get primaryColor => colorScheme.primary;
  Color get primaryVariantColor => colorScheme.primaryContainer;
  Color get accentColor => colorScheme.secondary;
  Color get successColor => const Color(0xFF2ECC71);
  Color get errorColor => colorScheme.error;
  Color get backgroundColor => colorScheme.background;
  Color get surfaceColor => colorScheme.surface;
  Color get cardColor => colorScheme.surface;
  Color get shadowColor => colorScheme.onSurface.withOpacity(0.1);
  Color get dividerColor => theme.dividerColor.withOpacity(0.1);
  Color get textColor => currentTextTheme.bodyLarge?.color ?? Colors.black87;
  Color get secondaryTextColor =>
      currentTextTheme.bodyMedium?.color ?? Colors.grey[600]!;

  // Compact Text styles
  TextStyle get titleStyle =>
      currentTextTheme.titleLarge?.copyWith(
        fontWeight: FontWeight.w600,
        fontSize: 16,
        letterSpacing: 0.1,
      ) ??
      const TextStyle();

  TextStyle get cardTitleStyle =>
      currentTextTheme.titleMedium?.copyWith(
        fontWeight: FontWeight.w600,
        fontSize: 14,
      ) ??
      const TextStyle();

  TextStyle get bodyStyle =>
      currentTextTheme.bodyLarge?.copyWith(
        fontSize: 13,
        fontWeight: FontWeight.w500,
        height: 1.3,
      ) ??
      const TextStyle();

  TextStyle get subtitleStyle =>
      currentTextTheme.bodySmall?.copyWith(
        fontSize: 12,
        height: 1.2,
      ) ??
      const TextStyle();

  TextStyle get buttonStyle =>
      textTheme.labelLarge?.copyWith(
        fontWeight: FontWeight.w600,
        fontSize: 14,
        color: colorScheme.onPrimary,
      ) ??
      const TextStyle();

  // Compact spacing
  double get smallSpace => 4.0;
  double get mediumSpace => 8.0;
  double get largeSpace => 12.0;
}

class BusPassengerDetailsScreen extends StatefulWidget {
  const BusPassengerDetailsScreen({
    this.fromCity,
    this.toCity,
    this.busName,
    this.travelDate,
    this.departureTime,
    this.arrivalTime,
    this.fare,
    this.selectedSeats,
    this.boardingPoint,
    this.droppingPoint,
    this.traceId,
    this.resultIndex,
    this.boardingPointId,
    this.droppingPointId,
    this.selectedSeatsObjects,
    super.key,
  });

  final String? fromCity;
  final String? toCity;
  final String? busName;
  final String? travelDate;
  final String? departureTime;
  final String? arrivalTime;
  final double? fare;
  final List<String>? selectedSeats;
  final String? boardingPoint;
  final String? droppingPoint;
  final String? traceId;
  final int? resultIndex;
  final String? boardingPointId;
  final String? droppingPointId;
  final List<dynamic>? selectedSeatsObjects;

  @override
  State<BusPassengerDetailsScreen> createState() =>
      _BusPassengerDetailsScreenState();
}

class _BusPassengerDetailsScreenState extends State<BusPassengerDetailsScreen>
    with SingleTickerProviderStateMixin {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // Controllers
  BusController? _busController;
  LoginController? _loginController;
  late final TravellerDetailController travellerController;

  // Dynamic data
  String _fromCity = '';
  String _toCity = '';
  String _busName = '';
  List<dynamic> _selectedSeatsObjects = [];
  String _travelDate = '';
  String _departureTime = '';
  String _arrivalTime = '';
  double _fare = 0.0;
  List<String> _selectedSeats = [];
  String _boardingPoint = '';
  String _droppingPoint = '';
  String _traceId = '';
  int _resultIndex = 0;
  String _boardingPointId = '';
  String _droppingPointId = '';

  // Booking data storage
  Map<String, dynamic>? _blockResponse;
  Map<String, dynamic>? _storedBusData;
  Map<String, dynamic>? _storedContactDetails;
  Map<String, dynamic>? _storedAddressDetails;
  Map<String, dynamic>? _storedTravelerDetails;
  Map<String, dynamic>? _storedFareDetails;
  Map<String, dynamic>? _storedSearchResponse;

  // User data
  String _userName = '';
  String _userEmail = '';
  String _userPhone = '';

  // Form controllers
  late final List<TextEditingController> _nameControllers;
  late final List<TextEditingController> _ageControllers;
  late final List<TextEditingController> _idNumberControllers;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _specialRequirementsController =
      TextEditingController();
  late final List<List<bool>> _genderSelections;
  late final List<String> _idProofTypes;
  late final List<String> _selectedIdProofTypes;
  bool _isFormValid = false;
  bool _tripProtectionEnabled = true;

  // Animation
  late final AnimationController _animationController;
  late final Animation<double> _fadeAnimation;

  // Loading state
  bool _isLoading = true;
  String? _errorMessage;

  // Traveller management
  List<String> selectedTravellers = [];
  bool _showAddGuestForm = false;
  final GlobalKey<FormState> _addGuestFormKey = GlobalKey<FormState>();
  final GlobalKey<TravellerFormWidgetState> _addGuestFormWidgetKey =
      GlobalKey<TravellerFormWidgetState>();
  Map<String, dynamic>? _savedGuestFormData;
  late final TravellerFormConfig _addGuestConfig;

  @override
  void initState() {
    super.initState();
    // Initialize animation controller
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    );

    // Initialize TravellerDetailController
    if (!Get.isRegistered<TravellerDetailController>()) {
      Get.put(TravellerDetailController());
    }
    travellerController = Get.find<TravellerDetailController>();

    // Initialize form configuration for adding bus guests
    _addGuestConfig = TravellerFormConfig.bus(
      title: 'Add Guest',
      subtitle: 'Add a guest to your saved travellers list',
    );

    // Initialize data dynamically
    _initializeData();
  }

  Future<void> _initializeData() async {
    try {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });

      // Get controllers
      try {
        _busController = Get.find<BusController>();
      } catch (e) {
        debugPrint('BusController not found: $e');
      }

      try {
        _loginController = Get.find<LoginController>();
      } catch (e) {
        debugPrint('LoginController not found: $e');
      }

      // Load data from controllers or use widget parameters
      await _loadData();

      // Initialize form controllers
      _initializeFormControllers();

      // Load user data
      await _loadUserData();

      setState(() {
        _isLoading = false;
      });

      _animationController.forward();
    } catch (e) {
      debugPrint('Error initializing data: $e');
      setState(() {
        _isLoading = false;
        _errorMessage = 'Failed to load data. Please try again.';
      });
    }
  }

  String _convertTo12HourFormat(String time24) {
    if (time24.isEmpty || time24 == '--:--' || !time24.contains(':')) {
      return time24;
    }

    try {
      final parts = time24.split(':');
      if (parts.length != 2) return time24;

      int hour = int.tryParse(parts[0]) ?? 0;
      int minute = int.tryParse(parts[1]) ?? 0;

      if (hour < 0 || hour > 23 || minute < 0 || minute > 59) {
        return time24;
      }

      String period = hour >= 12 ? 'PM' : 'AM';
      int hour12 = hour == 0 ? 12 : (hour > 12 ? hour - 12 : hour);
      String minuteStr = minute.toString().padLeft(2, '0');

      return '$hour12:$minuteStr $period';
    } catch (e) {
      return time24;
    }
  }

  Future<void> _loadData() async {
    // Use widget parameters if available, otherwise use defaults
    _fromCity = widget.fromCity ?? 'Unknown';
    _toCity = widget.toCity ?? 'Unknown';
    _selectedSeatsObjects = widget.selectedSeatsObjects ?? [];
    _busName = widget.busName ?? 'Unknown Bus';
    _travelDate = widget.travelDate ?? 'Date not specified';
    _departureTime = _convertTo12HourFormat(widget.departureTime ?? '--:--');
    _arrivalTime = _convertTo12HourFormat(widget.arrivalTime ?? '--:--');
    _fare = widget.fare ?? 0.0;
    _selectedSeats = widget.selectedSeats ?? [];
    _boardingPoint = widget.boardingPoint ?? 'Not selected';
    _droppingPoint = widget.droppingPoint ?? 'Not selected';
    _traceId = widget.traceId ?? '';
    _resultIndex = widget.resultIndex ?? 0;
    _boardingPointId = widget.boardingPointId ?? '';
    _droppingPointId = widget.droppingPointId ?? '';

    // If no seats selected, default to 1
    if (_selectedSeats.isEmpty) {
      _selectedSeats = ['1'];
    }
  }

  Future<void> _loadUserData() async {
    if (_loginController != null && _loginController!.userData.isNotEmpty) {
      final userData = _loginController!.userData;
      _userName = userData['name']?.toString() ?? '';
      _userEmail = userData['email']?.toString() ?? '';
      _userPhone = userData['phoneNumber']?.toString() ??
          userData['phone']?.toString() ??
          '';

      // Auto-populate contact fields
      if (_userEmail.isNotEmpty && _emailController.text.isEmpty) {
        _emailController.text = _userEmail;
      }
      if (_userPhone.isNotEmpty && _phoneController.text.isEmpty) {
        _phoneController.text = _userPhone;
      }
    }
  }

  void _initializeFormControllers() {
    // Initialize ID proof types
    _idProofTypes = [
      'Aadhaar',
      'Passport',
      'Driving License',
      'Voter ID',
      'PAN Card'
    ];

    // Initialize controllers and gender selections
    int passengerCount = _selectedSeats.length;

    _nameControllers =
        List.generate(passengerCount, (_) => TextEditingController());
    _ageControllers =
        List.generate(passengerCount, (_) => TextEditingController());
    _idNumberControllers =
        List.generate(passengerCount, (_) => TextEditingController());
    _genderSelections = List.generate(
        passengerCount, (_) => [false, false, false]); // Male, Female, Other
    _selectedIdProofTypes = List.filled(passengerCount, 'Aadhaar');

    // Auto-fill first passenger name if user is logged in
    if (_userName.isNotEmpty && _nameControllers.isNotEmpty) {
      _nameControllers[0].text = _userName;
    }

    // Add listeners for form validation
    _emailController.addListener(_validateForm);
    _phoneController.addListener(_validateForm);
    for (final controller in _nameControllers) {
      controller.addListener(_validateForm);
    }
    for (final controller in _ageControllers) {
      controller.addListener(_validateForm);
    }
    for (final controller in _idNumberControllers) {
      controller.addListener(_validateForm);
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _specialRequirementsController.dispose();
    for (var controller in _nameControllers) {
      controller.dispose();
    }
    for (var controller in _ageControllers) {
      controller.dispose();
    }
    for (var controller in _idNumberControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  bool _isTravellerComplete(Map<String, dynamic> traveller) {
    final name = traveller['passengerName'] ?? traveller['firstname'] ?? '';
    final age = traveller['passengerAge'] ?? traveller['age'];
    final gender = traveller['passengerGender'] ?? traveller['gender'];
    final mobile = traveller['passengerMobileNumber'] ??
        traveller['mobile'] ??
        traveller['phone'] ??
        '';
    final email = traveller['contact_email'] ?? traveller['email'] ?? '';
    final address = traveller['address'] ?? '';

    // Check if all mandatory fields are present and valid
    bool hasName = name.toString().trim().isNotEmpty && name != 'Unknown';
    bool hasAge = age != null &&
        (age is int ? age > 0 : (int.tryParse(age.toString()) ?? 0) > 0);
    bool hasGender = gender != null && gender.toString().trim().isNotEmpty;
    bool hasMobile = mobile.toString().trim().isNotEmpty &&
        mobile != '0000000000' &&
        mobile.toString().replaceAll(RegExp(r'[^\d]'), '').length >= 10;
    bool hasEmail = email.toString().trim().isNotEmpty &&
        GetUtils.isEmail(email.toString().trim());
    bool hasAddress = address.toString().trim().isNotEmpty;

    return hasName &&
        hasAge &&
        hasGender &&
        hasMobile &&
        hasEmail &&
        hasAddress;
  }

  List<String> _getMissingFields(Map<String, dynamic> traveller) {
    final missing = <String>[];
    final name = traveller['passengerName'] ?? traveller['firstname'] ?? '';
    final age = traveller['passengerAge'] ?? traveller['age'];
    final gender = traveller['passengerGender'] ?? traveller['gender'];
    final mobile = traveller['passengerMobileNumber'] ??
        traveller['mobile'] ??
        traveller['phone'] ??
        '';
    final email = traveller['contact_email'] ?? traveller['email'] ?? '';
    final address = traveller['address'] ?? '';

    if (name.toString().trim().isEmpty || name == 'Unknown')
      missing.add('Name');
    if (age == null ||
        (age is int ? age <= 0 : (int.tryParse(age.toString()) ?? 0) <= 0))
      missing.add('Age');
    if (gender == null || gender.toString().trim().isEmpty)
      missing.add('Gender');
    if (mobile.toString().trim().isEmpty ||
        mobile == '0000000000' ||
        mobile.toString().replaceAll(RegExp(r'[^\d]'), '').length < 10)
      missing.add('Mobile');
    if (email.toString().trim().isEmpty ||
        !GetUtils.isEmail(email.toString().trim())) missing.add('Email');
    if (address.toString().trim().isEmpty) missing.add('Address');

    return missing;
  }

  void _validateForm() {
    bool isValid = _formKey.currentState?.validate() ?? false;

    // Also validate selected travellers have all mandatory fields
    if (selectedTravellers.isNotEmpty) {
      final travellers = travellerController.travellers;
      for (final travellerName in selectedTravellers) {
        final traveller = travellers.firstWhere(
          (t) =>
              (t['passengerName'] ?? t['firstname'] ?? 'Unknown') ==
              travellerName,
          orElse: () => <String, dynamic>{},
        );
        if (traveller.isNotEmpty && !_isTravellerComplete(traveller)) {
          isValid = false;
          break;
        }
      }
    }

    if (_isFormValid != isValid) {
      setState(() {
        _isFormValid = isValid;
      });
    }
  }

  Future<void> _onProceed() async {
    if (!_formKey.currentState!.validate()) {
      HapticFeedback.heavyImpact();
      Get.snackbar(
        'Error',
        'Please fill all required fields correctly.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppTheme.AppColors.redCA0,
        colorText: Colors.white,
        borderRadius: 12,
        margin: const EdgeInsets.all(16),
        icon: const Icon(Icons.error_outline, color: Colors.white),
        duration: const Duration(seconds: 2),
      );
      return;
    }

    // Validate selected travellers have all mandatory fields
    if (selectedTravellers.isNotEmpty) {
      final travellers = travellerController.travellers;
      final incompleteTravellers = <String>[];

      for (final travellerName in selectedTravellers) {
        final traveller = travellers.firstWhere(
          (t) =>
              (t['passengerName'] ?? t['firstname'] ?? 'Unknown') ==
              travellerName,
          orElse: () => <String, dynamic>{},
        );
        if (traveller.isNotEmpty && !_isTravellerComplete(traveller)) {
          incompleteTravellers.add(travellerName);
        }
      }

      if (incompleteTravellers.isNotEmpty) {
        HapticFeedback.heavyImpact();
        Get.snackbar(
          'Incomplete Traveller Details',
          'Please complete all mandatory fields (Name, Age, Gender, Mobile, Email, Address) for selected travellers or edit them before proceeding.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.orange,
          colorText: Colors.white,
          borderRadius: 12,
          margin: const EdgeInsets.all(16),
          icon: const Icon(Icons.warning_amber_rounded, color: Colors.white),
          duration: const Duration(seconds: 4),
        );
        return;
      }
    }

    // Validate required booking parameters
    if (_traceId.isEmpty ||
        _resultIndex == 0 ||
        _boardingPointId.isEmpty ||
        _droppingPointId.isEmpty) {
      HapticFeedback.heavyImpact();
      Get.snackbar(
        'Error',
        'Missing booking information. Please go back and select seats again.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppTheme.AppColors.redCA0,
        colorText: Colors.white,
        borderRadius: 12,
        margin: const EdgeInsets.all(16),
        icon: const Icon(Icons.error_outline, color: Colors.white),
        duration: const Duration(seconds: 3),
      );
      return;
    }

    HapticFeedback.mediumImpact();

    try {
      // STEP 1: Prepare passenger data
      print('\n═══════════════════════════════════════════════════════════');
      print('🚌 BUS BOOKING FLOW STARTED');
      print('═══════════════════════════════════════════════════════════');
      print('📋 STEP 1: Preparing Passenger Data');

      final List<Map<String, dynamic>> passengers = _preparePassengerData();
      if (passengers.isEmpty) {
        throw Exception('Failed to prepare passenger data');
      }

      print('   ✅ Prepared ${passengers.length} passenger(s)');
      print('');

      // STEP 2: Store booking data for later use
      _storedContactDetails = {
        'email': _emailController.text.trim().isNotEmpty
            ? _emailController.text.trim()
            : _userEmail.isNotEmpty
                ? _userEmail
                : 'guest@example.com',
        'mobile': _phoneController.text.trim().isNotEmpty
            ? _phoneController.text.trim()
            : _userPhone.isNotEmpty
                ? _userPhone
                : '0000000000',
        'fromCityName': _fromCity,
        'toCityName': _toCity,
      };

      _storedAddressDetails = {
        'address': '', // Bus booking may not require full address
        'city': _fromCity,
        'state': '',
        'pincode': '',
      };

      _storedTravelerDetails = {};
      for (int i = 0; i < passengers.length; i++) {
        final seatLabel = _selectedSeats[i];
        _storedTravelerDetails![seatLabel] = {
          'firstName': passengers[i]['FirstName'],
          'lastName': passengers[i]['LastName'],
          'age': passengers[i]['Age'],
          'gender': passengers[i]['Gender'],
          'email': _storedContactDetails!['email'],
          'mobile': _storedContactDetails!['mobile'],
          'idType': passengers[i]['IdType'],
          'idNumber': passengers[i]['IdNumber'],
        };
      }

      _storedFareDetails = {
        'baseFare': _fare,
        'total': (_fare * _selectedSeats.length) +
            (_tripProtectionEnabled ? (109 * _selectedSeats.length) : 0),
        'tripProtection':
            _tripProtectionEnabled ? (109 * _selectedSeats.length) : 0,
      };

      _storedBusData = {
        'bus_id': null, // Will be set after booking
        'TravelName': _busName,
        'BusType': 'Bus',
        'Origin': _fromCity,
        'Destination': _toCity,
        'DepartureTime': widget.departureTime ?? '',
        'ArrivalTime': widget.arrivalTime ?? '',
        'total_seats': 0,
        'AvailableSeats': 0,
      };

      // STEP 3: Block seats before payment
      print('📋 STEP 2: Blocking Bus Seats');
      print('   🔄 Calling block API...');

      if (_busController == null) {
        throw Exception('BusController not available');
      }

      final blockResponse = await _busController!.blockBus(
        traceId: _traceId,
        resultIndex: _resultIndex,
        boardingPointId: _boardingPointId,
        droppingPointId: _droppingPointId,
        passengers: passengers,
      );

      if (blockResponse == null) {
        throw Exception('Failed to block bus seats');
      }

      _blockResponse = blockResponse;
      print('   ✅ Seats blocked successfully');
      print('');

      // STEP 4: Proceed to payment
      print('📋 STEP 3: Initiating Payment');
      final totalAmount = (_fare * _selectedSeats.length) +
          (_tripProtectionEnabled ? (109 * _selectedSeats.length) : 0);

      print('   💰 Payment Amount: ₹$totalAmount');
      print('   🔄 Opening payment gateway...');
      print('');

      if (!mounted) return;

      await Get.to(
        () => EasebuzzPaymentWidget(
          amount: totalAmount,
          name: _nameControllers.isNotEmpty &&
                  _nameControllers[0].text.trim().isNotEmpty
              ? _nameControllers[0].text.trim()
              : _userName.isNotEmpty
                  ? _userName
                  : 'Guest',
          email: _emailController.text.trim().isNotEmpty
              ? _emailController.text.trim()
              : _userEmail.isNotEmpty
                  ? _userEmail
                  : 'guest@example.com',
          phone: _phoneController.text.trim().isNotEmpty
              ? _phoneController.text.trim()
              : _userPhone.isNotEmpty
                  ? _userPhone
                  : '0000000000',
          productInfo: 'Bus Ticket - $_busName',
          onSuccess: () async {
            print('\n');
            print(
                '═══════════════════════════════════════════════════════════');
            print('💳 PAYMENT SUCCESSFUL');
            print(
                '═══════════════════════════════════════════════════════════');
            print('📅 Timestamp: ${DateTime.now().toIso8601String()}');
            print('');
            // Call complete booking after successful payment
            await _completeBooking();
          },
          onFailure: () {
            print('\n');
            print(
                '═══════════════════════════════════════════════════════════');
            print('❌ PAYMENT FAILED');
            print(
                '═══════════════════════════════════════════════════════════');
            print('📅 Timestamp: ${DateTime.now().toIso8601String()}');
            print('');

            // Clear stored data on payment failure
            _blockResponse = null;
            _storedBusData = null;
            _storedContactDetails = null;
            _storedAddressDetails = null;
            _storedTravelerDetails = null;
            _storedFareDetails = null;

            Get.snackbar(
              'Payment Failed',
              'Payment was not successful. Please try again.',
              snackPosition: SnackPosition.BOTTOM,
              backgroundColor: AppTheme.AppColors.redCA0,
              colorText: Colors.white,
              borderRadius: 12,
              margin: const EdgeInsets.all(16),
              icon: const Icon(Icons.error_outline, color: Colors.white),
              duration: const Duration(seconds: 4),
            );
          },
        ),
        transition: Transition.rightToLeft,
        duration: const Duration(milliseconds: 300),
      );
    } catch (e) {
      print('❌ Error in booking flow: $e');
      Get.snackbar(
        'Error',
        'An error occurred: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppTheme.AppColors.redCA0,
        colorText: Colors.white,
        borderRadius: 12,
        margin: const EdgeInsets.all(16),
        icon: const Icon(Icons.error_outline, color: Colors.white),
        duration: const Duration(seconds: 4),
      );
    }
  }

  List<Map<String, dynamic>> _preparePassengerData() {
    final List<Map<String, dynamic>> passengers = [];
    final travellers = travellerController.travellers;

    // Ensure we create a passenger for each selected seat
    for (int i = 0; i < _selectedSeats.length; i++) {
      // Get and validate name
      final name = _nameControllers[i].text.trim();
      if (name.isEmpty) {
        throw Exception('Passenger ${i + 1} name is required');
      }

      final nameParts = name.split(' ');
      final firstName = nameParts.isNotEmpty ? nameParts[0] : name;
      final lastName =
          nameParts.length > 1 ? nameParts.sublist(1).join(' ') : '';

      // Validate and get age
      final ageText = _ageControllers[i].text.trim();
      if (ageText.isEmpty) {
        throw Exception('Passenger ${i + 1} age is required');
      }
      final age = int.tryParse(ageText);
      if (age == null || age <= 0 || age > 120) {
        throw Exception('Passenger ${i + 1} has invalid age');
      }

      // Validate and get gender
      final genderIndex =
          _genderSelections[i].indexWhere((selected) => selected);
      if (genderIndex == -1) {
        throw Exception('Passenger ${i + 1} gender is required');
      }
      // Convert genderIndex to integer: 0 (Male) -> 1, 1 (Female) -> 0
      final genderValue = genderIndex == 0 ? 1 : (genderIndex == 1 ? 0 : 1);
      // Keep genderCode as string for comparison with traveler data
      final genderCode =
          genderIndex == 0 ? 'M' : (genderIndex == 1 ? 'F' : 'M');

      // Get contact details (required)
      final phone = _phoneController.text.trim().isNotEmpty
          ? _phoneController.text.trim()
          : _userPhone.isNotEmpty
              ? _userPhone
              : '';
      if (phone.isEmpty) {
        throw Exception('Contact phone number is required');
      }

      final email = _emailController.text.trim().isNotEmpty
          ? _emailController.text.trim()
          : _userEmail.isNotEmpty
              ? _userEmail
              : '';
      if (email.isEmpty || !GetUtils.isEmail(email)) {
        throw Exception('Valid contact email is required');
      }

      // Try to find matching traveler and get passengerId
      int? passengerId;
      try {
        final matchingTraveller = travellers.firstWhere(
          (t) {
            final travellerName =
                (t['passengerName'] ?? t['firstname'] ?? '').toString().trim();
            final travellerAge = t['passengerAge'] ?? t['age'];
            final travellerAgeNum = travellerAge is int
                ? travellerAge
                : int.tryParse(travellerAge.toString());
            final travellerGender = (t['passengerGender'] ?? t['gender'] ?? '')
                .toString()
                .toUpperCase();
            final travellerPhone =
                (t['passengerMobileNumber'] ?? t['mobile'] ?? '')
                    .toString()
                    .trim();

            // Match by name, age, gender, and phone
            return travellerName.toLowerCase() == name.toLowerCase() &&
                travellerAgeNum == age &&
                (travellerGender == genderCode || travellerGender.isEmpty) &&
                (travellerPhone == phone || travellerPhone.isEmpty);
          },
          orElse: () => <String, dynamic>{},
        );

        if (matchingTraveller.isNotEmpty) {
          final travellerPassengerId =
              matchingTraveller['passengerId'] ?? matchingTraveller['id'];
          if (travellerPassengerId != null) {
            passengerId = travellerPassengerId is int
                ? travellerPassengerId
                : int.tryParse(travellerPassengerId.toString());
            if (passengerId != null) {
              print(
                  '✅ Passenger ${i + 1}: Found matching traveler with passengerId: $passengerId');
            }
          }
        }
      } catch (e) {
        print(
            'ℹ️ Passenger ${i + 1}: No matching traveler found, will use index: $e');
      }

      // Get ID details (optional)
      final idType =
          _selectedIdProofTypes[i].isNotEmpty ? _selectedIdProofTypes[i] : null;
      final idNumber = _idNumberControllers[i].text.trim().isNotEmpty
          ? _idNumberControllers[i].text.trim()
          : null;

      // Get seat information - ensure it's a valid string
      final seatNameRaw = _selectedSeats[i];
      String seatName = seatNameRaw.toString();

      // Validate seat name is not empty or invalid
      if (seatName.isEmpty ||
          seatName == 'null' ||
          seatName.contains('Instance of') ||
          seatName.trim().isEmpty) {
        throw Exception('Passenger ${i + 1} seat name is invalid: $seatName');
      }

      // Clean up seat name (remove any extra whitespace)
      seatName = seatName.trim();

      // Calculate SeatIndex - the API expects this to match the actual seat index from layout
      // For seats like "2-1", calculate as: (row * 1000) + col
      // For simple numbers like "3", use the number directly
      final seatIndex = _parseSeatIndex(seatName);

      print('🔍 Passenger ${i + 1} Seat Info:');
      print('   SeatName: $seatName');
      print('   SeatIndex: $seatIndex');

      // Create passenger object with all required fields
      // IMPORTANT: The API expects specific data types and structure
      // - All numeric fields must be numbers (not strings)
      // - SeatIndex must be an integer matching the actual seat index from layout
      // - Gender must be an integer (1 for Male, 0 for Female)
      final passenger = <String, dynamic>{
        'FirstName': firstName,
        'LastName': lastName.isNotEmpty
            ? lastName
            : firstName, // Use firstName as lastName if empty
        'Age': age, // Integer
        'Gender': genderValue, // Integer: 1 for Male, 0 for Female
        'Phoneno': phone, // String
        'Email': email, // String
        'Seat': <String, dynamic>{
          'SeatIndex':
              seatIndex, // Integer - must match actual seat index from layout
          'SeatName': seatName, // String
          'SeatType':
              'Seater', // String - Default, can be updated from seat layout
          'SeatStatus': 'Available', // String
          'PublishedPrice': _fare.toDouble(), // Double/Number (not string)
          'SeatFare': _fare.toDouble(), // Double/Number (not string)
        },
      };

      // If we have full seat object details, use them to populate Price and other fields
      if (_selectedSeatsObjects.isNotEmpty &&
          i < _selectedSeatsObjects.length) {
        final seatObj = _selectedSeatsObjects[i];
        if (seatObj is Seat) {
          passenger['Seat']['SeatType'] =
              seatObj.isSleeper ? 'Sleeper' : 'Seater';
          passenger['Seat']['SeatStatus'] =
              seatObj.isAvailable ? 'Available' : 'Booked';

          // Use price from seat object if available
          if (seatObj.price > 0) {
            passenger['Seat']['PublishedPrice'] = seatObj.price;
            passenger['Seat']['SeatFare'] = seatObj.price;
          }

          // Add Price object if available
          if (seatObj.priceMap.isNotEmpty) {
            passenger['Seat']['Price'] = seatObj.priceMap;
          }
        } else if (seatObj is Map<String, dynamic>) {
          // Handle if it's a Map
          if (seatObj.containsKey('SeatType'))
            passenger['Seat']['SeatType'] = seatObj['SeatType'];
          if (seatObj.containsKey('SeatStatus'))
            passenger['Seat']['SeatStatus'] = seatObj['SeatStatus'];
          if (seatObj.containsKey('Price'))
            passenger['Seat']['Price'] = seatObj['Price'];
        }
      }

      // Add passengerId if found from traveler data
      if (passengerId != null) {
        passenger['PassengerId'] = passengerId;
        passenger['passengerId'] = passengerId;
        passenger['id'] = passengerId;
        print('   PassengerId: $passengerId (from traveler data)');
      } else {
        print(
            '   PassengerId: Not found in traveler data, will use index in blockBus');
      }

      print('📝 Passenger ${i + 1} Data:');
      print('   FirstName: ${passenger['FirstName']}');
      print('   LastName: ${passenger['LastName']}');
      print('   Age: ${passenger['Age']} (${passenger['Age'].runtimeType})');
      print(
          '   Gender: ${passenger['Gender']} (${passenger['Gender'].runtimeType})');
      print('   Phoneno: ${passenger['Phoneno']}');
      print('   Email: ${passenger['Email']}');
      print(
          '   Seat.SeatIndex: ${passenger['Seat']['SeatIndex']} (${passenger['Seat']['SeatIndex'].runtimeType})');
      print('   Seat.SeatName: ${passenger['Seat']['SeatName']}');
      print(
          '   Seat.PublishedPrice: ${passenger['Seat']['PublishedPrice']} (${passenger['Seat']['PublishedPrice'].runtimeType})');
      print(
          '   Seat.SeatFare: ${passenger['Seat']['SeatFare']} (${passenger['Seat']['SeatFare'].runtimeType})');

      // Add ID details only if both are provided (optional)
      if (idType != null &&
          idType.isNotEmpty &&
          idNumber != null &&
          idNumber.isNotEmpty) {
        passenger['IdType'] = idType;
        passenger['IdNumber'] = idNumber;
      }

      passengers.add(passenger);
    }

    // Ensure we have the same number of passengers as seats
    if (passengers.length != _selectedSeats.length) {
      throw Exception(
          'Number of passengers (${passengers.length}) does not match number of seats (${_selectedSeats.length})');
    }

    return passengers;
  }

  int _parseSeatIndex(String seatName) {
    // First check if we have the seat object stored to get the exact SeatIndex
    if (_selectedSeatsObjects.isNotEmpty) {
      for (var seatObj in _selectedSeatsObjects) {
        if (seatObj is Seat && seatObj.seatName == seatName) {
          // Seat object doesn't store original SeatIndex directly in properties shown in Seat class
          // But we added rawJson, so we can check that
          if (seatObj.rawJson.containsKey('SeatIndex')) {
            final idx = seatObj.rawJson['SeatIndex'];
            if (idx is int) return idx;
            if (idx is String) return int.tryParse(idx) ?? 1;
          }
        } else if (seatObj is Map &&
            (seatObj['SeatName'] == seatName ||
                seatObj['seatName'] == seatName)) {
          if (seatObj.containsKey('SeatIndex')) {
            final idx = seatObj['SeatIndex'];
            if (idx is int) return idx;
            if (idx is String) return int.tryParse(idx) ?? 1;
          }
        }
      }
    }

    // Try to parse seat name like "2-1" or "1" to integer
    // The API expects SeatIndex as an integer
    // For seats like "2-1", convert to format: row * 1000 + col
    if (seatName.contains('-')) {
      final parts = seatName.split('-');
      if (parts.length == 2) {
        final row = int.tryParse(parts[0]) ?? 0;
        final col = int.tryParse(parts[1]) ?? 0;
        // Calculate SeatIndex: row * 1000 + col (e.g., 2-1 becomes 2001)
        return (row * 1000) + col;
      }
    }
    // For simple seat numbers, try to parse directly
    final parsed = int.tryParse(seatName);
    if (parsed != null && parsed > 0) {
      return parsed;
    }
    // Fallback: if seat name is just a number, use it
    // Otherwise default to 1
    return 1;
  }

  Future<void> _completeBooking() async {
    try {
      print('📋 STEP 4: Completing Bus Booking');
      print('   🔄 Calling book API...');

      if (_busController == null || _blockResponse == null) {
        throw Exception('Missing required data for booking');
      }

      // Prepare passenger data again for booking
      final passengers = _preparePassengerData();

      // STEP 5: Book the bus
      final bookResponse = await _busController!.bookBus(
        traceId: _traceId,
        resultIndex: _resultIndex,
        boardingPointId: _boardingPointId,
        droppingPointId: _droppingPointId,
        passengers: passengers,
      );

      if (bookResponse == null) {
        throw Exception('Failed to book bus');
      }

      print('   ✅ Bus booked successfully');

      // Extract BusId from response
      final busId = bookResponse['BookResult']?['BusId']?.toString() ?? '';
      if (busId.isNotEmpty && _storedBusData != null) {
        _storedBusData!['bus_id'] = busId;
      }

      print('');

      // STEP 6: Save booking to database
      print('📋 STEP 5: Saving Booking to Database');
      print('   🔄 Saving booking with payment transaction...');

      final userId = _loginController?.userData['user_id'] ??
          _loginController?.userData['userId'] ??
          null;

      // Get payment transaction details (if available from payment widget)
      // Note: In a real implementation, you'd get this from the payment callback
      final bookingData = await _busController!.createBusBooking(
        userId: userId != null ? int.tryParse(userId.toString()) : null,
        busData: _storedBusData ?? {},
        blockData: _blockResponse!,
        contactDetails: _storedContactDetails ?? {},
        addressDetails: _storedAddressDetails ?? {},
        travelerDetails: _storedTravelerDetails ?? {},
        fareDetails: _storedFareDetails ?? {},
        searchResponse: _storedSearchResponse,
      );

      if (bookingData != null && bookingData['success'] == true) {
        print('   ✅ Booking saved to database successfully');
        print('      Booking ID: ${bookingData['booking_id']}');
        print('      Booking Reference: ${bookingData['booking_reference']}');
        print('');

        // STEP 7: Update booking status with payment details
        final bookingId = bookingData['booking_id']?.toString();
        if (bookingId != null) {
          // Update booking status to confirmed and payment status to paid
          await _busController!.updateBusBookingStatus(
            bookingId: bookingId,
            bookingStatus: 'Confirmed',
            paymentStatus: 'Completed',
            ticketNo: bookResponse['BookResult']?['TicketNo']?.toString(),
            travelOperatorPnr: bookResponse['BookResult']?['PNR']?.toString() ??
                bookResponse['BookResult']?['TravelOperatorPNR']?.toString(),
          );
        }

        print('═══════════════════════════════════════════════════════════');
        print('✅ BOOKING COMPLETED SUCCESSFULLY');
        print('═══════════════════════════════════════════════════════════');
        print('');

        Get.snackbar(
          'Booking Confirmed!',
          'Your bus booking has been confirmed. Booking ID: ${bookingData['booking_reference']}',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
          borderRadius: 12,
          margin: const EdgeInsets.all(16),
          icon: const Icon(Icons.check_circle, color: Colors.white),
          duration: const Duration(seconds: 5),
        );

        // Navigate back or to booking confirmation screen
        Get.back(); // Go back to previous screen
      } else {
        print('   ⚠️  WARNING: Booking confirmed but not saved to database');
        print('      💡 This should be handled by backend or retried later');
        print('');

        Get.snackbar(
          'Booking Confirmed',
          'Your bus booking is confirmed. Please note your booking reference.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.orange,
          colorText: Colors.white,
          borderRadius: 12,
          margin: const EdgeInsets.all(16),
          icon: const Icon(Icons.warning_amber_rounded, color: Colors.white),
          duration: const Duration(seconds: 4),
        );
      }
    } catch (e) {
      print('❌ Error completing booking: $e');
      print('═══════════════════════════════════════════════════════════\n');

      Get.snackbar(
        'Booking Error',
        'Payment was successful but booking confirmation failed. Please contact support with your payment reference.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orange,
        colorText: Colors.white,
        borderRadius: 12,
        margin: const EdgeInsets.all(16),
        icon: const Icon(Icons.warning_amber_rounded, color: Colors.white),
        duration: const Duration(seconds: 5),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: _buildAppBar(),
        body: _buildShimmerLoading(),
      );
    }

    if (_errorMessage != null) {
      return Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: _buildAppBar(),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline,
                size: 64,
                color: Theme.of(context)
                    .textTheme
                    .bodySmall
                    ?.color
                    ?.withOpacity(0.3),
              ),
              const SizedBox(height: 16),
              Text(
                _errorMessage!,
                style: GoogleFonts.poppins(
                  color: Theme.of(context).textTheme.bodyMedium?.color,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _errorMessage = null;
                    _initializeData();
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.AppColors.redCA0,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  'Retry',
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: _buildAppBar(),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 100),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildTripDetailsCard(),
                const SizedBox(height: 12),
                _buildContactDetailsCard(),
                const SizedBox(height: 12),
                _buildTravellersSection(),
                const SizedBox(height: 12),
                _buildPassengerDetailsCard(),
                const SizedBox(height: 12),
                _buildTripProtectionCard(),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomBar(),
    );
  }

  Widget _buildShimmerLoading() {
    return Shimmer.fromColors(
      baseColor: Theme.of(context).brightness == Brightness.dark
          ? Colors.grey[800]!
          : Colors.grey[300]!,
      highlightColor: Theme.of(context).brightness == Brightness.dark
          ? Colors.grey[700]!
          : Colors.grey[100]!,
      period: const Duration(milliseconds: 1200),
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Container(
            height: 180,
            margin: const EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          Container(
            height: 280,
            margin: const EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          Container(
            height: 400,
            margin: const EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          Container(
            height: 120,
            margin: const EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
          ),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() => AppBar(
        backgroundColor: AppTheme.AppColors.redCA0,
        foregroundColor: Colors.white,
        toolbarHeight: 85,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        leading: Container(
          margin: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.white.withOpacity(0.3), width: 1),
          ),
          child: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded,
                color: Colors.white, size: 18),
            onPressed: () => Get.back(),
            padding: EdgeInsets.zero,
          ),
        ),
        title: Text(
          'Passenger Details',
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: Colors.white,
            letterSpacing: 0.3,
          ),
        ),
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(4),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.white.withOpacity(0.1),
                  Colors.transparent,
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            height: 4,
          ),
        ),
      );

  Widget _buildCard({required Widget child}) => Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: Theme.of(context).dividerColor.withOpacity(0.1),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 8,
              spreadRadius: 0,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: child,
        ),
      );

  Widget _buildTripDetailsCard() => _buildCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              AppTheme.AppColors.redCA0,
                              AppTheme.AppColors.redCA0.withOpacity(0.8)
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.directions_bus_rounded,
                          color: Colors.white,
                          size: 22,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '$_fromCity → $_toCity',
                              style: GoogleFonts.poppins(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: Colors.black87,
                                letterSpacing: 0.1,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 2),
                            Text(
                              _busName,
                              style: GoogleFonts.poppins(
                                fontSize: 13,
                                color: Colors.black54,
                                fontWeight: FontWeight.w500,
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
                InkWell(
                  onTap: () {
                    HapticFeedback.selectionClick();
                    showModalBottomSheet(
                      context: context,
                      backgroundColor: Colors.transparent,
                      builder: (context) => _buildTripDetailsModal(),
                    );
                  },
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: AppTheme.AppColors.redCA0.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: AppTheme.AppColors.redCA0.withOpacity(0.2),
                        width: 1,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Details',
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: AppTheme.AppColors.redCA0,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Icon(
                          Icons.arrow_forward_ios_rounded,
                          size: 12,
                          color: AppTheme.AppColors.redCA0,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              height: 1,
              color: Theme.of(context).dividerColor.withOpacity(0.2),
            ),
            const SizedBox(height: 14),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppTheme.AppColors.redCA0.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.people_rounded,
                          size: 14, color: AppTheme.AppColors.redCA0),
                      const SizedBox(width: 6),
                      Text(
                        '${_selectedSeats.length} Traveller${_selectedSeats.length == 1 ? '' : 's'}',
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.AppColors.redCA0,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.grey[100]!,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.calendar_today_rounded,
                          size: 14, color: Colors.black54),
                      const SizedBox(width: 6),
                      Text(
                        _travelDate,
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Colors.black54,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.grey[100]!,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.access_time_rounded,
                          size: 14, color: Colors.black54),
                      const SizedBox(width: 6),
                      Text(
                        '$_departureTime - $_arrivalTime',
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Colors.black54,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Icon(Icons.location_on_rounded,
                    size: 16, color: Colors.black54),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    '$_boardingPoint → $_droppingPoint',
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      color: Colors.black87,
                      fontWeight: FontWeight.w500,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ],
        ),
      );

  Widget _buildTripDetailsModal() => Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 20,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Trip Details',
                  style: GoogleFonts.poppins(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: Colors.black87,
                  ),
                ),
                IconButton(
                  icon: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: Colors.grey[100]!,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.close,
                        size: 18, color: Colors.black54),
                  ),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            const SizedBox(height: 20),
            _buildModalDetailRow(
                'Route', '$_fromCity → $_toCity', Icons.route_rounded),
            const SizedBox(height: 16),
            _buildModalDetailRow('Bus', _busName, Icons.directions_bus_rounded),
            const SizedBox(height: 16),
            _buildModalDetailRow(
                'Date & Time',
                '$_travelDate | $_departureTime - $_arrivalTime',
                Icons.calendar_today_rounded),
            const SizedBox(height: 16),
            _buildModalDetailRow('Boarding & Dropping',
                '$_boardingPoint → $_droppingPoint', Icons.location_on_rounded),
            const SizedBox(height: 16),
            _buildModalDetailRow(
                'Seats', _selectedSeats.join(', '), Icons.event_seat_rounded),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppTheme.AppColors.redCA0.withOpacity(0.1),
                    AppTheme.AppColors.redCA0.withOpacity(0.05),
                  ],
                ),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: AppTheme.AppColors.redCA0.withOpacity(0.2),
                  width: 1,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Total Fare',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Colors.black87,
                    ),
                  ),
                  Text(
                    '₹${((_fare * _selectedSeats.length) + (_tripProtectionEnabled ? (109 * _selectedSeats.length) : 0)).toStringAsFixed(0)}',
                    style: GoogleFonts.poppins(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.AppColors.redCA0,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: MediaQuery.of(context).padding.bottom + 8),
          ],
        ),
      );

  Widget _buildModalDetailRow(String label, String value, IconData icon) => Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppTheme.AppColors.redCA0.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, size: 18, color: AppTheme.AppColors.redCA0),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Colors.black54,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
        ],
      );

  Widget _buildContactDetailsCard() => _buildCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppTheme.AppColors.redCA0,
                        AppTheme.AppColors.redCA0.withOpacity(0.8)
                      ],
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.contact_mail_rounded,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Contact Details',
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Your ticket & updates will be sent here',
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          color: Colors.black54,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: _emailController,
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: Colors.black87,
              ),
              decoration: InputDecoration(
                labelText: 'Email ID',
                labelStyle: GoogleFonts.poppins(
                  color: Colors.black54,
                ),
                prefixIcon: Icon(
                  Icons.email_outlined,
                  size: 20,
                  color: AppTheme.AppColors.redCA0,
                ),
                filled: true,
                fillColor: Colors.grey[50]!,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: Theme.of(context).dividerColor.withOpacity(0.2),
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: Theme.of(context).dividerColor.withOpacity(0.2),
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: AppTheme.AppColors.redCA0,
                    width: 2,
                  ),
                ),
                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: Colors.red,
                    width: 1.5,
                  ),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: Colors.red,
                    width: 2,
                  ),
                ),
              ),
              keyboardType: TextInputType.emailAddress,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Email is required';
                }
                if (!GetUtils.isEmail(value)) {
                  return 'Enter a valid email address';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _phoneController,
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: Colors.black87,
              ),
              decoration: InputDecoration(
                labelText: 'Phone Number',
                labelStyle: GoogleFonts.poppins(
                  color: Colors.black54,
                ),
                prefixIcon: Icon(
                  Icons.phone_outlined,
                  size: 20,
                  color: AppTheme.AppColors.redCA0,
                ),
                filled: true,
                fillColor: Colors.grey[50]!,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: Theme.of(context).dividerColor.withOpacity(0.2),
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: Theme.of(context).dividerColor.withOpacity(0.2),
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: AppTheme.AppColors.redCA0,
                    width: 2,
                  ),
                ),
                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: Colors.red,
                    width: 1.5,
                  ),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: Colors.red,
                    width: 2,
                  ),
                ),
              ),
              keyboardType: TextInputType.phone,
              maxLength: 10,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Phone number is required';
                }
                if (!GetUtils.isPhoneNumber(value) || value.length != 10) {
                  return 'Enter a valid 10-digit phone number';
                }
                return null;
              },
            ),
          ],
        ),
      );

  Widget _buildTravellersSection() => Obx(() {
        // Get ADDITIONAL GUESTS from TRAVELLERS table
        final travellers = travellerController.travellers;

        return _buildCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Saved Travellers (Optional)',
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Select from saved travellers or add new (${selectedTravellers.length} selected)',
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            color: Colors.black54,
                            fontWeight: FontWeight.normal,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          _showAddGuestForm = !_showAddGuestForm;
                        });
                      },
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: AppTheme.AppColors.redCA0.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                              color: AppTheme.AppColors.redCA0, width: 1),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              _showAddGuestForm ? Icons.close : Icons.add,
                              color: AppTheme.AppColors.redCA0,
                              size: 16,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              _showAddGuestForm ? 'Cancel' : 'Add Guest',
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w500,
                                fontSize: 12,
                                color: AppTheme.AppColors.redCA0,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () => Get.to(() => TravellerDetailScreen(
                            travelType: TravelType.bus,
                          )),
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.blue.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.blue, width: 1),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.people_outline,
                                color: Colors.blue, size: 16),
                            const SizedBox(width: 4),
                            Text(
                              'Manage',
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w500,
                                fontSize: 12,
                                color: Colors.blue,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Add Guest Form (expandable)
              if (_showAddGuestForm) ...[
                Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppTheme.AppColors.redCA0.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: AppTheme.AppColors.redCA0.withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TravellerFormWidget(
                        config: _addGuestConfig,
                        formKey: _addGuestFormKey,
                        widgetKey: _addGuestFormWidgetKey,
                        onSaved: (data) {
                          _savedGuestFormData = data;
                        },
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            onPressed: () {
                              setState(() {
                                _showAddGuestForm = false;
                                _addGuestFormKey.currentState?.reset();
                                _savedGuestFormData = null;
                              });
                            },
                            child: const Text('Cancel'),
                          ),
                          const SizedBox(width: 8),
                          ElevatedButton(
                            onPressed: () async {
                              // Use post-frame callback to ensure widget is built
                              await Future.microtask(() {});

                              if (!_addGuestFormKey.currentState!.validate()) {
                                return;
                              }

                              // Save the form first to ensure state is updated
                              _addGuestFormKey.currentState?.save();

                              // Try to get form data from widget state (primary method)
                              Map<String, dynamic>? formData;
                              final widgetState =
                                  _addGuestFormWidgetKey.currentState;

                              if (widgetState != null) {
                                formData = widgetState.getFormData();
                                if (formData.isNotEmpty) {
                                  _savedGuestFormData = formData;
                                }
                              } else {
                                formData = _savedGuestFormData;
                              }

                              if (formData != null && formData.isNotEmpty) {
                                try {
                                  // Prepare data for controller
                                  final name = formData['name'] ??
                                      formData['passengerName'] ??
                                      '';
                                  final age = formData['age']?.toString() ?? '';
                                  final gender = formData['gender'] ??
                                      formData['passengerGender'];
                                  final mobile = formData['mobile'] ??
                                      formData['phone'] ??
                                      formData['passengerMobileNumber'] ??
                                      '';
                                  final email = formData['email'] ?? '';
                                  final address = formData['address'] ?? '';
                                  // Note: ID number and ID proof type are stored in the traveller record
                                  // but the saveTravellerDetails method doesn't currently support them
                                  // They will be saved when the traveller is used in actual booking

                                  // Validate required fields for bus
                                  if (name.isEmpty) {
                                    Get.snackbar(
                                      'Error',
                                      'Name is required',
                                      backgroundColor: Colors.red,
                                      colorText: Colors.white,
                                    );
                                    return;
                                  }

                                  if (age.isEmpty) {
                                    Get.snackbar(
                                      'Error',
                                      'Age is required',
                                      backgroundColor: Colors.red,
                                      colorText: Colors.white,
                                    );
                                    return;
                                  }

                                  final ageNum = int.tryParse(age);
                                  if (ageNum == null || ageNum < 0) {
                                    Get.snackbar(
                                      'Error',
                                      'Please enter a valid age',
                                      backgroundColor: Colors.red,
                                      colorText: Colors.white,
                                    );
                                    return;
                                  }

                                  if (mobile.isEmpty) {
                                    Get.snackbar(
                                      'Error',
                                      'Mobile number is required',
                                      backgroundColor: Colors.red,
                                      colorText: Colors.white,
                                    );
                                    return;
                                  }

                                  if (email.isEmpty) {
                                    Get.snackbar(
                                      'Error',
                                      'Email is required',
                                      backgroundColor: Colors.red,
                                      colorText: Colors.white,
                                    );
                                    return;
                                  }

                                  if (address.isEmpty) {
                                    Get.snackbar(
                                      'Error',
                                      'Address is required',
                                      backgroundColor: Colors.red,
                                      colorText: Colors.white,
                                    );
                                    return;
                                  }

                                  // Save the new traveller
                                  await travellerController
                                      .saveTravellerDetails(
                                    name: name,
                                    age: age,
                                    gender: gender,
                                    mobile: mobile,
                                    berthPreference: '',
                                    foodPreference: '',
                                  );

                                  // Refresh travellers list
                                  await travellerController.fetchTravelers();

                                  // Reset form and hide
                                  if (mounted) {
                                    _addGuestFormKey.currentState?.reset();
                                    _savedGuestFormData = null;
                                    setState(() {
                                      _showAddGuestForm = false;
                                    });

                                    Get.snackbar(
                                      'Success',
                                      'Guest added successfully',
                                      backgroundColor: Colors.green,
                                      colorText: Colors.white,
                                      duration: const Duration(seconds: 2),
                                    );
                                  }
                                } catch (e) {
                                  if (mounted) {
                                    Get.snackbar(
                                      'Error',
                                      'Failed to add guest: ${e.toString()}',
                                      backgroundColor: Colors.red,
                                      colorText: Colors.white,
                                    );
                                  }
                                }
                              } else {
                                Get.snackbar(
                                  'Error',
                                  'Please fill in all required fields',
                                  backgroundColor: Colors.red,
                                  colorText: Colors.white,
                                );
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppTheme.AppColors.redCA0,
                              foregroundColor: Colors.white,
                            ),
                            child: const Text('Add Guest'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],

              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.blue[50]?.withOpacity(0.5) ??
                      Colors.blue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                      color: Colors.blue[200] ?? Colors.blue, width: 1),
                ),
                child: Row(
                  children: [
                    Icon(Icons.info_outline, size: 16, color: Colors.blue[700]),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'You can select saved travellers to auto-fill passenger details below, or add new travellers to your saved list.',
                        style: GoogleFonts.poppins(
                          fontSize: 11,
                          color: Colors.blue[900],
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              if (travellers.isEmpty)
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  alignment: Alignment.center,
                  child: Column(
                    children: [
                      Icon(Icons.person_add_alt_1_outlined,
                          size: 40, color: Colors.grey.withOpacity(0.5)),
                      const SizedBox(height: 8),
                      Text(
                        'No saved travellers yet',
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'You can add travellers or fill passenger details manually',
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.normal,
                          fontSize: 12,
                          color: Colors.grey[500],
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                )
              else
                ...travellers.map((traveller) {
                  final name = traveller['passengerName'] ??
                      traveller['firstname'] ??
                      'Unknown';
                  final age = traveller['passengerAge'] ?? traveller['age'];
                  final ageNum = age != null
                      ? (age is int ? age : int.tryParse(age.toString()))
                      : null;
                  final isSelected = selectedTravellers.contains(name);
                  final isComplete = _isTravellerComplete(traveller);
                  final missingFields = _getMissingFields(traveller);

                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isSelected
                            ? (isComplete
                                ? AppTheme.AppColors.redCA0
                                : Colors.orange)
                            : Colors.grey.withOpacity(0.5),
                        width: isSelected ? 1.5 : 1,
                      ),
                      color: isSelected
                          ? (isComplete
                              ? AppTheme.AppColors.redCA0.withOpacity(0.05)
                              : Colors.orange.withOpacity(0.05))
                          : Colors.transparent,
                    ),
                    child: Column(
                      children: [
                        CheckboxListTile(
                          title: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  name,
                                  style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 15,
                                  ),
                                ),
                              ),
                              if (!isComplete && isSelected)
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: Colors.orange,
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Text(
                                    'Incomplete',
                                    style: GoogleFonts.poppins(
                                      fontSize: 10,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (ageNum != null)
                                Text(
                                  '$ageNum yrs • ${ageNum < 18 ? 'Child' : 'Adult'}',
                                  style: GoogleFonts.poppins(
                                    fontSize: 12,
                                    color: Colors.grey[600],
                                  ),
                                ),
                              if (!isComplete &&
                                  isSelected &&
                                  missingFields.isNotEmpty)
                                Padding(
                                  padding: const EdgeInsets.only(top: 4),
                                  child: Text(
                                    'Missing: ${missingFields.join(", ")}',
                                    style: GoogleFonts.poppins(
                                      fontSize: 11,
                                      color: Colors.orange[700],
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                          value: isSelected,
                          onChanged: (value) {
                            setState(() {
                              if (value == true) {
                                selectedTravellers.add(name);
                                // Auto-fill passenger form if possible
                                _fillPassengerFormFromTraveller(traveller);
                              } else {
                                selectedTravellers.remove(name);
                              }
                              _validateForm();
                            });
                          },
                          activeColor: AppTheme.AppColors.redCA0,
                        ),
                        if (!isComplete && isSelected)
                          Padding(
                            padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                onTap: () {
                                  // Navigate to edit traveller with pre-filled data
                                  final travellers =
                                      travellerController.travellers;
                                  final traveller = travellers.firstWhere(
                                    (t) =>
                                        (t['passengerName'] ??
                                            t['firstname'] ??
                                            'Unknown') ==
                                        name,
                                    orElse: () => <String, dynamic>{},
                                  );
                                  if (traveller.isNotEmpty) {
                                    Get.to(() => TravellerDetailScreen(
                                          traveller: traveller,
                                          travelType: TravelType.bus,
                                        ))?.then((_) {
                                      setState(() {
                                        travellerController.fetchTravelers();
                                        _validateForm();
                                      });
                                    });
                                  }
                                },
                                borderRadius: BorderRadius.circular(8),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 8),
                                  decoration: BoxDecoration(
                                    color: Colors.orange.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(
                                        color: Colors.orange, width: 1),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.edit,
                                          size: 16, color: Colors.orange[700]),
                                      const SizedBox(width: 6),
                                      Text(
                                        'Edit Details',
                                        style: GoogleFonts.poppins(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.orange[700],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  );
                }).toList(),
            ],
          ),
        );
      });

  void _fillPassengerFormFromTraveller(Map<String, dynamic> traveller) {
    // Find the first empty passenger slot
    for (int i = 0; i < _nameControllers.length; i++) {
      if (_nameControllers[i].text.isEmpty) {
        final name = traveller['passengerName'] ?? traveller['firstname'] ?? '';
        final age = traveller['passengerAge'] ?? traveller['age'];
        final gender = traveller['passengerGender'] ?? traveller['gender'];
        final mobile = traveller['passengerMobileNumber'] ??
            traveller['mobile'] ??
            traveller['phone'] ??
            '';
        final email = traveller['contact_email'] ?? traveller['email'] ?? '';

        if (name.isNotEmpty) {
          _nameControllers[i].text = name;
        }
        if (age != null) {
          _ageControllers[i].text = age.toString();
        }
        if (gender != null) {
          // Set gender selection
          if (gender.toString().toLowerCase().contains('male') ||
              gender == 'M') {
            _genderSelections[i] = [true, false, false];
          } else if (gender.toString().toLowerCase().contains('female') ||
              gender == 'F') {
            _genderSelections[i] = [false, true, false];
          } else {
            _genderSelections[i] = [false, false, true];
          }
        }

        // Fill contact details if available
        if (mobile.isNotEmpty &&
            mobile != '0000000000' &&
            _phoneController.text.isEmpty) {
          _phoneController.text = mobile;
        }
        if (email.isNotEmpty && _emailController.text.isEmpty) {
          _emailController.text = email;
        }
        // Note: Address validation is checked in _isTravellerComplete but not auto-filled here

        _validateForm();
        break; // Fill only one slot at a time
      }
    }
  }

  Widget _buildPassengerDetailsCard() => _buildCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppTheme.AppColors.redCA0,
                        AppTheme.AppColors.redCA0.withOpacity(0.8)
                      ],
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.people_alt_rounded,
                    color: Colors.white,
                    size: 22,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Passenger Details',
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Enter details for each passenger. All fields are mandatory.',
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          color: Colors.black54,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Container(
              height: 1,
              color: Theme.of(context).dividerColor.withOpacity(0.2),
            ),
            const SizedBox(height: 20),

            // Passenger Forms
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _selectedSeats.length,
              itemBuilder: (context, index) => TweenAnimationBuilder<double>(
                duration: Duration(milliseconds: 300 + (index * 100)),
                tween: Tween(begin: 0.0, end: 1.0),
                curve: Curves.easeOutCubic,
                builder: (context, value, child) {
                  return Transform.translate(
                    offset: Offset(0, 20 * (1 - value)),
                    child: Opacity(
                      opacity: value,
                      child: PassengerFormWidget(
                        index: index,
                        nameControllers: _nameControllers,
                        ageControllers: _ageControllers,
                        idNumberControllers: _idNumberControllers,
                        genderSelections: _genderSelections,
                        selectedIdProofTypes: _selectedIdProofTypes,
                        idProofTypes: _idProofTypes,
                        selectedSeats: _selectedSeats,
                        validateForm: _validateForm,
                        onGenderSelected: (genderIndex) {
                          void _onGenderSelected(
                              int passengerIndex, int genderIndex) {
                            HapticFeedback.selectionClick();
                            setState(() {
                              // Update the selected gender for the specific passenger
                              for (int i = 0;
                                  i < _genderSelections[passengerIndex].length;
                                  i++) {
                                _genderSelections[passengerIndex][i] =
                                    (i == genderIndex);
                              }
                            });
                          }

                          _onGenderSelected(index, genderIndex);
                          _validateForm();
                        },
                      ),
                    ),
                  );
                },
              ),
              separatorBuilder: (context, index) => const SizedBox(height: 16),
            ),
          ],
        ),
      );

  // Widget _buildPassengerForm({required int index}) => Container(
  //     margin: const EdgeInsets.only(bottom: 20),
  //     decoration: BoxDecoration(
  //       color: Colors.white,
  //       borderRadius: BorderRadius.circular(20),
  //       boxShadow: [
  //         BoxShadow(
  //           color: context.primaryColor.withOpacity(0.04),
  //           blurRadius: 12,
  //           spreadRadius: 1,
  //           offset: const Offset(0, 6),
  //         ),
  //       ],
  //     ),
  //       child: Column(
  //         crossAxisAlignment: CrossAxisAlignment.start,
  //         children: [
  //           // Passenger Header
  //           Container(
  //             padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 18),
  //             decoration: BoxDecoration(
  //               gradient: LinearGradient(
  //                 begin: Alignment.topLeft,
  //                 end: Alignment.bottomRight,
  //                 colors: [
  //                   context.primaryColor.withOpacity(0.03),
  //                   context.primaryColor.withOpacity(0.01),
  //                 ],
  //               ),
  //               borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
  //               border: Border(
  //                 bottom: BorderSide(color: context.dividerColor.withOpacity(0.2)),
  //               ),
  //             ),
  //             child: Row(
  //               mainAxisAlignment: MainAxisAlignment.center,
  //               children: [
  //                 Row(
  //                   children: [
  //                     Container(
  //                       padding: const EdgeInsets.all(6),
  //                       decoration: BoxDecoration(
  //                         color: context.primaryColor,
  //                         shape: BoxShape.circle,
  //                       ),
  //                       child: Text(
  //                         '${index + 1}',
  //                         style: const TextStyle(
  //                           color: Colors.white,
  //                           fontSize: 14,
  //                           fontWeight: FontWeight.bold,
  //                         ),
  //                       ),
  //                     ),
  //                     const SizedBox(width: 12),
  //                     Text(
  //                       'Passenger Details',
  //                       style: context.cardTitleStyle.copyWith(
  //                         fontSize: 16,
  //                         color: context.textTheme.titleLarge?.color ?? Colors.black,
  //                       ),
  //                     ),
  //                   ],
  //                 ),
  //                 Container(
  //                   padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
  //                   decoration: BoxDecoration(
  //                     color: context.primaryColor.withOpacity(0.1),
  //                     borderRadius: BorderRadius.circular(12),
  //                   ),
  //                   child: Row(
  //                     mainAxisSize: MainAxisSize.min,
  //                     children: [
  //                       Icon(Icons.event_seat_rounded,
  //                           color: context.primaryColor, size: 16),
  //                       const SizedBox(width: 6),
  //                       Text(
  //                         'Seat ${widget.selectedSeats[index]}',
  //                         style: context.bodyStyle.copyWith(
  //                           fontWeight: FontWeight.w600,
  //                           color: context.primaryColor,
  //                           fontSize: 13,
  //                         ),
  //                       ),
  //                     ],
  //                   ),
  //                 ),
  //               ],
  //             ),
  //           ),
  //           // Form Content
  //           Padding(
  //             padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
  //             child: Column(
  //               crossAxisAlignment: CrossAxisAlignment.start,
  //               children: [
  //                 // Name Field
  //                 Column(
  //                   crossAxisAlignment: CrossAxisAlignment.start,
  //                   children: [
  //                     Text(
  //                       'Full Name',
  //                       style: context.subtitleStyle.copyWith(
  //                         fontSize: 13,
  //                         color: context.textTheme.bodySmall?.color ?? Colors.grey,
  //                         fontWeight: FontWeight.w500,
  //                       ),
  //                     ),
  //                     const SizedBox(height: 8),
  //                     Container(
  //                       decoration: BoxDecoration(
  //                         borderRadius: BorderRadius.circular(14),
  //                         boxShadow: [
  //                           BoxShadow(
  //                             color: context.primaryColor.withOpacity(0.04),
  //                             blurRadius: 8,
  //                             offset: const Offset(0, 2),
  //                           ),
  //                         ],
  //                       ),
  //                       child: TextFormField(
  //                         controller: _nameControllers[index],
  //                         style: context.bodyStyle.copyWith(
  //                           fontSize: 15,
  //                           color: context.textTheme.titleLarge?.color ?? Colors.black,
  //                           height: 1.4,
  //                         ),
  //                         decoration: InputDecoration(
  //                           hintText: 'Enter full name',
  //                           hintStyle: context.bodyStyle.copyWith(
  //                             color: context.textTheme.bodySmall?.color ?? Colors.grey.withOpacity(0.7),
  //                             fontSize: 15,
  //                           ),
  //                           border: OutlineInputBorder(
  //                             borderRadius: BorderRadius.circular(14),
  //                             borderSide: BorderSide.none,
  //                           ),
  //                           enabledBorder: OutlineInputBorder(
  //                             borderRadius: BorderRadius.circular(14),
  //                             borderSide: BorderSide.none,
  //                           ),
  //                           focusedBorder: OutlineInputBorder(
  //                             borderRadius: BorderRadius.circular(14),
  //                             borderSide: BorderSide(
  //                               color: context.primaryColor,
  //                               width: 1.5,
  //                             ),
  //                           ),
  //                           contentPadding: const EdgeInsets.symmetric(
  //                             horizontal: 18,
  //                             vertical: 16,
  //                           ),
  //                           prefixIcon: Icon(
  //                             Icons.person_outline_rounded,
  //                             color: context.primaryColor,
  //                             size: 22,
  //                           ),
  //                           filled: true,
  //                           fillColor: Colors.white,
  //                         ),
  //                         validator: (value) {
  //                           if (value == null || value.isEmpty) {
  //                             return 'Name cannot be empty';
  //                           }
  //                           if (value.length < 2) {
  //                             return 'Name must be at least 2 characters';
  //                           }
  //                           return null;
  //                         },
  //                       ),
  //                     ),
  //                   ],
  //                 ),

  //                 const SizedBox(height: 20),

  //                 // Age and Gender Row
  //                 Row(
  //                   crossAxisAlignment: CrossAxisAlignment.start,
  //                   children: [
  //                     // Age Field
  //                     Expanded(
  //                       flex: 3,
  //                       child: Column(
  //                         crossAxisAlignment: CrossAxisAlignment.start,
  //                         children: [
  //                           Text(
  //                             'Age',
  //                             style: context.subtitleStyle.copyWith(
  //                               fontSize: 13,
  //                               color: context.textTheme.bodySmall?.color ?? Colors.grey,
  //                               fontWeight: FontWeight.w500,
  //                             ),
  //                           ),
  //                           const SizedBox(height: 8),
  //                           Container(
  //                             decoration: BoxDecoration(
  //                               borderRadius: BorderRadius.circular(14),
  //                               boxShadow: [
  //                                 BoxShadow(
  //                                   color: context.primaryColor.withOpacity(0.04),
  //                                   blurRadius: 8,
  //                                   offset: const Offset(0, 2),
  //                                 ),
  //                               ],
  //                             ),
  //                             child: TextFormField(
  //                               controller: _ageControllers[index],
  //                               style: context.bodyStyle.copyWith(
  //                                 fontSize: 15,
  //                                 color: context.textTheme.titleLarge?.color ?? Colors.black,
  //                                 height: 1.4,
  //                               ),
  //                               decoration: InputDecoration(
  //                                 hintText: 'Age',
  //                                 hintStyle: context.bodyStyle.copyWith(
  //                                   color: context.textTheme.bodySmall?.color ?? Colors.grey.withOpacity(0.7),
  //                                   fontSize: 15,
  //                                 ),
  //                                 border: OutlineInputBorder(
  //                                   borderRadius: BorderRadius.circular(14),
  //                                   borderSide: BorderSide.none,
  //                                 ),
  //                                 enabledBorder: OutlineInputBorder(
  //                                   borderRadius: BorderRadius.circular(14),
  //                                   borderSide: BorderSide.none,
  //                                 ),
  //                                 focusedBorder: OutlineInputBorder(
  //                                   borderRadius: BorderRadius.circular(14),
  //                                   borderSide: BorderSide(
  //                                     color: context.primaryColor,
  //                                     width: 1.5,
  //                                   ),
  //                                 ),
  //                                 contentPadding: const EdgeInsets.symmetric(
  //                                   horizontal: 18,
  //                                   vertical: 16,
  //                                 ),
  //                                 prefixIcon: Icon(
  //                                   Icons.cake_rounded,
  //                                   color: context.primaryColor,
  //                                   size: 20,
  //                                 ),
  //                                 filled: true,
  //                                 fillColor: Colors.white,
  //                                 counterText: '',
  //                               ),
  //                               keyboardType: TextInputType.number,
  //                               maxLength: 3,
  //                               onChanged: (_) => _validateForm(),
  //                               validator: (value) {
  //                                 if (value == null || value.isEmpty) {
  //                                   return 'Required';
  //                                 }
  //                                 final age = int.tryParse(value);
  //                                 if (age == null || age <= 0 || age > 120) {
  //                                   return 'Invalid age';
  //                                 }
  //                                 return null;
  //                               },
  //                             ),
  //                           ),
  //                         ],
  //                       ),
  //                     ),
  //                     const SizedBox(width: 12),
  //                     // Gender Field
  //                     Expanded(
  //                       flex: 4,
  //                       child: Column(
  //                         crossAxisAlignment: CrossAxisAlignment.start,
  //                         children: [
  //                           Text(
  //                             'Gender',
  //                             style: context.subtitleStyle.copyWith(
  //                               fontSize: 13,
  //                               color: context.textTheme.bodySmall?.color ?? Colors.grey,
  //                               fontWeight: FontWeight.w500,
  //                             ),
  //                           ),
  //                           const SizedBox(height: 8),
  //                           _GenderSelector(
  //                             isSelected: _genderSelections[index],
  //                             onPressed: (genderIndex) {
  //                               setState(() {
  //                                 for (int i = 0; i < _genderSelections[index].length; i++) {
  //                                   _genderSelections[index][i] = i == genderIndex;
  //                                 }
  //                                 _validateForm();
  //                               });
  //                             },
  //                           ),
  //                         ],
  //                       ),
  //                     ),
  //                   ],
  //                 ),
  //                 // ID Proof Section - Only show for passengers above 5 years
  //                 Builder(
  //                   builder: (context) {
  //                     final age = int.tryParse(_ageControllers[index].text);
  //                     if (age == null || age <= 5) return const SizedBox.shrink();

  //                     return Column(
  //                       crossAxisAlignment: CrossAxisAlignment.start,
  //                       children: [
  //                         const SizedBox(height: 16),
  //                         Text(
  //                           'ID Proof (Required for age 5+)',
  //                           style: context.subtitleStyle.copyWith(
  //                             fontSize: 13,
  //                             color: context.textTheme.bodySmall?.color ?? Colors.grey,
  //                             fontWeight: FontWeight.w500,
  //                           ),
  //                         ),
  //                         const SizedBox(height: 8),
  //                         Row(
  //                           children: [
  //                             // ID Type Dropdown
  //                             Expanded(
  //                               flex: 4,
  //                               child: Container(
  //                                 decoration: BoxDecoration(
  //                                   color: context.backgroundColor,
  //                                   borderRadius: BorderRadius.circular(10),
  //                                   border: Border.all(color: context.dividerColor),
  //                                 ),
  //                                 child: DropdownButtonHideUnderline(
  //                                   child: ButtonTheme(
  //                                     alignedDropdown: true,
  //                                     child: DropdownButtonFormField<String>(
  //                                       value: _selectedIdProofTypes[index],
  //                                       isExpanded: true,
  //                                       icon: Icon(Icons.keyboard_arrow_down_rounded,
  //                                           color: context.primaryColor, size: 22),
  //                                       decoration: InputDecoration(
  //                                         contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
  //                                         border: InputBorder.none,
  //                                         hintText: 'ID Type',
  //                                         hintStyle: context.bodyStyle.copyWith(
  //                                           fontSize: 15,
  //                                           color: context.textTheme.bodySmall?.color ?? Colors.grey,
  //                                         ),
  //                                         prefixIcon: Icon(Icons.badge_outlined,
  //                                             color: context.primaryColor.withOpacity(0.7), size: 20),
  //                                       ),
  //                                       style: context.bodyStyle.copyWith(
  //                                         fontSize: 15,
  //                                         color: context.textTheme.titleLarge?.color ?? Colors.black,
  //                                       ),
  //                                       dropdownColor: Colors.white,
  //                                       items: _idProofTypes.map((String type) {
  //                                         return DropdownMenuItem<String>(
  //                                           value: type,
  //                                           child: Text(
  //                                             type,
  //                                             style: context.bodyStyle.copyWith(fontSize: 15),
  //                                             overflow: TextOverflow.ellipsis,
  //                                           ),
  //                                         );
  //                                       }).toList(),
  //                                       onChanged: (String? newValue) {
  //                                         if (newValue != null) {
  //                                           setState(() {
  //                                             _selectedIdProofTypes[index] = newValue;
  //                                           });
  //                                         }
  //                                       },
  //                                     ),
  //                                   ),
  //                                 ),
  //                               ),
  //                             ),
  //                             const SizedBox(width: 12),
  //                             // ID Number Field
  //                             Expanded(
  //                               flex: 6,
  //                               child: TextFormField(
  //                                 controller: _idNumberControllers[index],
  //                                 style: context.bodyStyle.copyWith(fontSize: 15, color: context.textTheme.titleLarge?.color ?? Colors.black),
  //                                 decoration: InputDecoration(
  //                                   labelText: 'ID Number',
  //                                   labelStyle: context.subtitleStyle.copyWith(fontSize: 13, color: context.textTheme.bodySmall?.color ?? Colors.grey),
  //                                   floatingLabelStyle: TextStyle(color: context.primaryColor),
  //                                   hintText: 'Enter ID number',
  //                                   hintStyle: context.bodyStyle.copyWith(color: context.textTheme.bodySmall?.color ?? Colors.grey, fontSize: 15),
  //                                   border: OutlineInputBorder(
  //                                     borderRadius: BorderRadius.circular(10),
  //                                     borderSide: BorderSide(color: context.dividerColor),
  //                                   ),
  //                                   enabledBorder: OutlineInputBorder(
  //                                     borderRadius: BorderRadius.circular(10),
  //                                     borderSide: BorderSide(color: context.dividerColor),
  //                                   ),
  //                                   focusedBorder: OutlineInputBorder(
  //                                     borderRadius: BorderRadius.circular(10),
  //                                     borderSide: BorderSide(color: context.primaryColor, width: 1.5),
  //                                   ),
  //                                   contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
  //                                   filled: true,
  //                                   fillColor: context.backgroundColor,
  //                                   prefixIcon: Icon(Icons.credit_card_rounded,
  //                                       color: context.primaryColor.withOpacity(0.7), size: 20),
  //                                 ),
  //                                 onChanged: (_) => _validateForm(),
  //                                 validator: (value) {
  //                                   if (age > 5 && (value == null || value.isEmpty)) {
  //                                     return 'Required';
  //                                   }
  //                                   return null;
  //                                 },
  //                               ),
  //                             ),
  //                           ],
  //                         ),
  //                       ],
  //                     );
  //                   },
  //                 ),
  //               ],
  //             ),
  //           ),
  //         ],
  //       ),
  //     );

  Widget _buildTripProtectionCard() => _buildCard(
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: _tripProtectionEnabled
                      ? [
                          AppTheme.AppColors.redCA0,
                          AppTheme.AppColors.redCA0.withOpacity(0.8)
                        ]
                      : [Colors.grey[400]!, Colors.grey[500]!],
                ),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                _tripProtectionEnabled
                    ? Icons.verified_user_rounded
                    : Icons.verified_user_outlined,
                color: Colors.white,
                size: 22,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Trip Protection',
                    style: GoogleFonts.poppins(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Get travel insurance coverage for your journey',
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: Colors.black54,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '₹109 per traveller',
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.AppColors.redCA0,
                    ),
                  ),
                ],
              ),
            ),
            Switch(
              value: _tripProtectionEnabled,
              onChanged: (value) {
                HapticFeedback.selectionClick();
                setState(() {
                  _tripProtectionEnabled = value;
                  _validateForm();
                });
              },
              activeColor: AppTheme.AppColors.redCA0,
              activeTrackColor: AppTheme.AppColors.redCA0.withOpacity(0.5),
            ),
          ],
        ),
      );

  Widget _buildBottomBar() {
    final double totalFare = (_fare * _selectedSeats.length).toDouble();
    final double tripProtection =
        _tripProtectionEnabled ? (109.0 * _selectedSeats.length) : 0.0;
    final double finalFare = totalFare + tripProtection;

    return Container(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 16,
        bottom: 16 + MediaQuery.of(context).padding.bottom,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            spreadRadius: 0,
            offset: const Offset(0, -4),
          ),
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            spreadRadius: 0,
            offset: const Offset(0, -2),
          ),
        ],
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Icon(Icons.currency_rupee_rounded,
                      size: 20, color: AppTheme.AppColors.redCA0),
                  Text(
                    finalFare.toStringAsFixed(0),
                    style: GoogleFonts.poppins(
                      fontSize: 26,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.AppColors.redCA0,
                      letterSpacing: -0.5,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              InkWell(
                onTap: () {
                  HapticFeedback.selectionClick();
                  showModalBottomSheet(
                    context: context,
                    backgroundColor: Colors.transparent,
                    builder: (context) =>
                        _buildFareDetailsModal(totalFare, finalFare),
                  );
                },
                child: Text(
                  'View Fare Details',
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.AppColors.redCA0,
                    decoration: TextDecoration.underline,
                    decorationColor: AppTheme.AppColors.redCA0,
                  ),
                ),
              ),
            ],
          ),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: _isFormValid
                    ? [
                        AppTheme.AppColors.redCA0,
                        AppTheme.AppColors.redCA0.withOpacity(0.9)
                      ]
                    : [Colors.grey[400]!, Colors.grey[500]!],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(14),
              boxShadow: _isFormValid
                  ? [
                      BoxShadow(
                        color: AppTheme.AppColors.redCA0.withOpacity(0.4),
                        blurRadius: 12,
                        spreadRadius: 0,
                        offset: const Offset(0, 4),
                      ),
                    ]
                  : null,
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: _isFormValid ? _onProceed : null,
                borderRadius: BorderRadius.circular(14),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Proceed',
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                          letterSpacing: 0.3,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Icon(
                        Icons.arrow_forward_rounded,
                        color: Colors.white,
                        size: 20,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFareDetailsModal(double totalFare, double finalFare) =>
      Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 20,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Fare Details',
                  style: GoogleFonts.poppins(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: Colors.black87,
                  ),
                ),
                IconButton(
                  icon: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: Colors.grey[100]!,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.close,
                        size: 18, color: Colors.black54),
                  ),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Base Fare (${_selectedSeats.length} seat${_selectedSeats.length == 1 ? '' : 's'})',
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                ),
                Row(
                  children: [
                    Icon(Icons.currency_rupee_rounded,
                        size: 16, color: Colors.black87),
                    Text(
                      totalFare.toStringAsFixed(0),
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            if (_tripProtectionEnabled) ...[
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Trip Protection (${_selectedSeats.length} traveller${_selectedSeats.length == 1 ? '' : 's'})',
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.black87,
                    ),
                  ),
                  Row(
                    children: [
                      Icon(Icons.currency_rupee_rounded,
                          size: 16, color: Colors.black87),
                      Text(
                        (109 * _selectedSeats.length).toStringAsFixed(0),
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
            const SizedBox(height: 16),
            Container(
              height: 1,
              color: Theme.of(context).dividerColor.withOpacity(0.2),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppTheme.AppColors.redCA0.withOpacity(0.1),
                    AppTheme.AppColors.redCA0.withOpacity(0.05),
                  ],
                ),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: AppTheme.AppColors.redCA0.withOpacity(0.2),
                  width: 1,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Total Fare',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Colors.black87,
                    ),
                  ),
                  Row(
                    children: [
                      Icon(Icons.currency_rupee_rounded,
                          size: 22, color: AppTheme.AppColors.redCA0),
                      Text(
                        finalFare.toStringAsFixed(0),
                        style: GoogleFonts.poppins(
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                          color: AppTheme.AppColors.redCA0,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: MediaQuery.of(context).padding.bottom + 8),
          ],
        ),
      );
}
