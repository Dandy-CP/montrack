import 'package:flutter/material.dart';
import 'package:montrack/widget/elements/button.dart';

class Dialogs {
  static void show({
    required BuildContext context,
    required String title,
    required String content,
    bool isPending = false,
    void Function()? onYesPressed,
  }) {
    if (context.mounted) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(title),
          content: Text(content),
          actionsAlignment: MainAxisAlignment.spaceBetween,
          actions: [
            Button(
              label: 'No',
              variant: 'outlined',
              width: 130,
              isLoading: isPending,
              disabled: isPending,
              onPressed: () => Navigator.pop(context),
            ),
            Button(
              label: 'Yes',
              width: 130,
              isLoading: isPending,
              disabled: isPending,
              onPressed: () {
                onYesPressed!();
              },
            ),
          ],
        ),
      );
    }
  }
}
