import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:seemytrip/Constants/colors.dart';
import 'package:seemytrip/Controller/language_controller.dart';
import 'package:seemytrip/Screens/Utills/common_text_widget.dart';

class LanguageScreen extends StatelessWidget {
  LanguageScreen({Key? key}) : super(key: key);

  final Map<String, Locale> languageMap = {
    'English': Locale('en'),
    'हिन्दी': Locale('hi'),
    'தமிழ்': Locale('ta'),
    'ಕನ್ನಡ': Locale('kn'),
    'తెలుగు': Locale('te'),
    'ଓଡ଼ିଆ': Locale('or'),
  };

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(LanguageController());
    
    return Scaffold(
      backgroundColor: white,
      appBar: AppBar(
        backgroundColor: redCA0,
        automaticallyImplyLeading: false,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: Icon(Icons.arrow_back, color: white, size: 20),
        ),
        title: CommonTextWidget.PoppinsSemiBold(
          text: "Language",
          color: white,
          fontSize: 18,
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20),
              CommonTextWidget.PoppinsSemiBold(
                text: "Select Language",
                color: black2E2,
                fontSize: 16,
              ),
              SizedBox(height: 30),
              GetBuilder<LanguageController>(
                builder: (controller) => ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: languageMap.length,
                  itemBuilder: (context, index) {
                    final languageName = languageMap.keys.elementAt(index);
                    final locale = languageMap[languageName]!;
                    
                    return Padding(
                      padding: EdgeInsets.only(bottom: 30),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CommonTextWidget.PoppinsMedium(
                            text: languageName,
                            color: grey717,
                            fontSize: 14,
                          ),
                          InkWell(
                            onTap: () {
                              controller.onLanguageSelected(locale);
                              Get.updateLocale(locale);
                            },
                            child: Container(
                              height: 18,
                              width: 18,
                              decoration: BoxDecoration(
                                color: white,
                                shape: BoxShape.circle,
                                border: Border.all(color: redCA0),
                              ),
                              alignment: Alignment.center,
                              child: Get.locale == locale
                                  ? Container(
                                      height: 10,
                                      width: 10,
                                      decoration: BoxDecoration(
                                        color: redCA0,
                                        shape: BoxShape.circle,
                                      ),
                                    )
                                  : SizedBox.shrink(),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
