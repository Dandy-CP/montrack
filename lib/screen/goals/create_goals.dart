import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:montrack/utils/logger.dart';
import 'package:montrack/widget/elements/button.dart';
import 'package:montrack/widget/elements/input.dart';
import 'package:montrack/widget/modules/app_bar.dart';

class CreateGoals extends StatefulWidget {
  const CreateGoals({super.key});

  @override
  State<CreateGoals> createState() => _CreateGoalsState();
}

class _CreateGoalsState extends State<CreateGoals> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String goalsName = '';
  String goalsAmount = '';
  String goalsDescription = '';
  File? previewImage;

  Future handlePickImage() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);

      if (image == null) return;

      final imageTemp = File(image.path);

      setState(() {
        previewImage = imageTemp;
      });
    } on PlatformException catch (error) {
      logger.e('Failed pick image', error: error);
    }
  }

  void handleCreateGoals() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Form Submitted'),
          content: Text(
            'Inputted, '
            'Pocket Name: $goalsName, Amount: $goalsAmount, Description: $goalsDescription',
          ),
          actions: [
            TextButton(
              onPressed: () => {Navigator.pop(context)},
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
        title: 'Create Goals',
        showLeading: true,
        onBack: () {
          context.pop();
        },
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Form(
              key: _formKey,
              child: Column(
                spacing: 20,
                children: [
                  Input(
                    label: 'Goals Name',
                    placeholder: 'Goals Name',
                    onSaved: (value) => goalsName = value!,
                  ),
                  Input(
                    label: 'Amount',
                    placeholder: '0',
                    keyboardType: TextInputType.number,
                    prefixIcon: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [Text('IDR')],
                    ),
                    onSaved: (value) => goalsAmount = value!,
                  ),
                  Input(
                    label: 'Description',
                    placeholder: 'Description (Optional)',
                    variant: 'multiline',
                    isOptional: true,
                    keyboardType: TextInputType.multiline,
                    onSaved: (value) => goalsDescription = value!,
                  ),

                  if (previewImage != null) Image.file(previewImage!),

                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(10),
                    decoration: ShapeDecoration(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                        side: BorderSide(width: 1, color: Colors.grey.shade500),
                      ),
                    ),
                    child: GestureDetector(
                      onTap: () => handlePickImage(),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        spacing: 10,
                        children: [
                          Icon(Icons.add_photo_alternate_outlined),
                          Text(
                            'Select Image',
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Button(label: 'Add Goals', onPressed: () => handleCreateGoals()),
          ],
        ),
      ),
    );
  }
}
