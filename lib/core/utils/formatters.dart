import 'package:intl/intl.dart';

class Formatters {
  static String formatPrice(num price) {
    if (price == 0) return 'Free';
    final formatter = NumberFormat.currency(
      locale: 'es_ES',
      symbol: '€',
      decimalDigits: 2,
    );
    return formatter.format(price);
  }
}
