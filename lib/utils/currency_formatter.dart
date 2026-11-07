import 'package:intl/intl.dart';

class CurrencyFormatter {
  static final NumberFormat _formatter = NumberFormat.currency(
    locale: 'en_IN',
    symbol: '₹',
    decimalDigits: 0,
  );

  static final NumberFormat _formatterWithDecimals = NumberFormat.currency(
    locale: 'en_IN',
    symbol: '₹',
    decimalDigits: 2,
  );

  static String format(double amount) {
    if (amount % 1 == 0) {
      return _formatter.format(amount);
    }
    return _formatterWithDecimals.format(amount);
  }

  static String formatSimple(double amount) {
    return '₹${amount.toStringAsFixed(amount % 1 == 0 ? 0 : 2)}';
  }
}
