import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:makeyourtripapp/Constants/colors.dart';
import 'package:makeyourtripapp/Controller/travellerDetailController.dart';
import 'package:makeyourtripapp/Screens/Utills/common_button_widget.dart';
import 'package:makeyourtripapp/Screens/Utills/common_text_widget.dart';
import 'package:makeyourtripapp/Screens/Utills/common_textfeild_widget.dart';

class TravellerDetailScreen extends StatelessWidget {
  TravellerDetailScreen({Key? key}) : super(key: key);

  final TextEditingController nameController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  final TextEditingController nationalityController = TextEditingController();
  final TravellerDetailController controller =
      Get.put(TravellerDetailController());

  final List<String> items = [
    "Lower Berth",
    "Middle Berth",
    "Upper Berth",
    "Side Lower Berth",
    "Side Upper Berth"
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
      appBar: _buildAppBar(),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20),
              _buildTextField("Name", "Full Name(As Per Govt. ID)",
                  nameController, TextInputType.name),
              SizedBox(height: 15),
              _buildAgeAndGenderFields(),
              SizedBox(height: 20),
              _buildBerthPreferenceSection(),
              SizedBox(height: 20),
              _buildTextField("Nationality", "INDIAN", nationalityController,
                  TextInputType.text),
              SizedBox(height: 270),
              CommonButtonWidget.button(
                text: "SAVE",
                // buttonColor: greyBEB,
                buttonColor: redCA0,
                onTap: () {
                  if (nameController.text.isEmpty ||
                      ageController.text.isEmpty ||
                      nationalityController.text.isEmpty) {
                    Get.snackbar(
                      "Error",
                      "Please fill out all fields.",
                      snackPosition: SnackPosition.BOTTOM,
                    );
                    return;
                  }

                  controller.saveTravellerDetails(
                    name: nameController.text,
                    age: ageController.text,
                    gender: "Male", // Replace with the selected gender
                    nationality: nationalityController.text,
                    berthPreferences: controller.selectedItems,
                  );

                  print("Saving Traveller Details:");
                  print("Name: ${nameController.text}");
                  print("Age: ${ageController.text}");
                  print("Gender: Male"); // Replace with the selected gender
                  print("Nationality: ${nationalityController.text}");
                  print("Berth Preferences: ${controller.selectedItems}");
                },
              ),
              SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
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
        text: "Traveller Details",
        color: white,
        fontSize: 18,
      ),
    );
  }

  Widget _buildTextField(String label, String hint,
      TextEditingController controller, TextInputType keyboardType) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CommonTextWidget.PoppinsMedium(
          text: label,
          color: grey717,
          fontSize: 12,
        ),
        SizedBox(height: 5),
        CommonTextFieldWidget.TextFormField5(
          hintText: hint,
          controller: controller,
          keyboardType: keyboardType,
        ),
      ],
    );
  }

  Widget _buildAgeAndGenderFields() {
    return Row(
      children: [
        Expanded(
          child: _buildTextField(
              "Age", "Enter age", ageController, TextInputType.number),
        ),
        SizedBox(width: 18),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CommonTextWidget.PoppinsMedium(
                text: "Gender",
                color: grey717,
                fontSize: 12,
              ),
              SizedBox(height: 5),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5),
                    borderSide: BorderSide(color: grey717, width: 1),
                  ),
                ),
                value: "Male",
                items: ["Male", "Female", "Other"].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: CommonTextWidget.PoppinsMedium(
                      text: value,
                      color: grey717,
                      fontSize: 12,
                    ),
                  );
                }).toList(),
                onChanged: (newValue) {
                  // Handle change here
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBerthPreferenceSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CommonTextWidget.PoppinsMedium(
          text: "Berth Preference",
          color: grey717,
          fontSize: 12,
        ),
        SizedBox(height: 5),
        DropdownButtonFormField<String>(
          decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5),
              borderSide: BorderSide(color: grey717, width: 1),
            ),
          ),
          value: items.first,
          items: items.map((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: CommonTextWidget.PoppinsMedium(
                text: value,
                color: grey717,
                fontSize: 12,
              ),
            );
          }).toList(),
          onChanged: (newValue) {
            controller.updateSelectedItems([newValue!]);
          },
        ),
      ],
    );
  }
}
