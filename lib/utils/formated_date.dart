import 'package:intl/intl.dart';

String formattedDate(String dateStringValue) {
  return DateFormat(
    'dd/MM/yyyy, hh:mm',
  ).format(DateTime.parse(dateStringValue));
}
