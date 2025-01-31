import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:makeyourtripapp/Constants/colors.dart';
import 'package:makeyourtripapp/Screens/Utills/common_text_widget.dart';
import 'package:makeyourtripapp/main.dart';

class TrainAndBusContactInformationScreen extends StatefulWidget {
  TrainAndBusContactInformationScreen({Key? key}) : super(key: key);

  @override
  _TrainAndBusContactInformationScreenState createState() =>
      _TrainAndBusContactInformationScreenState();
}

class _TrainAndBusContactInformationScreenState
    extends State<TrainAndBusContactInformationScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final ValueNotifier<bool> _isButtonEnabled = ValueNotifier(false);

  @override
  void initState() {
    super.initState();
    _usernameController.addListener(_onTextChanged);
  }

  void _onTextChanged() {
    _isButtonEnabled.value = _usernameController.text.isNotEmpty;
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _isButtonEnabled.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 300),
      child: Container(
        decoration: BoxDecoration(
          color: white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
        ),
        child: Padding(
          padding: EdgeInsets.only(top: 22, left: 24, right: 24),
          child: ScrollConfiguration(
            behavior: MyBehavior(),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                    Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CommonTextWidget.PoppinsMedium(
                      text: "Contact information",
                      color: black2E2,
                      fontSize: 18,
                      ),
                        IconButton(
                      onPressed: () {
                        Get.back();
                      },
                      icon: Icon(Icons.close, color: Colors.black),
                      ),
                    ],
                    ),
                  SizedBox(height: 15),
                  Container(
                    width: Get.width,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(3),
                      color: yellowF7C.withOpacity(0.3),
                    ),
                    child: Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      child: CommonTextWidget.PoppinsMedium(
                        text:
                            "Please enter the correct IRTC username. You will be required to "
                            "enter the password for this IRCTC username after payment.",
                        color: yellowCE8,
                        fontSize: 12,
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  Container(
                    width: Get.width,
                    decoration: BoxDecoration(
                      color: greyE2E,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: ListTile(
                      title: CommonTextWidget.PoppinsMedium(
                        text: "USERNAME",
                        color: grey888,
                        fontSize: 12,
                      ),
                      subtitle: TextField(
                        controller: _usernameController,
                        decoration: InputDecoration(
                          hintText: "Enter IRCTC Username",
                          hintStyle: TextStyle(color: grey888, fontSize: 12),
                          border: InputBorder.none,
                        ),
                        style: TextStyle(color: grey888, fontSize: 12),
                      ),
                    ),
                  ),
                  SizedBox(height: 25),
                  ValueListenableBuilder<bool>(
                    valueListenable: _isButtonEnabled,
                    builder: (context, isEnabled, child) {
                      return MaterialButton(
                        height: 50,
                        minWidth: Get.width,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(40),
                        ),
                        color: redCA0,
                        disabledColor: greyE2E,
                        onPressed: isEnabled
                          ? () {
                            String username = _usernameController.text;
                           Get.back(result: username);
                            }
                          : null,
                        child: CommonTextWidget.PoppinsSemiBold(
                          fontSize: 16,
                          text: "SUBMIT",
                          color: white,
                        ),
                      );
                    },
                  ),
                  SizedBox(height: 20),
                  CommonTextWidget.PoppinsMedium(
                    text: "FORGOT USERNAME",
                    color: redCA0,
                    fontSize: 12,
                  ),
                  SizedBox(height: 10),
                  CommonTextWidget.PoppinsMedium(
                    text: "CREATE NEW IRCTC ACCOUNT",
                    color: redCA0,
                    fontSize: 12,
                  ),
                  SizedBox(height: 60),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
