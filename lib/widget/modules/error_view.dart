import 'package:flutter/material.dart';
import 'package:montrack/widget/elements/button.dart';

class ErrorView extends StatefulWidget {
  const ErrorView({super.key, this.onTap});

  final void Function()? onTap;

  @override
  State<ErrorView> createState() => _ErrorViewState();
}

class _ErrorViewState extends State<ErrorView> {
  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 20,
      children: [
        Image.asset('assets/images/error_image.png', scale: 2),
        Text(
          'Ops Something Wrong, Please Try Again',
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
        ),
        Button(
          label: 'Try Again',
          onPressed: () => widget.onTap != null ? widget.onTap!() : null,
        ),
      ],
    );
  }
}
