import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

// Your other imports
import '../../../Controller/bus_controller.dart';
import 'boarding_point_screen.dart';

// --- THEME & STYLES ---
class AppColors {
  static const Color primary = Color(0xFFD32F2F);
  static const Color primaryVariant = Color(0xFFB71C1C);
  static const Color accent = Color(0xFFD32F2F);
  static const Color background = Color(0xFFF7F9FB);
  static const Color seatAvailable = Color(0xFFFFFFFF);
  static const Color seatAvailableBorder = Color(0xFFD0D5DD);
  static const Color seatSelected = Color(0xFFD32F2F);
  static const Color seatLadies = Color(0xFFF06292);
  static const Color seatBooked = Color(0xFFEAECF0);
  static const Color seatBookedBorder = Color(0xFFEAECF0);
  static const Color textDark = Color(0xFF101828);
  static const Color textLight = Color(0xFF667085);
  static const Color card = Colors.white;
}

class AppStyles {
  static final TextStyle heading1 = GoogleFonts.poppins(
      fontWeight: FontWeight.bold, fontSize: 20, color: AppColors.textDark);
  static final TextStyle heading2 = GoogleFonts.poppins(
      fontWeight: FontWeight.w600, fontSize: 16, color: AppColors.textDark);
  static final TextStyle body =
      GoogleFonts.poppins(fontSize: 14, color: AppColors.textLight);
  static final TextStyle bodyBold = GoogleFonts.poppins(
      fontWeight: FontWeight.w600, fontSize: 14, color: AppColors.textDark);
}

// --- DATA MODELS ---
class Seat {
  final int rowNo;
  final int columnNo;
  final String seatName;
  final bool isAvailable;
  final bool isLadiesSeat;
  final bool isSleeper;
  final double price;
  final bool isUpperDeck;

  Seat({
    required this.rowNo,
    required this.columnNo,
    required this.seatName,
    required this.isAvailable,
    required this.isLadiesSeat,
    required this.isSleeper,
    required this.price,
    required this.isUpperDeck,
  });

  factory Seat.fromJson(Map<String, dynamic> json) {
    String seatName = json['SeatName'] ?? 'N/A';
    bool isSleeper = seatName.toUpperCase().startsWith('U') ||
        seatName.toUpperCase().startsWith('L');
    return Seat(
      rowNo: int.tryParse(json['RowNo'] ?? '0') ?? 0,
      columnNo: int.tryParse(json['ColumnNo'] ?? '0') ?? 0,
      seatName: seatName,
      isAvailable: !(json['SeatStatus'] as bool? ?? true),
      isLadiesSeat: json['IsLadiesSeat'] as bool? ?? false,
      isSleeper: isSleeper,
      price: (json['Price']?['PublishedPrice'] as num? ?? 0.0).toDouble(),
      isUpperDeck: json['IsUpper'] as bool? ?? false,
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
  final int availableSeats;

  BusSeatLayoutScreenArguments({
    required this.traceId,
    required this.resultIndex,
    required this.fromLocation,
    required this.toLocation,
    required this.travelDate,
    required this.busName,
    required this.availableSeats,
  });
}

// --- MAIN SCREEN WIDGET ---
class BusSeatLayoutScreen extends StatefulWidget {
  final BusSeatLayoutScreenArguments args;
  const BusSeatLayoutScreen({super.key, required this.args});

  @override
  State<BusSeatLayoutScreen> createState() => _BusSeatLayoutScreenState();
}

class _BusSeatLayoutScreenState extends State<BusSeatLayoutScreen>
    with SingleTickerProviderStateMixin {
  List<List<Seat?>> _lowerDeckLayout = [];
  List<List<Seat?>> _upperDeckLayout = [];
  final List<Seat> _selectedSeats = [];
  double _totalPrice = 0.0;
  bool _isLoading = true;
  TabController? _tabController;
  bool _isSummaryExpanded = false;

  final BusController _busController = Get.find<BusController>();

  @override
  void initState() {
    super.initState();
    _loadSeatData();
  }

  @override
  void dispose() {
    _tabController?.dispose();
    super.dispose();
  }

  // --- DATA LOGIC ---
  Future<void> _loadSeatData() async {
    try {
      final seatLayoutResponse = await _busController.getBusSeatLayout(
          widget.args.traceId, widget.args.resultIndex);
      
      if (seatLayoutResponse != null &&
          seatLayoutResponse['GetBusSeatLayOutResult']?['SeatLayoutDetails']
                  ?['SeatLayout'] !=
              null) {
        _processSeatLayout(seatLayoutResponse);
      } else {
        throw Exception("Invalid seat layout format received from API.");
      }
    } catch (e) {
      debugPrint('Error loading seat layout: $e');
      if (mounted) {
        setState(() => _isLoading = false);
        Get.snackbar("Error", "Could not load seat layout. Please try again.");
      }
    }
  }

  void _processSeatLayout(Map<String, dynamic> apiResponse) {
    final seatLayoutData = apiResponse['GetBusSeatLayOutResult']
        ['SeatLayoutDetails']['SeatLayout'];
    final seatDetailsJson =
        seatLayoutData['SeatDetails'] as List<dynamic>? ?? [];

    List<Seat> allSeats = seatDetailsJson
        .expand(
            (row) => (row as List).map((seatJson) => Seat.fromJson(seatJson)))
        .toList();

    List<Seat> lowerDeckSeats = allSeats.where((s) => !s.isUpperDeck).toList();
    List<Seat> upperDeckSeats = allSeats.where((s) => s.isUpperDeck).toList();

    setState(() {
      _lowerDeckLayout = _createGridFromSeats(lowerDeckSeats);
      _upperDeckLayout = _createGridFromSeats(upperDeckSeats);

      _tabController = TabController(
          length: _upperDeckLayout.isNotEmpty ? 2 : 1, vsync: this);
      _isLoading = false;
    });
  }
  
  List<List<Seat?>> _createGridFromSeats(List<Seat> seats) {
    if (seats.isEmpty) return [];

    int maxRow = seats.map((s) => s.rowNo).reduce(max);
    int maxCol = seats.map((s) => s.columnNo).reduce(max);

    List<List<Seat?>> grid = List.generate(
        maxRow + 1, (_) => List.generate(maxCol + 1, (_) => null));

    for (var seat in seats) {
      if (seat.rowNo < grid.length && seat.columnNo < grid[seat.rowNo].length) {
        grid[seat.rowNo][seat.columnNo] = seat;
      }
    }
    return grid;
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
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            backgroundColor: AppColors.accent,
            content: Text('You can select a maximum of 6 seats.',
                style: AppStyles.body.copyWith(color: Colors.white))));
      }
      if (_selectedSeats.isNotEmpty && !_isSummaryExpanded) {
        _isSummaryExpanded = true;
      } else if (_selectedSeats.isEmpty && _isSummaryExpanded) {
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
        leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: AppColors.primary),
            onPressed: () => Get.back()),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('${widget.args.fromLocation} → ${widget.args.toLocation}',
                style: AppStyles.heading2),
            Text(DateFormat('E, d MMM yyyy').format(widget.args.travelDate),
                style: AppStyles.body.copyWith(fontSize: 12)),
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
                  duration: const Duration(milliseconds: 300),
                  child: _isLoading
                      ? const Center(
                          child: CircularProgressIndicator(
                              color: AppColors.primary))
                      : TabBarView(
                          controller: _tabController,
                          children: [
                            _buildDeckWidget(_lowerDeckLayout),
                            if (_upperDeckLayout.isNotEmpty)
                              _buildDeckWidget(_upperDeckLayout),
                          ],
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
        border:
            Border(bottom: BorderSide(color: Colors.grey.shade200, width: 1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(widget.args.busName, style: AppStyles.heading1),
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(Icons.event_seat_outlined,
                  color: AppColors.textLight, size: 16),
              const SizedBox(width: 8),
              Text('${widget.args.availableSeats} Seats Available',
                  style: AppStyles.body),
            ],
          ),
          const SizedBox(height: 16),
          const SeatInfoLegend(),
          const SizedBox(height: 8),
          if (!_isLoading && _upperDeckLayout.isNotEmpty)
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

  Widget _buildDeckWidget(List<List<Seat?>> layout) {
    if (layout.isEmpty) {
      return Center(
          child: Text("No layout available for this deck.",
              style: AppStyles.body));
    }

    int columnCount = layout.map((row) => row.length).reduce(max);

    return SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(
          16, 24, 16, 200 + MediaQuery.of(context).padding.bottom),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Stack(
          alignment: Alignment.topRight,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
              decoration: BoxDecoration(
                  border: Border.all(color: AppColors.seatAvailableBorder),
                  borderRadius: BorderRadius.circular(16)),
              child: Column(
                children: layout
                    .map((row) => _buildSeatRow(row, columnCount))
                    .toList(),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 16, top: 16),
              child: Icon(
                Icons.directions_bus,
                color: AppColors.textLight.withOpacity(0.5),
                size: 32,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSeatRow(List<Seat?> row, int totalColumns) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List.generate(totalColumns, (index) {
          final seat = index < row.length ? row[index] : null;

          if (seat == null) {
            return const SizedBox(
                width: 52, height: 60); // Aisle or empty space
          }
          return SeatWidget(
            seat: seat,
            isSelected: _selectedSeats.contains(seat),
            onTap: () => _onSeatTap(seat),
          );
        }),
      ),
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
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 20,
                offset: const Offset(0, -5))
          ],
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
                        Text('₹${_totalPrice.toStringAsFixed(0)}',
                            style: AppStyles.heading1.copyWith(
                                color: AppColors.accent, fontSize: 22)),
                        Text(
                            '${_selectedSeats.length} Seat${_selectedSeats.length == 1 ? '' : 's'} Selected',
                            style: AppStyles.body),
                      ],
                    ),
                  ),
                  TextButton.icon(
                    onPressed: () => setState(
                        () => _isSummaryExpanded = !_isSummaryExpanded),
                    icon: AnimatedRotation(
                        duration: const Duration(milliseconds: 200),
                        turns: _isSummaryExpanded ? 0.5 : 0,
                        child: const Icon(Icons.expand_less)),
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
                child: _isSummaryExpanded
                    ? _buildSelectedSeatsList()
                    : const SizedBox(width: double.infinity),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.accent,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  textStyle: AppStyles.bodyBold.copyWith(fontSize: 16),
                ),
                onPressed: () {
                  Get.to(() => BoardingPointScreen(
                        traceId: widget.args.traceId,
                        resultIndex: widget.args.resultIndex,
                        busName: widget.args.busName,
                        fromCity: widget.args.fromLocation,
                        toCity: widget.args.toLocation,
                        journeyDate: DateFormat('d MMM yyyy')
                            .format(widget.args.travelDate),
                        fare: _totalPrice.toStringAsFixed(0),
                        selectedSeats: _selectedSeats,
                      ));
                },
                child: const Text('Select Boarding Point'),
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
              Icon(seat.isSleeper ? Icons.bed_outlined : Icons.chair_outlined,
                  color: AppColors.primary, size: 20),
              const SizedBox(width: 8),
              Expanded(
                  child:
                      Text('Seat ${seat.seatName}', style: AppStyles.bodyBold)),
              Text('₹${seat.price.toStringAsFixed(0)}', style: AppStyles.body),
              IconButton(
                icon: const Icon(Icons.close_rounded,
                    color: AppColors.textLight, size: 20),
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

  const SeatWidget(
      {super.key,
      required this.seat,
      required this.isSelected,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    Color borderColor = AppColors.seatBookedBorder;
    Color backgroundColor = AppColors.seatBooked;
    Color contentColor = AppColors.textLight;

    if (seat.isAvailable) {
      if (seat.isLadiesSeat) {
        borderColor = AppColors.seatLadies;
        backgroundColor = AppColors.seatLadies.withOpacity(0.1);
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
      message: seat.isAvailable
          ? 'Seat ${seat.seatName} | ₹${seat.price.toStringAsFixed(0)}'
          : 'Booked',
      child: GestureDetector(
        onTap: seat.isAvailable ? onTap : null,
        child: AnimatedScale(
          duration: const Duration(milliseconds: 150),
          scale: isSelected ? 1.1 : 1.0,
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 4),
            width: 52,
            height: 60,
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(seat.isSleeper ? 12 : 8),
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
                  seat.seatName,
                  style: TextStyle(
                    color: contentColor,
                    fontSize: 12,
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
      spacing: 16.0,
      runSpacing: 8.0,
      children: [
        const LegendItem(
            color: AppColors.seatAvailableBorder, text: 'Available'),
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
  const LegendItem({super.key, required this.color, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(2),
                border: Border.all(color: Colors.grey.shade300, width: 0.5))),
        const SizedBox(width: 6),
        Text(text, style: AppStyles.body.copyWith(fontSize: 12)),
      ],
    );
  }
}
