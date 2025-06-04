import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:seemytrip/Constants/colors.dart';
import 'package:seemytrip/Controller/train_contact_information_controller.dart';
import 'package:seemytrip/Screens/Utills/common_text_widget.dart';
import 'package:seemytrip/main.dart';

class TrainAndBusContactInformationScreen extends StatefulWidget {
  TrainAndBusContactInformationScreen({Key? key}) : super(key: key);

  @override
  _TrainAndBusContactInformationScreenState createState() =>
      _TrainAndBusContactInformationScreenState();
}

class _TrainAndBusContactInformationScreenState
    extends State<TrainAndBusContactInformationScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final controller = Get.put(TrainContactInformationController());

  @override
  void initState() {
    super.initState();
    _usernameController.addListener(_onTextChanged);
  }

  void _onTextChanged() {
    controller.validateUsername(_usernameController.text);
  }

  @override
  void dispose() {
    _usernameController.dispose();
    controller.clearForm();
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
                            "Please enter the correct IRCTC username. You will be required to "
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
                          errorStyle: TextStyle(height: 0),
                        ),
                        style: TextStyle(color: grey888, fontSize: 12),
                      ),
                    ),
                  ),
                  Obx(() => controller.errorMessage.isNotEmpty
                      ? Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(
                            controller.errorMessage.value,
                            style: TextStyle(
                              color: Colors.red,
                              fontSize: 12,
                            ),
                          ),
                        )
                      : controller.successMessage.isNotEmpty
                          ? Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Text(
                                controller.successMessage.value,
                                style: TextStyle(
                                  color: Colors.green,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            )
                          : SizedBox.shrink()),
                  SizedBox(height: 25),
                  Obx(() => MaterialButton(
                        height: 50,
                        minWidth: Get.width,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(40),
                        ),
                        color: redCA0,
                        disabledColor: greyE2E,
                        onPressed: controller.isUsernameValid.value &&
                                !controller.isLoading.value
                            ? () async {
                                if (await controller.submitForm()) {
                                  // Add delay to show success message
                                  await Future.delayed(Duration(seconds: 1));
                                  Get.back(result: controller.username.value);
                                }
                              }
                            : null,
                        child: controller.isLoading.value
                            ? SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  color: white,
                                  strokeWidth: 2,
                                ),
                              )
                            : CommonTextWidget.PoppinsSemiBold(
                                fontSize: 16,
                                text: "SUBMIT",
                                color: white,
                              ),
                      )),
                  SizedBox(height: 20),
                  GestureDetector(
                    onTap: () {
                      // TODO: Implement forgot username functionality
                    },
                    child: CommonTextWidget.PoppinsMedium(
                      text: "FORGOT USERNAME",
                      color: redCA0,
                      fontSize: 12,
                    ),
                  ),
                  SizedBox(height: 10),
                  GestureDetector(
                    onTap: () {
                      // TODO: Implement create new account functionality
                    },
                    child: CommonTextWidget.PoppinsMedium(
                      text: "CREATE NEW IRCTC ACCOUNT",
                      color: redCA0,
                      fontSize: 12,
                    ),
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
