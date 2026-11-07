import 'package:intl/intl.dart';

class DateFormatter {
  static String formatOrderDate(DateTime dateTime) {
    return DateFormat('dd MMM yyyy, hh:mm a').format(dateTime);
  }

  static String formatShortDate(DateTime dateTime) {
    return DateFormat('dd MMM, hh:mm a').format(dateTime);
  }

  static String formatTime(DateTime dateTime) {
    return DateFormat('hh:mm a').format(dateTime);
  }
}
