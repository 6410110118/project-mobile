import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/export_bloc.dart';
import '../repositories/user_repository.dart';

class RegisterPage extends StatelessWidget {
  final _emailController = TextEditingController();
  final _usernameController = TextEditingController();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _passwordController = TextEditingController();
  
  RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Register'),
      ),
      body: BlocListener<RegisterBloc, RegisterState>(
        listener: (context, state) {
          if (state is RegisterSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Registration successful')),
            );
            // Navigate to the Travel Page after successful registration
            Navigator.pushReplacementNamed(context, '/login');
          } else if (state is RegisterFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Registration failed: ${state.error}')),
            );
          }
        },
        child: BlocBuilder<RegisterBloc, RegisterState>(
          builder: (context, state) {
            if (state is RegisterLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            String role = 'Leader'; // Move role declaration inside the builder

            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  TextField(
                    controller: _emailController,
                    decoration: const InputDecoration(labelText: 'Email'),
                  ),
                  TextField(
                    controller: _usernameController,
                    decoration: const InputDecoration(labelText: 'Username'),
                  ),
                  TextField(
                    controller: _firstNameController,
                    decoration: const InputDecoration(labelText: 'First Name'),
                  ),
                  TextField(
                    controller: _lastNameController,
                    decoration: const InputDecoration(labelText: 'Last Name'),
                  ),
                  TextField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: const InputDecoration(labelText: 'Password'),
                  ),
                  DropdownButton<String>(
                    value: role,
                    items: <String>['Leader', 'People'].map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (newRole) {
                      if (newRole != null) {
                        role = newRole; // Update role using local variable
                      }
                    },
                  ),
                  ElevatedButton(
                    onPressed: () {
                      BlocProvider.of<RegisterBloc>(context).add(
                        RegisterButtonPressed(
                          email: _emailController.text,
                          username: _usernameController.text,
                          firstName: _firstNameController.text,
                          lastName: _lastNameController.text,
                          password: _passwordController.text,
                          role: role,
                        ),
                      );
                    },
                    child: const Text('Register'),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushReplacementNamed(context, '/login');
                    },
                    child: const Text('Already have an account? Login'),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
