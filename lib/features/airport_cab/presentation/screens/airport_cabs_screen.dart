import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import '../../../../core/utils/colors.dart';
import '../../../../shared/constants/images.dart';
import '../../../../core/widgets/common_text_widget.dart';
import '../../../../core/widgets/lists_widget.dart';

class AirportCabsScreen extends StatelessWidget {
  AirportCabsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
      appBar: AppBar(
        backgroundColor: redCA0,
        automaticallyImplyLeading: false,
        elevation: 0,
        centerTitle: true,
        leading: InkWell(
          onTap: () {
            Get.back();
          },
          child: Icon(Icons.arrow_back, color: white, size: 20),
        ),
        title: CommonTextWidget.PoppinsSemiBold(
          text: "Airport cabs",
          color: white,
          fontSize: 18,
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          children: [
            SizedBox(height: 20),
            Image.asset(airportCab),
            SizedBox(height: 25),
            ListView.builder(
              padding: EdgeInsets.zero,
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: Lists.airportTabList.length,
              itemBuilder: (context, index) => ListTile(
                contentPadding: EdgeInsets.zero,
                horizontalTitleGap: -5,
                leading: SvgPicture.asset(
                  Lists.airportTabList[index]["image"],
                ),
                title: CommonTextWidget.PoppinsMedium(
                  text: Lists.airportTabList[index]["text1"],
                  color: grey717,
                  fontSize: 14,
                ),
                subtitle: CommonTextWidget.PoppinsRegular(
                  text: Lists.airportTabList[index]["text2"],
                  color: index == 1 ? black2E2 : redCA0,
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
