import 'package:flutter/material.dart';
import 'package:frontend/screen/sign_in_page.dart';

class LogoutDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Logout'),
      content: Text('Are you sure you want to logout?'),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(); // Close the dialog
          },
          child: Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            // Perform logout action
            // For example, clear the user session, navigate to login page, etc.
            // You might call a logout method here.
             Navigator.pushReplacementNamed(context, '/signin'); // Close the dialog
          },
          child: Text('Logout'),
        ),
      ],
    );
  }
}
