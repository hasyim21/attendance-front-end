import 'package:intl/intl.dart';

extension DateTimeExt on DateTime {
  /// Example Sabtu, 25 Mei 2024 (locale ID)
  String toFormattedDate() {
    return DateFormat('EEEE, d MMMM y', 'id_ID').format(this);
  }

  /// Example 09:00 AM or 05:00 PM
  String toFormattedTime() {
    return DateFormat('hh:mm a').format(this);
  }

  // /// Example 09:00 WIB or 17:00 WIB
  // String toFormattedTime() {
  //   return '${DateFormat('HH:mm').format(this)} WIB';
  // }

  // /// Example 09:00:00 WIB or 17:00:00 WIB
  // String toFormattedTimeWithSecond() {
  //   return '${DateFormat('HH:mm:ss').format(this)} WIB';
  // }

  /// Example 09:00:00 AM or 05:00:00 PM
  String toFormattedTimeWithSecond() {
    return DateFormat('hh:mm:ss a').format(this);
  }

  /// Example 01 Jun 2024
  String toShortFormattedDate() {
    return DateFormat('dd MMM y', 'id_ID').format(this);
  }

  /// Example 2024-06-01
  String toIsoFormattedDate() {
    return DateFormat('yyyy-MM-dd').format(this);
  }
}

extension StringDateTimeExt on String {
  /// Example 01 Juni 2024
  String toFormattedDate() {
    DateTime date = DateTime.parse(this);
    return DateFormat('dd MMMM yyyy', 'id_ID').format(date);
  }

  /// Example Sabtu, 25 Mei 2024 (locale ID)
  String toFormattedDatewithDay() {
    DateTime date = DateTime.parse(this);
    return DateFormat('EEEE, d MMMM y', 'id_ID').format(date);
  }

  /// Example 01 Jun 2024
  String toShortFormattedDate() {
    DateTime date = DateTime.parse(this);
    return DateFormat('dd MMM y', 'id_ID').format(date);
  }

  /// Example 09:00 AM or 5:00 PM
  String toFormattedTime() {
    // Parse waktu dengan format jam, menit, detik
    DateTime time = DateFormat('HH:mm:ss').parse(this);
    return DateFormat('hh:mm a').format(time);
  }

  // /// Example 09:00 WIB or 17:00 WIB
  // String toFormattedTime() {
  //   // Parse waktu dengan format jam, menit, detik
  //   DateTime time = DateFormat('HH:mm:ss').parse(this);
  //   return '${DateFormat('HH:mm').format(time)} WIB';
  // }

  /// Example 1
  String toFormattedShortDate() {
    DateTime date = DateTime.parse(this);
    return DateFormat('d', 'id_ID').format(date);
  }

  /// Example Jum
  String toFormattedDay() {
    DateTime date = DateTime.parse(this);
    return DateFormat('EEE', 'id_ID').format(date);
  }
}
