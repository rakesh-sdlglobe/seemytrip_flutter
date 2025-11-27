// ignore_for_file: avoid_classes_with_only_static_members, library_prefixes

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/theme/app_colors.dart' as AppTheme;
import '../../../../core/utils/helpers/date_time_helper.dart';

import '../../../auth/presentation/controllers/login_controller.dart';
import '../../../payment/easebuzz_payment_widget.dart';
import '../../../train/presentation/controllers/travellerDetailController.dart';

import '../../utils/traveller_utils.dart';
import '../controllers/bus_controller.dart';
import '../widgets/bus_booking_bottom_bar.dart';
import '../widgets/bus_passenger_app_bar.dart';
import '../widgets/bus_passenger_shimmer.dart';
import '../widgets/contact_details_card.dart';
import '../widgets/passenger_details_card.dart';
import '../widgets/travellers_section.dart';
import '../widgets/trip_details_card.dart';
import '../widgets/trip_protection_card.dart';
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
  Set<String> selectedTravellers = {};
  bool _isLoading = true;
  bool _isProcessing = false;
  String? _errorMessage;

  // Animation
  late final AnimationController _animationController;
  late final Animation<double> _fadeAnimation;

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

  Future<void> _loadData() async {
    // Use widget parameters if available, otherwise use defaults
    _fromCity = widget.fromCity ?? 'Unknown';
    _toCity = widget.toCity ?? 'Unknown';
    _selectedSeatsObjects = widget.selectedSeatsObjects ?? [];
    _busName = widget.busName ?? 'Unknown Bus';
    _travelDate = widget.travelDate ?? 'Date not specified';
    _departureTime =
        DateTimeHelper.convertTo12HourFormat(widget.departureTime ?? '--:--');
    _arrivalTime =
        DateTimeHelper.convertTo12HourFormat(widget.arrivalTime ?? '--:--');
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
        if (traveller.isNotEmpty &&
            !TravellerUtils.isTravellerComplete(traveller)) {
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
        if (traveller.isNotEmpty &&
            !TravellerUtils.isTravellerComplete(traveller)) {
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

    setState(() {
      _isProcessing = true;
    });

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
    } finally {
      if (mounted) {
        setState(() {
          _isProcessing = false;
        });
      }
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
        appBar: const BusPassengerAppBar(),
        body: const BusPassengerShimmer(),
      );
    }

    if (_errorMessage != null) {
      return Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: const BusPassengerAppBar(),
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
      appBar: const BusPassengerAppBar(),
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
                TripDetailsCard(
                  fromCity: _fromCity,
                  toCity: _toCity,
                  busName: _busName,
                  travelDate: _travelDate,
                  departureTime: _departureTime,
                  arrivalTime: _arrivalTime,
                  boardingPoint: _boardingPoint,
                  droppingPoint: _droppingPoint,
                  selectedSeats: _selectedSeats,
                  fare: _fare,
                  tripProtectionEnabled: _tripProtectionEnabled,
                ),
                const SizedBox(height: 12),
                ContactDetailsCard(
                  emailController: _emailController,
                  phoneController: _phoneController,
                ),
                const SizedBox(height: 12),
                TravellersSection(
                  travellerController: travellerController,
                  selectedTravellers: selectedTravellers,
                  onTravellerSelected: (traveller, selected) {
                    setState(() {
                      final name = traveller['passengerName'] ??
                          traveller['firstname'] ??
                          'Unknown';
                      if (selected) {
                        selectedTravellers.add(name);
                        // Auto-fill passenger form if possible
                        _fillPassengerFormFromTraveller(traveller);
                      } else {
                        selectedTravellers.remove(name);
                      }
                      _validateForm();
                    });
                  },
                  onValidate: _validateForm,
                ),
                const SizedBox(height: 12),
                PassengerDetailsCard(
                  selectedSeats: _selectedSeats,
                  nameControllers: _nameControllers,
                  ageControllers: _ageControllers,
                  idNumberControllers: _idNumberControllers,
                  genderSelections: _genderSelections,
                  selectedIdProofTypes: _selectedIdProofTypes,
                  idProofTypes: _idProofTypes,
                  onValidate: _validateForm,
                  onGenderSelected: (passengerIndex, genderIndex) {
                    HapticFeedback.selectionClick();
                    setState(() {
                      for (int i = 0;
                          i < _genderSelections[passengerIndex].length;
                          i++) {
                        _genderSelections[passengerIndex][i] =
                            (i == genderIndex);
                      }
                    });
                  },
                ),
                const SizedBox(height: 12),
                const SizedBox(height: 12),
                TripProtectionCard(
                  isEnabled: _tripProtectionEnabled,
                  onChanged: (value) {
                    setState(() {
                      _tripProtectionEnabled = value;
                      _validateForm();
                    });
                  },
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: BusBookingBottomBar(
        baseFare: _fare,
        seatCount: _selectedSeats.length,
        tripProtectionEnabled: _tripProtectionEnabled,
        isFormValid: _isFormValid,
        isLoading: _isProcessing,
        onProceed: _onProceed,
      ),
    );
  }

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
}
