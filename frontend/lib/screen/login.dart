import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/screen/main_screens.dart';

import '../bloc/export_bloc.dart';
import '../repositories/auth_repository.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LoginBloc(authRepository: AuthRepository()),
      child: Scaffold(
        body: BlocListener<LoginBloc, LoginState>(
          listener: (context, state) {
            if (state is LoginSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                content: Text('Login Success!'),
              ));
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => MainScreen()),
              );
            } else if (state is LoginFailure) {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                content: Text('Login Failed'),
              ));
            }
          },
          child: BlocBuilder<LoginBloc, LoginState>(
            builder: (context, state) {
              if (state is LoginLoading) {
                return const Center(child: CircularProgressIndicator());
              }

              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Center(
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ImageIcon(
                              AssetImage('assets/icon/flight.png'),
                              size: 128,
                              color: Colors.blue,
                            ),
                            SizedBox(height: 10), // Space between icon and text
                            Text(
                              'Plan For Travel',
                              style: TextStyle(
                                  fontSize: 24, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        const SizedBox(height: 40),
                        TextField(
                          controller: emailController,
                          decoration: const InputDecoration(
                            labelText: 'Username',
                            border: OutlineInputBorder(),
                          ),
                        ),
                        const SizedBox(height: 20),
                        TextField(
                          controller: passwordController,
                          decoration: const InputDecoration(
                            labelText: 'Password',
                            border: OutlineInputBorder(),
                            suffixIcon: Icon(Icons.visibility_off),
                          ),
                          obscureText: true,
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: () {
                              Navigator.pushReplacementNamed(
                                  context, '/changepassword');
                            },
                            child: const Text('Forgot Password?'),
                          ),
                        ),
                        const SizedBox(height: 20),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              final email = emailController.text.trim();
                              final password = passwordController.text.trim();

                              if (email.isEmpty || password.isEmpty) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content:
                                        Text('Please enter email and password'),
                                  ),
                                );
                                return;
                              }

                              context.read<LoginBloc>().add(
                                    LoginButtonPressed(
                                      username: '',
                                      password: password,
                                      email: email,
                                    ),
                                  );
                            },
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              backgroundColor:
                                  const Color.fromARGB(255, 41, 140, 155),
                            ),
                            child: const Text('Login',
                                style: TextStyle(
                                    color: Color.fromARGB(255, 255, 255, 255))),
                          ),
                        ),
                        const SizedBox(height: 20),
                        const SizedBox(height: 20),
                        TextButton(
                          onPressed: () {
                            Navigator.pushReplacementNamed(
                                context, '/register');
                          },
                          child:
                              const Text("Don't have an account? Register now"),
                        ),
                        if (state is LoginFailure)
                          Padding(
                            padding: const EdgeInsets.only(top: 10),
                            child: Text(
                              state.error,
                              style: const TextStyle(color: Colors.red),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
