import 'package:flutter/material.dart';

class Button extends StatefulWidget {
  const Button({
    super.key,
    this.variant = 'default',
    this.onPressed,
    required this.label,
    this.width = double.infinity,
    this.disabled = false,
    this.style,
    this.isLoading = false,
    this.textColor = const Color(0xFF3077E3),
  });

  final String variant; // default | outlined
  final VoidCallback? onPressed;
  final String label;
  final double? width;
  final bool disabled;
  final ButtonStyle? style;
  final bool isLoading;
  final Color? textColor;

  @override
  State<Button> createState() => _ButtonState();
}

class _ButtonState extends State<Button> {
  @override
  Widget build(BuildContext context) {
    switch (widget.variant) {
      case 'outlined':
        return SizedBox(
          width: widget.width,
          child: OutlinedButton(
            onPressed: !widget.disabled
                ? () {
                    if (widget.onPressed != null) {
                      widget.onPressed!();
                    }
                  }
                : null,
            style: widget.style,
            child: widget.isLoading
                ? CircularProgressIndicator(
                    color: Colors.white,
                    constraints: BoxConstraints(minHeight: 25, minWidth: 25),
                  )
                : Text(widget.label, style: TextStyle(color: widget.textColor)),
          ),
        );

      default:
        return SizedBox(
          width: widget.width,
          child: ElevatedButton(
            onPressed: !widget.disabled
                ? () {
                    if (widget.onPressed != null) {
                      widget.onPressed!();
                    }
                  }
                : null,
            style: widget.style,
            child: widget.isLoading
                ? CircularProgressIndicator(
                    color: Colors.white,
                    constraints: BoxConstraints(minHeight: 25, minWidth: 25),
                  )
                : Text(widget.label),
          ),
        );
    }
  }
}
