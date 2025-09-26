import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/widgets/common_button_widget.dart';
import '../../../../../core/widgets/common_text_widget.dart';
import '../../../../../shared/constants/images.dart';

class CancelledTripScreen extends StatelessWidget {
  CancelledTripScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Column(
      children: [
        SizedBox(height: 40),
        SvgPicture.asset(cancelledTripImage),
        SizedBox(height: 30),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 42),
          child: CommonTextWidget.PoppinsSemiBold(
            text: 'All updates regarding your '
                'cancellation requests are displayed '
                'here!',
            color: AppColors.black2E2,
            fontSize: 18,
            textAlign: TextAlign.center,
          ),
        ),
        SizedBox(height: 30),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 70),
          child: CommonButtonWidget.button(
            onTap: () {},
            buttonColor: AppColors.redCA0,
            text: 'Start Booking Now',
          ),
        ),
      ],
    );
}
