import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:seemytrip/Constants/colors.dart';
import 'package:seemytrip/Constants/images.dart';
import 'package:seemytrip/Screens/HomeScreen/TrainAndBusScreen/train_and_bus_search_screen.dart';
import 'package:seemytrip/Screens/Utills/common_text_widget.dart';
import 'package:seemytrip/Screens/Utills/lists_widget.dart';
import 'package:seemytrip/main.dart';

class TrainAndBusScreen extends StatelessWidget {
  TrainAndBusScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 100,
            width: Get.width,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(busAndTrainImage),
                fit: BoxFit.fill,
              ),
            ),
            child: Padding(
              padding: EdgeInsets.only(left: 24, right: 24, top: 50),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: () {
                      Get.back();
                    },
                    child: Icon(Icons.arrow_back, color: white, size: 20),
                  ),
                  CommonTextWidget.PoppinsSemiBold(
                    text: "Train & Bus",
                    color: white,
                    fontSize: 18,
                  ),
                  Container(),
                ],
              ),
            ),
          ),
          SizedBox(height: 20),
          ListView.builder(
            padding: EdgeInsets.symmetric(horizontal: 24),
            itemCount: Lists.bookBusAndTrainList.length,
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) => Padding(
              padding: EdgeInsets.only(bottom: 15),
              child: InkWell(
                onTap: () {
                  Get.to(() => TrainAndBusSearchScreen());
                },
                child: Container(
                  width: Get.width,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    color: white,
                    boxShadow: [
                      BoxShadow(
                        color: grey515.withOpacity(0.25),
                        blurRadius: 6,
                        offset: Offset(0, 1),
                      ),
                    ],
                  ),
                  child: ListTile(
                    horizontalTitleGap: -4,
                    leading: SvgPicture.asset(
                      Lists.bookBusAndTrainList[index]["image"],
                    ),
                    title: CommonTextWidget.PoppinsMedium(
                      text: Lists.bookBusAndTrainList[index]["text"],
                      color: black2E2,
                      fontSize: 16,
                    ),
                    trailing: Icon(Icons.arrow_forward, color: redCA0),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: 20),
          Divider(color: greyE8E, thickness: 1),
          SizedBox(height: 20),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 24),
            child: CommonTextWidget.PoppinsMedium(
              color: black2E2,
              text: "Train information Services",
              fontSize: 16,
            ),
          ),
          Expanded(
            child: ScrollConfiguration(
              behavior: MyBehavior(),
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 15,
                  crossAxisSpacing: 15,
                  childAspectRatio:
                      MediaQuery.of(context).size.aspectRatio * 2 / 0.4,
                ),
                shrinkWrap: true,
                primary: false,
                padding:
                    EdgeInsets.only(left: 24, right: 24, top: 15, bottom: 15),
                itemCount: Lists.trainAndBusInformationServiceList.length,
                itemBuilder: (context, index) {
                  return Container(
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: grey515.withOpacity(0.25),
                          offset: Offset(0, 1),
                          blurRadius: 6,
                        ),
                      ],
                      color: white,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 15),
                      child: Center(
                        child: CommonTextWidget.PoppinsMedium(
                          color: black2E2,
                          text: Lists.trainAndBusInformationServiceList[index],
                          fontSize: 14,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
