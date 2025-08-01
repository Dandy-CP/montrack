import 'package:flutter/material.dart';

enum SnackBarsVariant { success, warning, error }

class SnackBars {
  static void show({
    required BuildContext context,
    required String message,
    SnackBarsVariant? type,
  }) {
    Color colors;

    switch (type) {
      case SnackBarsVariant.success:
        colors = Colors.green;
      case SnackBarsVariant.warning:
        colors = Colors.yellow;
      case SnackBarsVariant.error:
        colors = Colors.redAccent;
      default:
        colors = Colors.green;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
        ),
        backgroundColor: colors,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
