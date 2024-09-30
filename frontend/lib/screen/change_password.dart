import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/export_bloc.dart';

class ChangePasswordPage extends StatelessWidget {
  const ChangePasswordPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: BlocProvider(
        create: (_) => ChangePasswordBloc(),
        child: const ChangePasswordForm(),
      ),
    );
  }
}

class ChangePasswordForm extends StatelessWidget {
  const ChangePasswordForm({super.key});

  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    return BlocListener<ChangePasswordBloc, ChangePasswordState>(
      listener: (context, state) {
        if (state is ChangePasswordSuccess) {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('Password Updated'),
                content:
                    const Text('Your password has been successfully updated.'),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('OK'),
                  ),
                ],
              );
            },
          );
        }
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 40.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              const SizedBox(height: 20),
              const Center(
                child: Text(
                  'Change Password',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              BlocBuilder<ChangePasswordBloc, ChangePasswordState>(
                builder: (context, state) {
                  return TextFormField(
                    obscureText: state.obscureOldPassword,
                    decoration: InputDecoration(
                      labelText: 'Old Password',
                      suffixIcon: IconButton(
                        icon: Icon(state.obscureOldPassword
                            ? Icons.visibility_off
                            : Icons.visibility),
                        onPressed: () {
                          context
                              .read<ChangePasswordBloc>()
                              .add(ToggleOldPasswordVisibility());
                        },
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your old password.';
                      }
                      return null;
                    },
                    onChanged: (value) {
                      context
                          .read<ChangePasswordBloc>()
                          .add(OldPasswordChanged(value));
                    },
                  );
                },
              ),
              const SizedBox(height: 20),
              BlocBuilder<ChangePasswordBloc, ChangePasswordState>(
                builder: (context, state) {
                  return TextFormField(
                    obscureText: state.obscureNewPassword,
                    decoration: InputDecoration(
                      labelText: 'New Password',
                      suffixIcon: IconButton(
                        icon: Icon(state.obscureNewPassword
                            ? Icons.visibility_off
                            : Icons.visibility),
                        onPressed: () {
                          context
                              .read<ChangePasswordBloc>()
                              .add(ToggleNewPasswordVisibility());
                        },
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your new password.';
                      }
                      if (value.length < 8) {
                        return 'Password must be at least 8 characters long.';
                      }
                      return null;
                    },
                    onChanged: (value) {
                      context
                          .read<ChangePasswordBloc>()
                          .add(NewPasswordChanged(value));
                    },
                  );
                },
              ),
              const SizedBox(height: 20),
              BlocBuilder<ChangePasswordBloc, ChangePasswordState>(
                builder: (context, state) {
                  return TextFormField(
                    obscureText: state.obscureConfirmPassword,
                    decoration: InputDecoration(
                      labelText: 'Confirm New Password',
                      suffixIcon: IconButton(
                        icon: Icon(state.obscureConfirmPassword
                            ? Icons.visibility_off
                            : Icons.visibility),
                        onPressed: () {
                          context
                              .read<ChangePasswordBloc>()
                              .add(ToggleConfirmPasswordChangeVisibility());
                        },
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please confirm your new password.';
                      }
                      if (value != state.newPassword) {
                        return 'Passwords do not match.';
                      }
                      return null;
                    },
                    onChanged: (value) {
                      context
                          .read<ChangePasswordBloc>()
                          .add(ConfirmPasswordChange(value));
                    },
                  );
                },
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    context
                        .read<ChangePasswordBloc>()
                        .add(ChangePasswordSubmitted());
                  }
                },
                child: const Text('Update Password'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
