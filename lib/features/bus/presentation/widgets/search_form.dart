import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:table_calendar/table_calendar.dart';

// Theme-aware color functions
Color kPrimaryColor(BuildContext context) => Theme.of(context).brightness == Brightness.dark
  ? const Color(0xFFFF5722) // Orange-red for dark theme
  : const Color(0xFFCA0B0B); // Red for light theme

Color kCardColor(BuildContext context) => Theme.of(context).cardColor;
Color kTextPrimaryColor(BuildContext context) => Theme.of(context).textTheme.titleLarge?.color ?? Colors.black;
Color kTextSecondaryColor(BuildContext context) => Theme.of(context).textTheme.bodySmall?.color ?? Colors.grey;
Color kBorderColor(BuildContext context) => Theme.of(context).dividerColor;

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
                  selectedDecoration: BoxDecoration(
                    color: kPrimaryColor(context),
                    shape: BoxShape.circle,
                  ),
                  todayDecoration: BoxDecoration(
                    color: kPrimaryColor(context).withOpacity(0.3),
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
                    color: kPrimaryColor(context), fontWeight: FontWeight.bold)),
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
        color: kCardColor(context),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).shadowColor.withOpacity(0.08),
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
        border: Border.all(color: kBorderColor(context)),
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
              Divider(
                  height: 1, color: kBorderColor(context), indent: 16, endIndent: 16),
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
              color: kCardColor(context),
              shape: CircleBorder(side: BorderSide(color: kBorderColor(context))),
              child: InkWell(
                onTap: widget.onSwapPressed,
                borderRadius: BorderRadius.circular(20),
                child: SizedBox(
                  width: 40,
                  height: 40,
                  child: Icon(
                    Icons.swap_vert_rounded,
                    color: kPrimaryColor(context),
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
            Icon(icon, color: kPrimaryColor(context), size: 22),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: kTextSecondaryColor(context),
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
                            ? kTextSecondaryColor(context).withOpacity(0.7)
                            : kTextPrimaryColor(context),
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
                color: kTextPrimaryColor(context),
              ),
            ),
            IconButton(
              icon: Icon(Icons.calendar_month_outlined,
                  color: kPrimaryColor(context)),
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
                  ? kTextSecondaryColor(context)
                  : kPrimaryColor(context),
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
                    color: isSelected 
                      ? kPrimaryColor(context) 
                      : (Theme.of(context).brightness == Brightness.dark
                          ? kPrimaryColor(context).withOpacity(0.2)
                          : kPrimaryColor(context).withOpacity(0.1)),
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
                          color: isSelected ? Colors.white : kPrimaryColor(context),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        dateInfo['day'] as String,
                        style: GoogleFonts.poppins(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: isSelected ? Colors.white : kPrimaryColor(context),
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
          shadowColor: kPrimaryColor(context).withOpacity(0.4),
        ),
        child: Ink(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              colors: [
                Theme.of(context).brightness == Brightness.dark
                  ? const Color(0xFFFF5722) // Orange-red for dark theme
                  : const Color(0xFFE53935), // Red for light theme
                Theme.of(context).brightness == Brightness.dark
                  ? const Color(0xFFE64A19) // Darker orange-red for dark theme
                  : const Color(0xFFC62828), // Darker red for light theme
              ],
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
