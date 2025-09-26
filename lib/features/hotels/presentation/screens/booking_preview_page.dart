// ignore_for_file: directives_ordering, unused_local_variable, unused_element, avoid_catches_without_on_clauses

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../controllers/hotel_payment_controller.dart';

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
  late final HotelPaymentController _paymentController;
  
  @override
  void initState() {
    super.initState();
    _paymentController = Get.put(HotelPaymentController());
  }
  
  // Form field controllers
  late String userName = 'John Doe';
  late String userEmail = 'john.doe@example.com';
  late String userPhone = '+919876543210';
  late String userAddress = '123 Main St';
  late String userCity = 'Mumbai';
  late String userPostalCode = '400001';
  late String userCountry = 'India';
  late String specialRequests = 'Early check-in if possible';
  
  bool _isProcessing = false;

  // Demo traveler details
  // String userName = 'John Doe';
  // String userEmail = 'john.doe@example.com';
  // String userPhone = '+1 (555) 123-4567';
  // String userAddress = '123 Traveler Street';
  // String userCity = 'New York';
  // String userCountry = 'United States';
  // String userPostalCode = '10001';
  // String specialRequests = 'Early check-in requested if possible';

  // SOLUTION 1: Add a robust parsing function for coordinates.
  double? _parseCoordinate(dynamic value) {
    if (value == null) return null;
    if (value is num) return value.toDouble();
    if (value is String) return double.tryParse(value);
    return null;
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
              color: Theme.of(context).appBarTheme.titleTextStyle?.color ?? Theme.of(context).colorScheme.onPrimary
            )),
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor ?? Theme.of(context).primaryColor,
        elevation: 0,
        foregroundColor: Theme.of(context).appBarTheme.foregroundColor ?? Theme.of(context).colorScheme.onPrimary,
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
                  _buildDetailItem('Rooms', "$numRooms ${numRooms > 1 ? 'Rooms' : 'Room'}"),
                ],
              ),
              _buildFareSummary(widget.price, widget.taxes),
              _buildTravellerForm(),
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
                            ? const Color(0xFFFF5722) // Orange-red for dark theme
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
      String rating, double? latitude, double? longitude) => AppCard(
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
                          size: 18, color: Theme.of(context).brightness == Brightness.dark
                            ? const Color(0xFFFF5722) // Orange-red for dark theme
                            : const Color(0xFFCA0B0B)), // Red for light theme
                      label: Text(
                        'View on Map',
                        style: TextStyle(
                          color: Theme.of(context).brightness == Brightness.dark
                            ? const Color(0xFFFF5722) // Orange-red for dark theme
                            : const Color(0xFFCA0B0B), // Red for light theme
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        side: BorderSide(color: (Theme.of(context).brightness == Brightness.dark
                            ? const Color(0xFFFF5722) // Orange-red for dark theme
                            : const Color(0xFFCA0B0B)).withOpacity(0.3)), // Red for light theme
                        backgroundColor: (Theme.of(context).brightness == Brightness.dark
                            ? const Color(0xFFFF5722) // Orange-red for dark theme
                            : const Color(0xFFCA0B0B)).withOpacity(0.05), // Red for light theme
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );

  Widget _buildRoomCard(String image, String name, String guests, String rooms, String offer) {
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
                  _buildRoomDetailChip(Icons.person_outline, '$numGuests Adults'),
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
          : const Color(0xFFCA0B0B)).withOpacity(0.08), // Red for light theme
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Icon(icon, size: 14, color: Theme.of(context).brightness == Brightness.dark
            ? const Color(0xFFFF5722) // Orange-red for dark theme
            : const Color(0xFFCA0B0B)), // Red for light theme
          const SizedBox(width: 4),
          Text(
            text,
            style: TextStyle(
              fontSize: 12,
              color: (Theme.of(context).brightness == Brightness.dark
                ? const Color(0xFFFF5722) // Orange-red for dark theme
                : const Color(0xFFCA0B0B)).withOpacity(0.9), // Red for light theme
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ));

  Widget _buildSectionCard({required String title, required IconData icon, required List<Widget> children}) => AppCard(
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

  Widget _buildDetailItem(String label, String value, {bool isBold = false}) => Padding(
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

  Widget _buildTravellerForm() => AppCard(
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const Text(
                'Traveller Details',
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    letterSpacing: -0.2),
              ),
              const SizedBox(height: 20),
              _formField(
                'Full Name',
                initialValue: 'John Doe',
                onSaved: (String? v) => userName = v ?? '',
                validator: (String? v) =>
                    v != null && v.length >= 3 ? null : 'Enter a valid name',
                prefixIcon: Icons.person_outline,
              ),
              const SizedBox(height: 16),
              _formField(
                'Email Address',
                initialValue: 'john.doe@example.com',
                onSaved: (String? v) => userEmail = v ?? '',
                validator: (String? v) =>
                    v != null && v.isEmail ? null : 'Enter a valid email',
                keyboardType: TextInputType.emailAddress,
                prefixIcon: Icons.email_outlined,
              ),
              const SizedBox(height: 16),
              _formField(
                'Phone Number',
                initialValue: '1234567890',
                onSaved: (String? v) => userPhone = v ?? '',
                validator: (String? v) =>
                    v != null && v.length >= 8 ? null : 'Enter a valid phone number',
                keyboardType: TextInputType.phone,
                prefixIcon: Icons.phone_outlined,
              ),
              const SizedBox(height: 16),
              _formField(
                'Address',
                initialValue: '123 Main St',
                onSaved: (String? v) => userAddress = v ?? '',
                prefixIcon: Icons.home_outlined,
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: _formField(
                      'City',
                      initialValue: 'New York',
                      onSaved: (String? v) => userCity = v ?? '',
                      prefixIcon: Icons.location_city_outlined,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _formField(
                      'Postal Code',
                      initialValue: '12345',
                      onSaved: (String? v) => userPostalCode = v ?? '',
                      keyboardType: TextInputType.number,
                      prefixIcon: Icons.numbers_outlined,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              _formField(
                'Country',
                initialValue: 'USA',
                onSaved: (String? v) => userCountry = v ?? '',
                prefixIcon: Icons.flag_outlined,
              ),
              const SizedBox(height: 16),
              _formField(
                'Special Requests (Optional)',
                initialValue: 'None',
                onSaved: (String? v) => specialRequests = v ?? '',
                maxLines: 3,
                prefixIcon: Icons.note_outlined,
              ),
            ],
          ),
        ),
      );

  Widget _formField(
    String label, {
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
    void Function(String?)? onSaved,
    IconData? prefixIcon,
    String? initialValue,
    int? maxLines,
  }) =>
      TextFormField(
        initialValue: initialValue,
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
                            color: Theme.of(context).brightness == Brightness.dark
                              ? const Color(0xFFFF5722) // Orange-red for dark theme
                              : const Color(0xFFCA0B0B), // Red for light theme
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
                            if (!_formKey.currentState!.validate()) return;
                            _formKey.currentState!.save();
                            try {
                              setState(() => _isProcessing = true);
                              final double amount = _calculateTotal(
                                widget.price,
                                widget.taxes,
                              );
                              final String formattedAmount = _formatCurrency(amount);
                              await _paymentController.processHotelPayment(
                                amount: amount,
                                name: userName,
                                email: userEmail,
                                phone: userPhone,
                                bookingDetails: {
                                  'hotelId': widget.hotelDetails['HotelDetail']?['HotelCode'],
                                  'roomType': widget.selectedRoom['Name'],
                                  'checkIn': widget.searchParams['checkInDate'] ?? '',
                                  'checkOut': widget.searchParams['checkOutDate'] ?? '',
                                  'guests': widget.searchParams['adults'] ?? 2,
                                  'rooms': widget.searchParams['rooms'] ?? 1,
                                  'totalAmount': amount,
                                  'guestDetails': {
                                    'name': userName,
                                    'email': userEmail,
                                    'phone': userPhone,
                                    'address': userAddress,
                                    'city': userCity,
                                    'postalCode': userPostalCode,
                                    'country': userCountry,
                                    'specialRequests': specialRequests,
                                  },
                                },
                              );
                            } catch (e) {
                              Get.snackbar(
                                'Payment Error',
                                e.toString(),
                                snackPosition: SnackPosition.BOTTOM,
                                backgroundColor: Colors.red,
                                colorText: Colors.white,
                              );
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
                      backgroundColor: Theme.of(context).brightness == Brightness.dark
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
    final hotelName = widget.hotelDetails['HotelDetail']?['HotelName'] ?? 'the hotel';
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
                      size: 40, color: Theme.of(context).brightness == Brightness.dark
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
                  color: Theme.of(context).textTheme.titleMedium?.color
                ),
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
              _buildDetailItem('Name', userName),
              _buildDetailItem('Email', userEmail),
              _buildDetailItem('Phone', userPhone),
              _buildDetailItem('Address', userAddress),
              _buildDetailItem('City', userCity),
              _buildDetailItem('Postal Code', userPostalCode),
              _buildDetailItem('Country', userCountry),
              if (specialRequests.isNotEmpty) ...[
                const SizedBox(height: 10),
                const Text(
                  'Special Requests',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 4),
                Text(
                  specialRequests,
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
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
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
                        backgroundColor: Theme.of(context).brightness == Brightness.dark
                          ? const Color(0xFFFF5722) // Orange-red for dark theme
                          : const Color(0xFFCA0B0B), // Red for light theme
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
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

  double _calculateTotal(double price, double taxes) {
    return price + taxes;
  }
  
  String _formatCurrency(double amount) {
    return '₹${amount.toStringAsFixed(amount.truncateToDouble() == amount ? 0 : 2)}';
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