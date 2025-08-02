import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:seemytrip/core/utils/colors.dart';
import 'package:seemytrip/shared/constants/images.dart';
import 'package:seemytrip/core/widgets/common_text_widget.dart';
import 'package:seemytrip/core/widgets/lists_widget.dart';
import 'package:seemytrip/features/home/presentation/screens/where_to_go/international_detail_screen2.dart';
import 'package:seemytrip/main.dart';

class InterNationalDetailScreen1 extends StatelessWidget {
  InterNationalDetailScreen1({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
      body: ScrollConfiguration(
        behavior: MyBehavior(),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 220,
                width: Get.width,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(internationalDetail1Image1),
                    fit: BoxFit.fill,
                  ),
                ),
                child: Padding(
                  padding: EdgeInsets.only(left: 24, right: 24, top: 55),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      InkWell(
                        onTap: () {
                          Get.back();
                        },
                        child: SvgPicture.asset(internationalDetailBackImage),
                      ),
                      CommonTextWidget.PoppinsMedium(
                        text: "Bali",
                        color: white,
                        fontSize: 18,
                      ),
                      SvgPicture.asset(internationalDetailSearchImage),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 10),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 24),
                child: CommonTextWidget.PoppinsSemiBold(
                  text: "Things To See & Do",
                  color: black2E2,
                  fontSize: 16,
                ),
              ),
              GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 0,
                  crossAxisSpacing: 15,
                  childAspectRatio:
                      MediaQuery.of(context).size.aspectRatio * 2 / 1.6,
                ),
                shrinkWrap: true,
                primary: false,
                physics: NeverScrollableScrollPhysics(),
                padding: EdgeInsets.only(left: 24, right: 24),
                itemCount: Lists.internationalDetail1List.length,
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () {
                      Get.to(InterNationalDetailScreen2());
                    },
                    child: Image.asset(Lists.internationalDetail1List[index]),
                  );
                },
              ),
              Image.asset(internationalDetail1Image6,
                  width: Get.width, height: 324),
            ],
          ),
        ),
      ),
    );
  }
}
