import 'package:flutter/material.dart';
import 'package:seemytrip/shared/constants/images.dart';
import 'package:seemytrip/features/booking/presentation/screens/seats_meals/seats.dart';
import 'package:seemytrip/core/widgets/lists_widget.dart';
import 'package:seemytrip/main.dart';
import 'package:get/get.dart';

class SeatsScreen extends StatelessWidget {
  SeatsScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ScrollConfiguration(
      behavior: MyBehavior(),
      child: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 40),
            Image.asset(seatsImage1),
            SizedBox(height: 25),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24),
              child: Image.asset(seatsImage2),
            ),
            SizedBox(height: 30),
            Padding(
              padding: EdgeInsets.only(left: 17, right: 17),
              child: Column(
                children: [
                  seatsRow(
                    index: "1",
                    image1: Lists.seatsList2[0],
                    image2: Lists.seatsList2[1],
                    image3: Lists.seatsList2[2],
                    image4: Lists.seatsList2[0],
                    image5: Lists.seatsList2[1],
                    image6: Lists.seatsList2[2],
                  ),
                  SizedBox(height: 8),
                  seatsRow(
                    index: "2",
                    image1: Lists.seatsList2[3],
                    image2: Lists.seatsList2[4],
                    image3: Lists.seatsList2[5],
                    image4: Lists.seatsList2[3],
                    image5: Lists.seatsList2[4],
                    image6: Lists.seatsList2[5],
                  ),
                  SizedBox(height: 8),
                  seatsRow(
                    index: "3",
                    image1: Lists.seatsList2[6],
                    image2: Lists.seatsList2[7],
                    image3: Lists.seatsList2[8],
                    image4: Lists.seatsList2[6],
                    image5: Lists.seatsList2[7],
                    image6: Lists.seatsList2[8],
                  ),
                  SizedBox(height: 8),
                  seatsRow(
                    index: "4",
                    image1: Lists.seatsList2[9],
                    image2: Lists.seatsList2[10],
                    image3: Lists.seatsList2[11],
                    image4: Lists.seatsList2[9],
                    image5: Lists.seatsList2[10],
                    image6: Lists.seatsList2[11],
                  ),
                  SizedBox(height: 8),
                  seatsRow(
                    index: "5",
                    image1: Lists.seatsList2[12],
                    image2: Lists.seatsList2[13],
                    image3: Lists.seatsList2[14],
                    image4: Lists.seatsList2[12],
                    image5: Lists.seatsList2[13],
                    image6: Lists.seatsList2[14],
                  ),
                  SizedBox(height: 8),
                  Obx(() {
                    return seatsRow(
                      index: "6",
                      image1: Lists.seatsList2[15],
                      image2: seatSelected.value == true
                          ? "assets/images/check.png"
                          : Lists.seatsList2[16],
                      image3: Lists.seatsList2[17],
                      image4: Lists.seatsList2[15],
                      image5: Lists.seatsList2[16],
                      image6: Lists.seatsList2[17],
                    );
                  }),
                  // seatsRow(
                  //   index: "6",
                  //   image1: Lists.seatsList2[15],
                  //   // image2: Lists.seatsList2[16],
                  //   image3: Lists.seatsList2[17],
                  //   image4: Lists.seatsList2[15],
                  //   image5: Lists.seatsList2[16],
                  //   image6: Lists.seatsList2[17],
                  // ),
                  SizedBox(height: 8),
                  seatsRow(
                    index: "7",
                    image1: Lists.seatsList2[18],
                    image2: Lists.seatsList2[19],
                    image3: Lists.seatsList2[20],
                    image4: Lists.seatsList2[18],
                    image5: Lists.seatsList2[19],
                    image6: Lists.seatsList2[20],
                  ),
                  SizedBox(height: 8),
                  seatsRow(
                    index: "8",
                    image1: Lists.seatsList2[21],
                    image2: Lists.seatsList2[22],
                    image3: Lists.seatsList2[23],
                    image4: Lists.seatsList2[21],
                    image5: Lists.seatsList2[22],
                    image6: Lists.seatsList2[23],
                  ),
                  SizedBox(height: 8),
                  seatsRow(
                    index: "9",
                    image1: Lists.seatsList2[24],
                    image2: Lists.seatsList2[25],
                    image3: Lists.seatsList2[26],
                    image4: Lists.seatsList2[24],
                    image5: Lists.seatsList2[25],
                    image6: Lists.seatsList2[26],
                  ),
                  SizedBox(height: 8),
                  seatsRow(
                    index: "10",
                    image1: Lists.seatsList2[27],
                    image2: Lists.seatsList2[28],
                    image3: Lists.seatsList2[29],
                    image4: Lists.seatsList2[27],
                    image5: Lists.seatsList2[28],
                    image6: Lists.seatsList2[29],
                  ),
                  SizedBox(height: 8),
                  seatsRow(
                    index: "11",
                    image1: Lists.seatsList2[30],
                    image2: Lists.seatsList2[31],
                    image3: Lists.seatsList2[32],
                    image4: Lists.seatsList2[30],
                    image5: Lists.seatsList2[31],
                    image6: Lists.seatsList2[32],
                  ),
                  SizedBox(height: 8),
                  seatsRow(
                    index: "12",
                    image1: Lists.seatsList2[33],
                    image2: Lists.seatsList2[34],
                    image3: Lists.seatsList2[35],
                    image4: Lists.seatsList2[33],
                    image5: Lists.seatsList2[34],
                    image6: Lists.seatsList2[35],
                  ),
                  SizedBox(height: 8),
                  seatsRow(
                    index: "13",
                    image1: Lists.seatsList2[36],
                    image2: Lists.seatsList2[37],
                    image3: Lists.seatsList2[38],
                    image4: Lists.seatsList2[36],
                    image5: Lists.seatsList2[37],
                    image6: Lists.seatsList2[38],
                  ),
                  SizedBox(height: 8),
                  seatsRow(
                    index: "14",
                    image1: Lists.seatsList2[39],
                    image2: Lists.seatsList2[40],
                    image3: Lists.seatsList2[41],
                    image4: Lists.seatsList2[39],
                    image5: Lists.seatsList2[40],
                    image6: Lists.seatsList2[41],
                  ),
                  SizedBox(height: 8),
                  seatsRow(
                    index: "15",
                    image1: Lists.seatsList2[42],
                    image2: Lists.seatsList2[43],
                    image3: Lists.seatsList2[44],
                    image4: Lists.seatsList2[42],
                    image5: Lists.seatsList2[43],
                    image6: Lists.seatsList2[44],
                  ),
                  SizedBox(height: 8),
                  seatsRow(
                    index: "16",
                    image1: Lists.seatsList2[45],
                    image2: Lists.seatsList2[46],
                    image3: Lists.seatsList2[47],
                    image4: Lists.seatsList2[45],
                    image5: Lists.seatsList2[46],
                    image6: Lists.seatsList2[47],
                  ),
                  SizedBox(height: 8),
                  seatsRow(
                    index: "17",
                    image1: Lists.seatsList2[48],
                    image2: Lists.seatsList2[49],
                    image3: Lists.seatsList2[50],
                    image4: Lists.seatsList2[48],
                    image5: Lists.seatsList2[49],
                    image6: Lists.seatsList2[50],
                  ),
                  SizedBox(height: 8),
                  seatsRow(
                    index: "18",
                    image1: Lists.seatsList2[51],
                    image2: Lists.seatsList2[52],
                    image3: Lists.seatsList2[53],
                    image4: Lists.seatsList2[51],
                    image5: Lists.seatsList2[52],
                    image6: Lists.seatsList2[53],
                  ),
                  SizedBox(height: 8),
                  seatsRow(
                    index: "19",
                    image1: Lists.seatsList2[54],
                    image2: Lists.seatsList2[55],
                    image3: Lists.seatsList2[56],
                    image4: Lists.seatsList2[54],
                    image5: Lists.seatsList2[55],
                    image6: Lists.seatsList2[56],
                  ),
                  SizedBox(height: 8),
                  seatsRow(
                    index: "20",
                    image1: Lists.seatsList2[57],
                    image2: Lists.seatsList2[58],
                    image3: Lists.seatsList2[59],
                    image4: Lists.seatsList2[57],
                    image5: Lists.seatsList2[58],
                    image6: Lists.seatsList2[59],
                  ),
                  SizedBox(height: 8),
                  seatsRow(
                    index: "21",
                    image1: Lists.seatsList2[60],
                    image2: Lists.seatsList2[61],
                    image3: Lists.seatsList2[62],
                    image4: Lists.seatsList2[60],
                    image5: Lists.seatsList2[61],
                    image6: Lists.seatsList2[62],
                  ),
                  SizedBox(height: 8),
                  seatsRow(
                    index: "22",
                    image1: Lists.seatsList2[63],
                    image2: Lists.seatsList2[64],
                    image3: Lists.seatsList2[65],
                    image4: Lists.seatsList2[63],
                    image5: Lists.seatsList2[64],
                    image6: Lists.seatsList2[65],
                  ),
                  SizedBox(height: 8),
                  seatsRow(
                    index: "23",
                    image1: Lists.seatsList2[66],
                    image2: Lists.seatsList2[67],
                    image3: Lists.seatsList2[68],
                    image4: Lists.seatsList2[66],
                    image5: Lists.seatsList2[67],
                    image6: Lists.seatsList2[68],
                  ),
                  SizedBox(height: 8),
                  seatsRow(
                    index: "24",
                    image1: Lists.seatsList2[69],
                    image2: Lists.seatsList2[70],
                    image3: Lists.seatsList2[71],
                    image4: Lists.seatsList2[69],
                    image5: Lists.seatsList2[70],
                    image6: Lists.seatsList2[71],
                  ),
                  SizedBox(height: 8),
                  seatsRow(
                    index: "25",
                    image1: Lists.seatsList2[72],
                    image2: Lists.seatsList2[73],
                    image3: Lists.seatsList2[74],
                    image4: Lists.seatsList2[72],
                    image5: Lists.seatsList2[73],
                    image6: Lists.seatsList2[74],
                  ),
                  SizedBox(height: 8),
                  seatsRow(
                    index: "26",
                    image1: Lists.seatsList2[75],
                    image2: Lists.seatsList2[76],
                    image3: Lists.seatsList2[77],
                    image4: Lists.seatsList2[75],
                    image5: Lists.seatsList2[76],
                    image6: Lists.seatsList2[77],
                  ),
                  SizedBox(height: 8),
                ],
              ),
              // child: Row(
              //   crossAxisAlignment: CrossAxisAlignment.start,
              //   mainAxisAlignment: MainAxisAlignment.start,
              //   children: [
              //     Container(
              //       color: Colors.transparent,
              //       width: 20,
              //       child: GridView.builder(
              //         gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              //           crossAxisCount: 1,
              //           mainAxisSpacing: 14.1,
              //           crossAxisSpacing: 0,
              //           childAspectRatio: 1,
              //         ),
              //         itemCount: Lists.seatsList1.length,
              //         shrinkWrap: true,
              //         physics: NeverScrollableScrollPhysics(),
              //         itemBuilder: (context, index) => Center(
              //           child: CommonTextWidget.PoppinsMedium(
              //             text: Lists.seatsList1[index],
              //             color: grey717,
              //             fontSize: 16,
              //           ),
              //         ),
              //       ),
              //     ),
              //     SizedBox(width: 10),
              //     Expanded(
              //       child: Column(
              //         children: [
              //           Row(
              //             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              //             children: [
              //               CommonTextWidget.PoppinsMedium(
              //                 text: "A",
              //                 fontSize: 16,
              //                 color: grey717,
              //               ),
              //               SizedBox(),
              //               SizedBox(),
              //               CommonTextWidget.PoppinsMedium(
              //                 text: "B",
              //                 fontSize: 16,
              //                 color: grey717,
              //               ),
              //               SizedBox(),
              //               SizedBox(),
              //               CommonTextWidget.PoppinsMedium(
              //                 text: "C",
              //                 fontSize: 16,
              //                 color: grey717,
              //               ),
              //             ],
              //           ),
              //           GridView.builder(
              //             gridDelegate:
              //                 SliverGridDelegateWithFixedCrossAxisCount(
              //               crossAxisCount: 3,
              //               mainAxisSpacing: 1,
              //               crossAxisSpacing: 16,
              //               childAspectRatio: 1,
              //             ),
              //             shrinkWrap: true,
              //             physics: NeverScrollableScrollPhysics(),
              //             padding: EdgeInsets.zero,
              //             itemCount: Lists.seatsList2.length,
              //             itemBuilder: (context, index) {
              //               return Padding(
              //                 padding:
              //                     const EdgeInsets.symmetric(horizontal: 1),
              //                 child: Image.asset(
              //                   Lists.seatsList2[index],
              //                 ),
              //               );
              //             },
              //           ),
              //         ],
              //       ),
              //     ),
              //     SizedBox(width: 53),
              //     Expanded(
              //       child: Column(
              //         children: [
              //           Row(
              //             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              //             children: [
              //               CommonTextWidget.PoppinsMedium(
              //                 text: "A",
              //                 fontSize: 16,
              //                 color: grey717,
              //               ),
              //               SizedBox(),
              //               SizedBox(),
              //               CommonTextWidget.PoppinsMedium(
              //                 text: "B",
              //                 fontSize: 16,
              //                 color: grey717,
              //               ),
              //               SizedBox(),
              //               SizedBox(),
              //               CommonTextWidget.PoppinsMedium(
              //                 text: "C",
              //                 fontSize: 16,
              //                 color: grey717,
              //               ),
              //             ],
              //           ),
              //           GridView.builder(
              //             gridDelegate:
              //                 SliverGridDelegateWithFixedCrossAxisCount(
              //               crossAxisCount: 3,
              //               mainAxisSpacing: 1,
              //               crossAxisSpacing: 16,
              //               childAspectRatio: 1,
              //             ),
              //             shrinkWrap: true,
              //             physics: NeverScrollableScrollPhysics(),
              //             padding: EdgeInsets.zero,
              //             itemCount: Lists.seatsList2.length,
              //             itemBuilder: (context, index) {
              //               return Padding(
              //                 padding:
              //                     const EdgeInsets.symmetric(horizontal: 1),
              //                 child: Image.asset(
              //                   Lists.seatsList2[index],
              //                 ),
              //               );
              //             },
              //           ),
              //         ],
              //       ),
              //     ),
              //     SizedBox(width: 10),
              //     Container(
              //       color: Colors.transparent,
              //       width: 20,
              //       child: GridView.builder(
              //         gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              //           crossAxisCount: 1,
              //           mainAxisSpacing: 14.1,
              //           crossAxisSpacing: 0,
              //           childAspectRatio: 1,
              //         ),
              //         itemCount: Lists.seatsList1.length,
              //         shrinkWrap: true,
              //         physics: NeverScrollableScrollPhysics(),
              //         itemBuilder: (context, index) => Center(
              //           child: CommonTextWidget.PoppinsMedium(
              //             text: Lists.seatsList1[index],
              //             color: grey717,
              //             fontSize: 16,
              //           ),
              //         ),
              //       ),
              //     ),
              //   ],
              // ),
            ),
            SizedBox(height: 110),
          ],
        ),
      ),
    );
  }
}
