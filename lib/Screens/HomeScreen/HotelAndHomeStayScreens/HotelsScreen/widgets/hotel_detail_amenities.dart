import 'package:flutter/material.dart';
import 'package:seemytrip/Constants/colors.dart';
import 'package:seemytrip/Screens/Utills/common_text_widget.dart';

class HotelDetailAmenities extends StatelessWidget {
  final Map<String, dynamic> hotelDetail;

  const HotelDetailAmenities({Key? key, required this.hotelDetail}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
        hotelDetail['Amenities'] != null &&
                hotelDetail['Amenities'] is List &&
                (hotelDetail['Amenities'] as List).isNotEmpty
            ? Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: greyE8E),
                ),
                child: GridView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: (hotelDetail['Amenities'] as List).length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 4.5,
                    mainAxisSpacing: 8,
                    crossAxisSpacing: 8,
                  ),
                  itemBuilder: (context, i) {
                    final amen = hotelDetail['Amenities'][i];
                    final String description = amen is Map && amen.containsKey('Description')
                        ? amen['Description'].toString()
                        : amen.toString();
                    final icon = _getAmenityIcon(description);
                    return Row(
                      children: [
                        Icon(icon, color: redCA0, size: 20),
                        SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            description,
                            style: TextStyle(fontSize: 13, color: black2E2),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    );
                  },
                ),
              )
            : Padding(
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
