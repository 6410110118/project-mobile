import 'package:flutter/material.dart';

// This function displays a success dialog based on the selected role.
// ignore: non_constant_identifier_names
void RegisterCheck(BuildContext context, String role) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Welcome $role!'),
        content: Text('You have successfully created an account as a $role.'),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close the dialog
            },
            child: const Text('OK'),
          ),
        ],
      );
    },
  );
}
