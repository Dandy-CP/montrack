import 'package:flutter/material.dart';

class DropdownInput extends StatefulWidget {
  const DropdownInput({
    super.key,
    required this.label,
    required this.placeholder,
    required this.options,
    required this.selectedOption,
    required this.onSelected,
    this.onSaved,
    this.enabled = true,
  });

  final String label;
  final String placeholder;
  final String? selectedOption;
  final bool enabled;
  final void Function(String?) onSelected;
  final List<Map<String, dynamic>> options;
  final void Function(String?)? onSaved;

  @override
  State<DropdownInput> createState() => _DropdownInputState();
}

class _DropdownInputState extends State<DropdownInput> {
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

        DropdownButtonFormField<String>(
          value: widget.selectedOption,
          hint: Text(widget.placeholder),
          onChanged: widget.enabled ? widget.onSelected : null,
          onSaved: widget.onSaved,
          items: widget.options.map<DropdownMenuItem<String>>((optionValue) {
            String label = optionValue['label'];
            String value = optionValue['value'];

            return DropdownMenuItem<String>(value: value, child: Text(label));
          }).toList(),
          validator: (value) {
            if (value == null) {
              return 'Please select an option';
            }
            return null;
          },
        ),
      ],
    );
  }
}
