// ignore_for_file: directives_ordering, unused_local_variable, unused_element, avoid_catches_without_on_clauses

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter/services.dart';

import '../../../auth/presentation/controllers/login_controller.dart';
import '../../../train/presentation/controllers/travellerDetailController.dart';
import '../../../train/presentation/screens/traveller_detail_screen.dart';
import '../../../payment/easebuzz_payment_widget.dart';
import '../../../../core/widgets/common/traveller_form_widget.dart';
import '../../../../core/models/traveller_form_config.dart';
import '../controllers/hotel_controller.dart';

class BookingPreviewPage extends StatefulWidget {
  const BookingPreviewPage({
    required this.hotelDetails,
    required this.hotelId,
    required this.searchParams,
    required this.selectedRoom,
    required this.price,
    required this.taxes,
    Key? key,
  }) : super(key: key);

  final Map<String, dynamic> hotelDetails;
  final String hotelId;
  final Map<String, dynamic> searchParams;
  final Map<String, dynamic> selectedRoom;
  final double price;
  final double taxes;

  @override
  State<BookingPreviewPage> createState() => _BookingPreviewPageState();
}

class _BookingPreviewPageState extends State<BookingPreviewPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<TravellerFormWidgetState> _travellerFormKey = GlobalKey<TravellerFormWidgetState>();
  late final LoginController loginController;
  late final TravellerDetailController travellerController;
  late final SearchCityController hotelController;
  
  @override
  void initState() {
    super.initState();
    // Initialize LoginController safely
    if (!Get.isRegistered<LoginController>()) {
      Get.put(LoginController());
    }
    loginController = Get.find<LoginController>();
    
    // Initialize TravellerDetailController
    if (!Get.isRegistered<TravellerDetailController>()) {
      Get.put(TravellerDetailController());
    }
    travellerController = Get.find<TravellerDetailController>();
    
    // Initialize HotelController
    if (!Get.isRegistered<SearchCityController>()) {
      Get.put(SearchCityController());
    }
    hotelController = Get.find<SearchCityController>();
    
    // Initialize form configuration for adding hotel guests (simplified - only name, email, mobile)
    _addGuestConfig = TravellerFormConfig(
      travelType: TravelType.hotel,
      showName: true, // Show full name field
      showEmail: true, // Show email field
      showMobile: true, // Show mobile field
      showMobilePrefix: true, // Show mobile prefix dropdown
      showAddress: false, // Hide address fields
      showCity: false,
      showPostalCode: false,
      showCountry: false,
      showTitle: false, // Hide title dropdown
      showMiddleName: false, // Hide middle name
      showFirstName: false, // Hide first name (use full name instead)
      showLastName: false, // Hide last name
      showAge: false, // Hide age
      showGender: false, // Hide gender
      showRoomId: false, // Hide room ID
      showLeadPax: false, // Hide lead passenger checkbox
      showPaxType: false, // Hide passenger type
      showDob: false, // Hide date of birth
      title: 'Add Guest',
      subtitle: 'Add a guest to your booking',
      mobilePrefixOptions: ['+91', '+1', '+44', '+61', '+971'],
      useSections: false,
    );
    
    _fetchUserContactDetails();
  }
  
  // Form field controllers
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _postalCodeController = TextEditingController();
  final TextEditingController _countryController = TextEditingController();
  final TextEditingController _specialRequestsController = TextEditingController();

  late String userName = '';
  late String userEmail = '';
  late String userPhone = '';
  late String userAddress = '';
  late String userCity = '';
  late String userPostalCode = '';
  late String userCountry = 'India';
  late String specialRequests = '';

  bool _isProcessing = false;
  List<String> selectedTravellers = [];
  bool _showAddGuestForm = false;
  final GlobalKey<FormState> _addGuestFormKey = GlobalKey<FormState>();
  final GlobalKey<TravellerFormWidgetState> _addGuestFormWidgetKey = GlobalKey<TravellerFormWidgetState>();
  
  // Store form data when saved via callback
  Map<String, dynamic>? _savedGuestFormData;
  
  // Store prebook response and booking data for book complete API
  Map<String, dynamic>? _prebookResponse;
  Map<String, dynamic>? _storedPrimaryGuest;
  List<Map<String, dynamic>>? _storedSelectedTravellers;
  
  // Configuration for adding hotel guests (simpler form - just name, age, gender)
  late final TravellerFormConfig _addGuestConfig;

  // Demo traveler details
  // String userName = 'John Doe';
  // String userEmail = 'john.doe@example.com';
  // String userPhone = '+1 (555) 123-4567';
  // String userAddress = '123 Traveler Street';
  // String userCity = 'New York';
  // String userCountry = 'United States';
  // String userPostalCode = '10001';
  // String specialRequests = 'Early check-in requested if possible';


  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _cityController.dispose();
    _postalCodeController.dispose();
    _countryController.dispose();
    _specialRequestsController.dispose();
    super.dispose();
  }

  Future<void> _fetchUserContactDetails() async {
    // ============================================
    // HOTEL BOOKING DATA REQUIREMENTS:
    // ============================================
    // 1. PRIMARY GUEST (REQUIRED) - From USERS table:
    //    - This is the logged-in user making the booking
    //    - Required: Name, Email, Phone (for booking confirmation)
    //    - Optional: Address, City, Country (for billing)
    //
    // 2. ADDITIONAL GUESTS (OPTIONAL) - From TRAVELLERS table:
    //    - Saved travellers that can be added to the booking
    //    - Used for: Guest list, room occupancy
    //    - Fields: Name, Age, Gender (to identify adults/children)
    // ============================================
    
    // Fetch PRIMARY GUEST data from USERS table (logged-in user)
    if (loginController.userData.isEmpty) {
      await loginController.fetchUserProfile();
    }
    
    // Fetch ADDITIONAL GUESTS from TRAVELLERS table (optional)
    await travellerController.fetchTravelers();
    
    // Initialize PRIMARY GUEST contact form with data from USERS table
    if (mounted) {
      // Get user data from USERS table
      final email = loginController.userEmail; // From users.email
      final phone = loginController.userPhone; // From users.phoneNumber
      final firstName = loginController.userData['firstName'] ?? '';
      final lastName = loginController.userData['lastName'] ?? '';
      final fullName = '$firstName $lastName'.trim();
      final nationality = loginController.userNationality; // From users.nationality
      
      // Set default values for variables (form will auto-fill via initialData)
      if (email.isNotEmpty) {
        userEmail = email;
      }
      if (phone.isNotEmpty) {
        userPhone = phone;
      }
      if (fullName.isNotEmpty) {
        userName = fullName;
      }
      
      // Set default country from user nationality or default to India
      userCountry = nationality.isNotEmpty ? nationality : 'India';
    }
  }

  // SOLUTION 1: Add a robust parsing function for coordinates.
  double? _parseCoordinate(dynamic value) {
    if (value == null) return null;
    if (value is num) return value.toDouble();
    if (value is String) return double.tryParse(value);
    return null;
  }

  // Helper method to extract mobile prefix from phone number
  String _extractMobilePrefix(String phone) {
    if (phone.isEmpty) return '+91';
    if (phone.startsWith('+91')) return '+91';
    if (phone.startsWith('+1')) return '+1';
    if (phone.startsWith('+44')) return '+44';
    if (phone.startsWith('+61')) return '+61';
    if (phone.startsWith('+971')) return '+971';
    // Default to +91 if no prefix found
    return '+91';
  }

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> hotelDetail =
        widget.hotelDetails['HotelDetail'] ?? <dynamic, dynamic>{};
    final String hotelName = hotelDetail['HotelName'] ?? 'Hotel';
    final String hotelAddress = hotelDetail['HotelAddress']?['Address'] ?? '';
    final String hotelCity = hotelDetail['HotelAddress']?['City'] ?? '';
    final String hotelRating = hotelDetail['StarRating']?.toString() ?? 'N/A';
    // Default hotel image if none provided
    final String hotelImage = (hotelDetail['HotelImages'] is List &&
            hotelDetail['HotelImages'].isNotEmpty)
        ? hotelDetail['HotelImages'][0]
        : 'https://via.placeholder.com/800x400?text=Hotel+Image';

    // SOLUTION 2: Use the safe parsing function instead of casting.
    final double? latitude =
        _parseCoordinate(hotelDetail['HotelAddress']?['Latitude']);
    final double? longitude =
        _parseCoordinate(hotelDetail['HotelAddress']?['Longitude']);

    final Map<String, dynamic> room = widget.selectedRoom;
    final String roomName = room['Name'] ?? 'Selected Room';
    final String roomImage = room['Image']?['ImageUrl'] ?? '';
    final String guests = widget.searchParams['adults']?.toString() ?? '2';
    final String roomsCount = widget.searchParams['rooms']?.toString() ?? '1';
    final String checkIn = widget.searchParams['checkInDate'] ?? 'N/A';
    // SOLUTION 3: Fix typo from search_params to searchParams.
    final String checkOut = widget.searchParams['checkOutDate'] ?? 'N/A';
    final String offer = room['Offer'] ?? hotelDetail['Offer'] ?? '';

    final int numRooms = int.tryParse(roomsCount) ?? 1;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text('Booking Preview',
            style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).appBarTheme.titleTextStyle?.color ??
                    Theme.of(context).colorScheme.onPrimary)),
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor ??
            Theme.of(context).primaryColor,
        elevation: 0,
        foregroundColor: Theme.of(context).appBarTheme.foregroundColor ??
            Theme.of(context).colorScheme.onPrimary,
        centerTitle: true,
      ),
      body: Stack(
        children: <Widget>[
          ListView(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 120),
            children: <Widget>[
              _buildHotelCard(hotelImage, hotelName, hotelAddress, hotelCity,
                  hotelRating, latitude, longitude),
              _buildRoomCard(roomImage, roomName, guests, roomsCount, offer),
              _buildSectionCard(
                title: 'Travel Details',
                icon: Icons.calendar_today,
                children: <Widget>[
                  _buildDetailItem('Check-in', checkIn),
                  _buildDetailItem('Check-out', checkOut),
                  _buildDetailItem('Guests', '$guests Adults'),
                  _buildDetailItem(
                      'Rooms', "$numRooms ${numRooms > 1 ? 'Rooms' : 'Room'}"),
                ],
              ),
              _buildFareSummary(widget.price, widget.taxes),
              _buildTravellersSection(),
            ],
          ),
          _buildBottomBar(widget.price, widget.taxes),
        ],
      ),
    );
  }

  // --- The rest of the file remains the same as the previous corrected version ---

  void _showMapDialog(double latitude, double longitude) {
    showDialog(
      context: context,
      builder: (BuildContext context) => Dialog(
        insetPadding: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: SizedBox(
          height: 350,
          width: double.infinity,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: FlutterMap(
              options: MapOptions(
                initialCenter: LatLng(latitude, longitude),
                initialZoom: 15,
              ),
              children: <Widget>[
                TileLayer(
                  urlTemplate:
                      'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                  subdomains: const <String>['a', 'b', 'c'],
                  userAgentPackageName: 'com.example.seemytrip',
                ),
                MarkerLayer(
                  markers: <Marker>[
                    Marker(
                      width: 40,
                      height: 40,
                      point: LatLng(latitude, longitude),
                      child: Icon(Icons.location_on,
                          color: Theme.of(context).brightness == Brightness.dark
                              ? const Color(
                                  0xFFFF5722) // Orange-red for dark theme
                              : const Color(0xFFCA0B0B), // Red for light theme
                          size: 40),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHotelCard(String image, String name, String address, String city,
          String rating, double? latitude, double? longitude) =>
      AppCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Stack(
              children: <Widget>[
                ClipRRect(
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(18)),
                  child: image.startsWith('http')
                      ? Image.network(
                          image,
                          width: double.infinity,
                          height: 180,
                          fit: BoxFit.cover,
                          errorBuilder: (BuildContext context, Object error,
                                  StackTrace? stackTrace) =>
                              Container(
                            height: 180,
                            color: Colors.grey[100],
                            child: Icon(Icons.image_not_supported,
                                size: 50, color: Colors.grey[400]),
                          ),
                        )
                      : Image.asset(
                          image,
                          height: 180,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                ),
                Positioned(
                  top: 12,
                  right: 12,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: <BoxShadow>[
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        const Icon(Icons.star, size: 16, color: Colors.amber),
                        const SizedBox(width: 4),
                        Text(
                          rating,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    name,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.3,
                      height: 1.3,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Icon(Icons.location_on_outlined,
                          size: 18, color: Colors.grey[600]),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          '$address, $city',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[700],
                            height: 1.4,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  if (latitude != null && longitude != null)
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        onPressed: () => _showMapDialog(latitude, longitude),
                        icon: Icon(Icons.map_outlined,
                            size: 18,
                            color:
                                Theme.of(context).brightness == Brightness.dark
                                    ? const Color(
                                        0xFFFF5722) // Orange-red for dark theme
                                    : const Color(
                                        0xFFCA0B0B)), // Red for light theme
                        label: Text(
                          'View on Map',
                          style: TextStyle(
                            color:
                                Theme.of(context).brightness == Brightness.dark
                                    ? const Color(
                                        0xFFFF5722) // Orange-red for dark theme
                                    : const Color(
                                        0xFFCA0B0B), // Red for light theme
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                        ),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          side: BorderSide(
                              color: (Theme.of(context).brightness ==
                                          Brightness.dark
                                      ? const Color(
                                          0xFFFF5722) // Orange-red for dark theme
                                      : const Color(0xFFCA0B0B))
                                  .withOpacity(0.3)), // Red for light theme
                          backgroundColor: (Theme.of(context).brightness ==
                                      Brightness.dark
                                  ? const Color(
                                      0xFFFF5722) // Orange-red for dark theme
                                  : const Color(0xFFCA0B0B))
                              .withOpacity(0.05), // Red for light theme
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      );

  Widget _buildRoomCard(
      String image, String name, String guests, String rooms, String offer) {
    final int numRooms = int.tryParse(rooms) ?? 1;
    final int numGuests = int.tryParse(guests) ?? 2;

    return AppCard(
        child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        ClipRRect(
          borderRadius: BorderRadius.circular(14),
          child: Image.network(
            image,
            width: 100,
            height: 100,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) => Container(
              width: 100,
              height: 100,
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.grey[800]
                  : Colors.grey[100],
              child: Icon(Icons.king_bed_rounded,
                  color: Theme.of(context).brightness == Brightness.dark
                      ? const Color(0xFFFF5722) // Orange-red for dark theme
                      : const Color(0xFFCA0B0B), // Red for light theme
                  size: 40),
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                name,
                style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    letterSpacing: -0.2),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 8),
              Row(
                children: <Widget>[
                  _buildRoomDetailChip(
                      Icons.person_outline, '$numGuests Adults'),
                  const SizedBox(width: 8),
                  _buildRoomDetailChip(Icons.king_bed_outlined,
                      "$numRooms ${numRooms > 1 ? 'Rooms' : 'Room'}"),
                ],
              ),
              if (offer.isNotEmpty) ...[
                const SizedBox(height: 10),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.green[50],
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.green[100]!),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Icon(Icons.local_offer_outlined,
                          size: 14, color: Colors.green[800]),
                      const SizedBox(width: 6),
                      Text(
                        offer,
                        style: TextStyle(
                          color: Colors.green[800],
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    ));
  }

  Widget _buildRoomDetailChip(IconData icon, String text) => Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
      decoration: BoxDecoration(
        color: (Theme.of(context).brightness == Brightness.dark
                ? const Color(0xFFFF5722) // Orange-red for dark theme
                : const Color(0xFFCA0B0B))
            .withOpacity(0.08), // Red for light theme
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Icon(icon,
              size: 14,
              color: Theme.of(context).brightness == Brightness.dark
                  ? const Color(0xFFFF5722) // Orange-red for dark theme
                  : const Color(0xFFCA0B0B)), // Red for light theme
          const SizedBox(width: 4),
          Text(
            text,
            style: TextStyle(
              fontSize: 12,
              color: (Theme.of(context).brightness == Brightness.dark
                      ? const Color(0xFFFF5722) // Orange-red for dark theme
                      : const Color(0xFFCA0B0B))
                  .withOpacity(0.9), // Red for light theme
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ));

  Widget _buildSectionCard(
          {required String title,
          required IconData icon,
          required List<Widget> children}) =>
      AppCard(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: Colors.orange[50],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, size: 20, color: Colors.orange[700]),
              ),
              const SizedBox(width: 12),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.2,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          ...children
              .map((Widget e) => Padding(
                    padding: const EdgeInsets.only(top: 12),
                    child: e,
                  ))
              .toList(),
        ],
      ));

  Widget _buildDetailItem(String label, String value, {bool isBold = false}) =>
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          children: <Widget>[
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                  fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ),
            Text(
              value,
              style: TextStyle(
                fontSize: isBold ? 15 : 14,
                fontWeight: isBold ? FontWeight.bold : FontWeight.w600,
                color: isBold
                    ? (Theme.of(context).brightness == Brightness.dark
                        ? const Color(0xFFFF5722) // Orange-red for dark theme
                        : const Color(0xFFCA0B0B)) // Red for light theme
                    : Theme.of(context).textTheme.titleMedium?.color,
              ),
            ),
          ],
        ),
      );

  Widget _buildFareSummary(double price, double taxes) => AppCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Fare Summary',
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.2),
            ),
            const SizedBox(height: 16),
            _fareRow('Room Price', price),
            const SizedBox(height: 8),
            _fareRow('Taxes & Fees', taxes),
            Container(
              margin: const EdgeInsets.symmetric(vertical: 12),
              height: 1,
              color: Colors.grey[200],
            ),
            _fareRow(
              'Total Amount',
              price + taxes,
              isTotal: true,
            ),
          ],
        ),
      );

  Widget _fareRow(String title, double amount, {bool isTotal = false}) {
    final String formattedAmount =
        '₹${amount.toStringAsFixed(amount.truncateToDouble() == amount ? 0 : 2)}';

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            title,
            style: TextStyle(
              fontSize: isTotal ? 16 : 14,
              fontWeight: isTotal ? FontWeight.w700 : FontWeight.w500,
              color: isTotal
                  ? Theme.of(context).textTheme.titleLarge?.color
                  : Theme.of(context).textTheme.bodySmall?.color,
            ),
          ),
          Text(
            formattedAmount,
            style: TextStyle(
              fontSize: isTotal ? 18 : 14,
              fontWeight: isTotal ? FontWeight.w800 : FontWeight.w600,
              color: isTotal
                  ? (Theme.of(context).brightness == Brightness.dark
                      ? const Color(0xFFFF5722) // Orange-red for dark theme
                      : const Color(0xFFCA0B0B)) // Red for light theme
                  : Theme.of(context).textTheme.titleLarge?.color,
            ),
          ),
        ],
      ),
    );
  }

  
  Widget _buildTravellersSection() => Obx(() {
    final travellers = travellerController.travellers;
    final selectedCount = selectedTravellers.length;
    
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section Header
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: Colors.purple[50],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(Icons.people_outline, size: 20, color: Colors.purple[700]),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Additional Guests',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        letterSpacing: -0.2,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      selectedCount > 0 
                          ? '$selectedCount guest${selectedCount > 1 ? 's' : ''} selected'
                          : 'Optional - Add guests for room occupancy',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              // Action Buttons
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    onPressed: () => Get.to(() => const TravellerDetailScreen()),
                    icon: Icon(Icons.manage_accounts_outlined, 
                        color: Colors.grey[700], size: 20),
                    tooltip: 'Manage travellers',
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                  const SizedBox(width: 8),
                  OutlinedButton.icon(
                    onPressed: () {
                      setState(() {
                        _showAddGuestForm = !_showAddGuestForm;
                      });
                    },
                    icon: Icon(
                      _showAddGuestForm ? Icons.close : Icons.add,
                      size: 16,
                    ),
                    label: Text(_showAddGuestForm ? 'Cancel' : 'Add Guest'),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      side: BorderSide(
                        color: Theme.of(context).brightness == Brightness.dark
                            ? const Color(0xFFFF5722)
                            : const Color(0xFFCA0B0B),
                      ),
                      foregroundColor: Theme.of(context).brightness == Brightness.dark
                          ? const Color(0xFFFF5722)
                          : const Color(0xFFCA0B0B),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          
          // Add Guest Form (expandable)
          if (_showAddGuestForm) ...[
            Container(
              margin: const EdgeInsets.only(bottom: 16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.grey[800]?.withOpacity(0.5)
                    : Colors.grey[50],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Theme.of(context).dividerColor.withOpacity(0.3),
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
                    initialData: _editingTravellerData, // Pre-fill form when editing
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
                            _editingTravellerId = null;
                            _editingTravellerData = null;
                          });
                        },
                        child: const Text('Cancel'),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton(
                        onPressed: () async {
                          await Future.microtask(() {});
                          
                          if (!_addGuestFormKey.currentState!.validate()) {
                            return;
                          }
                          
                          _addGuestFormKey.currentState?.save();
                          
                          Map<String, dynamic>? formData;
                          final widgetState = _addGuestFormWidgetKey.currentState;
                          
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
                              final firstName = formData['firstName'] ?? '';
                              final middleName = formData['middleName'] ?? '';
                              final lastName = formData['lastName'] ?? '';
                              final fullName = formData['name'] ?? formData['passengerName'] ?? '';
                              
                              final name = (firstName.isNotEmpty || lastName.isNotEmpty)
                                  ? [firstName, middleName, lastName].where((n) => n.isNotEmpty).join(' ').trim()
                                  : fullName;
                              
                              final numRooms = int.tryParse(widget.searchParams['rooms']?.toString() ?? '1') ?? 1;
                              final existingTravellersCount = travellerController.travellers.length;
                              final roomId = ((existingTravellersCount % numRooms) + 1).toString();
                              
                              final isEditing = _editingTravellerId != null;
                              
                              if (isEditing) {
                                // Update existing traveller
                                await travellerController.editTraveller(
                                  passengerId: _editingTravellerId.toString(),
                                  name: name,
                                  mobile: formData['mobile'] ?? formData['passengerMobileNumber'] ?? '',
                                  email: formData['email'] ?? formData['contact_email'] ?? '',
                                  address: formData['address'] ?? '',
                                  // Note: editTraveller doesn't support all fields, only basic ones
                                  age: formData['age']?.toString(),
                                  gender: formData['gender']?.toString(),
                                );
                              } else {
                                // Create new traveller
                                await travellerController.saveTravellerDetails(
                                  name: name,
                                  mobile: formData['mobile'] ?? formData['passengerMobileNumber'] ?? '',
                                  email: formData['email'] ?? formData['contact_email'] ?? '',
                                  address: formData['address'] ?? '',
                                  title: formData['title'],
                                  firstName: firstName.isNotEmpty ? firstName : null,
                                  middleName: middleName.isNotEmpty ? middleName : null,
                                  lastName: lastName.isNotEmpty ? lastName : null,
                                  mobilePrefix: formData['mobilePrefix'] ?? formData['mobile_prefix'] ?? '+91',
                                  roomId: formData['roomId'] ?? formData['room_id'] ?? roomId,
                                  leadPax: false,
                                  paxType: formData['paxType'] ?? formData['pax_type'] ?? 'A',
                                  dob: formData['dob'] ?? formData['dateOfBirth'],
                                );
                              }
                              
                              await travellerController.fetchTravelers();
                              
                              if (mounted) {
                                final wasEditing = isEditing;
                                
                                // Clear editing state
                                setState(() {
                                  _addGuestFormKey.currentState?.reset();
                                  _savedGuestFormData = null;
                                  _showAddGuestForm = false;
                                  _editingTravellerId = null;
                                  _editingTravellerData = null;
                                });
                                
                                Get.snackbar(
                                  'Success',
                                  wasEditing 
                                      ? 'Guest updated successfully'
                                      : 'Guest added successfully',
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
                          backgroundColor: Theme.of(context).brightness == Brightness.dark
                              ? const Color(0xFFFF5722)
                              : const Color(0xFFCA0B0B),
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
          
          // Travellers List
          if (travellers.isEmpty && !_showAddGuestForm)
            Container(
              padding: const EdgeInsets.symmetric(vertical: 24),
              alignment: Alignment.center,
              child: Column(
                children: [
                  Icon(
                    Icons.people_outline,
                    size: 48,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'No saved guests',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[700],
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Add guests for room occupancy or proceed with primary contact',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            )
          else
            Column(
              children: travellers.map((traveller) {
                final name = traveller['passengerName'] ?? 
                            traveller['firstname'] ?? 
                            '${traveller['firstName'] ?? ''} ${traveller['lastName'] ?? ''}'.trim();
                final age = traveller['passengerAge'] ?? traveller['age'];
                final ageNum = age != null ? (age is int ? age : int.tryParse(age.toString())) : null;
                final isSelected = selectedTravellers.contains(name);
                final isChild = ageNum != null && ageNum < 18;
                
                return Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: isSelected
                          ? (Theme.of(context).brightness == Brightness.dark
                              ? const Color(0xFFFF5722)
                              : const Color(0xFFCA0B0B))
                          : Colors.grey[300]!,
                      width: isSelected ? 1.5 : 1,
                    ),
                    color: isSelected
                        ? (Theme.of(context).brightness == Brightness.dark
                            ? const Color(0xFFFF5722).withOpacity(0.1)
                            : const Color(0xFFCA0B0B).withOpacity(0.05))
                        : Colors.transparent,
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    leading: CircleAvatar(
                      radius: 20,
                      backgroundColor: isSelected
                          ? (Theme.of(context).brightness == Brightness.dark
                              ? const Color(0xFFFF5722)
                              : const Color(0xFFCA0B0B))
                          : Colors.grey[300],
                      child: Text(
                        name.isNotEmpty ? name[0].toUpperCase() : '?',
                        style: TextStyle(
                          color: isSelected ? Colors.white : Colors.grey[700],
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    title: Text(
                      name,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    subtitle: ageNum != null
                        ? Text(
                            '$ageNum years • ${isChild ? 'Child' : 'Adult'}',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          )
                        : null,
                    trailing: Checkbox(
                      value: isSelected,
                      onChanged: (value) {
                        if (value == true) {
                          // Check if email and mobile number are present
                          final email = traveller['contact_email'] ?? traveller['email'] ?? '';
                          final mobile = traveller['passengerMobileNumber'] ?? traveller['mobile'] ?? traveller['phone'] ?? '';
                          
                          // Check if email or mobile is missing
                          if (email.isEmpty || mobile.isEmpty) {
                            // Show dialog asking to edit
                            _showEditGuestDialog(traveller, name);
                          } else {
                            // Both email and mobile are present, allow selection
                            if (!selectedTravellers.contains(name)) {
                              setState(() {
                                selectedTravellers.add(name);
                              });
                              print('✅ Guest selected: $name. Total selected: ${selectedTravellers.length}');
                            }
                          }
                        } else {
                          // Deselecting - no validation needed
                          if (selectedTravellers.contains(name)) {
                            setState(() {
                              selectedTravellers.remove(name);
                            });
                            print('❌ Guest deselected: $name. Total selected: ${selectedTravellers.length}');
                          }
                        }
                      },
                      activeColor: Theme.of(context).brightness == Brightness.dark
                          ? const Color(0xFFFF5722)
                          : const Color(0xFFCA0B0B),
                    ),
                  ),
                );
              }).toList(),
            ),
        ],
      ),
    );
  });

  /// Show dialog asking user to edit guest information when email or mobile is missing
  void _showEditGuestDialog(Map<String, dynamic> traveller, String name) {
    final email = traveller['contact_email'] ?? traveller['email'] ?? '';
    final mobile = traveller['passengerMobileNumber'] ?? traveller['mobile'] ?? traveller['phone'] ?? '';
    
    // Build message indicating what's missing
    final List<String> missingFields = [];
    if (email.isEmpty) missingFields.add('Email');
    if (mobile.isEmpty) missingFields.add('Mobile Number');
    final missingFieldsText = missingFields.join(' and ');
    
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
          title: const Text('Missing Information'),
          content: Text(
            'This guest is missing $missingFieldsText. Please edit the guest information to add the missing details.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                // Open the add guest form with pre-filled data
                _openEditGuestForm(traveller);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).brightness == Brightness.dark
                    ? const Color(0xFFFF5722)
                    : const Color(0xFFCA0B0B),
                foregroundColor: Colors.white,
              ),
              child: const Text('Edit Guest'),
            ),
          ],
        ),
    );
  }

  /// Open the add guest form with pre-filled traveller data for editing
  void _openEditGuestForm(Map<String, dynamic> traveller) {
    // Show the add guest form
    setState(() {
      _showAddGuestForm = true;
    });
    
    // Pre-fill the form with traveller data
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final widgetState = _addGuestFormWidgetKey.currentState;
      if (widgetState != null) {
        // Initialize form with traveller data
        // The form will auto-populate if we set initialData, but we need to update it
        // Since we're using a form widget, we'll need to manually set the values
        // For now, we'll set the form to show and the user can edit
        
        // Scroll to the form section
        Scrollable.ensureVisible(
          _addGuestFormWidgetKey.currentContext ?? context,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      }
    });
    
    // Create initial data map for the form
    final initialData = <String, dynamic>{
      'passengerName': traveller['passengerName'] ?? 
                       traveller['firstname'] ?? 
                       '${traveller['firstName'] ?? ''} ${traveller['lastName'] ?? ''}'.trim(),
      'name': traveller['passengerName'] ?? 
              traveller['firstname'] ?? 
              '${traveller['firstName'] ?? ''} ${traveller['lastName'] ?? ''}'.trim(),
      'contact_email': traveller['contact_email'] ?? traveller['email'] ?? '',
      'email': traveller['contact_email'] ?? traveller['email'] ?? '',
      'passengerMobileNumber': traveller['passengerMobileNumber'] ?? 
                               traveller['mobile'] ?? 
                               traveller['phone'] ?? '',
      'mobile': traveller['passengerMobileNumber'] ?? 
                traveller['mobile'] ?? 
                traveller['phone'] ?? '',
      'mobilePrefix': traveller['mobilePrefix'] ?? traveller['mobile_prefix'] ?? '+91',
      'mobile_prefix': traveller['mobilePrefix'] ?? traveller['mobile_prefix'] ?? '+91',
    };
    
    // Store the traveller ID for updating later
    _editingTravellerId = traveller['id'] ?? traveller['passengerId'];
    _editingTravellerData = initialData;
  }
  
  // Store editing traveller info
  dynamic _editingTravellerId;
  Map<String, dynamic>? _editingTravellerData;

  
  Widget _formFieldWithController(
    String label, {
    required TextEditingController controller,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
    void Function(String?)? onSaved,
    IconData? prefixIcon,
    int? maxLines,
  }) =>
      TextFormField(
        controller: controller,
        maxLines: maxLines,
        keyboardType: keyboardType,
        style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: Colors.grey[600], fontSize: 14),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
                color: Theme.of(context).brightness == Brightness.dark
                    ? const Color(0xFFFF5722) // Orange-red for dark theme
                    : const Color(0xFFCA0B0B), // Red for light theme
                width: 1.5),
          ),
          filled: true,
          fillColor: Theme.of(context).brightness == Brightness.dark
              ? Colors.grey[800]
              : Colors.grey[100],
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          prefixIcon: prefixIcon != null
              ? Padding(
                  padding: const EdgeInsets.only(left: 12, right: 8),
                  child: Icon(prefixIcon, size: 22, color: Colors.grey[600]),
                )
              : null,
        ),
        validator: validator,
        onSaved: onSaved,
        cursorColor: Theme.of(context).brightness == Brightness.dark
            ? const Color(0xFFFF5722) // Orange-red for dark theme
            : const Color(0xFFCA0B0B), // Red for light theme
      );

  Widget _buildBottomBar(double price, double taxes) => Positioned(
        left: 0,
        right: 0,
        bottom: 0,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: <BoxShadow>[
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 15,
                offset: const Offset(0, -2),
              ),
            ],
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: SafeArea(
            top: false,
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'Total Payable',
                        style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                            fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        _formatCurrency(price + taxes),
                        style: TextStyle(
                            fontWeight: FontWeight.w800,
                            fontSize: 22,
                            color:
                                Theme.of(context).brightness == Brightness.dark
                                    ? const Color(
                                        0xFFFF5722) // Orange-red for dark theme
                                    : const Color(
                                        0xFFCA0B0B), // Red for light theme
                            letterSpacing: -0.5),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  flex: 2,
                  child: ElevatedButton.icon(
                    onPressed: _isProcessing
                        ? null
                        : () async {
                            print('\n');
                            print('═══════════════════════════════════════════════════════════');
                            print('🏨 HOTEL BOOKING FLOW STARTED');
                            print('═══════════════════════════════════════════════════════════');
                            print('📅 Timestamp: ${DateTime.now().toIso8601String()}');
                            print('');
                            
                            // STEP 1: Validate guest count FIRST before proceeding to payment
                            print('📋 STEP 1: Guest Validation');
                            final requiredGuests = int.tryParse(widget.searchParams['adults']?.toString() ?? '2') ?? 2;
                            final selectedGuestsCount = selectedTravellers.length;
                            
                            print('   ✅ Required guests: $requiredGuests');
                            print('   ✅ Selected guests: $selectedGuestsCount');
                            
                            // Check if enough guests are selected
                            if (selectedGuestsCount < requiredGuests) {
                              final missingGuests = requiredGuests - selectedGuestsCount;
                              print('   ❌ ERROR: Missing $missingGuests guest(s)');
                              print('   ⚠️  Blocking payment - Guest validation failed');
                              print('═══════════════════════════════════════════════════════════\n');
                              
                              await showDialog(
                                context: context,
                                builder: (BuildContext context) => AlertDialog(
                                  title: Row(
                                    children: [
                                      Icon(
                                        Icons.people_outline,
                                        color: Colors.orange[700],
                                        size: 28,
                                      ),
                                      const SizedBox(width: 12),
                                      const Expanded(
                                        child: Text('Guest Selection Required'),
                                      ),
                                    ],
                                  ),
                                  content: Text(
                                    'This booking requires $requiredGuests guest${requiredGuests != 1 ? 's' : ''}.\n\nYou currently have ${selectedGuestsCount > 0 ? 'only $selectedGuestsCount' : 'no'} guest${selectedGuestsCount != 1 ? 's' : ''} selected. Please select ${missingGuests > 1 ? '$missingGuests more guests' : '1 more guest'} from the Additional Guests section below.',
                                    style: const TextStyle(fontSize: 15),
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.of(context).pop(),
                                      child: Text(
                                        'OK',
                                        style: TextStyle(
                                          color: Theme.of(context).brightness == Brightness.dark
                                              ? const Color(0xFFFF5722)
                                              : const Color(0xFFCA0B0B),
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                              return;
                            }
                            
                            // Check if too many guests are selected
                            if (selectedGuestsCount > requiredGuests) {
                              final extraGuests = selectedGuestsCount - requiredGuests;
                              print('   ❌ ERROR: Too many guests selected ($extraGuests extra)');
                              print('   ⚠️  Blocking payment - Guest validation failed');
                              print('═══════════════════════════════════════════════════════════\n');
                              
                              await showDialog(
                                context: context,
                                builder: (BuildContext context) => AlertDialog(
                                  title: Row(
                                    children: [
                                      Icon(
                                        Icons.warning_amber_rounded,
                                        color: Colors.orange[700],
                                        size: 28,
                                      ),
                                      const SizedBox(width: 12),
                                      const Expanded(
                                        child: Text('Too Many Guests Selected'),
                                      ),
                                    ],
                                  ),
                                  content: Text(
                                    'This booking requires only $requiredGuests guest${requiredGuests != 1 ? 's' : ''}. Please deselect $extraGuests guest${extraGuests != 1 ? 's' : ''}.',
                                    style: const TextStyle(fontSize: 15),
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.of(context).pop(),
                                      child: Text(
                                        'OK',
                                        style: TextStyle(
                                          color: Theme.of(context).brightness == Brightness.dark
                                              ? const Color(0xFFFF5722)
                                              : const Color(0xFFCA0B0B),
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                              return;
                            }
                            
                            print('   ✅ Guest validation PASSED');
                            print('');

                            // STEP 2: Get form data - use selected guest data if primary guest form doesn't exist
                            print('📋 STEP 2: Primary Guest Data Collection');
                            Map<String, dynamic>? formData;
                            
                            // If primary guest form exists and is valid, use it
                            if (_travellerFormKey.currentState != null && _formKey.currentState != null) {
                              if (!_formKey.currentState!.validate()) {
                                Get.snackbar(
                                  'Validation Error',
                                  'Please fill in all required primary guest details',
                                  backgroundColor: Colors.red,
                                  colorText: Colors.white,
                                );
                                return;
                              }
                              _formKey.currentState?.save();
                              formData = _travellerFormKey.currentState?.getFormData();
                            } else if (selectedTravellers.isNotEmpty) {
                              // No primary guest form - use first selected guest's data
                              final firstSelectedName = selectedTravellers.first;
                              final firstSelectedGuest = travellerController.travellers.firstWhere(
                                (t) {
                                  final tName = t['passengerName'] ?? 
                                               t['firstname'] ?? 
                                               '${t['firstName'] ?? ''} ${t['lastName'] ?? ''}'.trim();
                                  return tName == firstSelectedName;
                                },
                                orElse: () => <String, dynamic>{},
                              );
                              
                              if (firstSelectedGuest.isNotEmpty) {
                                formData = {
                                  'name': firstSelectedGuest['passengerName'] ?? 
                                          firstSelectedGuest['firstname'] ?? 
                                          '${firstSelectedGuest['firstName'] ?? ''} ${firstSelectedGuest['lastName'] ?? ''}'.trim(),
                                  'passengerName': firstSelectedGuest['passengerName'] ?? 
                                                  firstSelectedGuest['firstname'] ?? 
                                                  '${firstSelectedGuest['firstName'] ?? ''} ${firstSelectedGuest['lastName'] ?? ''}'.trim(),
                                  'email': firstSelectedGuest['contact_email'] ?? firstSelectedGuest['email'] ?? '',
                                  'contact_email': firstSelectedGuest['contact_email'] ?? firstSelectedGuest['email'] ?? '',
                                  'mobile': firstSelectedGuest['passengerMobileNumber'] ?? 
                                           firstSelectedGuest['mobile'] ?? 
                                           firstSelectedGuest['phone'] ?? '',
                                  'passengerMobileNumber': firstSelectedGuest['passengerMobileNumber'] ?? 
                                                          firstSelectedGuest['mobile'] ?? 
                                                          firstSelectedGuest['phone'] ?? '',
                                  'phone': firstSelectedGuest['passengerMobileNumber'] ?? 
                                          firstSelectedGuest['mobile'] ?? 
                                          firstSelectedGuest['phone'] ?? '',
                                };
                                print('✅ Using first selected guest data: ${formData['name']}');
                              }
                            }
                            if (formData != null) {
                              // Update all primary guest fields
                              final firstName = formData['firstName'] ?? '';
                              final middleName = formData['middleName'] ?? '';
                              final lastName = formData['lastName'] ?? '';
                              userName = formData['name'] ?? 
                                        formData['passengerName'] ?? 
                                        (firstName.isNotEmpty || lastName.isNotEmpty
                                            ? [firstName, middleName, lastName].where((n) => n.isNotEmpty).join(' ').trim()
                                            : userName);
                              userEmail = formData['email'] ?? formData['contact_email'] ?? userEmail;
                              // Combine mobile prefix with mobile number
                              final mobilePrefix = formData['mobilePrefix'] ?? formData['mobile_prefix'] ?? '+91';
                              final mobile = formData['mobile'] ?? formData['phone'] ?? formData['passengerMobileNumber'] ?? '';
                              userPhone = mobile.isNotEmpty ? '$mobilePrefix$mobile' : userPhone;
                              userAddress = formData['address'] ?? userAddress;
                              userCity = formData['city'] ?? userCity;
                              userPostalCode = formData['postalCode'] ?? userPostalCode;
                              userCountry = formData['country'] ?? userCountry;
                              
                              print('   ✅ Primary guest data collected from form');
                              print('      Name: $userName');
                              print('      Email: $userEmail');
                              print('      Phone: $userPhone');
                              
                              // Validate required fields are present
                              if (userEmail.isEmpty || userPhone.isEmpty || userName.isEmpty) {
                                print('   ❌ ERROR: Missing required fields (Name, Email, or Mobile)');
                                print('═══════════════════════════════════════════════════════════\n');
                                Get.snackbar(
                                  'Missing Information',
                                  'Please ensure Name, Email, and Mobile are filled',
                                  backgroundColor: Colors.orange,
                                  colorText: Colors.white,
                                );
                                return;
                              }
                            } else {
                              // If form data is not available, validate existing data
                              print('   ✅ Using existing primary guest data');
                              print('      Name: $userName');
                              print('      Email: $userEmail');
                              print('      Phone: $userPhone');
                              
                              if (userEmail.isEmpty || userPhone.isEmpty || userName.isEmpty) {
                                print('   ❌ ERROR: Missing required fields (Name, Email, or Mobile)');
                                print('═══════════════════════════════════════════════════════════\n');
                                Get.snackbar(
                                  'Missing Information',
                                  'Please fill in all required primary guest details',
                                  backgroundColor: Colors.red,
                                  colorText: Colors.white,
                                );
                                return;
                              }
                            }
                            print('');

                            setState(() => _isProcessing = true);
                            
                            try {
                              // STEP 3: Prepare primary guest data
                              print('📋 STEP 3: Preparing Booking Data');
                              final primaryGuest = {
                                'name': userName,
                                'email': userEmail,
                                'mobile': userPhone.replaceFirst(RegExp(r'^\+\d+'), ''), // Remove prefix if included
                                'mobilePrefix': _extractMobilePrefix(userPhone),
                                'phone': userPhone,
                              };
                              print('   ✅ Primary guest data prepared');
                              
                              // Prepare selected travellers data
                              print('   📝 Preparing selected travellers data...');
                              final selectedTravellersData = <Map<String, dynamic>>[];
                              for (var travellerName in selectedTravellers) {
                                final traveller = travellerController.travellers.firstWhere(
                                  (t) {
                                    final tName = t['passengerName'] ?? 
                                                 t['firstname'] ?? 
                                                 '${t['firstName'] ?? ''} ${t['lastName'] ?? ''}'.trim();
                                    return tName == travellerName;
                                  },
                                  orElse: () => <String, dynamic>{},
                                );
                                
                                if (traveller.isNotEmpty) {
                                  selectedTravellersData.add(traveller);
                                  print('      ✅ Added traveller: $travellerName');
                                }
                              }
                              print('   ✅ Total travellers prepared: ${selectedTravellersData.length}');
                              print('');
                              
                              // STEP 4: Call hotel prebook API before payment
                              print('📋 STEP 4: Calling Hotel Prebook API');
                              print('   🔄 Sending prebook request...');
                              final prebookResponse = await hotelController.hotelPrebook(
                                hotelDetails: widget.hotelDetails,
                                selectedRoom: widget.selectedRoom,
                                searchParams: widget.searchParams,
                                primaryGuest: primaryGuest,
                                selectedTravellers: selectedTravellersData,
                                currency: 'AED', // TODO: Get from search params or config
                              );
                              
                              print('   ✅ Prebook API Response Received');
                              print('   🔍 Prebook Response Structure:');
                              print('      Response keys: ${prebookResponse.keys.toList()}');
                              print('      Full prebook response: ${jsonEncode(prebookResponse)}');
                              
                              // Check if prebook was successful
                              if (prebookResponse['success'] == false || 
                                  (prebookResponse['error'] != null && prebookResponse['error'].toString().isNotEmpty)) {
                                print('   ❌ ERROR: Prebook API returned error');
                                print('      Error: ${prebookResponse['error'] ?? 'Prebook failed'}');
                                print('═══════════════════════════════════════════════════════════\n');
                                throw Exception(prebookResponse['error'] ?? 'Prebook failed');
                              }
                              
                              // Extract ReservationId and BookingId (try multiple variations)
                              String reservationId = prebookResponse['ReservationId']?.toString() ?? 
                                                    prebookResponse['reservationId']?.toString() ?? 
                                                    prebookResponse['ReservationID']?.toString() ??
                                                    prebookResponse['reservation_id']?.toString() ??
                                                    'N/A';
                              
                              dynamic bookingDetails = prebookResponse['BookingDetails'] ?? 
                                                      prebookResponse['bookingDetails'] ?? 
                                                      prebookResponse['booking_details'];
                              
                              String bookingId = 'N/A';
                              if (bookingDetails != null) {
                                if (bookingDetails is List && bookingDetails.isNotEmpty) {
                                  final firstBooking = bookingDetails[0];
                                  if (firstBooking is Map) {
                                    bookingId = firstBooking['BookingId']?.toString() ?? 
                                               firstBooking['bookingId']?.toString() ?? 
                                               firstBooking['BookingID']?.toString() ??
                                               'N/A';
                                  }
                                } else if (bookingDetails is Map) {
                                  bookingId = bookingDetails['BookingId']?.toString() ?? 
                                             bookingDetails['bookingId']?.toString() ?? 
                                             bookingDetails['BookingID']?.toString() ??
                                             'N/A';
                                }
                              }
                              
                              print('   ✅ Prebook SUCCESS');
                              print('      ReservationId: $reservationId');
                              print('      BookingId: $bookingId');
                              print('   📝 Full prebook response stored for book complete');
                              print('');
                              
                              // STEP 5: Store prebook response and booking data for book complete API
                              print('📋 STEP 5: Storing Prebook Data');
                              _prebookResponse = prebookResponse;
                              _storedPrimaryGuest = primaryGuest;
                              _storedSelectedTravellers = selectedTravellersData;
                              print('   ✅ Prebook data stored successfully');
                              print('');
                              
                              // STEP 6: Proceed to payment after successful prebook
                              print('📋 STEP 6: Initiating Payment');
                              final double amount = _calculateTotal(
                                widget.price,
                                widget.taxes,
                              );

                              final hotelName = widget.hotelDetails['HotelDetail']
                                      ?['HotelName'] ??
                                  'Hotel';
                              final roomType =
                                  widget.selectedRoom['Name'] ?? 'Room';

                              print('   💰 Payment Amount: $amount');
                              print('   🏨 Hotel: $hotelName');
                              print('   🛏️  Room: $roomType');
                              print('   🔄 Opening payment gateway...');
                              print('');

                              if (!mounted) return;

                              await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => EasebuzzPaymentWidget(
                                  amount: amount,
                                  name: userName.isNotEmpty ? userName : primaryGuest['name']?.toString() ?? 'Guest',
                                  email: userEmail.isNotEmpty ? userEmail : primaryGuest['email']?.toString() ?? 'guest@example.com',
                                  phone: userPhone.isNotEmpty 
                                      ? userPhone.replaceAll(RegExp(r'[^\d]'), '') // Remove all non-digits for phone
                                      : (primaryGuest['phone']?.toString().replaceAll(RegExp(r'[^\d]'), '') ?? '0000000000'),
                                  productInfo: 'Hotel Booking - $hotelName - $roomType',
                                  onSuccess: () async {
                                    print('\n');
                                    print('═══════════════════════════════════════════════════════════');
                                    print('💳 PAYMENT SUCCESSFUL');
                                    print('═══════════════════════════════════════════════════════════');
                                    print('📅 Timestamp: ${DateTime.now().toIso8601String()}');
                                    print('');
                                    // Call book complete API after successful payment
                                    await _completeBooking();
                                  },
                                  onFailure: () {
                                    print('\n');
                                    print('═══════════════════════════════════════════════════════════');
                                    print('❌ PAYMENT FAILED');
                                    print('═══════════════════════════════════════════════════════════');
                                    print('📅 Timestamp: ${DateTime.now().toIso8601String()}');
                                    print('   ⚠️  Clearing stored prebook data...');
                                    // Clear stored data on payment failure
                                    _prebookResponse = null;
                                    _storedPrimaryGuest = null;
                                    _storedSelectedTravellers = null;
                                    print('   ✅ Stored data cleared');
                                    print('═══════════════════════════════════════════════════════════\n');
                                    
                                    if (mounted) {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                          content: Text('Payment failed. Please try again.'),
                                        ),
                                      );
                                    }
                                  },
                                ),
                              ),
                            );
                            } catch (e) {
                              print('\n');
                              print('═══════════════════════════════════════════════════════════');
                              print('❌ BOOKING FLOW ERROR');
                              print('═══════════════════════════════════════════════════════════');
                              print('📅 Timestamp: ${DateTime.now().toIso8601String()}');
                              print('   ❌ Error: $e');
                              print('   📍 Location: Prebook API Call');
                              print('═══════════════════════════════════════════════════════════\n');
                              if (mounted) {
                                Get.snackbar(
                                  'Booking Failed',
                                  'Failed to reserve booking: ${e.toString()}',
                                  backgroundColor: Colors.red,
                                  colorText: Colors.white,
                                  duration: const Duration(seconds: 4),
                                );
                              }
                            } finally {
                              if (mounted) {
                                setState(() => _isProcessing = false);
                              }
                            }
                          },
                    icon: const Icon(Icons.lock_outline, size: 20),
                    label: Text(
                      _isProcessing ? 'Processing...' : 'Proceed to Pay',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.2),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).brightness ==
                              Brightness.dark
                          ? const Color(0xFFFF5722) // Orange-red for dark theme
                          : const Color(0xFFCA0B0B), // Red for light theme
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                          vertical: 16, horizontal: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      elevation: 0,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );

  Future<void> _processPayment() async {
    // This method is not needed anymore
  }

  void _showBookingConfirmation() {
    final hotelName =
        widget.hotelDetails['HotelDetail']?['HotelName'] ?? 'the hotel';
    final roomType = widget.selectedRoom['Name'] ?? 'Selected Room';
    final checkIn = widget.searchParams['checkInDate'] ?? 'N/A';
    final checkOut = widget.searchParams['checkOutDate'] ?? 'N/A';
    final totalAmount = widget.price + widget.taxes;

    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Colors.green.withOpacity(0.2)
                        : Colors.green[50],
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.check_circle_outline,
                      size: 40,
                      color: Theme.of(context).brightness == Brightness.dark
                          ? Colors.green[400]
                          : Colors.green[600]),
                ),
              ),
              const SizedBox(height: 16),
              Center(
                child: Text(
                  'Confirm Booking',
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: Theme.of(context).textTheme.headlineSmall?.color),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'Booking Summary',
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).textTheme.titleMedium?.color),
              ),
              const SizedBox(height: 10),
              _buildDetailItem('Hotel', hotelName),
              _buildDetailItem('Room Type', roomType),
              _buildDetailItem('Check-in', checkIn),
              _buildDetailItem('Check-out', checkOut),
              const SizedBox(height: 10),
              const Divider(),
              const SizedBox(height: 10),
              const Text(
                'Traveler Details',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 10),
              _buildDetailItem('Name', userName.isNotEmpty ? userName : 'Not provided'),
              _buildDetailItem('Email', userEmail.isNotEmpty ? userEmail : 'Not provided'),
              _buildDetailItem('Phone', userPhone.isNotEmpty ? userPhone : 'Not provided'),
              if (userAddress.isNotEmpty)
                _buildDetailItem('Address', userAddress),
              if (userCity.isNotEmpty)
                _buildDetailItem('City', userCity),
              if (userPostalCode.isNotEmpty)
                _buildDetailItem('Postal Code', userPostalCode),
              if (userCountry.isNotEmpty)
                _buildDetailItem('Country', userCountry),
              if (_specialRequestsController.text.isNotEmpty || specialRequests.isNotEmpty) ...[
                const SizedBox(height: 10),
                const Text(
                  'Special Requests',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 4),
                Text(
                  _specialRequestsController.text.isNotEmpty ? _specialRequestsController.text : specialRequests,
                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                ),
              ],
              const SizedBox(height: 20),
              _buildDetailItem(
                'Total Amount',
                '₹${totalAmount.toStringAsFixed(2)}',
                isBold: true,
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () => Get.back(),
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 24, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                          side: BorderSide(color: Colors.grey[300]!),
                        ),
                      ),
                      child: const Text(
                        'CANCEL',
                        style: TextStyle(
                          color: Colors.black87,
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _processPayment,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).brightness ==
                                Brightness.dark
                            ? const Color(
                                0xFFFF5722) // Orange-red for dark theme
                            : const Color(0xFFCA0B0B), // Red for light theme
                        padding: const EdgeInsets.symmetric(
                            horizontal: 24, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text(
                        'CONFIRM & PAY',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  double _calculateTotal(double price, double taxes) => price + taxes;

  String _formatCurrency(double amount) => '₹${amount.toStringAsFixed(amount.truncateToDouble() == amount ? 0 : 2)}';

  /// Prepare booking data for database storage
  /// Returns all required fields for backend
  Map<String, dynamic> _prepareBookingDataForDatabase({
    required String reservationId,
    required String bookingId,
    required Map<String, dynamic> bookCompleteResponse,
  }) {
    // Extract hotel information
    final hotelDetail = widget.hotelDetails['HotelDetail'] ?? widget.hotelDetails;
    final hotelAddress = hotelDetail['HotelAddress'];
    
    // Extract room information
    final selectedRoom = widget.selectedRoom;
    
    // Extract dates
    final checkInDate = widget.searchParams['checkInDate'] ?? '';
    final checkOutDate = widget.searchParams['checkOutDate'] ?? '';
    
    // Generate internal booking ID (format: INT-timestamp-random)
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final randomSuffix = (timestamp % 1000).toString().padLeft(3, '0');
    final internalBookingId = 'INT-$timestamp-$randomSuffix';
    
    // Get user ID from login controller
    final userId = loginController.userData['id'] ?? 
                   loginController.userData['userId'] ?? 
                   0;
    
    // Extract guest counts
    final numRooms = int.tryParse(widget.searchParams['rooms']?.toString() ?? '1') ?? 1;
    final numAdults = int.tryParse(widget.searchParams['adults']?.toString() ?? '2') ?? 2;
    final numChildren = int.tryParse(widget.searchParams['children']?.toString() ?? '0') ?? 0;
    
    // Extract hotel rating
    final hotelRating = hotelDetail['StarRating'];
    final hotelRatingStr = hotelRating != null ? hotelRating.toString() : '';
    
    // Extract hotel image URL
    final hotelImageUrl = (hotelDetail['HotelImages'] is List && hotelDetail['HotelImages'].isNotEmpty)
        ? hotelDetail['HotelImages'][0]
        : selectedRoom['Image']?['ImageUrl'] ?? '';
    
    // Extract room name
    final roomName = selectedRoom['Name'] ?? selectedRoom['RoomName'] ?? 'Room';
    
    // Extract room type
    final roomType = selectedRoom['RoomType'] ?? selectedRoom['roomType'] ?? '';
    
    // Extract meal code
    final mealCode = selectedRoom['MealCode'] ?? selectedRoom['mealCode'] ?? 'RO';
    
    // Extract hotel provider
    final hotelProvider = selectedRoom['ProviderName'] ?? 'HotelBeds';
    
    // Extract service identifier
    final serviceIdentifier = selectedRoom['ServiceIdentifer'] ?? 
                             selectedRoom['serviceIdentifer'] ?? 
                             null;
    
    // Extract unique reference key
    final uniqueReferenceKey = selectedRoom['UniqueReferencekey'] ?? 
                              selectedRoom['uniqueReferencekey'] ?? 
                              null;
    
    // Extract optional token
    final optionalToken = selectedRoom['OptionalToken'] ?? 
                         selectedRoom['optionalToken'] ?? 
                         null;
    
    // Extract service book price
    final serviceBookPrice = selectedRoom['ServiceBookPrice'] ?? 
                            selectedRoom['serviceBookPrice'] ?? 
                            (widget.price + widget.taxes);
    final serviceBookPriceDouble = serviceBookPrice is num ? serviceBookPrice.toDouble() : (widget.price + widget.taxes);
    
    // Calculate total amount
    final totalAmount = widget.price + widget.taxes;
    
    // Extract room details from prebook response
    final roomDetailsFromPrebook = _prebookResponse?['BookingDetails']?[0]?['HotelServiceDetail']?['RoomDetails'] ?? [];
    
    // Extract confirmation number from book complete response
    final confirmationNumber = bookCompleteResponse['ConfirmationNumber'] ?? 
                              bookCompleteResponse['confirmationNumber'] ?? 
                              null;
    
    // Get special requests
    final specialRequestsValue = _specialRequestsController.text.isNotEmpty 
        ? _specialRequestsController.text 
        : (specialRequests.isNotEmpty ? specialRequests : null);
    
    // Get booking date (current date in YYYY-MM-DD format)
    final bookingDate = DateTime.now().toIso8601String().split('T')[0];
    
    // Return all required fields for backend
    return {
      'booking_id': bookingId,
      'reservation_id': reservationId,
      'internal_booking_id': internalBookingId,
      'user_id': userId,
      'user_name': userName,
      'user_email': userEmail,
      'user_phone': userPhone,
      'hotel_id': widget.hotelId,
      'hotel_name': hotelDetail['HotelName'] ?? 'Hotel',
      'hotel_address': hotelAddress?['Address'] ?? '',
      'hotel_city': hotelAddress?['City'] ?? widget.searchParams['cityName'] ?? '',
      'hotel_country': hotelAddress?['Country'] ?? '',
      'hotel_rating': hotelRatingStr,
      'hotel_image_url': hotelImageUrl,
      'hotel_provider': hotelProvider,
      'room_name': roomName,
      'room_type': roomType,
      'number_of_rooms': numRooms,
      'meal_code': mealCode,
      'service_identifier': serviceIdentifier,
      'unique_reference_key': uniqueReferenceKey,
      'check_in_date': checkInDate,
      'check_out_date': checkOutDate,
      'check_in_time': null,
      'number_of_adults': numAdults,
      'number_of_children': numChildren,
      'number_of_infants': 0,
      'room_price': widget.price,
      'taxes': widget.taxes,
      'service_book_price': serviceBookPriceDouble,
      'total_amount': totalAmount,
      'currency': 'AED',
      'booking_status': 'pending',
      'payment_status': 'pending',
      'payment_id': null,
      'payment_method': null,
      'payment_date': null,
      'confirmation_number': confirmationNumber,
      'special_requests': specialRequestsValue,
      'cancellation_policy': null,
      'booking_remarks': null,
      'optional_token': optionalToken,
      'primary_guest_details': _storedPrimaryGuest,
      'traveller_details': _storedSelectedTravellers ?? [],
      'room_details': roomDetailsFromPrebook,
      'prebook_response': _prebookResponse ?? {},
      'book_complete_response': bookCompleteResponse,
      'booking_date': bookingDate,
    };
  }

  /// Complete the booking after successful payment
  Future<void> _completeBooking() async {
    print('📋 STEP 7: Validating Stored Prebook Data');
    
    if (_prebookResponse == null || _storedPrimaryGuest == null || _storedSelectedTravellers == null) {
      print('   ❌ ERROR: Missing prebook data for book complete');
      print('      PrebookResponse: ${_prebookResponse != null ? "✅" : "❌"}');
      print('      PrimaryGuest: ${_storedPrimaryGuest != null ? "✅" : "❌"}');
      print('      SelectedTravellers: ${_storedSelectedTravellers != null ? "✅" : "❌"}');
      print('═══════════════════════════════════════════════════════════\n');
      if (mounted) {
        Get.snackbar(
          'Booking Error',
          'Missing booking information. Please contact support.',
          backgroundColor: Colors.red,
          colorText: Colors.white,
          duration: const Duration(seconds: 4),
        );
      }
      return;
    }

    print('   ✅ All prebook data validated');
    print('');

    try {
      // STEP 8: Call hotel book complete API
      print('📋 STEP 8: Calling Hotel Book Complete API');
      print('   🔄 Sending book complete request...');
      
      final bookCompleteResponse = await hotelController.hotelBookComplete(
        prebookResponse: _prebookResponse!,
        hotelDetails: widget.hotelDetails,
        selectedRoom: widget.selectedRoom,
        searchParams: widget.searchParams,
        primaryGuest: _storedPrimaryGuest!,
        selectedTravellers: _storedSelectedTravellers!,
        currency: 'AED', // TODO: Get from search params or config
      );

      print('   ✅ Book Complete API Response Received');

      // Check if book complete was successful
      if (bookCompleteResponse['success'] == false || 
          (bookCompleteResponse['error'] != null && bookCompleteResponse['error'].toString().isNotEmpty)) {
        print('   ❌ ERROR: Book Complete API returned error');
        print('      Error: ${bookCompleteResponse['error'] ?? 'Book complete failed'}');
        print('═══════════════════════════════════════════════════════════\n');
        throw Exception(bookCompleteResponse['error'] ?? 'Book complete failed');
      }

      // STEP 9: Extract booking confirmation details
      print('📋 STEP 9: Extracting Booking Confirmation Details');
      final reservationId = _prebookResponse!['ReservationId']?.toString() ?? 'N/A';
      
      // Try to get BookingId from prebook response first
      String bookingId = 'N/A';
      final bookingDetails = _prebookResponse!['BookingDetails'] as List?;
      if (bookingDetails != null && bookingDetails.isNotEmpty) {
        bookingId = bookingDetails[0]['BookingId']?.toString() ?? 'N/A';
      }
      
      // If BookingId not in prebook, try to get it from book complete response
      if (bookingId == 'N/A' || bookingId.isEmpty) {
        print('   🔍 BookingId not in prebook response, checking book complete response...');
        final bookCompleteBookingDetails = bookCompleteResponse['BookingDetails'] as List?;
        if (bookCompleteBookingDetails != null && bookCompleteBookingDetails.isNotEmpty) {
          bookingId = bookCompleteBookingDetails[0]['BookingId']?.toString() ?? 
                     bookCompleteBookingDetails[0]['bookingId']?.toString() ?? 
                     'N/A';
        }
        
        // Also try root level
        if (bookingId == 'N/A' || bookingId.isEmpty) {
          bookingId = bookCompleteResponse['BookingId']?.toString() ?? 
                     bookCompleteResponse['bookingId']?.toString() ?? 
                     reservationId; // Use reservationId as fallback
        }
      }

      print('   ✅ Booking confirmed successfully');
      print('      ReservationId: $reservationId');
      print('      BookingId: $bookingId');
      print('');

      // STEP 10: Save booking to database
      print('📋 STEP 10: Saving Booking to Database');
      try {
        // Prepare booking data for database
        final bookingData = _prepareBookingDataForDatabase(
          reservationId: reservationId,
          bookingId: bookingId,
          bookCompleteResponse: bookCompleteResponse,
        );
        
        // Save to database
        await hotelController.saveHotelBookingToDatabase(bookingData: bookingData);
        print('   ✅ Booking saved to database successfully');
        print('');
      } catch (e) {
        print('   ⚠️  WARNING: Failed to save booking to database');
        print('      Error: $e');
        print('      Booking is confirmed but not saved to database');
        print('      💡 This should be handled by backend or retried later');
        print('');
        // Don't throw error - booking is confirmed, database save is secondary
      }

      // STEP 11: Clear stored data
      print('📋 STEP 11: Cleaning Up');
      _prebookResponse = null;
      _storedPrimaryGuest = null;
      _storedSelectedTravellers = null;
      print('   ✅ Stored data cleared');
      print('');

      if (mounted) {
        // STEP 12: Show success message
        print('📋 STEP 12: Showing Success Message');
        print('   ✅ Booking flow completed successfully!');
        print('═══════════════════════════════════════════════════════════');
        print('🎉 BOOKING CONFIRMED - FLOW COMPLETED');
        print('═══════════════════════════════════════════════════════════');
        print('📅 Timestamp: ${DateTime.now().toIso8601String()}');
        print('   ReservationId: $reservationId');
        print('   BookingId: $bookingId');
        print('═══════════════════════════════════════════════════════════\n');
        
        // Show success message
        Get.snackbar(
          'Booking Confirmed!',
          'Your hotel booking has been confirmed successfully.',
          backgroundColor: Colors.green,
          colorText: Colors.white,
          duration: const Duration(seconds: 3),
          icon: const Icon(Icons.check_circle, color: Colors.white),
        );

        // TODO: Navigate to booking success page with booking details
        // You can create a booking success page similar to the flight booking success page
        // Get.off(() => HotelBookingSuccessPage(
        //   bookingId: bookingId,
        //   reservationId: reservationId,
        //   hotelName: widget.hotelDetails['HotelDetail']?['HotelName'] ?? 'Hotel',
        // ));
      }
    } catch (e) {
      print('\n');
      print('═══════════════════════════════════════════════════════════');
      print('❌ BOOK COMPLETE API ERROR');
      print('═══════════════════════════════════════════════════════════');
      print('📅 Timestamp: ${DateTime.now().toIso8601String()}');
      print('   ❌ Error: $e');
      print('   📍 Location: Book Complete API Call');
      print('   ⚠️  Payment was successful but booking confirmation failed');
      print('   💡 User should contact support with payment reference');
      print('═══════════════════════════════════════════════════════════\n');
      if (mounted) {
        Get.snackbar(
          'Booking Confirmation Failed',
          'Payment was successful but booking confirmation failed. Please contact support with your payment reference.',
          backgroundColor: Colors.orange,
          colorText: Colors.white,
          duration: const Duration(seconds: 5),
          icon: const Icon(Icons.warning, color: Colors.white),
        );
      }
    }
  }
}

class AppCard extends StatelessWidget {
  final Widget child;
  const AppCard({required this.child, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(18),
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: Theme.of(context).shadowColor.withOpacity(0.04),
              blurRadius: 15,
              offset: const Offset(0, 4),
            ),
          ],
          border: Border.all(color: Theme.of(context).dividerColor),
        ),
        child: child,
      );
}
