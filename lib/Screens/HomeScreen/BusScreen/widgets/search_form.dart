import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:seemytrip/Constants/colors.dart';
import 'package:seemytrip/Screens/HomeScreen/BusScreen/widgets/bus_calendar_widget.dart';

class SearchForm extends StatefulWidget {
  final DateTime selectedDate;
  final Function(DateTime) onDateSelected;
  final Future<void> Function() onSearchPressed;
  final RxString departureCity;
  final RxString destinationCity;
  final Future<Map<String, dynamic>?> Function() onDepartureTap;
  final Future<Map<String, dynamic>?> Function() onDestinationTap;
  final VoidCallback onSwapPressed;
  bool isLoading;

  SearchForm({
    Key? key,
    required this.selectedDate,
    required this.onDateSelected,
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
  bool _showCalendar = false;
  late List<Map<String, dynamic>> dates;

  @override
  void initState() {
    super.initState();
    dates = List.generate(7, (index) {
      final date = DateTime.now().add(Duration(days: index));
      return {
        'date': date,
        'day': date.day.toString().padLeft(2, '0'),
        'weekday': _getWeekday(date.weekday),
      };
    });
  }

  String _getWeekday(int weekday) {
    switch (weekday) {
      case 1: return 'MON';
      case 2: return 'TUE';
      case 3: return 'WED';
      case 4: return 'THU';
      case 5: return 'FRI';
      case 6: return 'SAT';
      case 7: return 'SUN';
      default: return '';
    }
  }

  String _getMonthName(int month) {
    const months = [
      'JAN', 'FEB', 'MAR', 'APR', 'MAY', 'JUN',
      'JUL', 'AUG', 'SEP', 'OCT', 'NOV', 'DEC'
    ];
    return months[month - 1];
  }

  

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.red.withOpacity(0.07),
            spreadRadius: 1,
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
        border: Border.all(color: redCA0.withOpacity(0.12), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildLocationField(
            icon: Icons.navigation,
            label: 'Leaving from',
            value: widget.departureCity,
            onTap: widget.onDepartureTap,
          ),
          
          // Swap button
          Align(
            alignment: Alignment.centerRight,
            child: GestureDetector(
              onTap: widget.onSwapPressed,
              child: Container(
                margin: const EdgeInsets.symmetric(vertical: 8),
                child: CircleAvatar(
                  radius: 20,
                  backgroundColor: redCA0,
                  child: const Icon(
                    Icons.swap_vert,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              ),
            ),
          ),
          
          _buildLocationField(
            icon: Icons.location_on,
            label: 'Going To',
            value: widget.destinationCity,
            onTap: widget.onDestinationTap,
          ),
          
          const SizedBox(height: 20),
          _buildDateSelector(),
          const SizedBox(height: 24),
          
          // Search button
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: widget.isLoading ? null : () async {
                setState(() {
                  widget.isLoading = true;
                });
                await widget.onSearchPressed();
                setState(() {
                  widget.isLoading = false;
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: widget.isLoading ? Colors.grey[400] : redCA0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: widget.isLoading
                  ? const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
                        strokeWidth: 2.5,
                      ),
                    )
                  : const Text(
                      'SEARCH BUSES',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLocationField({
    required IconData icon,
    required String label,
    required RxString value,
    required Future<Map<String, dynamic>?> Function() onTap,
  }) {
    return Row(
      children: [
        Icon(icon, color: redCA0, size: 22),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  color: redCA0,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 4),
              GestureDetector(
                onTap: onTap,
                child: Container(
                  height: 40,
                  alignment: Alignment.centerLeft,
                  child: Obx(() => Text(
                    value.value,
                    style: TextStyle(
                      fontSize: 16,
                      color: value.value.startsWith('Enter ') || value.value.startsWith('Select')
                          ? Colors.red[200]
                          : black2E2,
                    ),
                  )),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDateSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Departure',
          style: TextStyle(
            color: redCA0,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 12),
        // Date chips
        SizedBox(
          height: 80,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: dates.length,
            itemBuilder: (context, index) {
              final date = dates[index];
              final isSelected = widget.selectedDate.day == date['date'].day &&
                  widget.selectedDate.month == date['date'].month &&
                  widget.selectedDate.year == date['date'].year;

              return GestureDetector(
                onTap: () {
                  widget.onDateSelected(date['date']);
                  setState(() => _showCalendar = false);
                },
                child: Container(
                  width: 60,
                  margin: const EdgeInsets.only(right: 12),
                  decoration: BoxDecoration(
                    color: isSelected ? redCA0 : Colors.transparent,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isSelected ? redCA0 : Colors.red[100]!,
                      width: 1.5,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        date['day'],
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: isSelected ? Colors.white : black2E2,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        date['weekday'],
                        style: TextStyle(
                          fontSize: 12,
                          color: isSelected ? Colors.white : redCA0,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        
        // Calendar toggle button
        GestureDetector(
          onTap: () {
            setState(() => _showCalendar = !_showCalendar);
          },
          child: Container(
            width: 160,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            margin: const EdgeInsets.only(top: 8),
            decoration: BoxDecoration(
              border: Border.all(color: redCA0),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '${_getMonthName(widget.selectedDate.month)} ${widget.selectedDate.year}',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: redCA0,
                  ),
                ),
                const SizedBox(width: 4),
                Icon(
                  _showCalendar ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                  size: 20,
                  color: redCA0,
                ),
              ],
            ),
          ),
        ),
        
        // Calendar widget
        if (_showCalendar)
          Padding(
            padding: const EdgeInsets.only(top: 16.0),
            child: BusCalendarWidget(
              selectedDate: widget.selectedDate,
              onDateSelected: (date) {
                widget.onDateSelected(date);
                setState(() => _showCalendar = false);
              },
            ),
          ),
      ],
    );
  }
}
