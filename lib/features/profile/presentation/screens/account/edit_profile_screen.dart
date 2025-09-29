import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/utils/common_textfeild_widget.dart';
import '../../../../../core/widgets/common_text_widget.dart';
import '../../../../../main.dart';
import '../../../../../shared/constants/images.dart';
import '../../../../auth/presentation/controllers/login_controller.dart';

class EditProfileScreen extends StatefulWidget {
  EditProfileScreen({Key? key}) : super(key: key);

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final LoginController loginController = Get.find<LoginController>();

  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController genderController = TextEditingController();
  final TextEditingController dateOfBirthController = TextEditingController();
  final TextEditingController nationalityController = TextEditingController();
  final TextEditingController emailIdController = TextEditingController();
  final TextEditingController mobileNumberController = TextEditingController();

  DateTime now = DateTime.now();
  late String formattedDate;

  @override
  void initState() {
    super.initState();
    formattedDate = DateFormat('yyyy-MM-dd').format(now);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadUserProfile();
    });
    
    // Listen to user data changes
    ever<Map<dynamic, dynamic>>(loginController.userData, (Map<dynamic, dynamic> userData) {
      _populateFields();
    });
  }

  Future<void> _loadUserProfile() async {
    await loginController.fetchUserProfile();
    _populateFields();
  }

  void _populateFields() {
    final userData = loginController.userData;
    if (mounted) {
      fullNameController.text = userData['firstName'] ?? '';
      genderController.text = userData['gender'] ?? '';
      
      // Format date properly if it exists
      String dob = userData['dob'] ?? '';
      if (dob.isNotEmpty) {
        try {
          // If the date is in a different format, convert it
          DateTime date = DateTime.parse(dob);
          dateOfBirthController.text = DateFormat('yyyy-MM-dd').format(date);
        } catch (e) {
          // If parsing fails, use the original value
          dateOfBirthController.text = dob;
        }
      } else {
        dateOfBirthController.text = '';
      }
      
      nationalityController.text = userData['nationality'] ?? '';
      emailIdController.text = userData['email'] ?? '';
      mobileNumberController.text = userData['phoneNumber'] ?? '';
    }
  }

  Future<void> _refreshProfile() async {
    await _loadUserProfile();
  }

  Future<void> editProfile() async {
    // Validate required fields
    if (fullNameController.text.trim().isEmpty) {
      Get.snackbar('Error', 'Please enter your name');
      return;
    }

    if (emailIdController.text.trim().isEmpty) {
      Get.snackbar('Error', 'Please enter your email');
      return;
    }

    // Prepare profile data, only include non-empty fields
    final Map<String, dynamic> profileData = {
      'firstName': fullNameController.text.trim(),
      'email': emailIdController.text.trim(),
    };

    // Add optional fields only if they have values
    if (genderController.text.trim().isNotEmpty) {
      profileData['gender'] = genderController.text.trim();
    }
    
    if (dateOfBirthController.text.trim().isNotEmpty) {
      profileData['dob'] = dateOfBirthController.text.trim();
    }
    
    if (mobileNumberController.text.trim().isNotEmpty) {
      profileData['phoneNumber'] = mobileNumberController.text.trim();
    }
    
    if (nationalityController.text.trim().isNotEmpty) {
      profileData['nationality'] = nationalityController.text.trim();
    }

    print('📤 Final profile data being sent: $profileData');

    final success = await loginController.updateUserProfile(profileData);
    
    if (success) {
      Get.back();
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
      backgroundColor: Theme.of(context).brightness == Brightness.dark 
          ? AppColors.backgroundDark 
          : AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.redCA0,
        elevation: 0,
        centerTitle: true,
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.white, size: 20),
          onPressed: () => Get.back(),
        ),
        title: CommonTextWidget.PoppinsSemiBold(
          text: 'Edit Profile',
          color: AppColors.white,
          fontSize: 18,
        ),
        actions: [
          // Refresh button
          IconButton(
            onPressed: _refreshProfile,
            icon: Icon(Icons.refresh, color: AppColors.white, size: 26),
            tooltip: 'Refresh Profile',
          ),
        ],
      ),
      body: Obx(() {
        if (loginController.isLoading.value) {
          return Center(child: LoadingAnimationWidget.dotsTriangle(
            color: AppColors.redCA0,
            size: 24,
          ));
        }

        return ScrollConfiguration(
          behavior: MyBehavior(),
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 22),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 25),
                Center(
                  child: Stack(
                    alignment: Alignment.bottomRight,
                    children: [ 
                      Obx(() => Icon(
                        Icons.account_circle, 
                        size: 130, 
                        color: loginController.userData.isNotEmpty 
                            ? AppColors.redCA0 
                            : AppColors.redCA0.withOpacity(0.5),
                      )),
                      // Profile edit icon
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          padding: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: AppColors.redCA0,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Theme.of(context).brightness == Brightness.dark 
                                  ? AppColors.backgroundDark 
                                  : AppColors.white,
                              width: 2,
                            ),
                          ),
                          child: Icon(
                            Icons.edit,
                            color: AppColors.white,
                            size: 16,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 22),
                _buildLabel('Name'),
                _buildField(fullNameController, 'Unknown', profileIcon),
                _buildLabel('Gender'),
                _buildField(genderController, 'Male', genderIcon),
                _buildLabel('Date of Birth'),
                _buildDateField(),
                _buildLabel('Nationality'),
                _buildField(nationalityController, 'India', null, isImage: true),
                _buildLabel('Email ID'),
                _buildField(emailIdController, 'example@email.com', emailIcon),
                _buildLabel('Mobile No.'),
                _buildField(mobileNumberController, '84XXX XXXXX', smartphoneIcon),
                SizedBox(height: 30),
                // Save button at bottom
                _buildSaveButton(),
                SizedBox(height: 30),
              ],
            ),
          ),
        );
      }),
    );

  Widget _buildLabel(String text) => Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CommonTextWidget.PoppinsMedium(
          text: text,
          color: Theme.of(context).brightness == Brightness.dark 
              ? AppColors.textPrimaryDark 
              : AppColors.black2E2,
          fontSize: 14,
        ),
        SizedBox(height: 10),
      ],
    );

  Widget _buildField(
    TextEditingController controller,
    String hint,
    String? iconPath, {
    bool isImage = false,
  }) => CommonTextFieldWidget(
      controller: controller,
      hintText: hint,
      keyboardType: TextInputType.text,
      prefixIcon: Padding(
        padding: EdgeInsets.all(10),
        child: isImage
            ? Image.asset(india, height: 20, width: 20)
            : iconPath != null
                ? SizedBox(
                    height: 20,
                    width: 20,
                    child: SvgPicture.asset(iconPath),
                  )
                : null,
      ),
    );

  Widget _buildDateField() => InkWell(
      onTap: () async {
        final DateTime? pickedDate = await showDatePicker(
          context: context,
          initialDate: DateTime.now().subtract(Duration(days: 365 * 20)), // Default to 20 years ago
          firstDate: DateTime(1900),
          lastDate: DateTime.now(),
        );
        
        if (pickedDate != null) {
          dateOfBirthController.text = DateFormat('yyyy-MM-dd').format(pickedDate);
        }
      },
      child: CommonTextFieldWidget(
        controller: dateOfBirthController,
        hintText: 'Select Date of Birth',
        keyboardType: TextInputType.none,
        prefixIcon: Padding(
          padding: EdgeInsets.all(10),
          child: Icon(
            Icons.calendar_today,
            color: Theme.of(context).brightness == Brightness.dark 
                ? AppColors.textSecondaryDark 
                : AppColors.grey929,
            size: 20,
          ),
        ),
      ),
    );

  Widget _buildSaveButton() => Container(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: editProfile,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.redCA0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
          elevation: 2,
        ),
        child: Obx(() => loginController.isLoading.value
            ? SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  color: AppColors.white,
                  strokeWidth: 2,
                ),
              )
            : CommonTextWidget.PoppinsMedium(
                text: 'Save Changes',
                color: AppColors.white,
                fontSize: 16,
              )),
      ),
    );
}
