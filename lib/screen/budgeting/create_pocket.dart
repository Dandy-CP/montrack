import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:montrack/widget/elements/button.dart';
import 'package:montrack/widget/elements/input.dart';
import 'package:montrack/widget/modules/app_bar.dart';

class CreatePocket extends StatefulWidget {
  const CreatePocket({super.key});

  @override
  State<CreatePocket> createState() => _CreatePocketState();
}

class _CreatePocketState extends State<CreatePocket> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String pocketName = '';
  String amount = '';
  String pocketDescription = '';

  void handleOnAddPocket() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Form Submitted'),
          content: Text(
            'Inputted, '
            'Pocket Name: $pocketName, Amount: $amount, Description: $pocketDescription',
          ),
          actions: [
            TextButton(
              onPressed: () => {Navigator.pop(context), context.pop()},
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(
        title: 'Add New Pocket',
        showLeading: true,
        onBack: () {
          context.pop();
        },
      ),
      body: Padding(
        padding: EdgeInsetsGeometry.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Form(
              key: _formKey,
              child: Column(
                spacing: 20,
                children: [
                  Input(
                    label: 'Name',
                    placeholder: 'Name Pocket',
                    onSaved: (value) => pocketName = value!,
                  ),
                  Input(
                    label: 'Amount',
                    placeholder: '0',
                    keyboardType: TextInputType.number,
                    prefixIcon: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [Text('IDR')],
                    ),
                    onSaved: (value) => amount = value!,
                  ),
                  Input(
                    label: 'Description',
                    placeholder: 'Description (Optional)',
                    variant: 'multiline',
                    keyboardType: TextInputType.multiline,
                    onSaved: (value) => pocketDescription = value!,
                  ),
                ],
              ),
            ),
            Button(label: 'Add Pocket', onPressed: () => handleOnAddPocket()),
          ],
        ),
      ),
    );
  }
}
