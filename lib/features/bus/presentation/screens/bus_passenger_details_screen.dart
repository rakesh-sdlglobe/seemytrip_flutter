// ignore_for_file: avoid_classes_with_only_static_members

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import 'passenger_form.dart';

// --- THEME-AWARE COLOR SYSTEM ---
class ThemeAwareColors {
  static Color primary(BuildContext context) => Theme.of(context).brightness == Brightness.dark
    ? const Color(0xFFFF5722) // Orange-red for dark theme
    : const Color(0xFFE53935); // Red for light theme
  
  static Color primaryVariant(BuildContext context) => Theme.of(context).brightness == Brightness.dark
    ? const Color(0xFFE64A19) // Darker orange-red for dark theme
    : const Color(0xFFC62828); // Darker red for light theme
  
  static Color accent(BuildContext context) => Theme.of(context).brightness == Brightness.dark
    ? const Color(0xFFFFB74D) // Orange accent for dark theme
    : const Color(0xFFFFA726); // Orange accent for light theme
  
  static Color success(BuildContext context) => Theme.of(context).brightness == Brightness.dark
    ? const Color(0xFF4CAF50) // Green for dark theme
    : const Color(0xFF2ECC71); // Green for light theme
  
  static Color error(BuildContext context) => Theme.of(context).brightness == Brightness.dark
    ? const Color(0xFFEF5350) // Light red for dark theme
    : const Color(0xFFD32F2F); // Red for light theme
}

class ThemeAwareStyles {
  static TextStyle title(BuildContext context) => GoogleFonts.poppins(
    fontWeight: FontWeight.w600,
    color: Theme.of(context).textTheme.titleLarge?.color,
    fontSize: 20,
    letterSpacing: 0.2,
  );

  static TextStyle cardTitle(BuildContext context) => GoogleFonts.poppins(
    fontWeight: FontWeight.w600,
    color: Theme.of(context).textTheme.titleLarge?.color,
    fontSize: 16,
  );

  static TextStyle body(BuildContext context) => GoogleFonts.poppins(
    color: Theme.of(context).textTheme.bodyLarge?.color,
    fontSize: 14,
    fontWeight: FontWeight.w500,
    height: 1.5,
  );

  static TextStyle subtitle(BuildContext context) => GoogleFonts.poppins(
    color: Theme.of(context).textTheme.bodySmall?.color,
    fontSize: 13,
    height: 1.4,
  );

  static TextStyle button(BuildContext context) => GoogleFonts.poppins(
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
  State<BusPassengerDetailsScreen> createState() =>
      _BusPassengerDetailsScreenState();
}

class _BusPassengerDetailsScreenState extends State<BusPassengerDetailsScreen>
    with SingleTickerProviderStateMixin {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late final List<TextEditingController> _nameControllers;
  late final List<TextEditingController> _ageControllers;
  late final List<TextEditingController> _idNumberControllers;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emergencyContactController =
      TextEditingController();
  final TextEditingController _specialRequirementsController =
      TextEditingController();
  late final List<List<bool>> _genderSelections;
  late final List<String> _idProofTypes;
  late final List<String> _selectedIdProofTypes;
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

    // Initialize ID proof types
    _idProofTypes = [
      'Aadhaar',
      'Passport',
      'Driving License',
      'Voter ID',
      'PAN Card'
    ];

    // Initialize controllers and gender selections
    int passengerCount = widget.selectedSeats.length;
    _nameControllers =
        List.generate(passengerCount, (_) => TextEditingController());
    _ageControllers =
        List.generate(passengerCount, (_) => TextEditingController());
    _idNumberControllers =
        List.generate(passengerCount, (_) => TextEditingController());
    _genderSelections =
        List.generate(passengerCount, (_) => [true, false, false]); // Default to Male
    _selectedIdProofTypes = List.generate(
        passengerCount, (_) => _idProofTypes[0]); // Default to first ID type

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
    _emergencyContactController.dispose();
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

    // Additional validation for ID proof if age is above 5
    for (int i = 0; i < _ageControllers.length; i++) {
      final age = int.tryParse(_ageControllers[i].text);
      if (age != null && age > 5 && _idNumberControllers[i].text.isEmpty) {
        isValid = false;
        break;
      }
    }

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
        backgroundColor: ThemeAwareColors.success(context),
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
        backgroundColor: ThemeAwareColors.error(context),
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_fadeAnimation == null || _animationController == null) {
      return Center(
          child: LoadingAnimationWidget.fourRotatingDots(
        color: ThemeAwareColors.primary(context),
        size: 40,
      ));
    }

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
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
        backgroundColor: Theme.of(context).cardColor,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        shadowColor: ThemeAwareColors.primary(context).withOpacity(0.1),
        leading: Container(
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Theme.of(context).shadowColor.withOpacity(0.08),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: IconButton(
            icon: Icon(Icons.arrow_back_ios_new_rounded,
                color: Theme.of(context).textTheme.titleLarge?.color, size: 20),
            onPressed: () => Get.back(),
          ),
        ),
        title: Text('Passenger Details', style: ThemeAwareStyles.title(context)),
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(
            color: Theme.of(context).dividerColor.withOpacity(0.5),
            height: 1,
          ),
        ),
      );

  Widget _buildCard({required Widget child}) => Container(
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).shadowColor.withOpacity(0.08),
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
                  style: ThemeAwareStyles.title(context).copyWith(fontSize: 18),
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
                      Text('Details',
                          style: ThemeAwareStyles.body(context)
                              .copyWith(color: ThemeAwareColors.accent(context))),
                      const SizedBox(width: 4),
                      Icon(Icons.arrow_forward_ios_rounded,
                          size: 14, color: ThemeAwareColors.accent(context)),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(widget.busName,
                style: ThemeAwareStyles.subtitle(context).copyWith(fontSize: 14)),
            const SizedBox(height: 12),
            Container(height: 1, color: Theme.of(context).dividerColor.withOpacity(0.5)),
            const SizedBox(height: 12),
            Text(
              '${widget.selectedSeats.length} Traveller(s) • ${widget.travelDate}',
              style: ThemeAwareStyles.body(context),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.access_time, size: 16, color: Theme.of(context).iconTheme.color ?? Colors.grey),
                const SizedBox(width: 8),
                Text(
                  '${widget.departureTime} - ${widget.arrivalTime}',
                  style: ThemeAwareStyles.body(context).copyWith(fontSize: 13),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.location_on, size: 16, color: Theme.of(context).iconTheme.color ?? Colors.grey),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    '${widget.boardingPoint} → ${widget.droppingPoint}',
                    style: ThemeAwareStyles.body(context).copyWith(fontSize: 13),
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
          color: Theme.of(context).cardColor,
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
                Text('Trip Details', style: ThemeAwareStyles.title(context)),
                IconButton(
                  icon: Icon(Icons.close, color: Theme.of(context).textTheme.titleLarge?.color ?? Colors.black),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text('Route', style: ThemeAwareStyles.cardTitle(context)),
            const SizedBox(height: 8),
            Text(
              '${widget.fromCity} → ${widget.toCity}',
              style: ThemeAwareStyles.body(context),
            ),
            const SizedBox(height: 12),
            Text('Bus', style: ThemeAwareStyles.cardTitle(context)),
            const SizedBox(height: 8),
            Text(widget.busName, style: ThemeAwareStyles.body(context)),
            const SizedBox(height: 12),
            Text('Date & Time', style: ThemeAwareStyles.cardTitle(context)),
            const SizedBox(height: 8),
            Text(
              '${widget.travelDate} | ${widget.departureTime} - ${widget.arrivalTime}',
              style: ThemeAwareStyles.body(context),
            ),
            const SizedBox(height: 12),
            Text('Boarding & Dropping', style: ThemeAwareStyles.cardTitle(context)),
            const SizedBox(height: 8),
            Text(
              '${widget.boardingPoint} → ${widget.droppingPoint}',
              style: ThemeAwareStyles.body(context),
            ),
            const SizedBox(height: 12),
            Text('Seats', style: ThemeAwareStyles.cardTitle(context)),
            const SizedBox(height: 8),
            Text(
              widget.selectedSeats.join(', '),
              style: ThemeAwareStyles.body(context),
            ),
            const SizedBox(height: 16),
            Text('Total Fare', style: ThemeAwareStyles.cardTitle(context)),
            const SizedBox(height: 8),
            Text(
              '₹${(widget.fare * widget.selectedSeats.length).toStringAsFixed(2)}',
              style: ThemeAwareStyles.body(context).copyWith(
                color: ThemeAwareColors.accent(context),
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
            Text('Contact Details', style: ThemeAwareStyles.cardTitle(context)),
            const SizedBox(height: 8),
            Text(
              'Your ticket & updates will be sent here',
              style: ThemeAwareStyles.subtitle(context),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: 'Email ID',
                prefixIcon: Icon(Icons.email_outlined,
                    size: 20, color: Theme.of(context).iconTheme.color ?? Colors.grey),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Theme.of(context).dividerColor),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Theme.of(context).dividerColor),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: ThemeAwareColors.primary(context), width: 1.5),
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
                    size: 20, color: Theme.of(context).iconTheme.color ?? Colors.grey),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Theme.of(context).dividerColor),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Theme.of(context).dividerColor),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: ThemeAwareColors.primary(context), width: 1.5),
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
            const SizedBox(height: 16),
            TextFormField(
              controller: _emergencyContactController,
              decoration: InputDecoration(
                labelText: 'Emergency Contact Number',
                prefixIcon: Icon(Icons.emergency_outlined,
                    size: 20, color: Theme.of(context).iconTheme.color ?? Colors.grey),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Theme.of(context).dividerColor),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Theme.of(context).dividerColor),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: ThemeAwareColors.primary(context), width: 1.5),
                ),
              ),
              keyboardType: TextInputType.phone,
              maxLength: 10,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Emergency contact is required';
                }
                if (!GetUtils.isPhoneNumber(value) || value.length != 10) {
                  return 'Enter a valid 10-digit number';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _specialRequirementsController,
              decoration: InputDecoration(
                labelText: 'Special Requirements (Optional)',
                prefixIcon: Icon(Icons.accessibility_new,
                    size: 20, color: Theme.of(context).iconTheme.color ?? Colors.grey),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Theme.of(context).dividerColor),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Theme.of(context).dividerColor),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: ThemeAwareColors.primary(context), width: 1.5),
                ),
              ),
              maxLines: 2,
              maxLength: 200,
            ),
          ],
        ),
      );

  Widget _buildPassengerDetailsCard() => _buildCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                border: Border(
                  bottom:
                      BorderSide(color: Theme.of(context).dividerColor.withOpacity(0.3)),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: ThemeAwareColors.primary(context).withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(Icons.people_alt_rounded,
                            color: ThemeAwareColors.primary(context), size: 20),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        'Passenger Details',
                        style: ThemeAwareStyles.cardTitle(context).copyWith(fontSize: 18),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Enter details for each passenger. All fields are mandatory.',
                    style: ThemeAwareStyles.subtitle(context).copyWith(fontSize: 13),
                  ),
                ],
              ),
            ),

            // Passenger Forms
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
                  // child: _buildPassengerForm(index: index),
                  child: PassengerFormWidget(
                    index: index,
                    nameControllers: _nameControllers,
                    ageControllers: _ageControllers,
                    idNumberControllers: _idNumberControllers,
                    genderSelections: _genderSelections,
                    selectedIdProofTypes: _selectedIdProofTypes,
                    idProofTypes: _idProofTypes,
                    selectedSeats: widget.selectedSeats,
                    validateForm: _validateForm,
                    onGenderSelected: (genderIndex) {
                      void _onGenderSelected(int passengerIndex, int genderIndex) {
                        setState(() {
                          // Update the selected gender for the specific passenger
                          for (int i = 0; i < _genderSelections[passengerIndex].length; i++) {
                            _genderSelections[passengerIndex][i] = (i == genderIndex);
                          }
                        });
                      }
                      _onGenderSelected(index, genderIndex);
                      _validateForm();
                    },
                  )),
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
  //           color: ThemeAwareColors.primary(context).withOpacity(0.04),
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
  //                   ThemeAwareColors.primary(context).withOpacity(0.03),
  //                   ThemeAwareColors.primary(context).withOpacity(0.01),
  //                 ],
  //               ),
  //               borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
  //               border: Border(
  //                 bottom: BorderSide(color: Theme.of(context).dividerColor.withOpacity(0.2)),
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
  //                         color: ThemeAwareColors.primary(context),
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
  //                       style: ThemeAwareStyles.cardTitle(context).copyWith(
  //                         fontSize: 16,
  //                         color: Theme.of(context).textTheme.titleLarge?.color ?? Colors.black,
  //                       ),
  //                     ),
  //                   ],
  //                 ),
  //                 Container(
  //                   padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
  //                   decoration: BoxDecoration(
  //                     color: ThemeAwareColors.primary(context).withOpacity(0.1),
  //                     borderRadius: BorderRadius.circular(12),
  //                   ),
  //                   child: Row(
  //                     mainAxisSize: MainAxisSize.min,
  //                     children: [
  //                       Icon(Icons.event_seat_rounded,
  //                           color: ThemeAwareColors.primary(context), size: 16),
  //                       const SizedBox(width: 6),
  //                       Text(
  //                         'Seat ${widget.selectedSeats[index]}',
  //                         style: ThemeAwareStyles.body(context).copyWith(
  //                           fontWeight: FontWeight.w600,
  //                           color: ThemeAwareColors.primary(context),
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
  //                       style: ThemeAwareStyles.subtitle(context).copyWith(
  //                         fontSize: 13,
  //                         color: Theme.of(context).textTheme.bodySmall?.color ?? Colors.grey,
  //                         fontWeight: FontWeight.w500,
  //                       ),
  //                     ),
  //                     const SizedBox(height: 8),
  //                     Container(
  //                       decoration: BoxDecoration(
  //                         borderRadius: BorderRadius.circular(14),
  //                         boxShadow: [
  //                           BoxShadow(
  //                             color: ThemeAwareColors.primary(context).withOpacity(0.04),
  //                             blurRadius: 8,
  //                             offset: const Offset(0, 2),
  //                           ),
  //                         ],
  //                       ),
  //                       child: TextFormField(
  //                         controller: _nameControllers[index],
  //                         style: ThemeAwareStyles.body(context).copyWith(
  //                           fontSize: 15,
  //                           color: Theme.of(context).textTheme.titleLarge?.color ?? Colors.black,
  //                           height: 1.4,
  //                         ),
  //                         decoration: InputDecoration(
  //                           hintText: 'Enter full name',
  //                           hintStyle: ThemeAwareStyles.body(context).copyWith(
  //                             color: Theme.of(context).textTheme.bodySmall?.color ?? Colors.grey.withOpacity(0.7),
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
  //                               color: ThemeAwareColors.primary(context),
  //                               width: 1.5,
  //                             ),
  //                           ),
  //                           contentPadding: const EdgeInsets.symmetric(
  //                             horizontal: 18,
  //                             vertical: 16,
  //                           ),
  //                           prefixIcon: Icon(
  //                             Icons.person_outline_rounded,
  //                             color: ThemeAwareColors.primary(context),
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
  //                             style: ThemeAwareStyles.subtitle(context).copyWith(
  //                               fontSize: 13,
  //                               color: Theme.of(context).textTheme.bodySmall?.color ?? Colors.grey,
  //                               fontWeight: FontWeight.w500,
  //                             ),
  //                           ),
  //                           const SizedBox(height: 8),
  //                           Container(
  //                             decoration: BoxDecoration(
  //                               borderRadius: BorderRadius.circular(14),
  //                               boxShadow: [
  //                                 BoxShadow(
  //                                   color: ThemeAwareColors.primary(context).withOpacity(0.04),
  //                                   blurRadius: 8,
  //                                   offset: const Offset(0, 2),
  //                                 ),
  //                               ],
  //                             ),
  //                             child: TextFormField(
  //                               controller: _ageControllers[index],
  //                               style: ThemeAwareStyles.body(context).copyWith(
  //                                 fontSize: 15,
  //                                 color: Theme.of(context).textTheme.titleLarge?.color ?? Colors.black,
  //                                 height: 1.4,
  //                               ),
  //                               decoration: InputDecoration(
  //                                 hintText: 'Age',
  //                                 hintStyle: ThemeAwareStyles.body(context).copyWith(
  //                                   color: Theme.of(context).textTheme.bodySmall?.color ?? Colors.grey.withOpacity(0.7),
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
  //                                     color: ThemeAwareColors.primary(context),
  //                                     width: 1.5,
  //                                   ),
  //                                 ),
  //                                 contentPadding: const EdgeInsets.symmetric(
  //                                   horizontal: 18,
  //                                   vertical: 16,
  //                                 ),
  //                                 prefixIcon: Icon(
  //                                   Icons.cake_rounded,
  //                                   color: ThemeAwareColors.primary(context),
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
  //                         child: Column(
  //                           crossAxisAlignment: CrossAxisAlignment.start,
  //                           children: [
  //                             Text(
  //                               'Gender',
  //                               style: ThemeAwareStyles.subtitle(context).copyWith(
  //                                 fontSize: 13,
  //                                 color: Theme.of(context).textTheme.bodySmall?.color ?? Colors.grey,
  //                                 fontWeight: FontWeight.w500,
  //                               ),
  //                             ),
  //                             const SizedBox(height: 8),
  //                             _GenderSelector(
  //                               isSelected: _genderSelections[index],
  //                               onPressed: (genderIndex) {
  //                                 setState(() {
  //                                   for (int i = 0; i < _genderSelections[index].length; i++) {
  //                                     _genderSelections[index][i] = i == genderIndex;
  //                                   }
  //                                   _validateForm();
  //                                 });
  //                               },
  //                             ),
  //                           ],
  //                         ),
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
  //                           style: ThemeAwareStyles.subtitle(context).copyWith(
  //                             fontSize: 13,
  //                             color: Theme.of(context).textTheme.bodySmall?.color ?? Colors.grey,
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
  //                                   color: Theme.of(context).scaffoldBackgroundColor,
  //                                   borderRadius: BorderRadius.circular(10),
  //                                   border: Border.all(color: Theme.of(context).dividerColor),
  //                                 ),
  //                                 child: DropdownButtonHideUnderline(
  //                                   child: ButtonTheme(
  //                                     alignedDropdown: true,
  //                                     child: DropdownButtonFormField<String>(
  //                                       value: _selectedIdProofTypes[index],
  //                                       isExpanded: true,
  //                                       icon: Icon(Icons.keyboard_arrow_down_rounded,
  //                                           color: ThemeAwareColors.primary(context), size: 22),
  //                                       decoration: InputDecoration(
  //                                         contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
  //                                         border: InputBorder.none,
  //                                         hintText: 'ID Type',
  //                                         hintStyle: ThemeAwareStyles.body(context).copyWith(
  //                                           fontSize: 15,
  //                                           color: Theme.of(context).textTheme.bodySmall?.color ?? Colors.grey,
  //                                         ),
  //                                         prefixIcon: Icon(Icons.badge_outlined,
  //                                             color: ThemeAwareColors.primary(context).withOpacity(0.7), size: 20),
  //                                       ),
  //                                       style: ThemeAwareStyles.body(context).copyWith(
  //                                         fontSize: 15,
  //                                         color: Theme.of(context).textTheme.titleLarge?.color ?? Colors.black,
  //                                       ),
  //                                       dropdownColor: Colors.white,
  //                                       items: _idProofTypes.map((String type) {
  //                                         return DropdownMenuItem<String>(
  //                                           value: type,
  //                                           child: Text(
  //                                             type,
  //                                             style: ThemeAwareStyles.body(context).copyWith(fontSize: 15),
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
  //                                 style: ThemeAwareStyles.body(context).copyWith(fontSize: 15, color: Theme.of(context).textTheme.titleLarge?.color ?? Colors.black),
  //                                 decoration: InputDecoration(
  //                                   labelText: 'ID Number',
  //                                   labelStyle: ThemeAwareStyles.subtitle(context).copyWith(fontSize: 13, color: Theme.of(context).textTheme.bodySmall?.color ?? Colors.grey),
  //                                   floatingLabelStyle: TextStyle(color: ThemeAwareColors.primary(context)),
  //                                   hintText: 'Enter ID number',
  //                                   hintStyle: ThemeAwareStyles.body(context).copyWith(color: Theme.of(context).textTheme.bodySmall?.color ?? Colors.grey, fontSize: 15),
  //                                   border: OutlineInputBorder(
  //                                     borderRadius: BorderRadius.circular(10),
  //                                     borderSide: BorderSide(color: Theme.of(context).dividerColor),
  //                                   ),
  //                                   enabledBorder: OutlineInputBorder(
  //                                     borderRadius: BorderRadius.circular(10),
  //                                     borderSide: BorderSide(color: Theme.of(context).dividerColor),
  //                                   ),
  //                                   focusedBorder: OutlineInputBorder(
  //                                     borderRadius: BorderRadius.circular(10),
  //                                     borderSide: BorderSide(color: ThemeAwareColors.primary(context), width: 1.5),
  //                                   ),
  //                                   contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
  //                                   filled: true,
  //                                   fillColor: Theme.of(context).scaffoldBackgroundColor,
  //                                   prefixIcon: Icon(Icons.credit_card_rounded,
  //                                       color: ThemeAwareColors.primary(context).withOpacity(0.7), size: 20),
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.verified_user_outlined,
                    color: ThemeAwareColors.primary(context), size: 22),
              ],
            ),
          ],
        ),
      );

  Widget _buildBottomBar() {
    final double totalFare = widget.fare * widget.selectedSeats.length;
    final double finalFare = _tripProtectionEnabled
        ? totalFare + (109 * widget.selectedSeats.length)
        : totalFare;

    return Container(
      padding: EdgeInsets.fromLTRB(
          16, 12, 16, MediaQuery.of(context).padding.bottom + 16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
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
                style: ThemeAwareStyles.title(context).copyWith(
                  fontSize: 24,
                  color: ThemeAwareColors.accent(context),
                ),
              ),
              InkWell(
                onTap: () {
                  showModalBottomSheet(
                    context: context,
                    backgroundColor: Colors.transparent,
                    builder: (context) =>
                        _buildFareDetailsModal(totalFare, finalFare),
                  );
                },
                child: Text(
                  'View Fare Details',
                  style: ThemeAwareStyles.subtitle(context).copyWith(
                    color: ThemeAwareColors.accent(context),
                    decoration: TextDecoration.underline,
                    decorationColor: ThemeAwareColors.accent(context),
                  ),
                ),
              ),
            ],
          ),
          ElevatedButton(
            onPressed: _isFormValid ? _onProceed : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: ThemeAwareColors.primary(context),
              disabledBackgroundColor:
                  Theme.of(context).textTheme.bodySmall?.color ?? Colors.grey.withOpacity(0.4),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 0,
              shadowColor: ThemeAwareColors.primary(context).withOpacity(0.3),
            ),
            child: Text(
              'Proceed',
              style: ThemeAwareStyles.button(context),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFareDetailsModal(double totalFare, double finalFare) =>
      Container(
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
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
                Text('Fare Details', style: ThemeAwareStyles.title(context)),
                IconButton(
                  icon: Icon(Icons.close, color: Theme.of(context).textTheme.titleLarge?.color ?? Colors.black),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                    'Base Fare (${widget.selectedSeats.length} seat${widget.selectedSeats.length == 1 ? '' : 's'})',
                    style: ThemeAwareStyles.body(context)),
                Text('₹${totalFare.toStringAsFixed(0)}',
                    style: ThemeAwareStyles.body(context)),
              ],
            ),
            if (_tripProtectionEnabled) ...[
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                      'Trip Protection (${widget.selectedSeats.length} traveller${widget.selectedSeats.length == 1 ? '' : 's'})',
                      style: ThemeAwareStyles.body(context)),
                  Text(
                      '₹${(109 * widget.selectedSeats.length).toStringAsFixed(0)}',
                      style: ThemeAwareStyles.body(context)),
                ],
              ),
            ],
            const SizedBox(height: 12),
            Container(height: 1, color: Theme.of(context).dividerColor.withOpacity(0.5)),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Total Fare',
                    style:
                        ThemeAwareStyles.body(context).copyWith(fontWeight: FontWeight.w600)),
                Text(
                  '₹${finalFare.toStringAsFixed(0)}',
                  style: ThemeAwareStyles.body(context).copyWith(
                    fontWeight: FontWeight.w600,
                    color: ThemeAwareColors.accent(context),
                  ),
                ),
              ],
            ),
          ],
        ),
      );
}

