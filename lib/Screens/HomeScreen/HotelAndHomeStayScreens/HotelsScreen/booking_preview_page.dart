import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:seemytrip/Constants/colors.dart';
import 'package:seemytrip/Constants/images.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:url_launcher/url_launcher.dart';

class BookingPreviewPage extends StatefulWidget {
  final Map<String, dynamic> hotelDetails;
  final String hotelId;
  final Map<String, dynamic> searchParams;
  final Map<String, dynamic> selectedRoom;
  final String price;
  final String taxes;

  const BookingPreviewPage({
    Key? key,
    required this.hotelDetails,
    required this.hotelId,
    required this.searchParams,
    required this.selectedRoom,
    required this.price,
    required this.taxes,
  }) : super(key: key);

  @override
  State<BookingPreviewPage> createState() => _BookingPreviewPageState();
}

class _BookingPreviewPageState extends State<BookingPreviewPage> {
  final _formKey = GlobalKey<FormState>();
  String userName = '';
  String userEmail = '';
  String userPhone = '';

  @override
  Widget build(BuildContext context) {
    final hotelDetail = widget.hotelDetails['HotelDetail'] ?? {};
    final hotelName = hotelDetail['HotelName'] ?? 'Hotel';
    final hotelAddress = hotelDetail['HotelAddress']?['Address'] ?? '';
    final hotelCity = hotelDetail['HotelAddress']?['City'] ?? '';
    final hotelRating = hotelDetail['StarRating']?.toString() ?? '';
    final hotelImage = (hotelDetail['HotelImages'] is List && hotelDetail['HotelImages'].isNotEmpty)
        ? hotelDetail['HotelImages'][0]
        : hotelDetailTopImage;
    final latitude = hotelDetail['HotelAddress']?['Latitude'];
    final longitude = hotelDetail['HotelAddress']?['Longitude'];

    final room = widget.selectedRoom;
    final roomName = room['Name'] ?? '';
    final roomImage = room['Image']?['ImageUrl'] ?? '';
    final guests = widget.searchParams['Guests']?.toString() ?? '2 Adults';
    final roomsCount = widget.searchParams['Rooms']?.toString() ?? '1';
    final checkIn = widget.searchParams['checkInDate'] ?? '';
    final checkOut = widget.searchParams['checkOutDate'] ?? '';
    final offer = room['Offer'] ?? hotelDetail['Offer'];
    final price = widget.price;
    final taxes = widget.taxes;

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text('Booking Preview', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        backgroundColor: redCA0,
        elevation: 0,
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: Stack(
        children: [
          ListView(
            padding: EdgeInsets.fromLTRB(16, 16, 16, 120),
            children: [
              _buildHotelCard(hotelImage, hotelName, hotelAddress, hotelCity, hotelRating),
              _buildRoomCard(roomImage, roomName, guests, roomsCount, offer),
              _buildSectionCard(
                title: "Travel Details",
                icon: Icons.calendar_today,
                children: [
                  _buildDetailItem(
                    Icons.calendar_today_outlined,
                    "Check-in",
                    checkIn,
                  ),
                  _buildDetailItem(
                    Icons.calendar_today_outlined,
                    "Check-out",
                    checkOut,
                  ),
                  _buildDetailItem(
                    Icons.people_outline,
                    "Guests",
                    guests,
                  ),
                  _buildDetailItem(
                    Icons.king_bed_outlined,
                    "Rooms",
                    "$roomsCount ${int.parse(roomsCount) > 1 ? 'Rooms' : 'Room'}",
                  ),
                ],
              ),
              _buildFareSummary(price, taxes),
              _buildTravellerForm(),
            ],
          ),
          _buildBottomBar(price, taxes),
        ],
      ),
    );
  }

  void _showMapDialog(double latitude, double longitude) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        insetPadding: EdgeInsets.all(16),
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
              children: [
                TileLayer(
                  urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                  subdomains: const ['a', 'b', 'c'],
                  userAgentPackageName: 'com.example.seemytrip',
                ),
                MarkerLayer(
                  markers: [
                    Marker(
                      width: 40,
                      height: 40,
                      point: LatLng(latitude, longitude),
                      child: Icon(Icons.location_on, color: redCA0, size: 40),
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

  Widget _buildHotelCard(String image, String name, String address, String city, String rating) {
    final hotelDetail = widget.hotelDetails['HotelDetail'] ?? {};
    final latitude = hotelDetail['HotelAddress']?['Latitude'];
    final longitude = hotelDetail['HotelAddress']?['Longitude'];

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 15,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: Colors.grey[100]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Hotel Image with Rating Badge
          Stack(
            children: [
              ClipRRect(
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(18)),
                child: image.startsWith('http')
                    ? Image.network(
                        image,
                        width: double.infinity,
                        height: 180,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Container(
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
              // Rating Badge
              Positioned(
                top: 12,
                right: 12,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
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

          // Hotel Info
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Hotel Name
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

                // Location
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
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

                // Map Button
                if (latitude != null && longitude != null) ...[
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: () {
                        double? lat = double.tryParse(latitude.toString());
                        double? lng = double.tryParse(longitude.toString());
                        if (lat != null && lng != null) {
                          _showMapDialog(lat, lng);
                        } else {
                          Get.snackbar(
                            "Error",
                            "Invalid coordinates.",
                            snackPosition: SnackPosition.BOTTOM,
                            backgroundColor: Colors.red[100],
                            colorText: Colors.red[900],
                          );
                        }
                      },
                      icon: Icon(Icons.map_outlined, size: 18, color: redCA0),
                      label: Text(
                        "View on Map",
                        style: TextStyle(
                          color: redCA0,
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        side: BorderSide(color: redCA0.withOpacity(0.3)),
                        backgroundColor: redCA0.withOpacity(0.05),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRoomCard(String image, String name, String guests, String rooms, dynamic offer) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 15,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: Colors.grey[100]!),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Room Image
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              color: Colors.grey[100],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: image.isNotEmpty
                  ? Image.network(
                      image,
                      width: 100,
                      height: 100,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        color: Colors.grey[100],
                        child: Icon(Icons.king_bed_rounded,
                            color: redCA0, size: 40),
                      ),
                    )
                  : Center(
                      child:
                          Icon(Icons.king_bed_rounded, color: redCA0, size: 40),
                    ),
            ),
          ),

          const SizedBox(width: 16),

          // Room Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Room Name
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    letterSpacing: -0.2,
                    height: 1.3,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),

                const SizedBox(height: 8),

                // Room Details
                Row(
                  children: [
                    _buildRoomDetailChip(
                      Icons.person_outline,
                      guests,
                      color: Colors.blue[50]!,
                      iconColor: Colors.blue[700]!,
                    ),
                    const SizedBox(width: 8),
                    _buildRoomDetailChip(
                      Icons.king_bed_outlined,
                      "$rooms ${int.parse(rooms) > 1 ? 'Rooms' : 'Room'}",
                      color: Colors.purple[50]!,
                      iconColor: Colors.purple[700]!,
                    ),
                  ],
                ),
                
                // Offer Badge
                if (offer != null) ...[
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
                      children: [
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
      ),
    );
  }

  Widget _buildRoomDetailChip(IconData icon, String text,
      {required Color color, required Color iconColor}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: iconColor),
          const SizedBox(width: 4),
          Text(
            text,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[800],
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionCard({required String title, required IconData icon, required List<Widget> children}) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: Colors.grey[100]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
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
          const SizedBox(height: 16),
          ...children
              .map((e) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: e,
                  ))
              .toList(),
        ],
      ),
    );
  }

  Widget _buildDetailItem(IconData icon, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 18, color: Colors.grey[600]),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFareSummary(String price, String taxes) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: Colors.grey[100]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: Colors.blue[50],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.receipt_long_outlined,
                    size: 20, color: Colors.blue),
              ),
              const SizedBox(width: 12),
              const Text(
                "Fare Summary",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.2,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _fareRow("Room Price", "₹$price"),
          const SizedBox(height: 8),
          _fareRow("Taxes & Fees", "₹$taxes"),
          const SizedBox(height: 8),
          Container(
            margin: const EdgeInsets.symmetric(vertical: 8),
            height: 1,
            color: Colors.grey[200],
          ),
          _fareRow(
            "Total Amount",
            "₹${_getTotal(price, taxes)}",
            isTotal: true,
          ),
          const SizedBox(height: 4),
          Text(
            "Inclusive of all taxes",
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }

  Widget _fareRow(String title, String amount, {bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: isTotal ? 16 : 14,
              fontWeight: isTotal ? FontWeight.w700 : FontWeight.w500,
              color: isTotal ? Colors.black87 : Colors.grey[700],
              letterSpacing: isTotal ? -0.2 : 0,
            ),
          ),
          Text(
            amount,
            style: TextStyle(
              fontSize: isTotal ? 18 : 14,
              fontWeight: isTotal ? FontWeight.w800 : FontWeight.w600,
              color: isTotal ? redCA0 : Colors.black87,
              letterSpacing: isTotal ? -0.3 : 0,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTravellerForm() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: Colors.grey[100]!),
      ),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: Colors.purple[50],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.person_outline,
                      size: 20, color: Colors.purple),
                ),
                const SizedBox(width: 12),
                const Text(
                  "Traveller Details",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    letterSpacing: -0.2,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            _formField(
              "Full Name",
              onSaved: (v) => userName = v ?? '',
              validator: (v) => v!.isEmpty ? "Please enter your name" : null,
              prefixIcon: Icons.person_outline,
            ),
            const SizedBox(height: 16),
            _formField(
              "Email Address",
              onSaved: (v) => userEmail = v ?? '',
              validator: (v) =>
                  v!.contains('@') ? null : "Please enter a valid email",
              keyboardType: TextInputType.emailAddress,
              prefixIcon: Icons.email_outlined,
            ),
            const SizedBox(height: 16),
            _formField(
              "Phone Number",
              onSaved: (v) => userPhone = v ?? '',
              validator: (v) =>
                  v!.length >= 8 ? null : "Enter a valid phone number",
              keyboardType: TextInputType.phone,
              prefixIcon: Icons.phone_outlined,
            ),
          ],
        ),
      ),
    );
  }

  Widget _formField(
    String label, {
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
    void Function(String?)? onSaved,
    IconData? prefixIcon,
  }) {
    return TextFormField(
      keyboardType: keyboardType,
      style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.grey[600], fontSize: 14),
        floatingLabelBehavior: FloatingLabelBehavior.never,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: redCA0, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.red, width: 1.0),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.red, width: 1.5),
        ),
        filled: true,
        fillColor: Colors.grey[50],
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        prefixIcon: prefixIcon != null
            ? Padding(
                padding: const EdgeInsets.only(left: 12, right: 8),
                child: Icon(prefixIcon, size: 22, color: Colors.grey[600]),
              )
            : null,
        prefixIconConstraints:
            const BoxConstraints(minWidth: 24, minHeight: 24),
      ),
      validator: validator,
      onSaved: onSaved,
      cursorColor: redCA0,
    );
  }

  Widget _buildBottomBar(String price, String taxes) {
    return Positioned(
      left: 0,
      right: 0,
      bottom: 0,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
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
            children: [
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Total Payable",
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      "₹${_getTotal(price, taxes)}",
                      style: TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 22,
                        color: redCA0,
                        letterSpacing: -0.5,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                flex: 2,
                child: ElevatedButton.icon(
                  onPressed: () {
                    if (_formKey.currentState?.validate() ?? false) {
                      _formKey.currentState?.save();
                      // Show a nice confirmation dialog
                      _showBookingConfirmation();
                    }
                  },
                  icon: const Icon(Icons.lock_outline, size: 20),
                  label: const Text(
                    "Proceed to Pay",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.2,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: redCA0,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                        vertical: 16, horizontal: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    elevation: 0,
                    shadowColor: Colors.transparent,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showBookingConfirmation() {
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Column(
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: Colors.green[50],
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.check_circle_outline,
                  size: 40, color: Colors.green[600]),
            ),
            const SizedBox(height: 16),
            const Text(
              "Confirm Booking",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: Colors.black87,
              ),
            ),
          ],
        ),
        content: Text(
          "Proceed to payment for your booking at ${widget.hotelDetails['HotelDetail']?['HotelName'] ?? 'the hotel'}?",
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.grey[700], height: 1.5),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            style: TextButton.styleFrom(
              foregroundColor: Colors.grey[600],
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            ),
            child: const Text("CANCEL",
                style: TextStyle(fontWeight: FontWeight.w600)),
          ),
          ElevatedButton(
            onPressed: () {
              Get.back();
              Get.snackbar(
                "Processing Payment",
                "Redirecting to secure payment gateway...",
                snackPosition: SnackPosition.BOTTOM,
                backgroundColor: Colors.blue[50],
                colorText: Colors.blue[900],
                margin: const EdgeInsets.all(16),
                borderRadius: 12,
                icon: const Icon(Icons.credit_card, color: Colors.blue),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: redCA0,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 0,
            ),
            child: const Text(
              "CONFIRM",
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }

  void _launchMapUrl(String url) async {
    // Make sure url_launcher is properly installed and initialized.
    // If you see "Could not open map", try a full restart of your app (not just hot reload).
    try {
      final uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        // Show a more helpful error message
        Get.snackbar("Error", "No map app found or invalid URL.");
      }
    } catch (e) {
      Get.snackbar("Error", "Could not open map. Please check your device or try a full restart.");
    }
  }

  String _getTotal(String price, String taxes) {
    double p = double.tryParse(price.replaceAll(RegExp(r'[^0-9.]'), '')) ?? 0.0;
    double t = double.tryParse(taxes.replaceAll(RegExp(r'[^0-9.]'), '')) ?? 0.0;
    double total = p + t;
    return total % 1 == 0 ? total.toStringAsFixed(0) : total.toStringAsFixed(2);
  }
}
