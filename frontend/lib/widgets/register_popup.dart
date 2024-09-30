import 'package:flutter/material.dart';

class RegisterPopup extends StatelessWidget {
  final String role;

  const RegisterPopup({super.key, required this.role});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Registration Successful'),
      content: Text('You have successfully registered as a $role.'),
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
