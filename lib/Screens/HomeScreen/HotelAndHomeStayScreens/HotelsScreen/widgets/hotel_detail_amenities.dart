import 'package:flutter/material.dart';
import 'package:seemytrip/Constants/colors.dart';
import 'package:seemytrip/Screens/Utills/common_text_widget.dart';

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
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.check_circle_outline, color: redCA0, size: 20),
            SizedBox(width: 8),
            CommonTextWidget.PoppinsMedium(
              text: "Amenities & Facilities",
              color: black2E2,
              fontSize: 17,
            ),
          ],
        ),
        SizedBox(height: 10),
        
        if (amenities.isNotEmpty)
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: greyE8E),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  spreadRadius: 1,
                  blurRadius: 3,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              children: [
                GridView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: _isExpanded ? amenities.length : _initialAmenitiesCount,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
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
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: greyE8E.withOpacity(0.3)),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Row(
                          children: [
                            Icon(icon, color: redCA0, size: 20),
                            SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                description,
                                style: TextStyle(
                                  fontSize: 13,
                                  color: black2E2,
                                  fontWeight: FontWeight.w500,
                                ),
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
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          _isExpanded = !_isExpanded;
                        });
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            _isExpanded ? 'Show Less' : 'Show More',
                            style: TextStyle(
                              color: redCA0,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Icon(
                            _isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                            color: redCA0,
                            size: 20,
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          )
        else
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Text(
              "No amenities listed.",
              style: TextStyle(
                color: grey717,
                fontSize: 14,
              ),
            ),
          ),
      ],
    );
  }
}
