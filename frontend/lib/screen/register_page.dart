import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/export_bloc.dart';
import '../repositories/user_repository.dart';

class RegisterPage extends StatelessWidget {
  final _emailController = TextEditingController();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  String role = 'Leader';
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => RegisterBloc(
        userRepository: RepositoryProvider.of<UserRepository>(context),
      ),
      child: Scaffold(
        backgroundColor: const Color(0xFFF6F7F0), // Beige white background color
        appBar: AppBar(
          // Add a back button using IconButton
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () {
              Navigator.pushReplacementNamed(context, '/login'); // Navigate back to the previous page
            },
          ),
          title: const Text(
            'Register',
            style: TextStyle(
              fontSize: 24, // Make the title larger
              fontWeight: FontWeight.bold, // Make the title bold
              color: Colors.white, // Change text color to white
            ),
          ),
          centerTitle: true, // Center the title
          backgroundColor: const Color.fromARGB(255, 32, 86, 137), // Match app theme color
        ),
        body: BlocListener<RegisterBloc, RegisterState>(
          listener: (context, state) {
            if (state is RegisterSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Registration successful')),
              );
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

              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: ListView(
                  children: [
                    // Row with First Name and Last Name Labels and Fields
                    Row(
                      children: [
                        // First Name Label and Field
                        Flexible(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'First Name',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: Color.fromARGB(255, 32, 86, 137),
                                ),
                              ),
                              const SizedBox(height: 8),
                              TextField(
                                controller: _firstNameController,
                                decoration: InputDecoration(
                                  hintText: 'John', // Placeholder inside the box
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8.0),
                                    borderSide: const BorderSide(color: Color(0xFFE5E5E5)), // Light grey border color
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8.0),
                                    borderSide: const BorderSide(color: Color.fromARGB(255, 32, 86, 137)),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 16), // Space between fields
                        // Last Name Label and Field
                        Flexible(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Last Name',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: Color.fromARGB(255, 32, 86, 137),
                                ),
                              ),
                              const SizedBox(height: 8),
                              TextField(
                                controller: _lastNameController,
                                decoration: InputDecoration(
                                  hintText: 'Doe', // Placeholder inside the box
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8.0),
                                    borderSide: const BorderSide(color: Color(0xFFE5E5E5)), // Light grey border color
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8.0),
                                    borderSide: const BorderSide(color: Color.fromARGB(255, 32, 86, 137)),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Username Label and Field
                    const Text(
                      'Username',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Color.fromARGB(255, 32, 86, 137),
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _usernameController,
                      decoration: InputDecoration(
                        hintText: 'Enter your Username', // Placeholder inside
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide: const BorderSide(color: Color(0xFFE5E5E5)), // Light grey border color
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide: const BorderSide(color: Color.fromARGB(255, 32, 86, 137)),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Email Label and Field
                    const Text(
                      'E-mail',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Color.fromARGB(255, 32, 86, 137),
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        hintText: 'Enter your email', // Placeholder inside
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide: const BorderSide(color: Color(0xFFE5E5E5)), // Light grey border color
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide: const BorderSide(color: Color.fromARGB(255, 32, 86, 137)),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Password Label and Field with Visibility Toggle
                    const Text(
                      'Password',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Color.fromARGB(255, 32, 86, 137),
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _passwordController,
                      obscureText: !_isPasswordVisible,
                      decoration: InputDecoration(
                        hintText: '********', // Placeholder inside
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide: const BorderSide(color: Color(0xFFE5E5E5)), // Light grey border color
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide: const BorderSide(color: Color.fromARGB(255, 32, 86, 137)),
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _isPasswordVisible
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            _isPasswordVisible = !_isPasswordVisible;
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Confirm Password Label and Field with Visibility Toggle
                    const Text(
                      'Confirm Password',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Color.fromARGB(255, 32, 86, 137),
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _confirmPasswordController,
                      obscureText: !_isConfirmPasswordVisible,
                      decoration: InputDecoration(
                        hintText: '********', // Placeholder inside
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide: const BorderSide(color: Color(0xFFE5E5E5)), // Light grey border color
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide: const BorderSide(color: Color.fromARGB(255, 32, 86, 137)),
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _isConfirmPasswordVisible
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Role Dropdown Label and Field
                    const Text(
                      'Role',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Color.fromARGB(255, 32, 86, 137),
                      ),
                    ),
                    const SizedBox(height: 8),
                    DropdownButtonFormField<String>(
                      value: role,
                      items: <String>['Leader', 'People'].map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (newRole) {
                        role = newRole!;
                      },
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide: const BorderSide(color: Color(0xFFE5E5E5)), // Light grey border color
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide: const BorderSide(color: Color.fromARGB(255, 32, 86, 137)),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Register Button
                    ElevatedButton(
                      onPressed: () {
                        BlocProvider.of<RegisterBloc>(context).add(
                          RegisterButtonPressed(
                            username: _usernameController.text,
                            email: _emailController.text,
                            firstName: _firstNameController.text,
                            lastName: _lastNameController.text,
                            password: _passwordController.text,
                            confirmPassword: _confirmPasswordController.text,
                            role: role,
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 50),
                        backgroundColor: const Color.fromARGB(255, 32, 86, 137),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                      child: const Text(
                        'Create Account',
                        style: TextStyle(
                          color: Colors.white, // Change button text color to white
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Already have an account? Login Button
                    TextButton(
                      onPressed: () {
                        Navigator.pushReplacementNamed(context, '/login');
                      },
                      child: const Text(
                        'Already have an account? Login',
                        style: TextStyle(
                          color: Color.fromARGB(255, 10, 8, 128), // Change link text color to white
                          fontSize: 16,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}