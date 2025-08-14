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
      builder: (context) => LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          return AlertDialog(
            title: Text(title),
            content: content != null ? Text(content) : null,
            actionsAlignment: MainAxisAlignment.spaceBetween,
            actions: [
              Button(
                label: 'No',
                variant: 'outlined',
                textColor: Colors.red,
                width: constraints.maxWidth * 0.3,
                style: ButtonStyle(
                  side: WidgetStateProperty.all(
                    BorderSide(color: Colors.red, width: 1.5),
                  ),
                ),
                onPressed: () => Navigator.pop(context),
              ),
              Button(
                label: 'Yes',
                width: constraints.maxWidth * 0.3,
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
