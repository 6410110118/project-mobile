import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/export_bloc.dart'; // import Bloc ที่เกี่ยวข้อง

class ChangePasswordDialog extends StatelessWidget {
  ChangePasswordDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _currentPasswordController = TextEditingController();
    final _newPasswordController = TextEditingController();

    return AlertDialog(
      title: Text('Change Password'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _currentPasswordController,
              decoration: InputDecoration(labelText: 'Current Password'),
              obscureText: true,
            ),
            TextField(
              controller: _newPasswordController,
              decoration: InputDecoration(labelText: 'New Password'),
              obscureText: true,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            final currentPassword = _currentPasswordController.text;
            final newPassword = _newPasswordController.text;

            // เรียก Bloc เพื่อเปลี่ยนรหัสผ่าน
            BlocProvider.of<LoginBloc>(context).add(
              ChangePasswordEvent(
                currentPassword: currentPassword,
                newPassword: newPassword,
              ),
            );

            // ปิด Dialog
            Navigator.of(context).pop();
          },
          child: Text('Change Password'),
        ),
      ],
    );
  }
}
