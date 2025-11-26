import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class FlightFilterSortWidget extends StatelessWidget {
  const FlightFilterSortWidget({
    required this.onSortChanged,
    required this.onFilterChanged,
    Key? key,
  }) : super(key: key);
  final Function(String) onSortChanged;
  final Function(Map<String, dynamic>) onFilterChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).shadowColor.withOpacity(0.03),
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
  }

  Widget _buildSortButton(BuildContext context) => PopupMenuButton<String>(
        onSelected: (value) {
          onSortChanged(value);
        },
        itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
          PopupMenuItem<String>(
            value: 'price_low_to_high',
            child: Text(
              'Price: Low to High',
              style: _getTextStyle(context),
            ),
          ),
          PopupMenuItem<String>(
            value: 'price_high_to_low',
            child: Text(
              'Price: High to Low',
              style: _getTextStyle(context),
            ),
          ),
          PopupMenuItem<String>(
            value: 'duration_short_to_long',
            child: Text(
              'Duration: Shortest First',
              style: _getTextStyle(context),
            ),
          ),
          PopupMenuItem<String>(
            value: 'departure_earliest',
            child: Text(
              'Departure: Earliest First',
              style: _getTextStyle(context),
            ),
          ),
        ],
        child: _buildButton(context, 'Sort'),
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
          PopupMenuItem<String>(
            value: 'non_stop',
            child: Text(
              'Non-stop Flights',
              style: _getTextStyle(context),
            ),
          ),
          PopupMenuItem<String>(
            value: 'one_stop',
            child: Text(
              '1 Stop',
              style: _getTextStyle(context),
            ),
          ),
          PopupMenuItem<String>(
            value: 'two_plus_stops',
            child: Text(
              '2+ Stops',
              style: _getTextStyle(context),
            ),
          ),
          const PopupMenuDivider(),
          PopupMenuItem<String>(
            value: 'airline_indigo',
            child: Text(
              'IndiGo',
              style: _getTextStyle(context),
            ),
          ),
          PopupMenuItem<String>(
            value: 'airline_air_india',
            child: Text(
              'Air India',
              style: _getTextStyle(context),
            ),
          ),
          PopupMenuItem<String>(
            value: 'airline_vistara',
            child: Text(
              'Vistara',
              style: _getTextStyle(context),
            ),
          ),
        ],
        child: _buildButton(context, 'Filter'),
      );

  Widget _buildButton(BuildContext context, String label) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: Theme.of(context).hintColor,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              _getIcon(label),
              size: 16,
              color: Theme.of(context).hintColor,
            ),
            const SizedBox(width: 4),
            Text(
              label,
              style: _getTextStyle(context),
            ),
            const Icon(Icons.arrow_drop_down, size: 20, color: Colors.blue),
          ],
        ),
      );

  IconData _getIcon(String label) {
    switch (label) {
      case 'Sort':
        return Icons.sort;
      case 'Filter':
        return Icons.filter_alt_outlined;
      default:
        return Icons.sort;
    }
  }

  TextStyle _getTextStyle(BuildContext context) => GoogleFonts.poppins(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: Theme.of(context).hintColor,
      );
}
