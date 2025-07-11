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
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
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
                  Text("Check-in: $checkIn"),
                  Text("Check-out: $checkOut"),
                  Text("Guests: $guests"),
                  Text("Rooms: $roomsCount"),
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
      margin: EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 4))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
            child: image.startsWith('http')
                ? Image.network(
                    image,
                    width: double.infinity,
                    height: 160,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      height: 160,
                      color: Colors.grey[300],
                      child: Icon(Icons.broken_image, size: 50, color: Colors.grey),
                    ),
                  )
                : Image.asset(image, height: 160, width: double.infinity, fit: BoxFit.cover),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                SizedBox(height: 6),
                Row(
                  children: [
                    Icon(Icons.location_on, size: 16, color: Colors.grey),
                    SizedBox(width: 4),
                    Expanded(child: Text('$address, $city', style: TextStyle(fontSize: 13))),
                    if (latitude != null && longitude != null)
                      TextButton.icon(
                        onPressed: () {
                          double? lat = double.tryParse(latitude.toString());
                          double? lng = double.tryParse(longitude.toString());
                          if (lat != null && lng != null) {
                            _showMapDialog(lat, lng);
                          } else {
                            Get.snackbar("Error", "Invalid coordinates.");
                          }
                        },
                        icon: Icon(Icons.map, color: redCA0, size: 18),
                        label: Text("Map", style: TextStyle(color: redCA0, fontSize: 13)),
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 0),
                          minimumSize: Size(0, 32),
                        ),
                      ),
                  ],
                ),
                SizedBox(height: 6),
                Row(
                  children: [
                    Icon(Icons.star, color: Colors.amber, size: 16),
                    SizedBox(width: 4),
                    Text(rating, style: TextStyle(fontWeight: FontWeight.w500)),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRoomCard(String image, String name, String guests, String rooms, dynamic offer) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 8)],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: image.isNotEmpty
                ? Image.network(image, width: 80, height: 80, fit: BoxFit.cover)
                : Container(
                    width: 80,
                    height: 80,
                    color: Colors.grey[200],
                    child: Icon(Icons.king_bed_rounded, color: redCA0, size: 40),
                  ),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
                SizedBox(height: 4),
                Text("Guests: $guests", style: TextStyle(fontSize: 13)),
                Text("Rooms: $rooms", style: TextStyle(fontSize: 13)),
                if (offer != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 6),
                    child: Text("Offer: $offer", style: TextStyle(color: Colors.green[800], fontSize: 13)),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionCard({required String title, required IconData icon, required List<Widget> children}) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 4,
      margin: EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: redCA0),
            SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
                  SizedBox(height: 6),
                  ...children.map((e) => Padding(padding: EdgeInsets.only(bottom: 2), child: e)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFareSummary(String price, String taxes) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 4,
      margin: EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Fare Summary", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            SizedBox(height: 12),
            _fareRow("Room Price", "₹$price"),
            _fareRow("Taxes & Fees", "₹$taxes"),
            Divider(),
            _fareRow("Total", "₹${_getTotal(price, taxes)}", isTotal: true),
          ],
        ),
      ),
    );
  }

  Widget _fareRow(String title, String amount, {bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: TextStyle(fontWeight: isTotal ? FontWeight.bold : FontWeight.normal)),
          Text(amount, style: TextStyle(fontWeight: isTotal ? FontWeight.bold : FontWeight.normal)),
        ],
      ),
    );
  }

  Widget _buildTravellerForm() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 4,
      margin: EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Traveller Details", style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
              SizedBox(height: 10),
              _formField("Name", onSaved: (v) => userName = v ?? '', validator: (v) => v!.isEmpty ? "Enter your name" : null),
              SizedBox(height: 10),
              _formField("Email", onSaved: (v) => userEmail = v ?? '', validator: (v) => v!.contains('@') ? null : "Enter valid email"),
              SizedBox(height: 10),
              _formField("Phone", keyboardType: TextInputType.phone, onSaved: (v) => userPhone = v ?? '', validator: (v) => v!.length >= 8 ? null : "Enter valid phone"),
            ],
          ),
        ),
      ),
    );
  }

  Widget _formField(String label, {TextInputType keyboardType = TextInputType.text, String? Function(String?)? validator, void Function(String?)? onSaved}) {
    return TextFormField(
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        filled: true,
        fillColor: Colors.grey[100],
      ),
      validator: validator,
      onSaved: onSaved,
    );
  }

  Widget _buildBottomBar(String price, String taxes) {
    return Positioned(
      left: 0,
      right: 0,
      bottom: 0,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 8)],
          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Total Payable", style: TextStyle(fontSize: 12, color: Colors.grey[600])),
                Text("₹${_getTotal(price, taxes)}", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: redCA0)),
              ],
            ),
            ElevatedButton.icon(
              onPressed: () {
                if (_formKey.currentState?.validate() ?? false) {
                  _formKey.currentState?.save();
                  Get.snackbar("Booking", "Proceeding to payment...", backgroundColor: Colors.green[100]);
                }
              },
              icon: Icon(Icons.payment),
              label: Text("Pay Now", style: TextStyle(fontSize: 16)),
              style: ElevatedButton.styleFrom(
                backgroundColor: redCA0,
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
              ),
            ),
          ],
        ),
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
