import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:seemytrip/Constants/colors.dart';
import 'package:seemytrip/Screens/Utills/common_button_widget.dart';
import 'package:seemytrip/Screens/Utills/common_text_widget.dart';

class BudgetScreen extends StatelessWidget {
  BudgetScreen({Key? key}) : super(key: key);

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
          child: Icon(Icons.close, color: white, size: 20),
        ),
        title: CommonTextWidget.PoppinsSemiBold(
          text: "Budget",
          color: white,
          fontSize: 18,
        ),
        actions: [
          Padding(
            padding: EdgeInsets.only(top: 20, right: 24),
            child: CommonTextWidget.PoppinsMedium(
              text: "CLEAR ALL",
              color: white,
              fontSize: 12,
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20),
            CommonTextWidget.PoppinsMedium(
              text: "Budget (Per Person)",
              color: black2E2,
              fontSize: 14,
            ),
            SizedBox(height: 15),
            Row(
              children: [
                Container(
                  height: 46,
                  width: 88,
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
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CommonTextWidget.PoppinsRegular(
                        text: "₹45,000",
                        color: black2E2,
                        fontSize: 12,
                      ),
                      CommonTextWidget.PoppinsRegular(
                        text: "(25)",
                        color: grey717,
                        fontSize: 12,
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 10),
                Container(
                  height: 46,
                  width: 148,
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
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CommonTextWidget.PoppinsRegular(
                        text: "₹45,000 - ₹70,000",
                        color: black2E2,
                        fontSize: 12,
                      ),
                      CommonTextWidget.PoppinsRegular(
                        text: "(35)",
                        color: grey717,
                        fontSize: 12,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            Row(
              children: [
                Container(
                  height: 46,
                  width: 148,
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
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CommonTextWidget.PoppinsRegular(
                        text: "₹70,000 - ₹90,000",
                        color: black2E2,
                        fontSize: 12,
                      ),
                      CommonTextWidget.PoppinsRegular(
                        text: "(38)",
                        color: grey717,
                        fontSize: 12,
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 10),
                Container(
                  height: 46,
                  width: 88,
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
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CommonTextWidget.PoppinsRegular(
                        text: "₹90,000",
                        color: black2E2,
                        fontSize: 12,
                      ),
                      CommonTextWidget.PoppinsRegular(
                        text: "(21)",
                        color: grey717,
                        fontSize: 12,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            // GridView.builder(
            //   gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            //     crossAxisCount: 2,
            //     mainAxisSpacing: 10,
            //     crossAxisSpacing: 10,
            //     childAspectRatio:
            //         MediaQuery.of(context).size.aspectRatio * 2 / 0.4,
            //   ),
            //   shrinkWrap: true,
            //   primary: false,
            //   physics: NeverScrollableScrollPhysics(),
            //   padding:
            //       EdgeInsets.only(top: 15, left: 24, right: 100, bottom: 5),
            //   itemCount: Lists.budgetList.length,
            //   itemBuilder: (context, index) {
            //     return Container(
            //       decoration: BoxDecoration(
            //         boxShadow: [
            //           BoxShadow(
            //             color: grey515.withOpacity(0.25),
            //             offset: Offset(0, 1),
            //             blurRadius: 6,
            //           ),
            //         ],
            //         color: white,
            //         borderRadius: BorderRadius.circular(5),
            //       ),
            //       child: Column(
            //         crossAxisAlignment: CrossAxisAlignment.center,
            //         mainAxisAlignment: MainAxisAlignment.center,
            //         children: [
            //           CommonTextWidget.PoppinsRegular(
            //             text: Lists.budgetList[index]["text1"],
            //             color: black2E2,
            //             fontSize: 12,
            //           ),
            //           CommonTextWidget.PoppinsRegular(
            //             text: Lists.budgetList[index]["text2"],
            //             color: grey717,
            //             fontSize: 12,
            //           ),
            //         ],
            //       ),
            //     );
            //   },
            // ),
            Spacer(),
            CommonButtonWidget.button(
              buttonColor: redCA0,
              onTap: () {},
              text: "APPLY",
            ),
            SizedBox(height: 60),
          ],
        ),
      ),
    );
  }
}
