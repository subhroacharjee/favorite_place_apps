import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImageInput extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ImageInputState();
}

class _ImageInputState extends State<ImageInput> {
  File? _selectedImage;
  void _takePicture() async {
    final imagePicker = ImagePicker();
    try {
      final image = await imagePicker.pickImage(
        source: ImageSource.gallery,
        maxHeight: 250,
        maxWidth: double.infinity,
      );
      if (image == null) return;
      setState(() {
        _selectedImage = File(image.path);
      });
    } catch (e) {
      print(e);
      if (context.mounted)
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              e.toString(),
            ),
          ),
        );
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget content = TextButton(
      onPressed: _takePicture,
      style: TextButton.styleFrom(
        padding: const EdgeInsets.symmetric(
          horizontal: 10,
          vertical: 20,
        ),
        shape: RoundedRectangleBorder(
          side: BorderSide(
            width: 3,
            color: Theme.of(context).colorScheme.secondary,
          ),
          borderRadius: BorderRadius.circular(5),
        ),
      ),
      child: const Row(
        children: [
          Icon(Icons.camera),
          SizedBox(
            width: 5,
          ),
          Text("Add Image"),
        ],
      ),
    );

    if (_selectedImage != null)
      content = InkWell(
        onTap: _takePicture,
        child: Image.file(_selectedImage!),
      );
    return Container(
      width: double.infinity,
      alignment: Alignment.center,
      child: content,
    );
  }
}
