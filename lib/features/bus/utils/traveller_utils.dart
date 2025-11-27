import 'package:get/get.dart';

class TravellerUtils {
  static bool isTravellerComplete(Map<String, dynamic> traveller) {
    final name = traveller['passengerName'] ?? traveller['firstname'] ?? '';
    final age = traveller['passengerAge'] ?? traveller['age'];
    final gender = traveller['passengerGender'] ?? traveller['gender'];
    final mobile = traveller['passengerMobileNumber'] ??
        traveller['mobile'] ??
        traveller['phone'] ??
        '';
    final email = traveller['contact_email'] ?? traveller['email'] ?? '';
    final address = traveller['address'] ?? '';

    // Check if all mandatory fields are present and valid
    bool hasName = name.toString().trim().isNotEmpty && name != 'Unknown';
    bool hasAge = age != null &&
        (age is int ? age > 0 : (int.tryParse(age.toString()) ?? 0) > 0);
    bool hasGender = gender != null && gender.toString().trim().isNotEmpty;
    bool hasMobile = mobile.toString().trim().isNotEmpty &&
        mobile != '0000000000' &&
        mobile.toString().replaceAll(RegExp(r'[^\d]'), '').length >= 10;
    bool hasEmail = email.toString().trim().isNotEmpty &&
        GetUtils.isEmail(email.toString().trim());
    bool hasAddress = address.toString().trim().isNotEmpty;

    return hasName &&
        hasAge &&
        hasGender &&
        hasMobile &&
        hasEmail &&
        hasAddress;
  }

  static List<String> getMissingFields(Map<String, dynamic> traveller) {
    final missing = <String>[];
    final name = traveller['passengerName'] ?? traveller['firstname'] ?? '';
    final age = traveller['passengerAge'] ?? traveller['age'];
    final gender = traveller['passengerGender'] ?? traveller['gender'];
    final mobile = traveller['passengerMobileNumber'] ??
        traveller['mobile'] ??
        traveller['phone'] ??
        '';
    final email = traveller['contact_email'] ?? traveller['email'] ?? '';
    final address = traveller['address'] ?? '';

    if (name.toString().trim().isEmpty || name == 'Unknown')
      missing.add('Name');
    if (age == null ||
        (age is int ? age <= 0 : (int.tryParse(age.toString()) ?? 0) <= 0))
      missing.add('Age');
    if (gender == null || gender.toString().trim().isEmpty)
      missing.add('Gender');
    if (mobile.toString().trim().isEmpty ||
        mobile == '0000000000' ||
        mobile.toString().replaceAll(RegExp(r'[^\d]'), '').length < 10)
      missing.add('Mobile');
    if (email.toString().trim().isEmpty ||
        !GetUtils.isEmail(email.toString().trim())) missing.add('Email');
    if (address.toString().trim().isEmpty) missing.add('Address');

    return missing;
  }
}
