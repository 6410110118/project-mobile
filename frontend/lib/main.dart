import 'package:flutter/material.dart';
import 'package:frontend/screen/login.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Plan For Travel',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Login(), // ไม่ส่ง trips เข้าไป
    );
  }
}
