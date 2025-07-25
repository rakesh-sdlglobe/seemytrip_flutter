import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Required for haptic feedback
import 'package:get/get.dart';
import 'package:intl/intl.dart';
// Make sure this path is correct for your project structure
import '../../../Controller/bus_controller.dart';

// --- THEME & STYLES ---
class AppColors {
  static const Color primary = Color(0xFF0D3B66);
  static const Color primaryVariant = Color(0xFF2A628F);
  static const Color accent = Color(0xFFE53B50);
  static const Color background = Color(0xFFF7F9FB);

  static const Color seatAvailable = Color(0xFFFFFFFF);
  static const Color seatAvailableBorder = Color(0xFFD0D5DD);
  static const Color seatSelected = Color(0xFFE53B50);
  static const Color seatLadies = Color(0xFFF9A620);
  static const Color seatBooked = Color(0xFFEAECF0);
  static const Color seatBookedBorder = Color(0xFFEAECF0);

  static const Color textDark = Color(0xFF101828);
  static const Color textLight = Color(0xFF667085);
  static const Color card = Colors.white;
}

class AppStyles {
  static const TextStyle heading1 = TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: AppColors.textDark);
  static const TextStyle heading2 = TextStyle(fontWeight: FontWeight.w600, fontSize: 16, color: AppColors.textDark);
  static const TextStyle body = TextStyle(fontSize: 14, color: AppColors.textLight);
  static const TextStyle bodyBold = TextStyle(fontWeight: FontWeight.w600, fontSize: 14, color: AppColors.textDark);
}

// --- DATA MODELS (Updated) ---
class Seat {
  final String seatName;
  final bool isAvailable;
  final bool isLadiesSeat;
  final bool isSleeper;
  final double price;
  final bool isUpperDeck;

  Seat({
    required this.seatName,
    required this.isAvailable,
    required this.isLadiesSeat,
    required this.isSleeper,
    required this.price,
    required this.isUpperDeck,
  });

  factory Seat.fromJson(Map<String, dynamic> json) {
    String seatName = json['SeatName'] ?? 'N/A';
    bool isSleeper = json['IsUpper'] ?? false;

    return Seat(
      seatName: seatName,
      isAvailable: json['SeatStatus'] ?? false,
      isLadiesSeat: json['IsLadiesSeat'] ?? false,
      isSleeper: isSleeper,
      price: (json['Price']?['PublishedPrice'] as num? ?? 0.0).toDouble(),
      isUpperDeck: json['IsUpper'] ?? false,
    );
  }
}

class BusSeatLayoutScreenArguments {
  final String traceId;
  final int resultIndex;
  final String fromLocation;
  final String toLocation;
  final DateTime travelDate;
  final String busName;

  BusSeatLayoutScreenArguments({
    required this.traceId,
    required this.resultIndex,
    required this.fromLocation,
    required this.toLocation,
    required this.travelDate,
    required this.busName,
  });
}

// --- MAIN SCREEN WIDGET ---
class BusSeatLayoutScreen extends StatefulWidget {
  final BusSeatLayoutScreenArguments args;
  const BusSeatLayoutScreen({super.key, required this.args});

  @override
  State<BusSeatLayoutScreen> createState() => _BusSeatLayoutScreenState();
}

class _BusSeatLayoutScreenState extends State<BusSeatLayoutScreen> with SingleTickerProviderStateMixin {
  List<List<Seat>> _lowerDeckLayout = [];
  List<List<Seat>> _upperDeckLayout = [];
  final List<Seat> _selectedSeats = [];
  double _totalPrice = 0.0;
  bool _isLoading = true;
  TabController? _tabController;
  bool _isSummaryExpanded = false;

  final BusController _busController = Get.find<BusController>();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadSeatData();
  }

  @override
  void dispose() {
    _tabController?.dispose();
    super.dispose();
  }

  // --- DATA LOGIC ---
  Future<void> _loadSeatData() async {
    await Future.delayed(const Duration(milliseconds: 800));
    try {
      final seatLayout = await _busController.getBusSeatLayout(widget.args.traceId, widget.args.resultIndex);
      _processSeatLayout(seatLayout);
    } catch (e) {
      debugPrint('Error loading seat layout: $e');
      _loadSeatDataFromJson();
    }
  }

  void _processSeatLayout(dynamic seatLayout) {
    _loadSeatDataFromJson();
  }

  void _loadSeatDataFromJson() {
    const jsonData = '''{"SeatLayouts":{"LowerDeck":[[{"SeatName":"L1","SeatStatus":true,"IsLadiesSeat":false,"Price":{"PublishedPrice":1262},"IsUpper":false},null,{"SeatName":"L2","SeatStatus":true,"Price":{"PublishedPrice":1011},"IsUpper":false},{"SeatName":"L3","SeatStatus":false,"IsMalesSeat":true,"Price":{"PublishedPrice":687},"IsUpper":false}],[null,null,{"SeatName":"L4","SeatStatus":true,"Price":{"PublishedPrice":588},"IsUpper":false},{"SeatName":"L5","SeatStatus":true,"Price":{"PublishedPrice":642},"IsUpper":false}],[{"SeatName":"L6","SeatStatus":true,"IsLadiesSeat":true,"Price":{"PublishedPrice":1677},"IsUpper":false},null,{"SeatName":"L7","SeatStatus":true,"Price":{"PublishedPrice":573},"IsUpper":false},{"SeatName":"L8","SeatStatus":true,"Price":{"PublishedPrice":692},"IsUpper":false}]],"UpperDeck":[[{"SeatName":"U1","SeatStatus":true,"Price":{"PublishedPrice":700},"IsUpper":true},null,{"SeatName":"U2","SeatStatus":true,"IsLadiesSeat":true,"Price":{"PublishedPrice":700},"IsUpper":true},{"SeatName":"U3","SeatStatus":true,"IsLadiesSeat":true,"Price":{"PublishedPrice":700},"IsUpper":true}],[{"SeatName":"U4","SeatStatus":true,"Price":{"PublishedPrice":1493},"IsUpper":true},null,{"SeatName":"U5","SeatStatus":true,"Price":{"PublishedPrice":1169},"IsUpper":true},null],[{"SeatName":"U6","SeatStatus":true,"Price":{"PublishedPrice":700},"IsUpper":true},null,{"SeatName":"U7","SeatStatus":true,"Price":{"PublishedPrice":700},"IsUpper":true},{"SeatName":"U8","SeatStatus":false,"Price":{"PublishedPrice":700},"IsUpper":true}]]}}''';
    final parsedJson = jsonDecode(jsonData);
    final layouts = parsedJson['SeatLayouts'];
    Seat emptySeat(bool isUpper) => Seat(seatName:'EMPTY', isAvailable:false, isLadiesSeat:false, isSleeper:false, price:0, isUpperDeck:isUpper);
    setState(() {
      _lowerDeckLayout = (layouts['LowerDeck'] as List).map<List<Seat>>((r) => (r as List).map<Seat>((s) => s == null ? emptySeat(false) : Seat.fromJson(s)).toList()).toList();
      _upperDeckLayout = (layouts['UpperDeck'] as List).map<List<Seat>>((r) => (r as List).map<Seat>((s) => s == null ? emptySeat(true) : Seat.fromJson(s)).toList()).toList();
      _isLoading = false;
    });
  }

  void _onSeatTap(Seat seat) {
    HapticFeedback.mediumImpact();
    setState(() {
      if (_selectedSeats.contains(seat)) {
        _selectedSeats.remove(seat);
        _totalPrice -= seat.price;
      } else if (_selectedSeats.length < 6) {
        _selectedSeats.add(seat);
        _totalPrice += seat.price;
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('You can select a maximum of 6 seats.')));
      }

      if (_selectedSeats.isEmpty) {
        _isSummaryExpanded = false;
      }
    });
  }

  // --- BUILD METHODS ---
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.card,
        elevation: 1,
        shadowColor: AppColors.primary.withOpacity(0.1),
        leading: IconButton(icon: const Icon(Icons.arrow_back, color: AppColors.primary), onPressed: () => Get.back()),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('${widget.args.fromLocation} → ${widget.args.toLocation}', style: AppStyles.heading2),
            Text(DateFormat('E, d MMM yyyy').format(widget.args.travelDate), style: AppStyles.body.copyWith(fontSize: 12)),
          ],
        ),
      ),
      body: Stack(
        children: [
          Column(
            children: [
              _buildHeader(),
              Expanded(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 500),
                  child: _isLoading
                      ? const Center(child: CircularProgressIndicator(color: AppColors.primary))
                      : TabBarView(
                          controller: _tabController,
                          children: [_buildDeckWidget(_lowerDeckLayout), _buildDeckWidget(_upperDeckLayout)],
                        ),
                ),
              ),
            ],
          ),
          Positioned(bottom: 0, left: 0, right: 0, child: _buildSummaryCard()),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      decoration: BoxDecoration(
        color: AppColors.card,
        border: Border(bottom: BorderSide(color: Colors.grey.shade200, width: 1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(widget.args.busName, style: AppStyles.heading1),
          const SizedBox(height: 16),
          const SeatInfoLegend(),
          const SizedBox(height: 8),
          TabBar(
            controller: _tabController,
            indicatorColor: AppColors.accent,
            indicatorWeight: 3,
            labelColor: AppColors.primary,
            unselectedLabelColor: AppColors.textLight,
            labelStyle: AppStyles.bodyBold,
            tabs: const [Tab(text: 'LOWER DECK'), Tab(text: 'UPPER DECK')],
          ),
        ],
      ),
    );
  }

  Widget _buildDeckWidget(List<List<Seat>> layout) {
    return SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(16, 24, 16, 150 + MediaQuery.of(context).padding.bottom),
      child: Stack(
        children: [
          // The bus outline and the seats within it
          CustomPaint(
            painter: BusOutlinePainter(),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 24.0, horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _buildSeatColumn(layout, 0),
                  _buildSeatColumn(layout, 1),
                  const SizedBox(width: 24), // Aisle
                  _buildSeatColumn(layout, 2),
                  _buildSeatColumn(layout, 3),
                ],
              ),
            ),
          ),
          // The driver icon positioned on top
          Positioned(
            top: 8,
            right: 12,
            child: Icon(
              Icons.drive_eta_rounded,
              color: AppColors.textLight.withOpacity(0.5),
              size: 32,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSeatColumn(List<List<Seat>> layout, int columnIndex) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(layout.length, (rowIndex) {
        final seat = (columnIndex < layout[rowIndex].length) ? layout[rowIndex][columnIndex] : null;
        if (seat == null || seat.seatName == 'EMPTY') {
          return const SizedBox(width: 52, height: 68); // Placeholder
        }
        return SeatWidget(
          seat: seat,
          isSelected: _selectedSeats.contains(seat),
          onTap: () => _onSeatTap(seat),
        );
      }),
    );
  }

  Widget _buildSummaryCard() {
    bool isVisible = _selectedSeats.isNotEmpty;
    return AnimatedSlide(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      offset: isVisible ? Offset.zero : const Offset(0, 2),
      child: Container(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom),
        decoration: BoxDecoration(
          color: AppColors.card,
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 20, offset: const Offset(0,-5))],
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 8),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                         Text('₹${_totalPrice.toStringAsFixed(0)}', style: AppStyles.heading1.copyWith(color: AppColors.accent)),
                         Text('${_selectedSeats.length} Seat${_selectedSeats.length > 1 ? 's' : ''} Selected', style: AppStyles.body),
                      ],
                    ),
                  ),
                  TextButton.icon(
                    onPressed: () => setState(() => _isSummaryExpanded = !_isSummaryExpanded),
                    icon: Icon(_isSummaryExpanded ? Icons.expand_more : Icons.expand_less),
                    label: const Text("Details"),
                  ),
                ],
              ),
            ),
            AnimatedSize(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              child: Container(
                constraints: const BoxConstraints(maxHeight: 150),
                child: _isSummaryExpanded ? _buildSelectedSeatsList() : const SizedBox(width: double.infinity),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.accent,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  textStyle: AppStyles.bodyBold,
                ),
                onPressed: () { /* TODO: Navigation logic */ },
                child: const Text('Continue'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSelectedSeatsList() {
    return ListView.builder(
      shrinkWrap: true,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      itemCount: _selectedSeats.length,
      itemBuilder: (context, index) {
        final seat = _selectedSeats[index];
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0),
          child: Row(
            children: [
              Icon(seat.isSleeper ? Icons.bed_outlined : Icons.chair_outlined, color: AppColors.primary, size: 20),
              const SizedBox(width: 8),
              Expanded(child: Text('Seat ${seat.seatName}', style: AppStyles.bodyBold)),
              Text('₹${seat.price.toStringAsFixed(0)}', style: AppStyles.body),
              IconButton(
                icon: const Icon(Icons.close_rounded, color: AppColors.textLight, size: 20),
                onPressed: () => _onSeatTap(seat),
              ),
            ],
          ),
        );
      },
    );
  }
}

// --- REUSABLE WIDGETS ---
class SeatWidget extends StatelessWidget {
  final Seat seat;
  final bool isSelected;
  final VoidCallback onTap;

  const SeatWidget({super.key, required this.seat, required this.isSelected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    Color borderColor = AppColors.seatBookedBorder;
    Color backgroundColor = AppColors.seatBooked;
    Color contentColor = AppColors.textLight;

    if (seat.isAvailable) {
      if (seat.isLadiesSeat) {
        borderColor = AppColors.seatLadies;
        backgroundColor = AppColors.card;
        contentColor = AppColors.seatLadies;
      } else {
        borderColor = AppColors.seatAvailableBorder;
        backgroundColor = AppColors.seatAvailable;
        contentColor = AppColors.textDark;
      }
    }

    if (isSelected) {
      borderColor = AppColors.seatSelected;
      backgroundColor = AppColors.seatSelected;
      contentColor = Colors.white;
    }

    return Tooltip(
      message: seat.isAvailable ? '₹${seat.price.toStringAsFixed(0)}' : 'Booked',
      child: GestureDetector(
        onTap: seat.isAvailable ? onTap : null,
        child: AnimatedScale(
          duration: const Duration(milliseconds: 200),
          scale: isSelected ? 1.1 : 1.0,
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 4),
            width: 52,
            height: 60,
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: borderColor, width: 1.5),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  seat.isSleeper ? Icons.bed_outlined : Icons.chair_outlined,
                  color: contentColor,
                  size: 20,
                ),
                const SizedBox(height: 2),
                Text(
                  seat.isAvailable ? '₹${seat.price.toStringAsFixed(0)}' : seat.seatName,
                  style: TextStyle(
                    color: contentColor,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class SeatInfoLegend extends StatelessWidget {
  const SeatInfoLegend({super.key});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 16.0, runSpacing: 8.0,
      children: [
        const LegendItem(color: AppColors.seatAvailableBorder, text: 'Available'),
        LegendItem(color: AppColors.seatBooked, text: 'Booked'),
        const LegendItem(color: AppColors.seatLadies, text: 'Ladies'),
        const LegendItem(color: AppColors.seatSelected, text: 'Selected'),
      ],
    );
  }
}

class LegendItem extends StatelessWidget {
  final Color color;
  final String text;
  const LegendItem({super.key,required this.color,required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(width: 12, height: 12, decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(2), border: Border.all(color: Colors.grey.shade300, width: 0.5))),
        const SizedBox(width: 6),
        Text(text, style: AppStyles.body.copyWith(fontSize: 12)),
      ],
    );
  }
}

// --- CUSTOM PAINTER ---
class BusOutlinePainter extends CustomPainter {
  BusOutlinePainter();

  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()..color = AppColors.card..style = PaintingStyle.fill;
    var shadowPaint = Paint()
      ..color = Colors.black.withOpacity(0.08)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);
    Path path = Path();
    double cornerRadius = 24.0;

    canvas.drawRRect(
        RRect.fromRectAndRadius(
            Rect.fromLTWH(0, 0, size.width, size.height), Radius.circular(cornerRadius)),
        shadowPaint);

    path.moveTo(cornerRadius, 0);
    path.lineTo(size.width, 0);
    path.lineTo(size.width, size.height - cornerRadius);
    path.quadraticBezierTo(
        size.width, size.height, size.width - cornerRadius, size.height);
    path.lineTo(cornerRadius, size.height);
    path.quadraticBezierTo(0, size.height, 0, size.height - cornerRadius);
    path.lineTo(0, cornerRadius);
    path.quadraticBezierTo(0, 0, cornerRadius, 0);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}