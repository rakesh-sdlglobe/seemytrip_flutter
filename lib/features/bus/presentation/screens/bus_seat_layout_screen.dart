import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:shimmer/shimmer.dart';
import 'package:seemytrip/core/theme/app_colors.dart' as AppTheme;
import '../controllers/bus_controller.dart';
import 'boarding_point_screen.dart';

// --- SIMPLIFIED THEME-AWARE COLORS ---
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
  
  static Color seatLadies(BuildContext context) => Theme.of(context).brightness == Brightness.dark
    ? const Color(0xFFE91E63) // Pink for dark theme
    : const Color(0xFFF06292); // Light pink for light theme
  
  static Color seatBooked(BuildContext context) => Theme.of(context).brightness == Brightness.dark
    ? Colors.grey[700]!
    : const Color(0xFFEAECF0);
}

// Keep simplified AppColors for compatibility
class AppColors {
  static const Color primary = Color(0xFFE53935); // Will be overridden in theme-aware widgets
  static const Color primaryVariant = Color(0xFFC62828);
  static const Color accent = Color(0xFFFFA726);
  static const Color background = Color(0xFFF5F6FA);
  static const Color seatAvailable = Color(0xFFFFFFFF);
  static const Color seatAvailableBorder = Color(0xFFD0D5DD);
  static const Color seatSelected = Color(0xFFE53935);
  static const Color seatLadies = Color(0xFFF06292);
  static const Color seatBooked = Color(0xFFEAECF0);
  static const Color seatBookedBorder = Color(0xFFEAECF0);
  static const Color textDark = Color(0xFF1A1A1A);
  static const Color textLight = Color(0xFF757575);
  static const Color card = Colors.white;
  static const Color redCA0 = Color(0xFFCA0D0D);
  static const Color redF9E = Color(0xFFF9E4E4);
}

class AppStyles {
  static final TextStyle heading1 = GoogleFonts.poppins(
    fontWeight: FontWeight.w600,
    fontSize: 18,
    color: AppColors.textDark,
    letterSpacing: 0.1,
  );
  static final TextStyle heading2 = GoogleFonts.poppins(
    fontWeight: FontWeight.w600,
    fontSize: 15,
    color: AppColors.textDark,
  );
  static final TextStyle body = GoogleFonts.poppins(
    fontSize: 13,
    color: AppColors.textLight,
    height: 1.4,
  );
  static final TextStyle bodyBold = GoogleFonts.poppins(
    fontWeight: FontWeight.w600,
    fontSize: 13,
    color: AppColors.textDark,
  );
  static final TextStyle button = GoogleFonts.poppins(
    fontWeight: FontWeight.w600,
    fontSize: 14,
    color: Colors.white,
  );
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
  final String? departureTime;
  final String? arrivalTime;

  BusSeatLayoutScreenArguments({
    required this.traceId,
    required this.resultIndex,
    required this.fromLocation,
    required this.toLocation,
    required this.travelDate,
    required this.busName,
    required this.availableSeats,
    this.departureTime,
    this.arrivalTime,
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
    with TickerProviderStateMixin {
  List<List<Seat?>> _lowerDeckLayout = [];
  List<List<Seat?>> _upperDeckLayout = [];
  final List<Seat> _selectedSeats = [];
  double _totalPrice = 0.0;
  bool _isLoading = true;
  TabController? _tabController;
  bool _isSummaryExpanded = false;
  AnimationController? _animationController;
  Animation<double>? _fadeAnimation;

  final BusController _busController = Get.find<BusController>();

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _animationController!,
      curve: Curves.easeOutCubic,
    );
    _loadSeatData();
  }

  @override
  void dispose() {
    _tabController?.dispose();
    _animationController?.dispose();
    super.dispose();
  }

  // --- DATA LOGIC ---
  Future<void> _loadSeatData() async {
    try {
      final seatLayoutResponse = await _busController.getBusSeatLayout(
        widget.args.traceId,
        widget.args.resultIndex,
      );

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
        Get.snackbar(
          "Error",
          "Could not load seat layout. Please try again.",
          backgroundColor: ThemeAwareColors.primaryVariant(context),
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 3),
        );
      }
    }
  }

  void _processSeatLayout(Map<String, dynamic> apiResponse) {
    final seatLayoutData = apiResponse['GetBusSeatLayOutResult']
        ['SeatLayoutDetails']['SeatLayout'];
    final seatDetailsJson =
        seatLayoutData['SeatDetails'] as List<dynamic>? ?? [];

    List<Seat> allSeats = seatDetailsJson
        .expand((row) => (row as List).map((seatJson) => Seat.fromJson(seatJson)))
        .toList();

    List<Seat> lowerDeckSeats = allSeats.where((s) => !s.isUpperDeck).toList();
    List<Seat> upperDeckSeats = allSeats.where((s) => s.isUpperDeck).toList();

    setState(() {
      _lowerDeckLayout = _createGridFromSeats(lowerDeckSeats);
      _upperDeckLayout = _createGridFromSeats(upperDeckSeats);
      _tabController = TabController(
        length: _upperDeckLayout.isNotEmpty ? 2 : 1,
        vsync: this,
      );
      _isLoading = false;
      _animationController?.forward();
    });
  }

  List<List<Seat?>> _createGridFromSeats(List<Seat> seats) {
    if (seats.isEmpty) return [];

    int maxRow = seats.map((s) => s.rowNo).reduce(max);
    int maxCol = seats.map((s) => s.columnNo).reduce(max);

    List<List<Seat?>> grid = List.generate(
      maxRow + 1,
      (_) => List.generate(maxCol + 1, (_) => null),
    );

    for (var seat in seats) {
      if (seat.rowNo < grid.length && seat.columnNo < grid[seat.rowNo].length) {
        grid[seat.rowNo][seat.columnNo] = seat;
      }
    }
    return grid;
  }

  void _onSeatTap(Seat seat) {
    if (!seat.isAvailable) {
      HapticFeedback.lightImpact();
      return;
    }
    HapticFeedback.mediumImpact();
    setState(() {
      if (_selectedSeats.contains(seat)) {
        _selectedSeats.remove(seat);
        _totalPrice -= seat.price;
      } else if (_selectedSeats.length < 6) {
        _selectedSeats.add(seat);
        _totalPrice += seat.price;
      } else {
        HapticFeedback.heavyImpact();
        Get.snackbar(
          'Maximum Seats',
          'You can select a maximum of 6 seats.',
          backgroundColor: AppTheme.AppColors.redCA0,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 2),
          borderRadius: 12,
          margin: const EdgeInsets.all(16),
          icon: const Icon(Icons.info_outline, color: Colors.white),
        );
      }
      _isSummaryExpanded = _selectedSeats.isNotEmpty;
    });
    _animationController?.forward();
  }

  // --- BUILD METHODS ---
  @override
  Widget build(BuildContext context) {
    if (_fadeAnimation == null || _animationController == null) {
      return Center(
          child: LoadingAnimationWidget.dotsTriangle(
color: ThemeAwareColors.primary(context),
        size: 40,
      ));
    }

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: _buildAppBar(),
      body: Stack(
        children: [
          FadeTransition(
            opacity: _fadeAnimation!,
            child: Column(
              children: [
                _buildHeader(),
                Expanded(
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    child: _isLoading
                        ? _buildShimmerLoading()
                        : _tabController == null
                            ? Center(
                                child: Text(
                                  'Error loading seat layout.',
                                  style: AppStyles.body.copyWith(
                                    color: Theme.of(context).textTheme.bodyMedium?.color,
                                  ),
                                ),
                              )
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
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: _buildSummaryCard(),
          ),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() => AppBar(
        backgroundColor: AppTheme.AppColors.redCA0,
        foregroundColor: Colors.white,
        toolbarHeight: 85,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        leading: Container(
          margin: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.white.withOpacity(0.3), width: 1),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded, 
                color: Colors.white, size: 18),
            onPressed: () => Get.back(),
            padding: EdgeInsets.zero,
          ),
        ),
        title: Container(
          padding: const EdgeInsets.only(right: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '${widget.args.fromLocation} → ${widget.args.toLocation}',
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.2,
                  height: 1.2,
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  Icon(Icons.calendar_today_rounded, size: 12, color: Colors.white.withOpacity(0.9)),
                  const SizedBox(width: 6),
                  Text(
                    DateFormat('EEEE, d MMM yyyy').format(widget.args.travelDate),
                    style: GoogleFonts.poppins(
                      color: Colors.white.withOpacity(0.95),
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 0.1,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(4),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.white.withOpacity(0.1),
                  Colors.transparent,
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            height: 4,
          ),
        ),
      );

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [AppTheme.AppColors.redCA0, AppTheme.AppColors.redCA0.withOpacity(0.8)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.AppColors.redCA0.withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Icon(
                  Icons.directions_bus_rounded,
                  color: Colors.white,
                  size: 26,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.args.busName,
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                        color: Theme.of(context).textTheme.bodyLarge?.color ?? Colors.black87,
                        letterSpacing: 0.1,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppTheme.AppColors.redF9E.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: AppTheme.AppColors.redCA0.withOpacity(0.2),
                          width: 1,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.event_seat_rounded, size: 14, color: AppTheme.AppColors.redCA0),
                          const SizedBox(width: 6),
                          Text(
                            '${widget.args.availableSeats} Seats Available',
                            style: GoogleFonts.poppins(
                              color: AppTheme.AppColors.redCA0,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              if (_upperDeckLayout.isNotEmpty)
                Container(
                  decoration: BoxDecoration(
                    color: AppTheme.AppColors.redF9E,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(
                      color: AppTheme.AppColors.redCA0.withOpacity(0.3),
                      width: 1.5,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: AppTheme.AppColors.redCA0.withOpacity(0.1),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: TabBar(
                    controller: _tabController,
                    labelColor: Colors.white,
                    unselectedLabelColor: AppTheme.AppColors.redCA0,
                    indicator: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [AppTheme.AppColors.redCA0, AppTheme.AppColors.redCA0.withOpacity(0.9)],
                      ),
                      borderRadius: BorderRadius.circular(18),
                    ),
                    indicatorSize: TabBarIndicatorSize.tab,
                    labelStyle: GoogleFonts.poppins(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.5,
                    ),
                    unselectedLabelStyle: GoogleFonts.poppins(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.5,
                    ),
                    labelPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    tabs: const [
                      Tab(text: 'LOWER'),
                      Tab(text: 'UPPER'),
                    ],
                  ),
                ),
            ],
          ),
          const SizedBox(height: 16),
          const SeatInfoLegend(),
        ],
      ),
    );
  }

  Widget _buildDeckWidget(List<List<Seat?>> layout) {
    if (layout.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.event_seat_outlined,
              size: 64,
              color: Theme.of(context).textTheme.bodySmall?.color?.withOpacity(0.3),
            ),
            const SizedBox(height: 16),
            Text(
              "No layout available for this deck.",
              style: GoogleFonts.poppins(
                fontSize: 15,
                color: Theme.of(context).textTheme.bodyMedium?.color,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      );
    }

    int columnCount = layout.map((row) => row.length).reduce(max);

    return SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(
        16,
        24,
        16,
        220 + MediaQuery.of(context).padding.bottom,
      ),
      physics: const BouncingScrollPhysics(),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        child: Stack(
          alignment: Alignment.topRight,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 28),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Theme.of(context).cardColor,
                    Theme.of(context).brightness == Brightness.dark
                        ? Colors.black.withOpacity(0.3)
                        : AppTheme.AppColors.redF9E.withOpacity(0.05),
                  ],
                ),
                border: Border.all(
                  color: Theme.of(context).dividerColor.withOpacity(0.3),
                  width: 1,
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Theme.of(context).shadowColor.withOpacity(0.1),
                    blurRadius: 20,
                    spreadRadius: 0,
                    offset: const Offset(0, 6),
                  ),
                  BoxShadow(
                    color: Theme.of(context).shadowColor.withOpacity(0.05),
                    blurRadius: 8,
                    spreadRadius: 0,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                children: layout
                    .asMap()
                    .entries
                    .map((entry) => TweenAnimationBuilder<double>(
                          duration: Duration(milliseconds: 300 + (entry.key * 50)),
                          tween: Tween(begin: 0.0, end: 1.0),
                          curve: Curves.easeOutCubic,
                          builder: (context, value, child) {
                            return Transform.translate(
                              offset: Offset(0, 20 * (1 - value)),
                              child: Opacity(
                                opacity: value,
                                child: RepaintBoundary(
                                  child: _buildSeatRow(entry.value, columnCount),
                                ),
                              ),
                            );
                          },
                        ))
                    .toList(),
              ),
            ),
            Positioned(
              right: 20,
              top: 20,
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppTheme.AppColors.redCA0.withOpacity(0.1),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppTheme.AppColors.redCA0.withOpacity(0.2),
                    width: 1,
                  ),
                ),
                child: Icon(
                  Icons.directions_bus_rounded,
                  color: AppTheme.AppColors.redCA0.withOpacity(0.6),
                  size: 32,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildShimmerLoading() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: List.generate(8, (index) => Padding(
          padding: const EdgeInsets.only(bottom: 12.0),
          child: Shimmer.fromColors(
            baseColor: Theme.of(context).brightness == Brightness.dark
                ? Colors.grey[800]!
                : Colors.grey[300]!,
            highlightColor: Theme.of(context).brightness == Brightness.dark
                ? Colors.grey[700]!
                : Colors.grey[100]!,
            period: const Duration(milliseconds: 1200),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(4, (_) => Container(
                width: 56,
                height: 64,
                margin: const EdgeInsets.symmetric(horizontal: 4),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                ),
              )),
            ),
          ),
        )),
      ),
    );
  }

  Widget _buildSeatRow(List<Seat?> row, int totalColumns) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: List.generate(totalColumns, (index) {
          final seat = index < row.length ? row[index] : null;
          if (seat == null) {
            return const SizedBox(width: 56, height: 64); // Aisle or empty space
          }
          return RepaintBoundary(
            child: SeatWidget(
              seat: seat,
              isSelected: _selectedSeats.contains(seat),
              onTap: () => _onSeatTap(seat),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildSummaryCard() {
    bool isVisible = _selectedSeats.isNotEmpty;
    return AnimatedSlide(
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeOutCubic,
      offset: isVisible ? Offset.zero : const Offset(0, 2),
      child: Container(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Theme.of(context).cardColor,
              Theme.of(context).brightness == Brightness.dark
                  ? Colors.black.withOpacity(0.3)
                  : AppTheme.AppColors.redF9E.withOpacity(0.1),
            ],
          ),
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).shadowColor.withOpacity(0.15),
              blurRadius: 25,
              spreadRadius: 0,
              offset: const Offset(0, -8),
            ),
            BoxShadow(
              color: Theme.of(context).shadowColor.withOpacity(0.08),
              blurRadius: 10,
              spreadRadius: 0,
              offset: const Offset(0, -2),
            ),
          ],
          borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          AppTheme.AppColors.redCA0,
                          AppTheme.AppColors.redCA0.withOpacity(0.8),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: [
                        BoxShadow(
                          color: AppTheme.AppColors.redCA0.withOpacity(0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.event_seat_rounded,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '₹',
                              style: GoogleFonts.poppins(
                                color: AppTheme.AppColors.redCA0,
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                                height: 1.2,
                              ),
                            ),
                            Text(
                              _totalPrice.toStringAsFixed(0),
                              style: GoogleFonts.poppins(
                                color: AppTheme.AppColors.redCA0,
                                fontSize: 28,
                                fontWeight: FontWeight.w800,
                                letterSpacing: -0.5,
                                height: 1.1,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${_selectedSeats.length} Seat${_selectedSeats.length == 1 ? '' : 's'} Selected',
                          style: GoogleFonts.poppins(
                            fontSize: 13,
                            color: Theme.of(context).textTheme.bodyMedium?.color,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: AppTheme.AppColors.redF9E.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: AppTheme.AppColors.redCA0.withOpacity(0.2),
                        width: 1,
                      ),
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () => setState(() => _isSummaryExpanded = !_isSummaryExpanded),
                        borderRadius: BorderRadius.circular(12),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                "Details",
                                style: GoogleFonts.poppins(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: AppTheme.AppColors.redCA0,
                                ),
                              ),
                              const SizedBox(width: 4),
                              AnimatedRotation(
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.easeInOut,
                                turns: _isSummaryExpanded ? 0.5 : 0,
                                child: Icon(
                                  Icons.expand_less,
                                  color: AppTheme.AppColors.redCA0,
                                  size: 20,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
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
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: _selectedSeats.isEmpty
                        ? [Colors.grey[400]!, Colors.grey[500]!]
                        : [
                            AppTheme.AppColors.redCA0,
                            AppTheme.AppColors.redCA0.withOpacity(0.9),
                          ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: _selectedSeats.isEmpty
                      ? null
                      : [
                          BoxShadow(
                            color: AppTheme.AppColors.redCA0.withOpacity(0.4),
                            blurRadius: 16,
                            spreadRadius: 0,
                            offset: const Offset(0, 6),
                          ),
                          BoxShadow(
                            color: AppTheme.AppColors.redCA0.withOpacity(0.2),
                            blurRadius: 8,
                            spreadRadius: 0,
                            offset: const Offset(0, 3),
                          ),
                        ],
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: _selectedSeats.isEmpty
                        ? null
                        : () {
                            Get.to(() => BoardingPointScreen(
                                  traceId: widget.args.traceId,
                                  resultIndex: widget.args.resultIndex,
                                  busName: widget.args.busName,
                                  fromCity: widget.args.fromLocation,
                                  toCity: widget.args.toLocation,
                                  journeyDate: DateFormat('d MMM yyyy').format(widget.args.travelDate),
                                  departureTime: widget.args.departureTime,
                                  arrivalTime: widget.args.arrivalTime,
                                  fare: _totalPrice.toStringAsFixed(0),
                                  selectedSeats: _selectedSeats,
                                ));
                          },
                    borderRadius: BorderRadius.circular(16),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 18),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.location_on_rounded,
                            color: Colors.white,
                            size: 22,
                          ),
                          const SizedBox(width: 10),
                          Text(
                            'Select Boarding Point',
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w700,
                              fontSize: 16,
                              color: Colors.white,
                              letterSpacing: 0.3,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
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
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      itemCount: _selectedSeats.length,
      itemBuilder: (context, index) {
        final seat = _selectedSeats[index];
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 6.0),
          child: Row(
            children: [
              Icon(
                seat.isSleeper ? Icons.bed_outlined : Icons.chair_outlined,
                color: ThemeAwareColors.primary(context),
                size: 20,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  'Seat ${seat.seatName}',
                  style: AppStyles.bodyBold.copyWith(fontSize: 13),
                ),
              ),
              Text(
                '₹${seat.price.toStringAsFixed(0)}',
                style: AppStyles.body.copyWith(fontSize: 13),
              ),
              IconButton(
                icon: Icon(Icons.close_rounded, color: Theme.of(context).textTheme.bodySmall?.color, size: 20),
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

  const SeatWidget({
    super.key,
    required this.seat,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    Color borderColor = ThemeAwareColors.seatBooked(context);
    Color backgroundColor = ThemeAwareColors.seatBooked(context);
    Color contentColor = Theme.of(context).textTheme.bodySmall?.color ?? Colors.grey;

    if (seat.isAvailable) {
      if (seat.isLadiesSeat) {
        borderColor = ThemeAwareColors.seatLadies(context);
        backgroundColor = ThemeAwareColors.seatLadies(context).withOpacity(0.15);
        contentColor = ThemeAwareColors.seatLadies(context);
      } else {
        borderColor = Theme.of(context).dividerColor;
        backgroundColor = Theme.of(context).cardColor;
        contentColor = Theme.of(context).textTheme.titleLarge?.color ?? Colors.black;
      }
    }

    if (isSelected) {
      borderColor = ThemeAwareColors.primary(context);
      backgroundColor = ThemeAwareColors.primary(context);
      contentColor = Colors.white;
    }

    return Tooltip(
      message: seat.isAvailable
          ? 'Seat ${seat.seatName} | ₹${seat.price.toStringAsFixed(0)}'
          : 'Booked',
      preferBelow: false,
      decoration: BoxDecoration(
        color: Colors.black87,
        borderRadius: BorderRadius.circular(8),
      ),
      textStyle: GoogleFonts.poppins(
        color: Colors.white,
        fontSize: 12,
        fontWeight: FontWeight.w500,
      ),
      child: GestureDetector(
        onTap: seat.isAvailable ? onTap : null,
        child: TweenAnimationBuilder<double>(
          duration: const Duration(milliseconds: 200),
          tween: Tween(begin: 1.0, end: isSelected ? 1.08 : 1.0),
          curve: Curves.easeOutBack,
          builder: (context, scale, child) {
            return Transform.scale(
              scale: scale,
              child: Container(
                margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 4),
                width: 60,
                height: 68,
                decoration: BoxDecoration(
                  gradient: isSelected
                      ? LinearGradient(
                          colors: [
                            ThemeAwareColors.primary(context),
                            ThemeAwareColors.primary(context).withOpacity(0.9),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        )
                      : null,
                  color: isSelected ? null : backgroundColor,
                  borderRadius: BorderRadius.circular(seat.isSleeper ? 14 : 10),
                  border: Border.all(
                    color: borderColor,
                    width: isSelected ? 2.5 : 1.5,
                  ),
                  boxShadow: [
                    if (isSelected)
                      BoxShadow(
                        color: ThemeAwareColors.primary(context).withOpacity(0.4),
                        blurRadius: 12,
                        spreadRadius: 0,
                        offset: const Offset(0, 4),
                      ),
                    BoxShadow(
                      color: Colors.black.withOpacity(isSelected ? 0.15 : 0.08),
                      blurRadius: isSelected ? 8 : 4,
                      offset: Offset(0, isSelected ? 3 : 2),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      seat.isSleeper ? Icons.bed_outlined : Icons.chair_outlined,
                      color: contentColor,
                      size: isSelected ? 24 : 22,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      seat.seatName,
                      style: GoogleFonts.poppins(
                        color: contentColor,
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.3,
                      ),
                    ),
                    if (isSelected && seat.isAvailable)
                      Padding(
                        padding: const EdgeInsets.only(top: 2),
                        child: Icon(
                          Icons.check_circle,
                          color: Colors.white,
                          size: 14,
                        ),
                      ),
                  ],
                ),
              ),
            );
          },
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
      spacing: 20.0,
      runSpacing: 10.0,
      children: [
        LegendItem(
          color: Theme.of(context).cardColor,
          borderColor: Theme.of(context).dividerColor,
          text: 'Available',
        ),
        LegendItem(
          color: ThemeAwareColors.seatBooked(context),
          borderColor: ThemeAwareColors.seatBooked(context),
          text: 'Booked',
        ),
        LegendItem(
          color: ThemeAwareColors.seatLadies(context).withOpacity(0.15),
          borderColor: ThemeAwareColors.seatLadies(context),
          text: 'Ladies',
        ),
        LegendItem(
          color: ThemeAwareColors.primary(context),
          borderColor: ThemeAwareColors.primary(context),
          text: 'Selected',
        ),
      ],
    );
  }
}

class LegendItem extends StatelessWidget {
  final Color color;
  final Color borderColor;
  final String text;

  const LegendItem({
    super.key,
    required this.color,
    required this.borderColor,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 14,
          height: 14,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(4),
            border: Border.all(color: borderColor, width: 1),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          text,
          style: AppStyles.body.copyWith(
            fontSize: 13,
            color: Theme.of(context).textTheme.bodySmall?.color,
          ),
        ),
      ],
    );
  }
}