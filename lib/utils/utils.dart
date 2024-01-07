import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

pickImage(ImageSource source) async {
  final ImagePicker _imagePicker = ImagePicker();
  XFile? _file = await _imagePicker.pickImage(source: source,imageQuality: 25);

  _file = await _cropImage(imageFile:_file);
  if (_file != null) {
    return await _file.readAsBytes();
  }
  print('No Image Selected');
}
_cropImage({required XFile? imageFile}) async{
  CroppedFile? img = await ImageCropper().cropImage(sourcePath: imageFile!.path);
  if(img==null) return;
  return XFile(img.path);
}

// for displaying snackbars
showSnackBar(BuildContext context, String text) {
  return ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(text),
    ),
  );
}