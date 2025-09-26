import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../../core/widgets/lists_widget.dart';
import 'package:seemytrip/core/theme/app_colors.dart';

class ToStationSelector extends StatelessWidget {
  final String? selectedToStation;
  final VoidCallback onTap;

  const ToStationSelector({
    required this.selectedToStation,
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
            color: AppColors.grey9B9.withOpacity(0.15),
            borderRadius: BorderRadius.circular(5),
            border: Border.all(width: 1, color: AppColors.greyE2E),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 12),
            child: Row(
              children: [
                SvgPicture.asset(
                  Lists.flightSearchList1[1]['image'],
                  width: 24,
                  height: 24,
                  fit: BoxFit.contain,
                ),
                SizedBox(width: 15),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'To',
                        style: TextStyle(
                          color: AppColors.grey888,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        selectedToStation ?? 'Select To Station',
                        style: TextStyle(
                          color: selectedToStation == null ? AppColors.grey888 : AppColors.black2E2,
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
