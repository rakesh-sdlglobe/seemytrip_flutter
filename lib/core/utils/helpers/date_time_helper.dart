import 'package:intl/intl.dart';

class DateTimeHelper {
  /// Format a DateTime to a string with the given format
  ///
  /// Example:
  /// ```dart
  /// formatDate(DateTime(2023, 1, 1), 'yyyy-MM-dd') // '2023-01-01'
  /// formatDate(DateTime(2023, 1, 1), 'MMM dd, yyyy') // 'Jan 01, 2023'
  /// ```
  static String formatDate(DateTime date, String format) {
    return DateFormat(format).format(date);
  }

  /// Parse a string to DateTime with the given format
  ///
  /// Example:
  /// ```dart
  /// parseDate('2023-01-01', 'yyyy-MM-dd') // DateTime(2023, 1, 1)
  /// ```
  static DateTime? parseDate(String dateString, String format) {
    try {
      return DateFormat(format).parse(dateString);
    } catch (e) {
      return null;
    }
  }

  /// Get a human-readable time difference between two dates
  ///
  /// Example:
  /// ```dart
  /// getTimeAgo(DateTime.now().subtract(Duration(hours: 2))) // '2 hours ago'
  /// ```
  static String getTimeAgo(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays > 365) {
      final years = (difference.inDays / 365).floor();
      return '$years ${years == 1 ? 'year' : 'years'} ago';
    } else if (difference.inDays > 30) {
      final months = (difference.inDays / 30).floor();
      return '$months ${months == 1 ? 'month' : 'months'} ago';
    } else if (difference.inDays > 0) {
      return '${difference.inDays} ${difference.inDays == 1 ? 'day' : 'days'} ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} ${difference.inHours == 1 ? 'hour' : 'hours'} ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} ${difference.inMinutes == 1 ? 'minute' : 'minutes'} ago';
    } else {
      return 'just now';
    }
  }

  /// Check if a date is today
  static bool isToday(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year &&
        date.month == now.month &&
        date.day == now.day;
  }

  /// Check if a date is yesterday
  static bool isYesterday(DateTime date) {
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    return date.year == yesterday.year &&
        date.month == yesterday.month &&
        date.day == yesterday.day;
  }

  /// Get the start of the day (00:00:00)
  static DateTime startOfDay(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }

  /// Get the end of the day (23:59:59.999)
  static DateTime endOfDay(DateTime date) {
    return DateTime(date.year, date.month, date.day, 23, 59, 59, 999);
  }

  /// Get the start of the week (Monday)
  static DateTime startOfWeek(DateTime date) {
    // Find the previous Monday
    return date.subtract(Duration(days: date.weekday - 1));
  }

  /// Get the end of the week (Sunday)
  static DateTime endOfWeek(DateTime date) {
    // Find the next Sunday
    return date.add(Duration(days: DateTime.daysPerWeek - date.weekday));
  }

  /// Get the start of the month
  static DateTime startOfMonth(DateTime date) {
    return DateTime(date.year, date.month, 1);
  }

  /// Get the end of the month
  static DateTime endOfMonth(DateTime date) {
    return DateTime(date.year, date.month + 1, 0, 23, 59, 59, 999);
  }

  /// Format a duration in HH:MM:SS format
  static String formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(duration.inHours);
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));

    if (duration.inHours > 0) {
      return '$hours:$minutes:$seconds';
    } else {
      return '$minutes:$seconds';
    }
  }

  /// Get the age from a birth date
  static int calculateAge(DateTime birthDate) {
    final now = DateTime.now();
    int age = now.year - birthDate.year;

    // Adjust age if birthday hasn't occurred yet this year
    if (now.month < birthDate.month ||
        (now.month == birthDate.month && now.day < birthDate.day)) {
      age--;
    }

    return age;
  }

  /// Check if a year is a leap year
  static bool isLeapYear(int year) {
    return (year % 4 == 0 && year % 100 != 0) || (year % 400 == 0);
  }

  /// Convert 24-hour time string (HH:mm) to 12-hour format (hh:mm AM/PM)
  static String convertTo12HourFormat(String time24) {
    if (time24.isEmpty || time24 == '--:--' || !time24.contains(':')) {
      return time24;
    }

    try {
      final parts = time24.split(':');
      if (parts.length != 2) return time24;

      int hour = int.tryParse(parts[0]) ?? 0;
      int minute = int.tryParse(parts[1]) ?? 0;

      if (hour < 0 || hour > 23 || minute < 0 || minute > 59) {
        return time24;
      }

      String period = hour >= 12 ? 'PM' : 'AM';
      int hour12 = hour == 0 ? 12 : (hour > 12 ? hour - 12 : hour);
      String minuteStr = minute.toString().padLeft(2, '0');

      return '$hour12:$minuteStr $period';
    } catch (e) {
      return time24;
    }
  }
}
