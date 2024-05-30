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
}
