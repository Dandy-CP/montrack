import 'package:flutter/material.dart';

class DateRangePicker {
  static Future<void> show({
    required BuildContext context,
    required DateTimeRange? selectedDateRange,
    required void Function(DateTimeRange<DateTime>) onDatePicked,
  }) async {
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2000),
      lastDate: DateTime(2050),
      initialDateRange: selectedDateRange,
    );

    if (picked != null && picked != selectedDateRange) {
      onDatePicked(picked);
    }
  }
}
