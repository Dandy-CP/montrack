import 'package:flutter/material.dart';

class Input extends StatefulWidget {
  const Input({
    super.key,
    this.variant = 'text',
    required this.label,
    required this.placeholder,
    this.enabled = true,
    this.readOnly = false,
    this.initialValue,
    this.isOptional = false,
    this.suffixIcon,
    this.prefixIcon,
    this.onSaved,
    this.onChanged,
    this.validator,
    this.keyboardType = TextInputType.text,
    this.onTap,
    this.controller,
  });

  final String variant; // 'text' || 'password' || 'multiline'
  final String label;
  final String placeholder;
  final bool enabled;
  final bool readOnly;
  final String? initialValue;
  final bool isOptional;
  final TextInputType keyboardType;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final void Function(String?)? onSaved;
  final void Function()? onTap;
  final TextEditingController? controller;

  @override
  State<Input> createState() => _InputState();
}

class _InputState extends State<Input> {
  bool isPasswordVisible = true;

  void togglePasswordVisibility() {
    setState(() {
      isPasswordVisible = !isPasswordVisible;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 5,
      children: [
        Text(
          widget.label,
          style: TextStyle(fontSize: 14, color: Colors.grey[700]),
        ),
        TextFormField(
          controller: widget.controller,
          enabled: widget.enabled,
          initialValue: widget.initialValue,
          keyboardType: widget.keyboardType,
          maxLines: widget.variant == 'multiline' ? null : 1,
          obscureText: widget.variant == 'password' && isPasswordVisible,
          onChanged: widget.onChanged,
          onSaved: widget.onSaved,
          onTap: widget.onTap,
          readOnly: widget.readOnly,
          decoration: InputDecoration(
            hintText: widget.placeholder,
            suffixIcon: widget.variant == 'password'
                ? IconButton(
                    onPressed: () {
                      togglePasswordVisibility();
                    },
                    icon: Icon(
                      isPasswordVisible
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined,
                    ),
                  )
                : widget.suffixIcon,
            prefixIcon: widget.prefixIcon,
          ),
          validator: !widget.isOptional
              ? widget.validator ??
                    (String? value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter ${widget.label.toLowerCase()}';
                      }

                      if (widget.variant == 'password' && value.length < 8) {
                        return 'Password must be 8 character';
                      }

                      return null;
                    }
              : null,
        ),
      ],
    );
  }
}
