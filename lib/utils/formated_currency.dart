import 'package:intl/intl.dart';

String formattedCurrency(int amount) {
  return NumberFormat.simpleCurrency(
    locale: 'id',
    decimalDigits: 0,
  ).format(amount);
}
