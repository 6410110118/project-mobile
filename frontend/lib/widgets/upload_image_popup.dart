import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/bloc/export_bloc.dart';

class UploadImagePopup extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Upload Image'),
      content: Text('Choose an image to upload.'),
      actions: [
        TextButton(
          onPressed: () async {
            final imagePicker = ImagePicker();
            final pickedFile =
                await imagePicker.pickImage(source: ImageSource.gallery);
            if (pickedFile != null) {
              try {
                // แปลงภาพเป็น Uint8List
                Uint8List imageData = await pickedFile.readAsBytes();
                // สร้าง UploadImageEvent และส่งไปยัง Bloc
                BlocProvider.of<GetMeBloc>(context)
                    .add(UploadImageEvent(imageData));
                Navigator.of(context).pop(); // ปิดป๊อปอัพ
              } catch (e) {
                // แสดงข้อความข้อผิดพลาด
                ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error: ${e.toString()}')));
              }
            } else {
              // แสดงข้อความเมื่อไม่มีการเลือกภาพ
              ScaffoldMessenger.of(context)
                  .showSnackBar(SnackBar(content: Text('No image selected.')));
            }
          },
          child: Text('Select from Gallery'),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(); // ปิดป๊อปอัพ
          },
          child: Text('Cancel'),
        ),
      ],
    );
  }
}
