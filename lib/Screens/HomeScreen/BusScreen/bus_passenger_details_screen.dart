import 'package:flutter/material.dart';
import 'package:get/get.dart'; // Using Get for navigation as in the original code
import 'package:google_fonts/google_fonts.dart';

// A centralized place for colors and styles for this screen
class _AppStyles {
  // Colors
  static const Color primary = Color(0xFF0D47A1); // A deeper, more professional blue
  static const Color accent = Color(0xFFFFC107);
  static const Color textPrimary = Color(0xFF212121);
  static const Color textSecondary = Color(0xFF616161);
  static const Color background = Color(0xFFF5F7FA);
  static const Color cardBackground = Colors.white;
  static const Color error = Color(0xFFD32F2F);
  static const Color success = Color(0xFF2E7D32);
  static const Color divider = Color(0xFFE0E0E0);
  static const Color iconColor = Color(0xFF757575);

  // Text Styles
  static TextStyle get title => GoogleFonts.poppins(
        fontWeight: FontWeight.w600,
        color: textPrimary,
        fontSize: 18,
      );

  static TextStyle get cardTitle => GoogleFonts.poppins(
        fontWeight: FontWeight.w600,
        color: textPrimary,
        fontSize: 16,
      );
      
  static TextStyle get body => GoogleFonts.roboto(
        color: textPrimary,
        fontSize: 14,
        fontWeight: FontWeight.w500,
      );

  static TextStyle get subtitle => GoogleFonts.roboto(
        color: textSecondary,
        fontSize: 12,
      );
}

class BusPassengerDetailsScreen extends StatefulWidget {
  // Mock data for demonstration purposes
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

  const BusPassengerDetailsScreen({
    super.key,
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
  });

  @override
  State<BusPassengerDetailsScreen> createState() =>
      _BusPassengerDetailsScreenState();
}

class _BusPassengerDetailsScreenState extends State<BusPassengerDetailsScreen> {
  final _formKey = GlobalKey<FormState>();

  // Controllers for all input fields
  late final List<TextEditingController> _nameControllers;
  late final List<TextEditingController> _ageControllers;
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();

  // State for gender selection, now correctly using a list of lists of booleans
  late final List<List<bool>> _genderSelections;

  bool _isFormValid = false;
  
  // A flag to enable trip protection
  bool _tripProtectionEnabled = true;

  @override
  void initState() {
    super.initState();
    int passengerCount = widget.selectedSeats.length;

    // Initialize controllers and gender selections based on passenger count
    _nameControllers =
        List.generate(passengerCount, (_) => TextEditingController());
    _ageControllers =
        List.generate(passengerCount, (_) => TextEditingController());
    _genderSelections =
        List.generate(passengerCount, (_) => [true, false]); // Default to Male

    // Add listeners to validate form on any change
    _emailController.addListener(_validateForm);
    _phoneController.addListener(_validateForm);
    for (int i = 0; i < passengerCount; i++) {
      _nameControllers[i].addListener(_validateForm);
      _ageControllers[i].addListener(_validateForm);
    }
  }

  @override
  void dispose() {
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
      // All data is valid, proceed with booking logic
      Get.snackbar(
        "Success",
        "Proceeding to payment...",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: _AppStyles.success,
        colorText: Colors.white,
      );
    } else {
      // Show an error message if the button was somehow enabled while form is invalid
      Get.snackbar(
        "Error",
        "Please fill all required fields correctly.",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: _AppStyles.error,
        colorText: Colors.white,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _AppStyles.background,
      appBar: AppBar(
        backgroundColor: _AppStyles.cardBackground,
        elevation: 1,
        shadowColor: Colors.black.withOpacity(0.1),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded,
              size: 20, color: _AppStyles.textPrimary),
          onPressed: () => Get.back(),
        ),
        title: Text('Passenger Details', style: _AppStyles.title),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.all(16.0),
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
      bottomNavigationBar: _buildBottomBar(),
    );
  }

  /// Builds a generic card container
  Widget _buildCard({required Widget child}) {
    return Container(
      decoration: BoxDecoration(
        color: _AppStyles.cardBackground,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: child,
      ),
    );
  }

  /// Builds the top card showing trip summary
  Widget _buildTripDetailsCard() {
    return _buildCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${widget.fromCity} → ${widget.toCity}',
                style: _AppStyles.title.copyWith(fontSize: 16),
              ),
              InkWell(
                onTap: () { /* Show details modal */ },
                child: Row(
                  children: [
                    Text('Details', style: _AppStyles.body.copyWith(color: _AppStyles.primary)),
                    const SizedBox(width: 4),
                    const Icon(Icons.arrow_forward_ios_rounded, size: 14, color: _AppStyles.primary),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(widget.busName, style: _AppStyles.subtitle),
          const SizedBox(height: 12),
          const Divider(color: _AppStyles.divider),
          const SizedBox(height: 12),
          Text(
            '${widget.selectedSeats.length} Traveller(s) • ${widget.travelDate}',
            style: _AppStyles.body,
          ),
        ],
      ),
    );
  }

  /// Builds the card for contact information
  Widget _buildContactDetailsCard() {
    return _buildCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Contact Details', style: _AppStyles.cardTitle),
          const SizedBox(height: 4),
          Text(
            'Your ticket & updates will be sent here',
            style: _AppStyles.subtitle,
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _emailController,
            decoration: const InputDecoration(
              labelText: 'Email ID',
              prefixIcon: Icon(Icons.email_outlined, size: 20),
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
          const SizedBox(height: 12),
          TextFormField(
            controller: _phoneController,
            decoration: const InputDecoration(
              labelText: 'Phone Number',
              prefixIcon: Icon(Icons.phone_outlined, size: 20),
            ),
            keyboardType: TextInputType.phone,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Phone number is required';
              }
              if (!GetUtils.isPhoneNumber(value) || value.length < 10) {
                return 'Enter a valid 10-digit phone number';
              }
              return null;
            },
          ),
        ],
      ),
    );
  }

  /// Builds the main card for filling passenger details
  Widget _buildPassengerDetailsCard() {
    return _buildCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Passenger Details', style: _AppStyles.cardTitle),
          const SizedBox(height: 16),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: widget.selectedSeats.length,
            itemBuilder: (context, index) {
              return _buildPassengerForm(index: index);
            },
            separatorBuilder: (context, index) =>
                const Divider(height: 32, color: _AppStyles.divider),
          ),
        ],
      ),
    );
  }

  /// Builds the form for a single passenger
  Widget _buildPassengerForm({required int index}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Align(
          alignment: Alignment.centerRight,
          child: Chip(
            avatar: const Icon(Icons.event_seat, color: _AppStyles.success, size: 16),
            label: Text(
              'Seat: ${widget.selectedSeats[index]}',
              style: _AppStyles.body.copyWith(fontWeight: FontWeight.bold),
            ),
            backgroundColor: _AppStyles.success.withOpacity(0.1),
            padding: const EdgeInsets.symmetric(horizontal: 8),
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: _nameControllers[index],
          decoration: const InputDecoration(labelText: 'Full Name'),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Name cannot be empty';
            }
            return null;
          },
        ),
        const SizedBox(height: 12),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 2,
              child: TextFormField(
                controller: _ageControllers[index],
                decoration: const InputDecoration(labelText: 'Age'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Required';
                  }
                  final age = int.tryParse(value);
                  if (age == null || age <= 0 || age > 120) {
                    return 'Invalid';
                  }
                  return null;
                },
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              flex: 5,
              child: _GenderSelector(
                isSelected: _genderSelections[index],
                onPressed: (genderIndex) {
                  setState(() {
                    for (int i = 0; i < _genderSelections[index].length; i++) {
                      _genderSelections[index][i] = i == genderIndex;
                    }
                  });
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  /// Builds the Trip Protection promotional card
  Widget _buildTripProtectionCard() {
    return _buildCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.verified_user_outlined, color: _AppStyles.primary),
              const SizedBox(width: 8),
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
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Secure your trip with Free Cancellation & Instant Refunds.',
            style: _AppStyles.subtitle.copyWith(fontSize: 14, height: 1.4),
          ),
          const SizedBox(height: 4),
          Text(
            '@ only ₹109 per passenger',
            style: _AppStyles.body.copyWith(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  /// Builds the bottom navigation bar with price and proceed button
  Widget _buildBottomBar() {
    final double totalFare = widget.fare * widget.selectedSeats.length;
    final double finalFare = _tripProtectionEnabled 
        ? totalFare + (109 * widget.selectedSeats.length) 
        : totalFare;
        
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
      decoration: BoxDecoration(
        color: _AppStyles.cardBackground,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '₹${finalFare.toStringAsFixed(2)}',
                style: _AppStyles.title.copyWith(fontSize: 22),
              ),
              Text(
                'View Fare Details',
                style: _AppStyles.subtitle.copyWith(
                  color: _AppStyles.primary,
                  decoration: TextDecoration.underline,
                ),
              ),
            ],
          ),
          ElevatedButton(
            onPressed: _isFormValid ? _onProceed : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: _AppStyles.primary,
              disabledBackgroundColor: Colors.grey.shade400,
              padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 5,
              shadowColor: _AppStyles.primary.withOpacity(0.5),
            ),
            child: Text(
              'Proceed',
              style: _AppStyles.title.copyWith(fontSize: 16, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}

/// A custom widget for a modern gender selection UI
class _GenderSelector extends StatelessWidget {
  final List<bool> isSelected;
  final ValueChanged<int> onPressed;

  const _GenderSelector({required this.isSelected, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return InputDecorator(
      decoration: InputDecoration(
        labelText: 'Gender',
        border: InputBorder.none,
        contentPadding: const EdgeInsets.only(top: 0, bottom: 12),
        labelStyle: _AppStyles.subtitle.copyWith(fontSize: 14),
      ),
      child: Row(
        children: [
          _buildGenderOption(context, 'Male', 0),
          const SizedBox(width: 8),
          _buildGenderOption(context, 'Female', 1),
        ],
      ),
    );
  }

  Widget _buildGenderOption(BuildContext context, String text, int index) {
    final bool selected = isSelected[index];
    return Expanded(
      child: GestureDetector(
        onTap: () => onPressed(index),
        child: Container(
          height: 48,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: selected ? _AppStyles.primary.withOpacity(0.1) : _AppStyles.background,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: selected ? _AppStyles.primary : _AppStyles.divider,
            ),
          ),
          child: Text(
            text,
            style: _AppStyles.body.copyWith(
              color: selected ? _AppStyles.primary : _AppStyles.textSecondary,
              fontWeight: selected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ),
      ),
    );
  }
}