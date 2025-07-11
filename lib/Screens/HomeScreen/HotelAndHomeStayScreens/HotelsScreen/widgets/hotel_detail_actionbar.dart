import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:seemytrip/Constants/colors.dart';
import 'package:seemytrip/Screens/Utills/common_text_widget.dart';
import 'package:seemytrip/Screens/HomeScreen/HotelAndHomeStayScreens/HotelsScreen/rooms_page.dart';

class HotelDetailActionBar extends StatelessWidget {
  final Map<String, dynamic> hotelDetail;
  final String hotelServicePrice;
  final Map<String, dynamic> hotelDetails;
  final String hotelId;
  final Map<String, dynamic> searchParams;

  const HotelDetailActionBar({
    Key? key,
    required this.hotelDetail,
    required this.hotelServicePrice,
    required this.hotelDetails,
    required this.hotelId,
    required this.searchParams,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 0,
      right: 0,
      bottom: 0,
      child: Container(
        color: Colors.black87,
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CommonTextWidget.PoppinsSemiBold(
                  text: "₹ $hotelServicePrice",
                  color: Colors.white,
                  fontSize: 16,
                ),
                CommonTextWidget.PoppinsRegular(
                  text: "+ ₹${hotelDetail['TaxesAndFees']?.toString() ?? '0'} taxes & service fees",
                  color: Colors.white,
                  fontSize: 10,
                ),
                CommonTextWidget.PoppinsRegular(
                  text: "Per Night (${hotelDetail['Guests']?.toString() ?? '2 Adults'})",
                  color: Colors.white,
                  fontSize: 10,
                ),
              ],
            ),
            MaterialButton(
              onPressed: () {
                Get.to(() => RoomsPage(
                  hotelDetails: hotelDetails,
                  hotelId: hotelId,
                  searchParams: searchParams,
                ));
              },
              height: 40,
              minWidth: 140,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(40),
              ),
              color: redCA0,
              child: CommonTextWidget.PoppinsSemiBold(
                fontSize: 16,
                text: "SELECT ROOM",
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
