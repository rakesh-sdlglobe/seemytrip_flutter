import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:seemytrip/core/utils/colors.dart';
import 'package:seemytrip/core/widgets/common_text_widget.dart';
import 'package:seemytrip/core/widgets/lists_widget.dart';
import 'package:seemytrip/main.dart';

class SortByScreen extends StatelessWidget {
   SortByScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScrollConfiguration(
      behavior: MyBehavior(),
      child: ListView.builder(
        shrinkWrap: true,
        padding: EdgeInsets.only(top: 40),
        itemCount: Lists.sortList.length,
        itemBuilder: (context, index) => Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                children: [
                  SvgPicture.asset(
                    Lists.sortList[index]["image"],
                  ),
                  SizedBox(width: 30),
                  CommonTextWidget.PoppinsMedium(
                    text: Lists.sortList[index]["text1"],
                    color: grey717,
                    fontSize: 14,
                  ),
                  Expanded(
                    child: Align(
                      alignment: Alignment.topRight,
                      child: CommonTextWidget.PoppinsRegular(
                        text: Lists.sortList[index]["text2"],
                        color: grey717,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 15),
            Divider(thickness: 1, color: greyDED),
            SizedBox(height: 15),
          ],
        ),
      ),
    );
  }
}
