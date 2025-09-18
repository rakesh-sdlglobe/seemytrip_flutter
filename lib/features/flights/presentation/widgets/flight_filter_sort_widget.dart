import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class FlightFilterSortWidget extends StatelessWidget {
  
  const FlightFilterSortWidget({
    required this.onSortChanged, required this.onFilterChanged, Key? key,
  }) : super(key: key);
  final Function(String) onSortChanged;
  final Function(Map<String, dynamic>) onFilterChanged;

  @override
  Widget build(BuildContext context) => Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Sort Button
          _buildSortButton(context),
          const SizedBox(width: 8),
          // Filter Button
          _buildFilterButton(context),
        ],
      ),
    );

  Widget _buildSortButton(BuildContext context) => PopupMenuButton<String>(
      onSelected: (value) {
        onSortChanged(value);
      },
      itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
        const PopupMenuItem<String>(
          value: 'price_low_to_high',
          child: Text('Price: Low to High'),
        ),
        const PopupMenuItem<String>(
          value: 'price_high_to_low',
          child: Text('Price: High to Low'),
        ),
        const PopupMenuItem<String>(
          value: 'duration_short_to_long',
          child: Text('Duration: Shortest First'),
        ),
        const PopupMenuItem<String>(
          value: 'departure_earliest',
          child: Text('Departure: Earliest First'),
        ),
      ],
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.grey[300]!),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.sort, size: 16, color: Colors.blue),
            const SizedBox(width: 4),
            Text(
              'Sort',
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            const Icon(Icons.arrow_drop_down, size: 20, color: Colors.blue),
          ],
        ),
      ),
    );

  Widget _buildFilterButton(BuildContext context) => PopupMenuButton<String>(
      onSelected: (value) {
        // Handle filter selection
        Map<String, dynamic> filters = {};
        
        if (value == 'non_stop') {
          filters['stops'] = 0;
        } else if (value == 'one_stop') {
          filters['stops'] = 1;
        } else if (value == 'two_plus_stops') {
          filters['stops'] = 2; // 2 or more
        } else if (value.startsWith('airline_')) {
          filters['airline'] = value.replaceAll('airline_', '');
        }
        
        onFilterChanged(filters);
      },
      itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
        const PopupMenuItem<String>(
          value: 'non_stop',
          child: Text('Non-stop Flights'),
        ),
        const PopupMenuItem<String>(
          value: 'one_stop',
          child: Text('1 Stop'),
        ),
        const PopupMenuItem<String>(
          value: 'two_plus_stops',
          child: Text('2+ Stops'),
        ),
        const PopupMenuDivider(),
        const PopupMenuItem<String>(
          value: 'airline_indigo',
          child: Text('IndiGo'),
        ),
        const PopupMenuItem<String>(
          value: 'airline_air_india',
          child: Text('Air India'),
        ),
        const PopupMenuItem<String>(
          value: 'airline_vistara',
          child: Text('Vistara'),
        ),
      ],
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.grey[300]!),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.filter_alt_outlined, size: 16, color: Colors.blue),
            const SizedBox(width: 4),
            Text(
              'Filter',
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            const Icon(Icons.arrow_drop_down, size: 20, color: Colors.blue),
          ],
        ),
      ),
    );
}
