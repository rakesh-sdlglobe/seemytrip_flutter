import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:seemytrip/Constants/colors.dart';

class BusCalendarWidget extends StatefulWidget {
  final DateTime? selectedDate;
  final Function(DateTime) onDateSelected;
  final DateTime? firstDay;
  final DateTime? lastDay;

  const BusCalendarWidget({
    Key? key,
    this.selectedDate,
    required this.onDateSelected,
    this.firstDay,
    this.lastDay,
  }) : super(key: key);

  @override
  _BusCalendarWidgetState createState() => _BusCalendarWidgetState();
}

class _BusCalendarWidgetState extends State<BusCalendarWidget> {
  late DateTime _focusedDay;
  late DateTime _selectedDay;
  late DateTime _firstDay;
  late DateTime _lastDay;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _focusedDay = widget.selectedDate ?? now;
    _selectedDay = widget.selectedDate ?? now;
    _firstDay = widget.firstDay ?? now;
    _lastDay = widget.lastDay ?? now.add(const Duration(days: 365));
  }

  @override
  void didUpdateWidget(BusCalendarWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.selectedDate != null && 
        !isSameDay(_selectedDay, widget.selectedDate!)) {
      setState(() {
        _selectedDay = widget.selectedDate!;
        _focusedDay = widget.selectedDate!;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Ensure we have valid dates
    final firstDay = _firstDay;
    final lastDay = _lastDay;
    final focusedDay = _focusedDay;
    final selectedDay = _selectedDay;

    if (firstDay.isAfter(lastDay)) {
      return const Center(child: Text('Invalid date range'));
    }

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      child: TableCalendar(
        firstDay: firstDay,
        lastDay: lastDay,
        focusedDay: focusedDay,
        selectedDayPredicate: (day) => isSameDay(selectedDay, day),
        onDaySelected: (newSelectedDay, newFocusedDay) {
          if (!isSameDay(selectedDay, newSelectedDay)) {
            setState(() {
              _selectedDay = newSelectedDay;
              _focusedDay = newFocusedDay;
            });
            widget.onDateSelected(newSelectedDay);
          }
        },
        onPageChanged: (focusedDay) {
          _focusedDay = focusedDay;
        },
        calendarFormat: CalendarFormat.month,
        calendarStyle: CalendarStyle(
          todayDecoration: BoxDecoration(
            color: redCA0.withOpacity(0.3),
            shape: BoxShape.circle,
          ),
          selectedDecoration: BoxDecoration(
            color: redCA0,
            shape: BoxShape.circle,
          ),
          todayTextStyle: const TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
          ),
          selectedTextStyle: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
          weekendTextStyle: const TextStyle(
            color: Colors.black87,
          ),
          defaultTextStyle: const TextStyle(
            color: Colors.black87,
          ),
          outsideDaysVisible: false,
        ),
        headerStyle: HeaderStyle(
          formatButtonVisible: false,
          titleCentered: true,
          titleTextStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
          leftChevronIcon: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.chevron_left, size: 20, color: Colors.black87),
          ),
          rightChevronIcon: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.chevron_right, size: 20, color: Colors.black87),
          ),
        ),
        daysOfWeekStyle: const DaysOfWeekStyle(
          weekdayStyle: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.w500,
          ),
          weekendStyle: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
