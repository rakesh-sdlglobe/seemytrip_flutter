import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:seemytrip/Constants/colors.dart';
import 'package:seemytrip/Screens/Utills/lists_widget.dart';

class ToStationSelector extends StatelessWidget {
  final String? selectedToStation;
  final VoidCallback onTap;

  const ToStationSelector({
    required this.selectedToStation,
    required this.onTap,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.grey.withOpacity(0.15),
            borderRadius: BorderRadius.circular(5),
            border: Border.all(width: 1, color: greyE2E),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 12),
            child: Row(
              children: [
                SvgPicture.asset(Lists.flightSearchList1[1]["image"]),
                SizedBox(width: 15),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "To",
                      style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 16,
                          fontWeight: FontWeight.w500),
                    ),
                    Text(
                      selectedToStation ?? "Select To Station",
                      style: TextStyle(
                        color: selectedToStation == null ? grey888 : black2E2,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
