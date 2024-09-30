import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/bloc/welcome/welcome_event.dart';
import 'package:frontend/screen/change_password.dart';
import 'package:frontend/screen/login.dart';
import 'package:frontend/screen/register_page.dart';
import 'package:frontend/screen/welcome_screens.dart';
import 'bloc/export_bloc.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: BlocProvider(
        create: (_) => TravelBloc()..add(LoadTravelPage()),
        child: TravelPage(),
      ),
      routes: {
        '/signin': (context) => SignInPage(),
        '/login': (context) => const Login(),
        '/register': (context) => const RegisterPage(),
        '/changepassword': (context) => const ChangePasswordPage(),
      },
    );
  }
}

@override
Widget build(BuildContext context) {
  return MaterialApp(
    title: 'Plan For Travel',
    theme: ThemeData(
      primarySwatch: Colors.blue,
    ),
    home: TravelPage(), // ไม่ส่ง trips เข้าไป
  );
}
