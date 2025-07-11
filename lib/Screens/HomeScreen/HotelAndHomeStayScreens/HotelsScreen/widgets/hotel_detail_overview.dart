import 'package:flutter/material.dart';
import 'package:seemytrip/Constants/colors.dart';
import 'package:seemytrip/Screens/Utills/common_text_widget.dart';

class HotelDetailOverview extends StatelessWidget {
  final Map<String, dynamic> hotelDetail;

  const HotelDetailOverview({Key? key, required this.hotelDetail}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.info_outline, color: redCA0, size: 20),
            SizedBox(width: 8),
            CommonTextWidget.PoppinsMedium(
              text: "Overview",
              color: black2E2,
              fontSize: 17,
            ),
          ],
        ),
        SizedBox(height: 8),
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: greyE8E.withOpacity(0.5),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            hotelDetail['description']?.toString() ?? "No overview available.",
            style: TextStyle(
              color: grey717,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}
