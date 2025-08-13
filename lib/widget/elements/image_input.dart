import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:montrack/utils/logger.dart';

class ImageInput extends StatefulWidget {
  const ImageInput({
    super.key,
    required this.onPickImage,
    this.enabled = true,
    this.defaultImage,
  });

  final void Function(File?) onPickImage;
  final String? defaultImage;
  final bool enabled;

  @override
  State<ImageInput> createState() => _ImageInputState();
}

class _ImageInputState extends State<ImageInput> {
  File? previewImage;
  String? imageName;

  Future handlePickImage() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);

      if (image == null) return;

      final imageTemp = File(image.path);

      widget.onPickImage(imageTemp);

      setState(() {
        imageName = image.name;
        previewImage = imageTemp;
      });
    } on PlatformException catch (error) {
      logger.e('Failed pick image', error: error);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 15,
      children: [
        if (previewImage != null) Image.file(previewImage!),
        if (widget.defaultImage != null && previewImage == null)
          Image.network(widget.defaultImage!),

        Container(
          width: double.infinity,
          padding: EdgeInsets.all(10),
          decoration: ShapeDecoration(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
              side: BorderSide(width: 1, color: Colors.grey.shade500),
            ),
          ),

          child: InkWell(
            onTap: () => widget.enabled ? handlePickImage() : null,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              spacing: 10,
              children: [
                Icon(Icons.add_photo_alternate_outlined),
                Text(
                  imageName ?? 'Select Image',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
