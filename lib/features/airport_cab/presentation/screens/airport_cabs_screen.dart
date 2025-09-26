import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/common_text_widget.dart';
import '../../../../core/widgets/lists_widget.dart';
import '../../../../shared/constants/images.dart';

class AirportCabsScreen extends StatelessWidget {
  AirportCabsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.redCA0,
        automaticallyImplyLeading: false,
        elevation: 0,
        centerTitle: true,
        leading: InkWell(
          onTap: () {
            Get.back();
          },
          child: Icon(Icons.arrow_back, color: AppColors.white, size: 20),
        ),
        title: CommonTextWidget.PoppinsSemiBold(
          text: 'Airport cabs',
          color: AppColors.white,
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
                  Lists.airportTabList[index]['image'],
                ),
                title: CommonTextWidget.PoppinsMedium(
                  text: Lists.airportTabList[index]['text1'],
                  color: AppColors.grey717,
                  fontSize: 14,
                ),
                subtitle: CommonTextWidget.PoppinsRegular(
                  text: Lists.airportTabList[index]['text2'],
                  color: index == 1 ? AppColors.black2E2 : AppColors.redCA0,
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),
      ),
    );
}
