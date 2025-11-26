import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/widgets/common_text_widget.dart';
import '../../../../../main.dart';
import '../../../../../shared/constants/images.dart';
import '../../../../../shared/constants/font_family.dart';
import '../../../../auth/presentation/controllers/login_controller.dart';

class EditProfileScreen extends StatefulWidget {
  EditProfileScreen({Key? key}) : super(key: key);

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final LoginController loginController = Get.find<LoginController>();

  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController dateOfBirthController = TextEditingController();
  final TextEditingController nationalityController = TextEditingController();
  final TextEditingController emailIdController = TextEditingController();
  final TextEditingController mobileNumberController = TextEditingController();

  // Gender dropdown
  String? selectedGender;
  final List<String> genderOptions = ['Male', 'Female', 'Other'];

  DateTime now = DateTime.now();
  late String formattedDate;
  
  // Form validation
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

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
      setState(() {
        // Populate name
        fullNameController.text = userData['firstName'] ?? userData['name'] ?? '';
        
        // Populate gender - match with dropdown options
        String gender = userData['gender'] ?? '';
        if (gender.isNotEmpty) {
          // Normalize gender value to match dropdown options
          String normalizedGender = gender;
          if (gender.toLowerCase() == 'm' || gender.toLowerCase() == 'male') {
            normalizedGender = 'Male';
          } else if (gender.toLowerCase() == 'f' || gender.toLowerCase() == 'female') {
            normalizedGender = 'Female';
          } else if (gender.toLowerCase() == 'o' || gender.toLowerCase() == 'other') {
            normalizedGender = 'Other';
          }
          selectedGender = genderOptions.contains(normalizedGender) ? normalizedGender : null;
        } else {
          selectedGender = null;
        }
        
        // Format date properly if it exists
        String dob = userData['dob'] ?? userData['dateOfBirth'] ?? '';
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
        
        // Populate nationality
        nationalityController.text = userData['nationality'] ?? '';
        
        // Populate email
        emailIdController.text = userData['email'] ?? '';
        
        // Populate phone number - backend returns "mobile" field
        mobileNumberController.text = userData['mobile'] ?? '';
      });
    }
  }

  Future<void> _refreshProfile() async {
    await _loadUserProfile();
  }

  // Email validation
  bool _isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  // Phone validation
  bool _isValidPhone(String phone) {
    // Remove spaces and special characters for validation
    String cleanedPhone = phone.replaceAll(RegExp(r'[^\d]'), '');
    return cleanedPhone.length >= 10;
  }

  Future<void> editProfile() async {
    // Validate form
    if (!_formKey.currentState!.validate()) {
      return;
    }

    // Validate required fields
    if (fullNameController.text.trim().isEmpty) {
      Get.snackbar('Error', 'Please enter your name');
      return;
    }

    if (emailIdController.text.trim().isEmpty) {
      Get.snackbar('Error', 'Please enter your email');
      return;
    }

    // Validate email format
    if (!_isValidEmail(emailIdController.text.trim())) {
      Get.snackbar('Error', 'Please enter a valid email address');
      return;
    }

    // Validate phone number if provided
    if (mobileNumberController.text.trim().isNotEmpty) {
      if (!_isValidPhone(mobileNumberController.text.trim())) {
        Get.snackbar('Error', 'Please enter a valid phone number (at least 10 digits)');
        return;
      }
    }

    // Prepare profile data
    final Map<String, dynamic> profileData = {
      'firstName': fullNameController.text.trim(),
      'email': emailIdController.text.trim(),
    };

    // Add gender if selected - convert to backend format (M/F/O)
    if (selectedGender != null && selectedGender!.isNotEmpty) {
      String genderCode = selectedGender!;
      if (genderCode == 'Male') {
        genderCode = 'M';
      } else if (genderCode == 'Female') {
        genderCode = 'F';
      } else if (genderCode == 'Other') {
        genderCode = 'O';
      }
      profileData['gender'] = genderCode;
    }
    
    // Add date of birth if provided
    if (dateOfBirthController.text.trim().isNotEmpty) {
      profileData['dob'] = dateOfBirthController.text.trim();
    }
    
    // Add phone number if provided - backend expects "mobile" not "phoneNumber"
    if (mobileNumberController.text.trim().isNotEmpty) {
      // Clean phone number (remove spaces and special characters)
      String cleanedPhone = mobileNumberController.text.trim().replaceAll(RegExp(r'[^\d]'), '');
      profileData['mobile'] = cleanedPhone; // Backend expects "mobile"
    }
    
    // Add nationality if provided
    if (nationalityController.text.trim().isNotEmpty) {
      profileData['nationality'] = nationalityController.text.trim();
    }

    // Enhanced logging
    print('═══════════════════════════════════════════════════');
    print('📤 [EDIT PROFILE] Preparing to send profile data:');
    print('   - firstName: "${profileData['firstName']}"');
    print('   - email: "${profileData['email']}"');
    print('   - gender: ${profileData['gender'] ?? 'NOT PROVIDED'}');
    print('   - dob: ${profileData['dob'] ?? 'NOT PROVIDED'}');
    print('   - mobile: ${profileData['mobile'] ?? 'NOT PROVIDED'}');
    print('   - nationality: ${profileData['nationality'] ?? 'NOT PROVIDED'}');
    print('   - Total fields: ${profileData.length}');
    print('   - Full data map: $profileData');
    print('═══════════════════════════════════════════════════');

    final success = await loginController.updateUserProfile(profileData);
    
    if (success) {
      // Refresh profile data after successful update
      await loginController.fetchUserProfile();
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
          child: Form(
            key: _formKey,
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
                  _buildField(
                    fullNameController, 
                    'Enter your name', 
                    profileIcon,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter your name';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 15),
                  _buildLabel('Gender'),
                  _buildGenderDropdown(),
                  SizedBox(height: 15),
                  _buildLabel('Date of Birth'),
                  _buildDateField(),
                  SizedBox(height: 15),
                  _buildLabel('Nationality'),
                  _buildField(nationalityController, 'Enter nationality', null, isImage: true),
                  SizedBox(height: 15),
                  _buildLabel('Email ID'),
                  _buildField(
                    emailIdController, 
                    'Enter your email', 
                    emailIcon,
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter your email';
                      }
                      if (!_isValidEmail(value.trim())) {
                        return 'Please enter a valid email address';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 15),
                  _buildLabel('Mobile No.'),
                  _buildField(
                    mobileNumberController, 
                    'Enter mobile number', 
                    smartphoneIcon,
                    keyboardType: TextInputType.phone,
                    validator: (value) {
                      if (value != null && value.trim().isNotEmpty) {
                        if (!_isValidPhone(value.trim())) {
                          return 'Please enter a valid phone number';
                        }
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 30),
                  // Save button at bottom
                  _buildSaveButton(),
                  SizedBox(height: 30),
                ],
              ),
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
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) => TextFormField(
      controller: controller,
      keyboardType: keyboardType ?? TextInputType.text,
      validator: validator,
      cursorColor: Theme.of(context).brightness == Brightness.dark 
          ? AppColors.textPrimaryDark 
          : AppColors.black2E2,
      style: TextStyle(
        color: Theme.of(context).brightness == Brightness.dark 
            ? AppColors.textPrimaryDark 
            : AppColors.black2E2,
        fontSize: 14,
        fontFamily: FontFamily.PoppinsRegular,
      ),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(
          color: Theme.of(context).brightness == Brightness.dark 
              ? AppColors.textHintDark 
              : AppColors.grey929,
          fontSize: 14,
          fontFamily: FontFamily.PoppinsMedium,
        ),
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
        filled: true,
        fillColor: Theme.of(context).brightness == Brightness.dark 
            ? AppColors.surfaceDark 
            : AppColors.white,
        contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide(
            color: Theme.of(context).brightness == Brightness.dark 
                ? AppColors.borderDark 
                : AppColors.grey929,
            width: 1.5,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide(
            color: Theme.of(context).brightness == Brightness.dark 
                ? AppColors.borderDark 
                : AppColors.grey929,
            width: 1.5,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide(color: AppColors.redCA0, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide(color: Colors.red, width: 1.5),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide(color: Colors.red, width: 1.5),
        ),
      ),
    );

  Widget _buildGenderDropdown() => Container(
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.dark 
            ? AppColors.surfaceDark 
            : AppColors.white,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(
          color: Theme.of(context).brightness == Brightness.dark 
              ? AppColors.borderDark 
              : AppColors.grey929,
          width: 1.5,
        ),
      ),
      child: DropdownButtonFormField<String>(
        value: selectedGender,
        decoration: InputDecoration(
          hintText: 'Select gender',
          hintStyle: TextStyle(
            color: Theme.of(context).brightness == Brightness.dark 
                ? AppColors.textHintDark 
                : AppColors.grey929,
            fontSize: 14,
            fontFamily: FontFamily.PoppinsMedium,
          ),
          prefixIcon: Padding(
            padding: EdgeInsets.all(10),
            child: SizedBox(
              height: 20,
              width: 20,
              child: SvgPicture.asset(genderIcon),
            ),
          ),
          filled: true,
          fillColor: Colors.transparent,
          contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
        ),
        style: TextStyle(
          color: Theme.of(context).brightness == Brightness.dark 
              ? AppColors.textPrimaryDark 
              : AppColors.black2E2,
          fontSize: 14,
          fontFamily: FontFamily.PoppinsRegular,
        ),
        icon: Icon(
          Icons.arrow_drop_down,
          color: Theme.of(context).brightness == Brightness.dark 
              ? AppColors.textSecondaryDark 
              : AppColors.grey929,
        ),
        dropdownColor: Theme.of(context).brightness == Brightness.dark 
            ? AppColors.surfaceDark 
            : AppColors.white,
        items: genderOptions.map((String gender) {
          return DropdownMenuItem<String>(
            value: gender,
            child: Text(gender),
          );
        }).toList(),
        onChanged: (String? newValue) {
          setState(() {
            selectedGender = newValue;
          });
        },
      ),
    );

  Widget _buildDateField() => InkWell(
      onTap: () async {
        // Determine initial date - use existing DOB if available, otherwise default to 20 years ago
        DateTime initialDate = DateTime.now().subtract(Duration(days: 365 * 20));
        if (dateOfBirthController.text.isNotEmpty) {
          try {
            initialDate = DateTime.parse(dateOfBirthController.text);
          } catch (e) {
            // If parsing fails, use default
          }
        }
        
        final DateTime? pickedDate = await showDatePicker(
          context: context,
          initialDate: initialDate,
          firstDate: DateTime(1900),
          lastDate: DateTime.now(),
          builder: (context, child) {
            return Theme(
              data: Theme.of(context).copyWith(
                colorScheme: ColorScheme.light(
                  primary: AppColors.redCA0,
                  onPrimary: AppColors.white,
                  onSurface: Theme.of(context).brightness == Brightness.dark 
                      ? AppColors.textPrimaryDark 
                      : AppColors.black2E2,
                ),
              ),
              child: child!,
            );
          },
        );
        
        if (pickedDate != null) {
          setState(() {
            dateOfBirthController.text = DateFormat('yyyy-MM-dd').format(pickedDate);
          });
        }
      },
      child: TextFormField(
        controller: dateOfBirthController,
        keyboardType: TextInputType.none,
        enabled: false,
        style: TextStyle(
          color: Theme.of(context).brightness == Brightness.dark 
              ? AppColors.textPrimaryDark 
              : AppColors.black2E2,
          fontSize: 14,
          fontFamily: FontFamily.PoppinsRegular,
        ),
        decoration: InputDecoration(
          hintText: 'Select Date of Birth',
          hintStyle: TextStyle(
            color: Theme.of(context).brightness == Brightness.dark 
                ? AppColors.textHintDark 
                : AppColors.grey929,
            fontSize: 14,
            fontFamily: FontFamily.PoppinsMedium,
          ),
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
          filled: true,
          fillColor: Theme.of(context).brightness == Brightness.dark 
              ? AppColors.surfaceDark 
              : AppColors.white,
          contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide(
              color: Theme.of(context).brightness == Brightness.dark 
                  ? AppColors.borderDark 
                  : AppColors.grey929,
              width: 1.5,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide(
              color: Theme.of(context).brightness == Brightness.dark 
                  ? AppColors.borderDark 
                  : AppColors.grey929,
              width: 1.5,
            ),
          ),
          disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide(
              color: Theme.of(context).brightness == Brightness.dark 
                  ? AppColors.borderDark 
                  : AppColors.grey929,
              width: 1.5,
            ),
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
