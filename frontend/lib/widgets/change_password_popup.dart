import 'package:flutter/material.dart';

class ChangePasswordPopup extends StatelessWidget {
  const ChangePasswordPopup({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Password Changed'),
      content: const Text('Your password has been successfully updated.'),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(); // Close the popup
          },
          child: const Text('OK'),
        ),
      ],
    );
  }
}
