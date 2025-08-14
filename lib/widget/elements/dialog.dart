import 'package:flutter/material.dart';
import 'package:montrack/widget/elements/button.dart';

class Dialogs {
  static void show({
    required BuildContext context,
    required String title,
    String? content,
    void Function()? onYesPressed,
  }) {
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: Text(title),
            content: content != null ? Text(content) : null,
            actionsAlignment: MainAxisAlignment.spaceBetween,
            actions: [
              Button(
                label: 'No',
                variant: 'outlined',
                width: MediaQuery.of(context).size.width * 0.33,
                onPressed: () => Navigator.pop(context),
              ),
              Button(
                label: 'Yes',
                width: MediaQuery.of(context).size.width * 0.33,
                onPressed: () {
                  if (onYesPressed != null) {
                    onYesPressed();
                  }

                  Navigator.pop(context);
                },
              ),
            ],
          );
        },
      ),
    );
  }
}
