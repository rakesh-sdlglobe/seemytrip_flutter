import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:seemytrip/core/theme/app_colors.dart';
import 'package:seemytrip/core/widgets/lists_widget.dart';

class FromStationSelector extends StatelessWidget {
  final String? selectedFromStation;
  final VoidCallback onTap;

  const FromStationSelector({
    required this.selectedFromStation,
    required this.onTap,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Padding(
      padding: EdgeInsets.symmetric(horizontal: 24),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: AppColors.greyE2E.withOpacity(0.15),
            borderRadius: BorderRadius.circular(5),
            border: Border.all(width: 1, color: AppColors.greyE2E),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 12),
            child: Row(
              children: [
                SizedBox(
                  width: 24,
                  height: 24,
                  child: SvgPicture.asset(
                    Lists.flightSearchList1[0]['image'],
                    fit: BoxFit.contain,
                  ),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'From',
                        style: TextStyle(
                          color: AppColors.grey717,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        selectedFromStation ?? 'Select From Station',
                        style: TextStyle(
                          color: selectedFromStation == null ? AppColors.grey888 : AppColors.black2E2,
                          fontSize: 16,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
}
