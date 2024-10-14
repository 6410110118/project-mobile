import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/export_bloc.dart'; // Import Bloc ที่จำเป็น

class ChangePasswordPage extends StatefulWidget {
  @override
  _ChangePasswordPageState createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _currentPasswordController =
      TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Change Password',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        iconTheme: IconThemeData(
          color: Colors.white, // ปรับสีไอคอนย้อนกลับเป็นสีขาว
        ),
        backgroundColor: const Color.fromARGB(255, 32, 86, 137), // สีหลักของแอป
        centerTitle: true,
      ),

      backgroundColor: const Color(0xFFF6F7F0), // สีพื้นหลังเบจอ่อน
      body: BlocListener<GetMeBloc, GetMeState>(
        listener: (context, state) {
          if (state is ChangePasswordSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Password changed successfully!')),
            );
            Navigator.pop(context);
          } else if (state is ChangePasswordFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                  content: Text('Failed to change password: ${state.error}')),
            );
          }
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildPasswordField(
                  controller: _currentPasswordController,
                  label: 'Current Password',
                ),
                const SizedBox(height: 20),
                _buildPasswordField(
                  controller: _newPasswordController,
                  label: 'New Password',
                ),
                const SizedBox(height: 20),
                _buildPasswordField(
                  controller: _confirmPasswordController,
                  label: 'Confirm New Password',
                ),
                const SizedBox(height: 40),
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        BlocProvider.of<GetMeBloc>(context)
                            .add(ChangePasswordEvent(
                          currentPassword: _currentPasswordController.text,
                          newPassword: _newPasswordController.text,
                        ));
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          const Color.fromARGB(255, 32, 86, 137), // ปุ่มสีหลัก
                      padding: const EdgeInsets.symmetric(
                          horizontal: 50, vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: const Text(
                      'Change Password',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPasswordField({
    required TextEditingController controller,
    required String label,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.grey),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.grey),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color.fromARGB(255, 32, 86, 137)),
        ),
      ),
      obscureText: true,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter your password';
        }
        return null;
      },
    );
  }
}
