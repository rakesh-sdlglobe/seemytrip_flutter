import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:seemytrip/core/utils/colors.dart';
import 'package:seemytrip/core/widgets/common_text_widget.dart';

class CancellationRefundScreen extends StatelessWidget {
  CancellationRefundScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 20),
        // Padding(
        //   padding: EdgeInsets.symmetric(horizontal: 24),
        //   child: Container(
        //     decoration: BoxDecoration(
        //       borderRadius: BorderRadius.circular(5),
        //     ),
        //     child: Table(
        //       border: TableBorder(
        //         bottom: BorderSide(color: greyE2E, width: 1),
        //         top: BorderSide(color: greyE2E, width: 1),
        //         left: BorderSide(color: greyE2E, width: 1),
        //         right: BorderSide(color: greyE2E, width: 1),
        //         verticalInside: BorderSide(color: greyE2E, width: 1),
        //       ),
        //       children: [
        //         TableRow(
        //           decoration: BoxDecoration(
        //             color: grey9B9.withOpacity(0.15),
        //           ),
        //           children: [
        //             Padding(
        //               padding: EdgeInsets.only(top: 8, left: 8, bottom: 8),
        //               child: Column(
        //                 crossAxisAlignment: CrossAxisAlignment.start,
        //                 children: [
        //                   CommonTextWidget.PoppinsMedium(
        //                     text: "Time frame",
        //                     color: black2E2,
        //                     fontSize: 12,
        //                   ),
        //                   CommonTextWidget.PoppinsRegular(
        //                     text: "(From Scheduled flight \ndeparture)",
        //                     color: grey717,
        //                     fontSize: 10,
        //                   ),
        //                 ],
        //               ),
        //             ),
        //             Padding(
        //               padding: EdgeInsets.only(top: 8, right: 8),
        //               child: Column(
        //                 crossAxisAlignment: CrossAxisAlignment.end,
        //                 children: [
        //                   CommonTextWidget.PoppinsMedium(
        //                     text: "Airline Fee + MMT Fee",
        //                     color: black2E2,
        //                     fontSize: 12,
        //                   ),
        //                   CommonTextWidget.PoppinsRegular(
        //                     text: "(Per passenger)",
        //                     color: grey717,
        //                     fontSize: 10,
        //                   ),
        //                 ],
        //               ),
        //             ),
        //           ],
        //         ),
        //         TableRow(
        //           children: [
        //             Column(
        //               crossAxisAlignment: CrossAxisAlignment.start,
        //               children: [
        //                 Padding(
        //                   padding:
        //                       EdgeInsets.only(top: 14, left: 12, bottom: 35),
        //                   child: CommonTextWidget.PoppinsMedium(
        //                     text: "0 hours to 2 hours*",
        //                     color: black2E2,
        //                     fontSize: 11,
        //                   ),
        //                 ),
        //                 Padding(
        //                   padding: EdgeInsets.only(left: 12, bottom: 35),
        //                   child: CommonTextWidget.PoppinsMedium(
        //                     text: "2 hours to 4 days*",
        //                     color: black2E2,
        //                     fontSize: 11,
        //                   ),
        //                 ),
        //                 Padding(
        //                   padding: EdgeInsets.only(left: 12, bottom: 35),
        //                   child: CommonTextWidget.PoppinsMedium(
        //                     text: "4 days to 365 days*",
        //                     color: black2E2,
        //                     fontSize: 11,
        //                   ),
        //                 ),
        //               ],
        //             ),
        //             Padding(
        //               padding: const EdgeInsets.only(left: 28),
        //               child: Column(
        //                 crossAxisAlignment: CrossAxisAlignment.start,
        //                 children: [
        //                   Padding(
        //                     padding: EdgeInsets.only(top: 14, bottom: 35),
        //                     child: CommonTextWidget.PoppinsMedium(
        //                       text: "ADULT : Non Chargeable",
        //                       color: black2E2,
        //                       fontSize: 11,
        //                     ),
        //                   ),
        //                   Padding(
        //                     padding: EdgeInsets.only(right: 12, bottom: 35),
        //                     child: CommonTextWidget.PoppinsMedium(
        //                       text: "ADULT : ₹ 3,350 + ₹ 300",
        //                       color: black2E2,
        //                       fontSize: 11,
        //                     ),
        //                   ),
        //                   Padding(
        //                     padding: EdgeInsets.only(right: 12, bottom: 35),
        //                     child: CommonTextWidget.PoppinsMedium(
        //                       text: "ADULT : ₹ 2,535 + ₹ 300",
        //                       color: black2E2,
        //                       fontSize: 11,
        //                     ),
        //                   ),
        //                 ],
        //               ),
        //             ),
        //           ],
        //         ),
        //       ],
        //     ),
        //   ),
        // ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 24),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: 250,
                width: Get.width / 2.4,
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  border: Border.all(color: greyAFA, width: 0.5),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(5),
                    bottomLeft: Radius.circular(5),
                  ),
                ),
                child: Stack(
                  children: [
                    Align(
                      alignment: Alignment.topCenter,
                      child: Container(
                        height: 67,
                        width: Get.width,
                        decoration: BoxDecoration(
                          color: whiteF2F,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(5),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 8),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 8),
                              CommonTextWidget.PoppinsMedium(
                                text: "Time frame",
                                color: black2E2,
                                fontSize: 12.0,
                              ),
                              SizedBox(height: 1),
                              CommonTextWidget.PoppinsRegular(
                                text: "(From Scheduled flight Departure)",
                                color: grey717,
                                fontSize: 10.0,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 79,
                      left: 10,
                      child: CommonTextWidget.PoppinsMedium(
                        text: "0 hours to 2 hours*",
                        color: black2E2,
                        fontSize: 10,
                      ),
                    ),
                    Positioned(
                      top: 131,
                      left: 10,
                      child: CommonTextWidget.PoppinsMedium(
                        text: "2 hours to 4 days*",
                        color: black2E2,
                        fontSize: 10,
                      ),
                    ),
                    Positioned(
                      top: 195,
                      left: 10,
                      child: CommonTextWidget.PoppinsMedium(
                        text: "4 days to 365 days*",
                        color: black2E2,
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                height: 250,
                width: Get.width / 2.4,
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  border: Border.all(color: greyAFA, width: 0.5),
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(5),
                    bottomRight: Radius.circular(5),
                  ),
                ),
                child: Stack(
                  children: [
                    Align(
                      alignment: Alignment.topCenter,
                      child: Container(
                        height: 67,
                        width: Get.width,
                        decoration: BoxDecoration(
                          color: whiteF2F,
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(5),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              SizedBox(height: 8),
                              CommonTextWidget.PoppinsMedium(
                                text: "Airline Fee + MMT Fee",
                                color: black2E2,
                                textAlign: TextAlign.end,
                                fontSize: 12.0,
                              ),
                              SizedBox(height: 1),
                              CommonTextWidget.PoppinsRegular(
                                text: "(Per passenger)",
                                color: grey717,
                                fontSize: 10.0,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 79,
                      left: 17,
                      child: CommonTextWidget.PoppinsMedium(
                        text: "ADULT : Non Chargeable",
                        color: black2E2,
                        fontSize: 10,
                      ),
                    ),
                    Positioned(
                      top: 131,
                      left: 17,
                      child: CommonTextWidget.PoppinsMedium(
                        text: "ADULT : ₹ 3,350 + ₹ 300",
                        color: black2E2,
                        textAlign: TextAlign.end,
                        fontSize: 10,
                      ),
                    ),
                    Positioned(
                      top: 195,
                      left: 17,
                      child: CommonTextWidget.PoppinsMedium(
                        text: "ADULT : ₹ 2,535 + ₹ 300",
                        color: black2E2,
                        textAlign: TextAlign.end,
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 15),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 24),
          child: CommonTextWidget.PoppinsRegular(
            text: "*From the Date of departure",
            color: grey717,
            fontSize: 10,
          ),
        ),
        SizedBox(height: 15),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 24),
          child: Container(
            width: Get.width,
            decoration: BoxDecoration(
              color: orangeEB9.withOpacity(0.2),
              borderRadius: BorderRadius.circular(3),
            ),
            child: Padding(
              padding: EdgeInsets.all(10),
              child: CommonTextWidget.PoppinsMedium(
                text:
                    "Important: The Baggage info is indicative. MakeMyTrip does "
                    "not guarantee the accuracy of the information. Kindly check "
                    "with airline website for accurate cancellation information. "
                    "The baggage allowance may vary according to stop-overs "
                    "connecting flights and charges in airline rules.",
                color: black2E2,
                fontSize: 10,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
