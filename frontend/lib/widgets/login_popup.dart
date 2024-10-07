import 'package:flutter/material.dart';

class SuccessPopup extends StatelessWidget {
  final String message;

  const SuccessPopup({Key? key, required this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Success'),
      content: Column(
        mainAxisSize: MainAxisSize.min, // ทำให้สูงพอดีกับเนื้อหา
        children: [
          const Icon(
            Icons.check_circle, // ไอคอนติ๊ก
            color: Colors.green,
            size: 64, // ขนาดไอคอน
          ),
          const SizedBox(height: 10), // ช่องว่างระหว่างไอคอนและข้อความ
          Text(message),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('OK'),
        ),
      ],
    );
  }
}
