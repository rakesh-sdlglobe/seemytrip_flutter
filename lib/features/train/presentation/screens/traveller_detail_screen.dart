import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import '../../../../core/utils/common_textfeild_widget.dart';
import '../controllers/train_detail_controller.dart';
import '../controllers/travellerDetailController.dart';
import '../../../../core/utils/colors.dart';
import '../../../../core/widgets/common_button_widget.dart';
import '../../../../core/widgets/common_text_widget.dart';

// Ensure it's a StatefulWidget
class TravellerDetailScreen extends StatefulWidget {
  TravellerDetailScreen({Key? key}) : super(key: key);

  @override
  State<TravellerDetailScreen> createState() => _TravellerDetailScreenState();
}

class _TravellerDetailScreenState extends State<TravellerDetailScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  final TextEditingController nationalityController = TextEditingController();
  // Find the controller instance
  final TrainDetailController controller = Get.find<TrainDetailController>();
  final TravellerDetailController travellerDetailController = Get.put(TravellerDetailController());

  // State variables for dropdowns
  String? _selectedGender; // Allow null initially
  String? _selectedBerth; // Allow null initially

  final List<String> genderItems = <String>['Male', 'Female', 'Other'];
  // --- NEW: Add "No Preference" to UI list ---
  final List<String> berthItems = <String>[
    'Lower Berth',
    'Middle Berth',
    'Upper Berth',
    'Side Lower Berth',
    'Side Upper Berth',
    'No Preference' // Added No Preference
  ];
  // --- End NEW ---

  @override
  void initState() {
    super.initState();
    // Set default nationality
    nationalityController.text = 'INDIAN';
    // Set default selections (optional, can show hint text instead)
    // _selectedGender = genderItems.first; // e.g., Male
    _selectedBerth = berthItems.last; // e.g., No Preference
  }

  @override
  void dispose() {
    nameController.dispose();
    ageController.dispose();
    nationalityController.dispose();
    super.dispose();
  }

  // Updated to pass local state to controller
  void _handleSave() {
    // Basic Validation
    if (nameController.text.trim().isEmpty) {
       Get.snackbar('Error', "Please enter the traveller's name.", snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.red, colorText: Colors.white);
       return;
    }
     if (ageController.text.trim().isEmpty) {
       Get.snackbar('Error', "Please enter the traveller's age.", snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.red, colorText: Colors.white);
       return;
    }
    if (_selectedGender == null) {
      Get.snackbar('Error', 'Please select a gender.', snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }
     if (_selectedBerth == null) {
      Get.snackbar('Error', 'Please select a berth preference.', snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }
     if (nationalityController.text.trim().isEmpty) {
       // Although defaulted, check just in case
       Get.snackbar('Error', 'Please enter the nationality.', snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.red, colorText: Colors.white);
       return;
    }


    // Call controller method with current state values
    travellerDetailController.saveTravellerDetails(
      name: nameController.text,
      age: ageController.text,
      gender: _selectedGender, // Pass the selected gender from state
      nationality: nationalityController.text,
      berthPreference: _selectedBerth, // Pass the selected berth from state
    );
  }


  @override
  Widget build(BuildContext context) => Scaffold(
      backgroundColor: white,
      appBar: _buildAppBar(),
      // Use Obx ONLY for parts reacting to controller state (like isLoading)
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    _buildTextField('Name', 'Full Name (As Per Govt. ID)',
                        nameController, TextInputType.name),
                    SizedBox(height: 16),
                    _buildAgeAndGenderFields(), // Uses local state _selectedGender
                    SizedBox(height: 16),
                    _buildBerthPreferenceSection(), // Uses local state _selectedBerth
                    SizedBox(height: 16),
                    _buildTextField('Nationality', 'Enter Nationality', nationalityController,
                        TextInputType.text),
                  ],
                ),
              ),
            ),
            // Button Section at the bottom - reacts to controller.isLoading
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              child: Obx( // Use Obx here for the button's loading state
                () => CommonButtonWidget.button(
                  text: controller.isLoading.value ? null : 'SAVE',
                  buttonColor: redCA0,
                  onTap: controller.isLoading.value ? null : _handleSave,
                  child: controller.isLoading.value
                      ? SizedBox(
                          height: 24,
                          width: 24,
                          child: LoadingAnimationWidget.fourRotatingDots(
                            color: white,
                            size: 20,
                          ),
                        )
                      : null,
                ),
              ),
            ),
          ],
        ),
      ),
    );

  AppBar _buildAppBar() => AppBar(
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
        text: 'Traveller Details',
        color: white,
        fontSize: 18,
      ),
    );

  // Helper for TextFields (remains the same)
  Widget _buildTextField(String label, String hint,
      TextEditingController controller, TextInputType keyboardType) => Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        CommonTextWidget.PoppinsMedium(
          text: label,
          color: grey717,
          fontSize: 12,
        ),
        SizedBox(height: 5),
        // Assuming CommonTextFieldWidget.TextFormField5 exists and is styled
        CommonTextFieldWidget(
          hintText: hint,
          controller: controller,
          keyboardType: keyboardType,
        ),
      ],
    );

  // Helper for Age and Gender Row - uses local state _selectedGender
  Widget _buildAgeAndGenderFields() => Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Expanded(
          child: _buildTextField(
              'Age', 'Enter age', ageController, TextInputType.number),
        ),
        SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              CommonTextWidget.PoppinsMedium(
                text: 'Gender',
                color: grey717,
                fontSize: 12,
              ),
              SizedBox(height: 5),
              DropdownButtonFormField<String>(
                 // Add styling matching your app theme
                 decoration: InputDecoration(
                   hintText: 'Select Gender', // Add hint text
                   contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 14),
                   border: OutlineInputBorder(borderRadius: BorderRadius.circular(5), borderSide: BorderSide(color: greyBEB)),
                   enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(5), borderSide: BorderSide(color: greyBEB)),
                   focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(5), borderSide: BorderSide(color: redCA0, width: 1.5)),
                   filled: true, fillColor: greyE2E.withOpacity(0.5),
                 ),
                value: _selectedGender, // Use state variable
                isExpanded: true,
                icon: Icon(Icons.arrow_drop_down, color: grey717),
                items: genderItems.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: CommonTextWidget.PoppinsRegular(
                      text: value, color: black2E2, fontSize: 14,
                    ),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  // Update state when changed
                  setState(() {
                    _selectedGender = newValue;
                  });
                },
                // Optional validation
                validator: (String? value) => value == null ? 'Please select gender' : null,
              ),
            ],
          ),
        ),
      ],
    );

  // Helper for Berth Preference Dropdown - uses local state _selectedBerth
  Widget _buildBerthPreferenceSection() => Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        CommonTextWidget.PoppinsMedium(
          text: 'Berth Preference',
          color: grey717,
          fontSize: 12,
        ),
        SizedBox(height: 5),
        DropdownButtonFormField<String>(
           // Add styling matching your app theme
           decoration: InputDecoration(
             hintText: 'Select Preference', // Add hint text
             contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 14),
             border: OutlineInputBorder(borderRadius: BorderRadius.circular(5), borderSide: BorderSide(color: greyBEB)),
             enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(5), borderSide: BorderSide(color: greyBEB)),
             focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(5), borderSide: BorderSide(color: redCA0, width: 1.5)),
             filled: true, fillColor: greyE2E.withOpacity(0.5),
           ),
          value: _selectedBerth, // Use state variable
          isExpanded: true,
          icon: Icon(Icons.arrow_drop_down, color: grey717),
          // ignore: prefer_expression_function_bodies
          items: berthItems.map((String value) { // Use updated berthItems list
            return DropdownMenuItem<String>(
              value: value,
              child: CommonTextWidget.PoppinsRegular(
                text: value, color: black2E2, fontSize: 14,
              ),
            );
          }).toList(),
          onChanged: (String? newValue) {
            if (newValue != null) {
              setState(() {
                _selectedBerth = newValue;
              });
            }
          },
           // Optional validation
           validator: (String? value) => value == null ? 'Please select preference' : null,
        ),
      ],
    );
}
