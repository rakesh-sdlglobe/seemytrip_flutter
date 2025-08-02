import 'package:flutter/material.dart';
import 'package:seemytrip/core/utils/colors.dart';
import 'package:google_fonts/google_fonts.dart';

class HotelDetailAmenities extends StatefulWidget {
  final Map<String, dynamic> hotelDetail;

  const HotelDetailAmenities({Key? key, required this.hotelDetail}) : super(key: key);

  @override
  _HotelDetailAmenitiesState createState() => _HotelDetailAmenitiesState();
}

class _HotelDetailAmenitiesState extends State<HotelDetailAmenities> {
  bool _isExpanded = false;
  final int _initialAmenitiesCount = 4;

  IconData _getAmenityIcon(String description) {
    switch (description.toLowerCase()) {
      case 'wifi':
      case 'free wifi':
        return Icons.wifi;
      case 'parking':
      case 'free parking':
        return Icons.local_parking;
      case 'pool':
      case 'swimming pool':
        return Icons.pool;
      case 'restaurant':
        return Icons.restaurant;
      case 'bar':
        return Icons.local_bar;
      case 'spa':
        return Icons.spa;
      case 'gym':
      case 'fitness center':
        return Icons.fitness_center;
      case 'air conditioning':
      case 'ac':
        return Icons.ac_unit;
      case 'laundry':
        return Icons.local_laundry_service;
      case 'pet friendly':
        return Icons.pets;
      case 'room service':
        return Icons.room_service;
      case 'tv':
      case 'television':
        return Icons.tv;
      case 'coffee/tea maker':
        return Icons.coffee;
      case 'elevator':
        return Icons.elevator;
      case 'safe':
        return Icons.lock;
      case 'bathtub':
        return Icons.bathtub;
      case 'balcony':
        return Icons.balcony;
      case 'non-smoking':
        return Icons.smoke_free;
      case 'breakfast':
        return Icons.free_breakfast;
      default:
        return Icons.check_circle_outline;
    }
  }

  @override
  Widget build(BuildContext context) {
    final amenities = widget.hotelDetail['Amenities'] as List<dynamic>? ?? [];
    
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with icon
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: Colors.orange.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.emoji_food_beverage_outlined,
                    size: 20,
                    color: Colors.orange,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  'Amenities',
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 16),
            
            if (amenities.isNotEmpty)
              Column(
                children: [
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _isExpanded ? amenities.length : _initialAmenitiesCount,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 4.5,
                      mainAxisSpacing: 8,
                      crossAxisSpacing: 8,
                    ),
                    itemBuilder: (context, i) {
                      final amen = amenities[i];
                      final String description = amen is Map && amen.containsKey('Description')
                          ? amen['Description'].toString()
                          : amen.toString();
                      final icon = _getAmenityIcon(description);
                      
                      return Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[50],
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.grey[200]!),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8),
                          child: Row(
                            children: [
                              Icon(icon, color: redCA0, size: 18),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  description,
                                  style: GoogleFonts.poppins(
                                    fontSize: 13,
                                    color: Colors.grey[800],
                                    fontWeight: FontWeight.w500,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                  if (amenities.length > _initialAmenitiesCount)
                    Padding(
                      padding: const EdgeInsets.only(top: 12.0),
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            _isExpanded = !_isExpanded;
                          });
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              _isExpanded ? 'Show Less' : 'Show More',
                              style: GoogleFonts.poppins(
                                color: redCA0,
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Icon(
                              _isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                              color: redCA0,
                              size: 18,
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              )
            else
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(
                  'No amenities listed.',
                  style: GoogleFonts.poppins(
                    color: Colors.grey[600],
                    fontSize: 14,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
