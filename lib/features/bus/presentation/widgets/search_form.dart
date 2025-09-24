import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:table_calendar/table_calendar.dart';

// --- Modern RED Color Scheme ---
const Color kPrimaryColor = Color(0xFFD32F2F); // A strong, material red
const Color kPrimaryLightColor =
    Color(0xFFFFEBEE); // A light shade of the primary color
const Color kBackgroundColor = Color(0xFFF8F9FA);
const Color kCardColor = Colors.white;
const Color kTextPrimaryColor = Color(0xFF212529);
const Color kTextSecondaryColor = Color(0xFF6C757D);
const Color kBorderColor = Color(0xFFDEE2E6);
const Color kPrimaryDarkColor = Color(0xFFC62828);
const Color kAccentColor = Color(0xFFDD2C00);
const Color kScaffoldBackgroundColor = Color(0xFFF8F9FA);

class SearchForm extends StatefulWidget {
  // CHANGED: Now accepts a list of dates and a toggle function
  final List<DateTime> selectedDates;
  final Function(DateTime) onDateTapped;
  final Future<void> Function() onSearchPressed;
  final RxString departureCity;
  final RxString destinationCity;
  final Future<Map<String, dynamic>?> Function() onDepartureTap;
  final Future<Map<String, dynamic>?> Function() onDestinationTap;
  final VoidCallback onSwapPressed;
  final bool isLoading;

  const SearchForm({
    Key? key,
    required this.selectedDates,
    required this.onDateTapped,
    required this.onSearchPressed,
    required this.departureCity,
    required this.destinationCity,
    required this.onDepartureTap,
    required this.onDestinationTap,
    required this.onSwapPressed,
    this.isLoading = false,
  }) : super(key: key);

  @override
  _SearchFormState createState() => _SearchFormState();
}

class _SearchFormState extends State<SearchForm> {
  // The horizontal list now simply reflects the state passed into the widget
  List<Map<String, dynamic>> _generateQuickDates() => List.generate(14, (index) {
      final date = DateTime.now().add(Duration(days: index));
      return {
        'date': date,
        'day': DateFormat('d').format(date),
        'weekday': DateFormat('E').format(date).toUpperCase(),
        // Check if the date exists in the selected dates list
        'isSelected': widget.selectedDates.any((d) => isSameDay(d, date)),
      };
    });

  /// Shows a dialog with a full calendar for multi-date selection.
  void _showCalendarPicker(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        contentPadding: const EdgeInsets.all(8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          "Select Dates",
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
        ),
        content: SizedBox(
          width: 350,
          height: 420,
          // StatefulBuilder is used to update the dialog's UI without closing it
          child: StatefulBuilder(
            builder: (context, setDialogState) => TableCalendar(
                focusedDay: widget.selectedDates.isNotEmpty
                    ? widget.selectedDates.first
                    : DateTime.now(),
                firstDay: DateTime.now().subtract(const Duration(days: 30)),
                lastDay: DateTime.now().add(const Duration(days: 365)),
                headerStyle: HeaderStyle(
                  titleTextStyle:
                      GoogleFonts.poppins(fontWeight: FontWeight.bold),
                  formatButtonVisible: false,
                  titleCentered: true,
                ),
                calendarStyle: CalendarStyle(
                  selectedDecoration: const BoxDecoration(
                    color: kPrimaryColor,
                    shape: BoxShape.circle,
                  ),
                  todayDecoration: BoxDecoration(
                    color: kPrimaryColor.withOpacity(0.3),
                    shape: BoxShape.circle,
                  ),
                ),
                // This predicate determines which days are marked as selected
                selectedDayPredicate: (day) {
                  return widget.selectedDates.any((d) => isSameDay(d, day));
                },
                onDaySelected: (selectedDay, focusedDay) {
                  // The parent widget handles the logic for adding/removing dates
                  widget.onDateTapped(selectedDay);
                  // Update the dialog's state to show the change immediately
                  setDialogState(() {});
                },
              ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text("Done",
                style: GoogleFonts.poppins(
                    color: kPrimaryColor, fontWeight: FontWeight.bold)),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) => Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
      decoration: BoxDecoration(
        color: kCardColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 30,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildLocationSection(),
          const SizedBox(height: 24),
          _buildDateSection(),
          const SizedBox(height: 24),
          _buildSearchButton(),
        ],
      ),
    );

  /// Builds the combined "From" and "To" input section.
  Widget _buildLocationSection() {
    // This section remains the same as before
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: kBorderColor),
      ),
      child: Stack(
        alignment: Alignment.centerRight,
        children: [
          Column(
            children: [
              _buildCityField(
                label: 'From',
                city: widget.departureCity,
                onTap: widget.onDepartureTap,
                icon: Icons.my_location,
              ),
              const Divider(
                  height: 1, color: kBorderColor, indent: 16, endIndent: 16),
              _buildCityField(
                label: 'To',
                city: widget.destinationCity,
                onTap: widget.onDestinationTap,
                icon: Icons.location_on_outlined,
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: Material(
              color: kCardColor,
              shape: CircleBorder(side: BorderSide(color: kBorderColor)),
              child: InkWell(
                onTap: widget.onSwapPressed,
                borderRadius: BorderRadius.circular(20),
                child: const SizedBox(
                  width: 40,
                  height: 40,
                  child: Icon(
                    Icons.swap_vert_rounded,
                    color: kPrimaryColor,
                    size: 24,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// A reusable widget for a single city input field.
  Widget _buildCityField({
    required String label,
    required RxString city,
    required Future<void> Function() onTap,
    required IconData icon,
  }) {
    // This section remains the same as before
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(icon, color: kPrimaryColor, size: 22),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: kTextSecondaryColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Obx(
                    () => Text(
                      city.value.isEmpty ? 'Select City' : city.value,
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: city.value.isEmpty
                            ? kTextSecondaryColor.withOpacity(0.7)
                            : kTextPrimaryColor,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Builds the date selection section with a summary, calendar button, and quick-pick list.
  Widget _buildDateSection() {
    final quickDates = _generateQuickDates();
    widget.selectedDates.sort();
    final formattedDates = widget.selectedDates
        .map((date) => DateFormat('MMM d').format(date))
        .join(', ');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Dates of Journey',
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: kTextPrimaryColor,
              ),
            ),
            IconButton(
              icon: const Icon(Icons.calendar_month_outlined,
                  color: kPrimaryColor),
              onPressed: () => _showCalendarPicker(context),
            )
          ],
        ),
        // Display for selected dates
        Padding(
          padding: const EdgeInsets.only(left: 4.0, right: 4.0, bottom: 12.0),
          child: Text(
            widget.selectedDates.isEmpty
                ? 'Select one or more dates'
                : formattedDates,
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: widget.selectedDates.isEmpty
                  ? kTextSecondaryColor
                  : kPrimaryColor,
              fontWeight: FontWeight.w500,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        // Horizontal quick-pick list
        SizedBox(
          height: 75,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: quickDates.length,
            itemBuilder: (context, index) {
              final dateInfo = quickDates[index];
              final isSelected = dateInfo['isSelected'] as bool;
              return GestureDetector(
                onTap: () => widget.onDateTapped(dateInfo['date'] as DateTime),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                  width: 60,
                  margin: const EdgeInsets.only(right: 12),
                  decoration: BoxDecoration(
                    color: isSelected ? kPrimaryColor : kPrimaryLightColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        dateInfo['weekday'] as String,
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: isSelected ? Colors.white : kPrimaryColor,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        dateInfo['day'] as String,
                        style: GoogleFonts.poppins(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: isSelected ? Colors.white : kPrimaryColor,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  /// Builds the gradient search button.
  Widget _buildSearchButton() => SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: widget.isLoading
            ? null
            : () async {
                // MODIFIED: Check if cities or dates are empty
                if (widget.departureCity.value.isEmpty ||
                    widget.destinationCity.value.isEmpty ||
                    widget.selectedDates.isEmpty) {
                  Get.snackbar(
                    'Missing Information',
                    'Please select cities and at least one date.',
                    snackPosition: SnackPosition.BOTTOM,
                    backgroundColor: Colors.amber[800],
                    colorText: Colors.white,
                    margin: const EdgeInsets.all(12),
                    borderRadius: 12,
                  );
                  return;
                }
                await widget.onSearchPressed();
              },
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.all(0),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          elevation: 8,
          shadowColor: kPrimaryColor.withOpacity(0.4),
        ),
        child: Ink(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: const LinearGradient(
              colors: [Color(0xFFE53935), Color(0xFFC62828)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 18),
            alignment: Alignment.center,
            child: widget.isLoading
                ? SizedBox(
                    child: LoadingAnimationWidget.fourRotatingDots(
                      color: Colors.white,
                      size: 40,
                    ),
                  )
                : Text(
                    'Search Buses',
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                      letterSpacing: 0.5,
                    ),
                  ),
          ),
        ),
      ),
    );
}
