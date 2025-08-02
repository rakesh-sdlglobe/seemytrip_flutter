import 'package:flutter/material.dart';
import 'dart:convert';

/// Extensions on [String] to provide common utilities
/// 
/// Example:
/// ```dart
/// 'hello'.capitalize() // 'Hello'
/// 'hello'.isValidEmail // false
/// 'user@example.com'.isValidEmail // true
/// ```
extension StringExtensions on String {
  /// Capitalizes the first letter of the string
  String capitalize() {
    if (isEmpty) return this;
    return '${this[0].toUpperCase()}${substring(1).toLowerCase()}';
  }

  /// Capitalizes the first letter of each word in the string
  String toTitleCase() {
    if (isEmpty) return this;
    return split(' ').map((word) => word.capitalize()).join(' ');
  }

  /// Returns true if the string is a valid email address
  bool get isValidEmail {
    final emailRegExp = RegExp(
      r'^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+',
    );
    return emailRegExp.hasMatch(this);
  }

  /// Returns true if the string is a valid phone number
  bool get isValidPhone {
    final phoneRegExp = RegExp(r'^\+?[0-9]{10,15}$');
    return phoneRegExp.hasMatch(this);
  }

  /// Returns true if the string is a valid URL
  bool get isValidUrl {
    try {
      Uri.parse(this);
      return true;
    } catch (_) {
      return false;
    }
  }

  /// Returns true if the string is a valid date
  bool get isValidDate {
    try {
      DateTime.parse(this);
      return true;
    } catch (_) {
      return false;
    }
  }

  /// Truncates the string if it's longer than [maxLength] and adds an ellipsis
  String truncateWithEllipsis(int maxLength) {
    if (length <= maxLength) return this;
    return '${substring(0, maxLength)}...';
  }

  /// Returns the string with the first [n] characters
  String firstChars(int n) => length <= n ? this : substring(0, n);

  /// Returns the string with the last [n] characters
  String lastChars(int n) => length <= n ? this : substring(length - n);

  /// Returns true if the string is null or empty
  bool get isNullOrEmpty => trim().isEmpty;

  /// Returns true if the string is not null and not empty
  bool get isNotNullOrEmpty => !isNullOrEmpty;

  /// Returns the string with only the first letter capitalized
  String get capitalizeFirstOfEach => split(" ").map((str) => str.capitalize()).join(" ");

  /// Returns a color from a hex string
  /// 
  /// Example:
  /// ```dart
  /// '#FF5733'.toColor() // Color(0xFFFF5733)
  /// 'FF5733'.toColor() // Color(0xFFFF5733)
  /// ```
  Color toColor() {
    String hexColor = this;
    if (hexColor.startsWith('#')) {
      hexColor = hexColor.substring(1);
    }
    
    if (hexColor.length == 6) {
      hexColor = 'FF$hexColor';
    }
    
    return Color(
      int.parse(hexColor, radix: 16),
    );
  }

  /// Parses the string to a double, returns null if parsing fails
  double? toDoubleOrNull() {
    try {
      return double.parse(this);
    } catch (_) {
      return null;
    }
  }

  /// Parses the string to an int, returns null if parsing fails
  int? toIntOrNull() {
    try {
      return int.parse(this);
    } catch (_) {
      return null;
    }
  }

  /// Returns true if the string is a valid JSON
  bool get isJson {
    try {
      // ignore: unused_local_variable
      final json = jsonDecode(this) as Map<String, dynamic>;
      return true;
    } catch (_) {
      return false;
    }
  }

  /// Returns the string with all whitespace removed
  String removeAllWhitespace() => replaceAll(RegExp(r'\s+'), '');

  /// Returns the string with only digits
  String get digitsOnly => replaceAll(RegExp(r'[^0-9]'), '');

  /// Returns the string with only letters
  String get lettersOnly => replaceAll(RegExp(r'[^a-zA-Z]'), '');

  /// Returns the string with only alphanumeric characters
  String get alphanumericOnly => replaceAll(RegExp(r'[^a-zA-Z0-9]'), '');

  /// Returns the string with the first [length] characters
  String take(int length) => substring(0, length.clamp(0, this.length));

  /// Returns the string with the last [length] characters
  String takeLast(int length) => substring((this.length - length).clamp(0, this.length));
}
