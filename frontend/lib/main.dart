import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/repositories/user_repository.dart';
import 'package:frontend/screen/change_password.dart';
import 'package:frontend/screen/login.dart';
import 'package:frontend/screen/profile.dart';
import 'package:frontend/screen/register_page.dart';
import 'bloc/onboarding/onboarding_bloc.dart';
import 'bloc/onboarding/onboarding_state.dart';
import 'bloc/register/register_bloc.dart'; // import RegisterBloc
import 'screen/onboarding_screen.dart';
import 'screen/sign_in_page.dart';
import 'screen/welcome_screens.dart';

void main() {
  runApp(PlanTravel());
}

class PlanTravel extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => OnboardingBloc(),
        ),
        BlocProvider(
          create: (_) => RegisterBloc(userRepository: UserRepository()), // เพิ่ม RegisterBloc ที่นี่
        ),
      ],
      child: MaterialApp(
        initialRoute: '/',
        routes: {
          '/': (context) => BlocBuilder<OnboardingBloc, OnboardingState>(
                builder: (context, state) {
                  if (state is OnboardingInitial) {
                    return WelcomePage();
                  } else if (state is OnboardingInProgress) {
                    return const OnboardingScreen();
                  } else if (state is OnboardingCompleted) {
                    return SignInPage();
                  } else {
                    return WelcomePage();
                  }
                },
              ),
          '/onboarding': (context) => const OnboardingScreen(),
          '/signin': (context) => SignInPage(),
          '/login': (context) => const Login(),
          '/register': (context) => RegisterPage(), // ตอนนี้ RegisterBloc ใช้ได้ทั่วแอป
          '/changepassword': (context) => const ChangePasswordPage(),
          '/profile': (context) => ProfilePage(),
        },
        title: 'Plan For Travel',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
      ),
    );
  }
}
