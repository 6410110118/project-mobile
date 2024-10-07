import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:frontend/screen/login.dart';

class LogoutDialog extends StatelessWidget {
  final FlutterSecureStorage storage = FlutterSecureStorage(); // Initialize storage

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
          onPressed: () async {
            // Perform logout action
            await storage.delete(key: 'userToken'); // Clear user session

            // Navigate to login page and remove all previous routes
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => Login()), 
              (Route<dynamic> route) => false,
            );
          },
          child: Text('Logout'),
        ),
      ],
    );
  }
}
