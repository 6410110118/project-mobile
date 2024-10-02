import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/bloc/welcome/welcome_event.dart';
import 'package:frontend/repositories/user_repository.dart'; // อย่าลืม import UserRepository
import 'package:frontend/screen/change_password.dart';
import 'package:frontend/screen/login.dart';
import 'package:frontend/screen/register_page.dart';
import 'package:frontend/screen/sign_in_page.dart';
import 'package:frontend/screen/welcome_screens.dart';
import 'package:provider/provider.dart';
import 'bloc/export_bloc.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<UserRepository>(create: (_) => UserRepository()), // ให้บริการ UserRepository
        BlocProvider<TravelBloc>(create: (_) => TravelBloc()..add(LoadTravelPage())), // ให้บริการ TravelBloc
        // คุณสามารถเพิ่ม Bloc อื่น ๆ ที่นี่ถ้าจำเป็น
      ],
      child: MaterialApp(
        title: 'Plan For Travel',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const TravelPage(),
        routes: {
          '/signin': (context) =>  SignInPage(),
          '/login': (context) => const Login(),
          '/register': (context) =>  RegisterPage(),
          '/changepassword': (context) => const ChangePasswordPage(),
        },
      ),
    );
  }
}
