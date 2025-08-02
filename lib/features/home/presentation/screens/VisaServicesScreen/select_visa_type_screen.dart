import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:seemytrip/core/utils/colors.dart';
import 'package:seemytrip/shared/constants/images.dart';
import 'package:seemytrip/features/home/presentation/screens/VisaServicesScreen/price_breakup_screen.dart';
import 'package:seemytrip/features/home/presentation/screens/VisaServicesScreen/see_visa_process_screen.dart';
import 'package:seemytrip/core/widgets/common_text_widget.dart';
import 'package:seemytrip/main.dart';

class SelectVisaTypeScreen extends StatelessWidget {
  SelectVisaTypeScreen({Key? key}) : super(key: key);

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
          text: "Select Visa Type",
          color: white,
          fontSize: 18,
        ),
      ),
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          ScrollConfiguration(
            behavior: MyBehavior(),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 20),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24),
                    child: Container(
                      width: Get.width,
                      decoration: BoxDecoration(
                        color: yellowF7C.withOpacity(0.35),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                        child: Row(
                          children: [
                            SvgPicture.asset(info, color: yellowCE8),
                            SizedBox(width: 10),
                            CommonTextWidget.PoppinsRegular(
                              text: "We Currently process Tourist visas only!",
                              color: yellowCE8,
                              fontSize: 12,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Divider(color: greyE8E, thickness: 1),
                  SizedBox(height: 15),
                  ListTile(
                    leading: SvgPicture.asset(selectVisaTypeImage),
                    title: CommonTextWidget.PoppinsLight(
                      text: "We Recommend",
                      color: redCA0,
                      fontSize: 18,
                    ),
                    subtitle: CommonTextWidget.PoppinsMedium(
                      text: "Based on your Travel Duration",
                      color: grey717,
                      fontSize: 14,
                    ),
                  ),
                  SizedBox(height: 15),
                  Divider(color: greyE8E, thickness: 1),
                  SizedBox(height: 15),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CommonTextWidget.PoppinsMedium(
                              text: "30 Days Stay Single Entry",
                              color: black2E2,
                              fontSize: 14,
                            ),
                            CommonTextWidget.PoppinsMedium(
                              text: "VALIDITY 59 Days",
                              color: grey717,
                              fontSize: 12,
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CommonTextWidget.PoppinsSemiBold(
                              text: "₹ 6790  ",
                              color: black2E2,
                              fontSize: 18,
                            ),
                            CommonTextWidget.PoppinsRegular(
                              text: "For 1 traveller",
                              color: grey717,
                              fontSize: 10,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 15),
                  Divider(color: greyE8E, thickness: 1),
                  SizedBox(height: 15),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(Icons.circle, color: grey717, size: 8),
                        SizedBox(width: 8),
                        Expanded(
                          child: CommonTextWidget.PoppinsRegular(
                            text:
                                "The UAE Immigration Mandates every passenger "
                                "gas to carry copy if international Health Insurance "
                                "that covers the treatment of COVID / Quarantine "
                                "during the period of stay in UAE.",
                            color: grey717,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(Icons.circle, color: grey717, size: 8),
                        SizedBox(width: 8),
                        Expanded(
                          child: CommonTextWidget.PoppinsRegular(
                            text:
                                "Fully vaccinated passengers with tourist visas can "
                                "now travel Dubai.",
                            color: grey717,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(Icons.circle, color: grey717, size: 8),
                        SizedBox(width: 8),
                        Expanded(
                          child: CommonTextWidget.PoppinsRegular(
                            text:
                                "In case Visas are cancelled by the embassy later  "
                                "due to COVID-19, we’ll refund your fee if not applied "
                                "to the consulate.",
                            color: grey717,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(Icons.circle, color: grey717, size: 8),
                        SizedBox(width: 8),
                        Expanded(
                          child: CommonTextWidget.PoppinsRegular(
                            text:
                                "Additional documents may be required if embassy "
                                "askes for females (below 21 yrs ) or males (below 18 "
                                "yes) travelling alone, ‘’Our Visa "
                                "experts will contact you for the same”",
                            color: grey717,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 110),
                ],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 40),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: 60,
                width: Get.width,
                color: black2E2,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Column(
                            children: [
                              CommonTextWidget.PoppinsSemiBold(
                                text: "₹ 6,790",
                                color: white,
                                fontSize: 16,
                              ),
                              CommonTextWidget.PoppinsMedium(
                                text: "For 1 traveller",
                                color: white,
                                fontSize: 10,
                              ),
                            ],
                          ),
                          SizedBox(width: 15),
                          InkWell(
                            onTap: () {
                              Get.bottomSheet(
                                PriceBreakUpScreen(),
                                backgroundColor: Colors.transparent,
                                isScrollControlled: true,
                              );
                            },
                            child: SvgPicture.asset(info),
                          ),
                        ],
                      ),
                      MaterialButton(
                        onPressed: () {
                          Get.to(() => SeeVisaProcessScreen());
                        },
                        height: 40,
                        minWidth: 140,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(40),
                        ),
                        color: redCA0,
                        child: CommonTextWidget.PoppinsSemiBold(
                          fontSize: 16,
                          text: "CONTINUE",
                          color: white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
