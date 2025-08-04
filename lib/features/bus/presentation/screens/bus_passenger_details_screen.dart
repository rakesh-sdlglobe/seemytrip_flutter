// ignore_for_file: avoid_classes_with_only_static_members

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

// --- REFINED THEME & STYLES ---
class _AppStyles {
  // Colors aligned with BusSearchResultsScreen and BusSeatLayoutScreen
  static const Color primary = Color(0xFFE53935); // Softer red
  static const Color primaryVariant = Color(0xFFC62828); // Darker for depth
  static const Color accent = Color(0xFFFFA726); // Orange for highlights
  static const Color textPrimary = Color(0xFF1A1A1A); // Softer black
  static const Color textSecondary = Color(0xFF757575); // Neutral grey
  static const Color background = Color(0xFFF5F6FA); // Clean background
  static const Color cardBackground = Colors.white;
  static const Color error = Color(0xFFD32F2F);
  static const Color success = Color(0xFF2ECC71);
  static const Color divider = Color(0xFFE0E0E0);
  static const Color iconColor = Color(0xFF757575);

  // Text Styles
  static final TextStyle title = GoogleFonts.poppins(
    fontWeight: FontWeight.w600,
    color: textPrimary,
    fontSize: 20,
    letterSpacing: 0.2,
  );

  static final TextStyle cardTitle = GoogleFonts.poppins(
    fontWeight: FontWeight.w600,
    color: textPrimary,
    fontSize: 16,
  );

  static final TextStyle body = GoogleFonts.poppins(
    color: textPrimary,
    fontSize: 14,
    fontWeight: FontWeight.w500,
    height: 1.5,
  );

  static final TextStyle subtitle = GoogleFonts.poppins(
    color: textSecondary,
    fontSize: 13,
    height: 1.4,
  );

  static final TextStyle button = GoogleFonts.poppins(
    fontWeight: FontWeight.w600,
    fontSize: 16,
    color: Colors.white,
  );
}

class BusPassengerDetailsScreen extends StatefulWidget {
  const BusPassengerDetailsScreen({
    required this.fromCity,
    required this.toCity,
    required this.busName,
    required this.travelDate,
    required this.departureTime,
    required this.arrivalTime,
    required this.fare,
    required this.selectedSeats,
    required this.boardingPoint,
    required this.droppingPoint,
    super.key,
  });

  final String fromCity;
  final String toCity;
  final String busName;
  final String travelDate;
  final String departureTime;
  final String arrivalTime;
  final double fare;
  final List<String> selectedSeats;
  final String boardingPoint;
  final String droppingPoint;

  @override
  State<BusPassengerDetailsScreen> createState() => _BusPassengerDetailsScreenState();
}

class _BusPassengerDetailsScreenState extends State<BusPassengerDetailsScreen> with SingleTickerProviderStateMixin {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late final List<TextEditingController> _nameControllers;
  late final List<TextEditingController> _ageControllers;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  late final List<List<bool>> _genderSelections;
  bool _isFormValid = false;
  bool _tripProtectionEnabled = true;
  AnimationController? _animationController;
  Animation<double>? _fadeAnimation;

  @override
  void initState() {
    super.initState();
    // Initialize animation controller
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _animationController!,
      curve: Curves.easeInOut,
    );
    _animationController!.forward();

    // Initialize controllers and gender selections
    int passengerCount = widget.selectedSeats.length;
    _nameControllers = List.generate(passengerCount, (_) => TextEditingController());
    _ageControllers = List.generate(passengerCount, (_) => TextEditingController());
    _genderSelections = List.generate(passengerCount, (_) => [true, false]); // Default to Male

    // Add listeners for form validation
    _emailController.addListener(_validateForm);
    _phoneController.addListener(_validateForm);
    for (int i = 0; i < passengerCount; i++) {
      _nameControllers[i].addListener(_validateForm);
      _ageControllers[i].addListener(_validateForm);
    }
  }

  @override
  void dispose() {
    _animationController?.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    for (var controller in _nameControllers) {
      controller.dispose();
    }
    for (var controller in _ageControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _validateForm() {
    final bool isValid = _formKey.currentState?.validate() ?? false;
    if (_isFormValid != isValid) {
      setState(() {
        _isFormValid = isValid;
      });
    }
  }

  void _onProceed() {
    if (_formKey.currentState!.validate()) {
      HapticFeedback.mediumImpact();
      Get.snackbar(
        'Success',
        'Proceeding to payment...',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: _AppStyles.success,
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
      );
      // Add navigation to payment screen or further logic here
    } else {
      HapticFeedback.heavyImpact();
      Get.snackbar(
        'Error',
        'Please fill all required fields correctly.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: _AppStyles.error,
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_fadeAnimation == null || _animationController == null) {
      return const Center(child: CircularProgressIndicator(color: _AppStyles.primary));
    }

    return Scaffold(
      backgroundColor: _AppStyles.background,
      appBar: _buildAppBar(),
      body: FadeTransition(
        opacity: _fadeAnimation!,
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildTripDetailsCard(),
                const SizedBox(height: 16),
                _buildContactDetailsCard(),
                const SizedBox(height: 16),
                _buildPassengerDetailsCard(),
                const SizedBox(height: 16),
                _buildTripProtectionCard(),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomBar(),
    );
  }

  PreferredSizeWidget _buildAppBar() => AppBar(
        backgroundColor: _AppStyles.cardBackground,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        shadowColor: _AppStyles.primary.withOpacity(0.1),
        leading: Container(
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: _AppStyles.background,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded,
                color: _AppStyles.textPrimary, size: 20),
            onPressed: () => Get.back(),
          ),
        ),
        title: Text('Passenger Details', style: _AppStyles.title),
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(
            color: _AppStyles.divider.withOpacity(0.5),
            height: 1,
          ),
        ),
      );

  Widget _buildCard({required Widget child}) => Container(
        decoration: BoxDecoration(
          color: _AppStyles.cardBackground,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
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
                Text(
                  '${widget.fromCity} → ${widget.toCity}',
                  style: _AppStyles.title.copyWith(fontSize: 18),
                  overflow: TextOverflow.ellipsis,
                ),
                InkWell(
                  onTap: () {
                    showModalBottomSheet(
                      context: context,
                      backgroundColor: Colors.transparent,
                      builder: (context) => _buildTripDetailsModal(),
                    );
                  },
                  child: Row(
                    children: [
                      Text('Details', style: _AppStyles.body.copyWith(color: _AppStyles.accent)),
                      const SizedBox(width: 4),
                      Icon(Icons.arrow_forward_ios_rounded,
                          size: 14, color: _AppStyles.accent),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(widget.busName, style: _AppStyles.subtitle.copyWith(fontSize: 14)),
            const SizedBox(height: 12),
            Container(height: 1, color: _AppStyles.divider.withOpacity(0.5)),
            const SizedBox(height: 12),
            Text(
              '${widget.selectedSeats.length} Traveller(s) • ${widget.travelDate}',
              style: _AppStyles.body,
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.access_time, size: 16, color: _AppStyles.iconColor),
                const SizedBox(width: 8),
                Text(
                  '${widget.departureTime} - ${widget.arrivalTime}',
                  style: _AppStyles.body.copyWith(fontSize: 13),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.location_on, size: 16, color: _AppStyles.iconColor),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    '${widget.boardingPoint} → ${widget.droppingPoint}',
                    style: _AppStyles.body.copyWith(fontSize: 13),
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
          color: _AppStyles.cardBackground,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Trip Details', style: _AppStyles.title),
                IconButton(
                  icon: const Icon(Icons.close, color: _AppStyles.textPrimary),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text('Route', style: _AppStyles.cardTitle),
            const SizedBox(height: 8),
            Text(
              '${widget.fromCity} → ${widget.toCity}',
              style: _AppStyles.body,
            ),
            const SizedBox(height: 12),
            Text('Bus', style: _AppStyles.cardTitle),
            const SizedBox(height: 8),
            Text(widget.busName, style: _AppStyles.body),
            const SizedBox(height: 12),
            Text('Date & Time', style: _AppStyles.cardTitle),
            const SizedBox(height: 8),
            Text(
              '${widget.travelDate} | ${widget.departureTime} - ${widget.arrivalTime}',
              style: _AppStyles.body,
            ),
            const SizedBox(height: 12),
            Text('Boarding & Dropping', style: _AppStyles.cardTitle),
            const SizedBox(height: 8),
            Text(
              '${widget.boardingPoint} → ${widget.droppingPoint}',
              style: _AppStyles.body,
            ),
            const SizedBox(height: 12),
            Text('Seats', style: _AppStyles.cardTitle),
            const SizedBox(height: 8),
            Text(
              widget.selectedSeats.join(', '),
              style: _AppStyles.body,
            ),
            const SizedBox(height: 16),
            Text('Total Fare', style: _AppStyles.cardTitle),
            const SizedBox(height: 8),
            Text(
              '₹${(widget.fare * widget.selectedSeats.length).toStringAsFixed(2)}',
              style: _AppStyles.body.copyWith(
                color: _AppStyles.accent,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      );

  Widget _buildContactDetailsCard() => _buildCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Contact Details', style: _AppStyles.cardTitle),
            const SizedBox(height: 8),
            Text(
              'Your ticket & updates will be sent here',
              style: _AppStyles.subtitle,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: 'Email ID',
                prefixIcon: Icon(Icons.email_outlined,
                    size: 20, color: _AppStyles.iconColor),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: _AppStyles.divider),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: _AppStyles.divider),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: _AppStyles.primary, width: 1.5),
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
              decoration: InputDecoration(
                labelText: 'Phone Number',
                prefixIcon: Icon(Icons.phone_outlined,
                    size: 20, color: _AppStyles.iconColor),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: _AppStyles.divider),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: _AppStyles.divider),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: _AppStyles.primary, width: 1.5),
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

  Widget _buildPassengerDetailsCard() => _buildCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Passenger Details', style: _AppStyles.cardTitle),
            const SizedBox(height: 16),
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: widget.selectedSeats.length,
              itemBuilder: (context, index) => FadeTransition(
                opacity: Tween<double>(begin: 0, end: 1).animate(
                  CurvedAnimation(
                    parent: _animationController!,
                    curve: Interval(0.1 * index, 1.0, curve: Curves.easeOut),
                  ),
                ),
                child: _buildPassengerForm(index: index),
              ),
              separatorBuilder: (context, index) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Container(height: 1, color: _AppStyles.divider.withOpacity(0.5)),
              ),
            ),
          ],
        ),
      );

  Widget _buildPassengerForm({required int index}) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Align(
            alignment: Alignment.centerRight,
            child: Chip(
              avatar: Icon(Icons.event_seat,
                  color: _AppStyles.success, size: 16),
              label: Text(
                'Seat: ${widget.selectedSeats[index]}',
                style: _AppStyles.body.copyWith(fontWeight: FontWeight.w600),
              ),
              backgroundColor: _AppStyles.success.withOpacity(0.15),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(color: _AppStyles.success.withOpacity(0.3)),
              ),
            ),
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: _nameControllers[index],
            decoration: InputDecoration(
              labelText: 'Full Name',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: _AppStyles.divider),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: _AppStyles.divider),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: _AppStyles.primary, width: 1.5),
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Name cannot be empty';
              }
              if (value.length < 2) {
                return 'Name must be at least 2 characters';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 2,
                child: TextFormField(
                  controller: _ageControllers[index],
                  decoration: InputDecoration(
                    labelText: 'Age',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: _AppStyles.divider),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: _AppStyles.divider),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: _AppStyles.primary, width: 1.5),
                    ),
                  ),
                  keyboardType: TextInputType.number,
                  maxLength: 3,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Required';
                    }
                    final age = int.tryParse(value);
                    if (age == null || age <= 0 || age > 120) {
                      return 'Invalid age';
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                flex: 5,
                child: _GenderSelector(
                  isSelected: _genderSelections[index],
                  onPressed: (genderIndex) {
                    setState(() {
                      for (int i = 0; i < _genderSelections[index].length; i++) {
                        _genderSelections[index][i] = i == genderIndex;
                      }
                      _validateForm();
                    });
                  },
                ),
              ),
            ],
          ),
        ],
      );

  Widget _buildTripProtectionCard() => _buildCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.verified_user_outlined,
                    color: _AppStyles.primary, size: 22),
                const SizedBox(width: 10),
                Text('Trip Protection', style: _AppStyles.cardTitle),
                const Spacer(),
                Switch(
                  value: _tripProtectionEnabled,
                  onChanged: (value) {
                    setState(() {
                      _tripProtectionEnabled = value;
                    });
                  },
                  activeColor: _AppStyles.primary,
                  activeTrackColor: _AppStyles.primary.withOpacity(0.3),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              'Secure your trip with Free Cancellation & Instant Refunds.',
              style: _AppStyles.subtitle.copyWith(fontSize: 14),
            ),
            const SizedBox(height: 6),
            Text(
              '@ only ₹109 per passenger',
              style: _AppStyles.body.copyWith(
                fontWeight: FontWeight.w600,
                color: _AppStyles.accent,
              ),
            ),
          ],
        ),
      );

  Widget _buildBottomBar() {
    final double totalFare = widget.fare * widget.selectedSeats.length;
    final double finalFare =
        _tripProtectionEnabled ? totalFare + (109 * widget.selectedSeats.length) : totalFare;

    return Container(
      padding: EdgeInsets.fromLTRB(16, 12, 16, MediaQuery.of(context).padding.bottom + 16),
      decoration: BoxDecoration(
        color: _AppStyles.cardBackground,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 12,
            offset: const Offset(0, -4),
          ),
        ],
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '₹${finalFare.toStringAsFixed(0)}',
                style: _AppStyles.title.copyWith(
                  fontSize: 24,
                  color: _AppStyles.accent,
                ),
              ),
              InkWell(
                onTap: () {
                  showModalBottomSheet(
                    context: context,
                    backgroundColor: Colors.transparent,
                    builder: (context) => _buildFareDetailsModal(totalFare, finalFare),
                  );
                },
                child: Text(
                  'View Fare Details',
                  style: _AppStyles.subtitle.copyWith(
                    color: _AppStyles.accent,
                    decoration: TextDecoration.underline,
                    decorationColor: _AppStyles.accent,
                  ),
                ),
              ),
            ],
          ),
          ElevatedButton(
            onPressed: _isFormValid ? _onProceed : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: _AppStyles.primary,
              disabledBackgroundColor: _AppStyles.textSecondary.withOpacity(0.4),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 0,
              shadowColor: _AppStyles.primary.withOpacity(0.3),
            ),
            child: Text(
              'Proceed',
              style: _AppStyles.button,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFareDetailsModal(double totalFare, double finalFare) => Container(
        decoration: BoxDecoration(
          color: _AppStyles.cardBackground,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Fare Details', style: _AppStyles.title),
                IconButton(
                  icon: const Icon(Icons.close, color: _AppStyles.textPrimary),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Base Fare (${widget.selectedSeats.length} seat${widget.selectedSeats.length == 1 ? '' : 's'})', style: _AppStyles.body),
                Text('₹${totalFare.toStringAsFixed(0)}', style: _AppStyles.body),
              ],
            ),
            if (_tripProtectionEnabled) ...[
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Trip Protection (${widget.selectedSeats.length} traveller${widget.selectedSeats.length == 1 ? '' : 's'})', style: _AppStyles.body),
                  Text('₹${(109 * widget.selectedSeats.length).toStringAsFixed(0)}', style: _AppStyles.body),
                ],
              ),
            ],
            const SizedBox(height: 12),
            Container(height: 1, color: _AppStyles.divider.withOpacity(0.5)),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Total Fare', style: _AppStyles.body.copyWith(fontWeight: FontWeight.w600)),
                Text(
                  '₹${finalFare.toStringAsFixed(0)}',
                  style: _AppStyles.body.copyWith(
                    fontWeight: FontWeight.w600,
                    color: _AppStyles.accent,
                  ),
                ),
              ],
            ),
          ],
        ),
      );
}

class _GenderSelector extends StatelessWidget {
  const _GenderSelector({required this.isSelected, required this.onPressed});

  final List<bool> isSelected;
  final ValueChanged<int> onPressed;

  @override
  Widget build(BuildContext context) => InputDecorator(
        decoration: InputDecoration(
          labelText: 'Gender',
          border: InputBorder.none,
          contentPadding: const EdgeInsets.only(top: 0, bottom: 12),
          labelStyle: _AppStyles.subtitle.copyWith(fontSize: 14),
        ),
        child: Row(
          children: [
            _buildGenderOption(context, 'Male', 0),
            const SizedBox(width: 12),
            _buildGenderOption(context, 'Female', 1),
          ],
        ),
      );

  Widget _buildGenderOption(BuildContext context, String text, int index) {
    final bool selected = isSelected[index];
    return Expanded(
      child: GestureDetector(
        onTap: () => onPressed(index),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          height: 48,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: selected ? _AppStyles.primary.withOpacity(0.15) : _AppStyles.background,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: selected ? _AppStyles.primary : _AppStyles.divider,
              width: 1.5,
            ),
            boxShadow: selected
                ? [
                    BoxShadow(
                      color: _AppStyles.primary.withOpacity(0.2),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : null,
          ),
          child: Text(
            text,
            style: _AppStyles.body.copyWith(
              color: selected ? _AppStyles.primary : _AppStyles.textSecondary,
              fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}