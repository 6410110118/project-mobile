import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/bloc/export_bloc.dart';

class UploadImagePopup extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Upload Image'),
      content: const Text('Choose an image to upload.'),
      actions: [
        TextButton(
          onPressed: () async {
            final imagePicker = ImagePicker();
            final pickedFile =
                await imagePicker.pickImage(source: ImageSource.gallery);
            if (pickedFile != null) {
              try {
                
                Uint8List imageData = await pickedFile.readAsBytes();
                
                BlocProvider.of<GetMeBloc>(context)
                    .add(UploadImageEvent(imageData));
                Navigator.of(context).pop(); 
              } catch (e) {
                
                ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error: ${e.toString()}')));
              }
            } else {
              
              ScaffoldMessenger.of(context)
                  .showSnackBar(const SnackBar(content: Text('No image selected.')));
            }
          },
          child: const Text('Select from Gallery'),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(); 
          },
          child: const Text('Cancel'),
        ),
      ],
    );
  }
}
