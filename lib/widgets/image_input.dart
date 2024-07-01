import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

// @Riverpod(keepAlive: false)

class ImageInput extends StatefulWidget {
  const ImageInput({super.key, required this.onSelectedImage});

  final void Function(File?, Uint8List?) onSelectedImage;

  @override
  State<ImageInput> createState() {
    return _ImageInputState();
  }
}

class _ImageInputState extends State<ImageInput> {
  File? _selectedImage;
  Uint8List? _selectedImageWeb;

  void _takePicture() async {
    final imagePicker = ImagePicker();
    final takenImage = await imagePicker.pickImage(
      source: ImageSource.camera,
      maxWidth: 600,
    );

    if (takenImage != null) {
      _selectedImageWeb = await takenImage.readAsBytes();
      setState(() {
        _selectedImage = File(takenImage.path);
      });
      widget.onSelectedImage(_selectedImage!, _selectedImageWeb!);
      return;
    }
    widget.onSelectedImage(_selectedImage, _selectedImageWeb);
    return;

    // if (takenImage == null) {
    //   return;
    // } else {
    //   setState(() {
    //     _selectedImage = File(takenImage.path);
    //   });
    //   widget.onSelectedImage(_selectedImage!);
    //   return;
    // }
  }

  void _chooseImage() async {
    final imagePicker = ImagePicker();
    final pickedImage = await imagePicker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 600,
    );

    if (pickedImage != null) {
      _selectedImageWeb = await pickedImage.readAsBytes();
      setState(() {
        _selectedImage = File(pickedImage.path);
      });
      widget.onSelectedImage(_selectedImage!, _selectedImageWeb!);
      return;
    }
    widget.onSelectedImage(_selectedImage, _selectedImageWeb);
    return;

    // if (pickedImage == null) {
    //   return;
    // } else {
    //   setState(() {
    //     _selectedImage = File(pickedImage.path);
    //   });
    //   widget.onSelectedImage(_selectedImage!);
    //   return;
    // }
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> content = [
      OverflowBar(
        overflowAlignment: OverflowBarAlignment.center,
        children: [
          TextButton.icon(
            onPressed: _takePicture,
            label: const Text("Take an image"),
            icon: const Icon(Icons.camera_alt_rounded),
          ),
          const SizedBox(
            height: 12.0,
            width: 12.0,
          ),
          TextButton.icon(
            onPressed: _chooseImage,
            label: const Text("Pick from gallery"),
            icon: const Icon(Icons.image_rounded),
          ),
        ],
      ),
    ];
    if (_selectedImage != null) {
      content = [
        ClipRRect(
          borderRadius: BorderRadius.circular(12.0),
          child: kIsWeb
              ? Image.memory(
                  _selectedImageWeb!,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: double.infinity,
                )
              : Image.file(
                  _selectedImage!,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: double.infinity,
                ),
        ),
        Positioned(
          right: 0,
          bottom: 0,
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: FloatingActionButton(
              onPressed: () {
                setState(() {
                  _selectedImage = null;
                  _selectedImageWeb = null;
                  widget.onSelectedImage(_selectedImage, _selectedImageWeb);
                });
              },
              child: const Icon(Icons.delete_rounded),
            ),
          ),
        )
      ];
    }
    return Container(
      height: 250.0,
      width: double.infinity,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.0),
        border: Border.all(
          width: 1.5,
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
      child: Stack(
        // mainAxisAlignment: MainAxisAlignment.center,
        children: content,
      ),
    );
  }
}
