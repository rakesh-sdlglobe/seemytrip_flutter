import 'package:seemytrip/core/theme/app_colors.dart';
import 'package:seemytrip/core/theme/app_text_styles.dart';

/// A utility class for form validations
class FormValidator {
  /// Validates if the input is not empty
  static String? validateRequired(String? value, {String? fieldName}) {
    if (value == null || value.trim().isEmpty) {
      return fieldName != null 
          ? '$fieldName is required' 
          : 'This field is required';
    }
    return null;
  }

  /// Validates email format
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }
    
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9.!#$%&''*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*'
    );
    
    if (!emailRegex.hasMatch(value)) {
      return 'Please enter a valid email address';
    }
    
    return null;
  }

  /// Validates password strength
  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    
    if (value.length < 8) {
      return 'Password must be at least 8 characters long';
    }
    
    if (!value.contains(RegExp(r'[A-Z]'))) {
      return 'Password must contain at least one uppercase letter';
    }
    
    if (!value.contains(RegExp(r'[0-9]'))) {
      return 'Password must contain at least one number';
    }
    
    if (!value.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
      return 'Password must contain at least one special character';
    }
    
    return null;
  }

  /// Validates phone number format
  static String? validatePhoneNumber(String? value, {bool isRequired = true}) {
    if ((value == null || value.isEmpty)) {
      return isRequired ? 'Phone number is required' : null;
    }
    
    final phoneRegex = RegExp(r'^[+]*[(]{0,1}[0-9]{1,4}[)]{0,1}[-\s\./0-9]*$');
    
    if (!phoneRegex.hasMatch(value)) {
      return 'Please enter a valid phone number';
    }
    
    // Remove all non-digit characters and check length
    final digitsOnly = value.replaceAll(RegExp(r'[^0-9]'), '');
    if (digitsOnly.length < 10) {
      return 'Phone number is too short';
    }
    
    return null;
  }

  /// Validates if two fields match (e.g., password confirmation)
  static String? validateMatch(
    String? value1, 
    String? value2, 
    String field1Name, 
    String field2Name,
  ) {
    if (value1 != value2) {
      return '$field1Name does not match $field2Name';
    }
    return null;
  }

  /// Validates a credit card number
  static String? validateCreditCard(String? value) {
    if (value == null || value.isEmpty) {
      return 'Card number is required';
    }
    
    // Remove all non-digit characters
    final digitsOnly = value.replaceAll(RegExp(r'[^0-9]'), '');
    
    // Check if the card number is valid using Luhn algorithm
    if (!_isValidLuhn(digitsOnly)) {
      return 'Invalid card number';
    }
    
    // Check card length based on card type (simplified)
    if (digitsOnly.length < 13 || digitsOnly.length > 19) {
      return 'Invalid card number length';
    }
    
    return null;
  }

  /// Validates a CVV code
  static String? validateCVV(String? value) {
    if (value == null || value.isEmpty) {
      return 'CVV is required';
    }
    
    if (!RegExp(r'^[0-9]{3,4}$').hasMatch(value)) {
      return 'Invalid CVV';
    }
    
    return null;
  }

  /// Validates an expiration date in MM/YY format
  static String? validateExpiryDate(String? value) {
    if (value == null || value.isEmpty) {
      return 'Expiry date is required';
    }
    
    if (!RegExp(r'^(0[1-9]|1[0-2])/?([0-9]{2})$').hasMatch(value)) {
      return 'Invalid expiry date format (MM/YY)';
    }
    
    final parts = value.split('/');
    final month = int.tryParse(parts[0]) ?? 0;
    final year = int.tryParse(parts[1]) ?? 0;
    
    if (month < 1 || month > 12) {
      return 'Invalid month';
    }
    
    final now = DateTime.now();
    final currentYear = now.year % 100; // Last two digits
    final currentMonth = now.month;
    
    if (year < currentYear || (year == currentYear && month < currentMonth)) {
      return 'Card has expired';
    }
    
    return null;
  }

  /// Validates a URL
  static String? validateUrl(String? value, {bool isRequired = true}) {
    if (value == null || value.isEmpty) {
      return isRequired ? 'URL is required' : null;
    }
    
    final urlRegex = RegExp(
      r'^(https?:\/\/)?' // protocol
      r'(([a-zA-Z0-9]([a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?\.)+[a-zA-Z]{2,}' // domain
      r'|\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3})' // OR ip (v4) address
      r'(\:\d+)?' // port
      r'(\/[-a-zA-Z0-9%_.~+]*)*' // path
      r'(\?[;&a-zA-Z0-9%_.~+=-]*)?' // query string
      r'(\#[-a-zA-Z0-9_]*)?$', // fragment locator
    );
    
    if (!urlRegex.hasMatch(value)) {
      return 'Please enter a valid URL';
    }
    
    return null;
  }

  // Helper method to validate credit card using Luhn algorithm
  static bool _isValidLuhn(String number) {
    int sum = 0;
    bool alternate = false;
    
    for (int i = number.length - 1; i >= 0; i--) {
      int n = int.parse(number[i]);
      
      if (alternate) {
        n *= 2;
        if (n > 9) {
          n = (n ~/ 10) + (n % 10);
        }
      }
      
      sum += n;
      alternate = !alternate;
    }
    
    return (sum % 10 == 0);
  }
}
