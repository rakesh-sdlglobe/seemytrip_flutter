import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:seemytrip/Constants/colors.dart';
import 'package:seemytrip/Controller/trainfromSearchController.dart';
import 'package:seemytrip/Screens/Utills/common_text_widget.dart';

class TrainAndBusFromScreen extends StatelessWidget {
  final TrainFromSearchController controller =
      Get.put(TrainFromSearchController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 60),
            Container(
              width: Get.width,
              decoration: BoxDecoration(
                color: redF8E,
                borderRadius: BorderRadius.circular(5),
                border: Border.all(color: greyE8E, width: 1),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 8, horizontal: 18),
                child: Row(
                  children: [
                    InkWell(
                      onTap: () {
                        Get.back();
                      },
                      child: Icon(Icons.arrow_back, color: black2E2, size: 20),
                    ),
                    SizedBox(width: 15),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CommonTextWidget.PoppinsMedium(
                          text: "From",
                          color: redCA0,
                          fontSize: 14,
                        ),
                        SizedBox(height: 5),
                        Obx(() => controller.isEditingFrom.value
                            ? SizedBox(
                                width: 200,
                                child: TextField(
                                  controller: controller.fromController,
                                  autofocus: true,
                                  decoration: InputDecoration(
                                    hintText: "Enter any City/Station Name",
                                    border: InputBorder.none,
                                  ),
                                  onSubmitted: (value) {
                                    controller.isEditingFrom.value = false;
                                  },
                                ),
                              )
                            : InkWell(
                                onTap: () {
                                  controller.isEditingFrom.value = true;
                                },
                                child: CommonTextWidget.PoppinsMedium(
                                  text: controller.fromController.text.isEmpty
                                      ? "Enter any City/Station Name"
                                      : controller.fromController.text,
                                  color: grey717,
                                  fontSize: 14,
                                ),
                              )),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
            CommonTextWidget.PoppinsMedium(
              text: "Popular Searches",
              color: grey717,
              fontSize: 12,
            ),
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                          redCA0), // Change to your desired color
                      strokeWidth:
                          3.0, // Change the thickness of the progress indicator

                    ),
                  );
                } else if (controller.hasError.value) {
                  return Center(child: Text("Error fetching stations."));
                } else if (controller.filteredStations.isEmpty) {
                  return Center(child: Text("No stations found"));
                } else {
                  return ListView.builder(
                    padding: EdgeInsets.zero,
                    itemCount: controller.filteredStations.length,
                    itemBuilder: (context, index) {
                      final station = controller.filteredStations[index];
                      return Column(
                        children: [
                          ListTile(
                            contentPadding: EdgeInsets.zero,
                            leading: Icon(Icons.directions_railway_rounded,
                                color: grey717),
                            title: CommonTextWidget.PoppinsRegular(
                              text: station,
                              color: black2E2,
                              fontSize: 16,
                            ),
                            onTap: () {
                              controller.selectStation(station);
                            },
                          ),
                          Divider(color: greyE8E),
                        ],
                      );
                    },
                  );
                }
              }),
            ),
          ],
        ),
      ),
    );
  }
}
