import 'package:intl/intl.dart';

String formattedDate(String dateStringValue) {
  return DateFormat('dd/MM/yyyy').format(DateTime.parse(dateStringValue));
}
