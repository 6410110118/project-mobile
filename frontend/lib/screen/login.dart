import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/export_bloc.dart';
import '../repositories/auth_repository.dart';
import 'trip_homs.dart';
// นำเข้า TripHome ที่คุณสร้างขึ้น

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LoginBloc(authRepository: AuthRepository()),
      child: Scaffold(
        appBar: AppBar(
          title: Text('Login', style: TextStyle(fontSize: 24)),
        ),
        body: BlocListener<LoginBloc, LoginState>( 
          listener: (context, state) {
            if (state is LoginSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text('Login Success!'),
              ));
              // Navigate to Trip Home screen on successful login
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => TripHome()), // เปลี่ยนชื่อ TripHome ให้ตรงกับหน้าที่คุณสร้าง
              );
            } else if (state is LoginFailure) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text('Login Failed'),
              ));
            }
          },
          child: BlocBuilder<LoginBloc, LoginState>(
            builder: (context, state) {
              if (state is LoginLoading) {
                return Center(child: CircularProgressIndicator());
              }

              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextField(
                      controller: usernameController,
                      decoration: InputDecoration(labelText: 'Username'),
                    ),
                    TextField(
                      controller: passwordController,
                      decoration: InputDecoration(labelText: 'Password'),
                      obscureText: true,
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        final username = usernameController.text.trim();
                        final password = passwordController.text.trim();

                        if (username.isEmpty || password.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Please enter username and password'),
                            ),
                          );
                          return;
                        }

                        context.read<LoginBloc>().add(
                              LoginButtonPressed(
                                username: username,
                                password: password,
                              ),
                            );
                      },
                      child: Text('Login'),
                    ),
                    if (state is LoginFailure)
                      Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: Text(
                          state.error,
                          style: TextStyle(color: Colors.red),
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
