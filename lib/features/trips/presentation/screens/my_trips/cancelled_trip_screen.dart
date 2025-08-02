import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:seemytrip/core/utils/colors.dart';
import 'package:seemytrip/shared/constants/images.dart';
import 'package:seemytrip/core/widgets/common_button_widget.dart';
import 'package:seemytrip/core/widgets/common_text_widget.dart';

class CancelledTripScreen extends StatelessWidget {
  CancelledTripScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 40),
        SvgPicture.asset(cancelledTripImage),
        SizedBox(height: 30),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 42),
          child: CommonTextWidget.PoppinsSemiBold(
            text: "All updates regarding your "
                "cancellation requests are displayed "
                "here!",
            color: black2E2,
            fontSize: 18,
            textAlign: TextAlign.center,
          ),
        ),
        SizedBox(height: 30),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 70),
          child: CommonButtonWidget.button(
            onTap: () {},
            buttonColor: redCA0,
            text: "Start Booking Now",
          ),
        ),
      ],
    );
  }
}
