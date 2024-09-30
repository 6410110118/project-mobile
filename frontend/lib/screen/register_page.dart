import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/export_bloc.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider(
        create: (_) => RegisterBloc(),
        child: const RegisterForm(),
      ),
    );
  }
}

class RegisterForm extends StatelessWidget {
  const RegisterForm({super.key});

  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    return BlocListener<RegisterBloc, RegisterState>(
      listener: (context, state) {
        if (state is RegisterFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.error)),
          );
        } else if (state is RegisterSuccess) {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Welcome ${state.role}!'),
                content: Text(
                    'You have successfully created an account as a ${state.role}.'),
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
              const SizedBox(height: 40),
              const Center(
                child: Text(
                  'Register',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ),
              const SizedBox(height: 30),
              BlocBuilder<RegisterBloc, RegisterState>(
                builder: (context, state) {
                  return Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          decoration:
                              const InputDecoration(labelText: 'First Name'),
                          onChanged: (value) {
                            context
                                .read<RegisterBloc>()
                                .add(FirstNameChanged(value));
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'กรุณากรอกชื่อ';
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: TextFormField(
                          decoration:
                              const InputDecoration(labelText: 'Last Name'),
                          onChanged: (value) {
                            context
                                .read<RegisterBloc>()
                                .add(LastNameChanged(value));
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'กรุณากรอกนามสกุล';
                            }
                            return null;
                          },
                        ),
                      ),
                    ],
                  );
                },
              ),
              const SizedBox(height: 20),
              TextFormField(
                decoration: const InputDecoration(labelText: 'E-mail'),
                onChanged: (value) {
                  context.read<RegisterBloc>().add(EmailChanged(value));
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'กรุณากรอกอีเมล';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              BlocBuilder<RegisterBloc, RegisterState>(
                builder: (context, state) {
                  return TextFormField(
                    obscureText: state.obscurePassword,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      suffixIcon: IconButton(
                        icon: Icon(state.obscurePassword
                            ? Icons.visibility_off
                            : Icons.visibility),
                        onPressed: () {
                          context
                              .read<RegisterBloc>()
                              .add(TogglePasswordVisibility());
                        },
                      ),
                    ),
                    onChanged: (value) {
                      context.read<RegisterBloc>().add(PasswordChanged(value));
                    },
                    validator: (value) {
                      if (value == null || value.length < 8) {
                        return 'รหัสผ่านต้องมีอย่างน้อย 8 ตัว';
                      }
                      return null;
                    },
                  );
                },
              ),
              const SizedBox(height: 20),
              BlocBuilder<RegisterBloc, RegisterState>(
                builder: (context, state) {
                  return TextFormField(
                    obscureText: state.obscureConfirmPassword,
                    decoration: InputDecoration(
                      labelText: 'Confirm Password',
                      suffixIcon: IconButton(
                        icon: Icon(state.obscureConfirmPassword
                            ? Icons.visibility_off
                            : Icons.visibility),
                        onPressed: () {
                          context
                              .read<RegisterBloc>()
                              .add(ToggleConfirmPasswordVisibility());
                        },
                      ),
                    ),
                    onChanged: (value) {
                      context
                          .read<RegisterBloc>()
                          .add(ConfirmPasswordChanged(value));
                    },
                    validator: (value) {
                      if (value == null || value != state.password) {
                        return 'รหัสผ่านและยืนยันรหัสผ่านไม่ตรงกัน';
                      }
                      return null;
                    },
                  );
                },
              ),
              const SizedBox(height: 20),
              BlocBuilder<RegisterBloc, RegisterState>(
                builder: (context, state) {
                  return DropdownButtonFormField<String>(
                    decoration: const InputDecoration(labelText: 'Role'),
                    value: state.role,
                    onChanged: (value) {
                      context.read<RegisterBloc>().add(RoleChanged(value!));
                    },
                    items: const [
                      DropdownMenuItem(value: 'Member', child: Text('Member')),
                      DropdownMenuItem(value: 'Leader', child: Text('Leader')),
                    ],
                  );
                },
              ),
              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    context.read<RegisterBloc>().add(FormSubmitted());
                  }
                },
                child: const Text('Register'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
