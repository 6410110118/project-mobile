import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/bloc/export_bloc.dart';
import 'package:frontend/repositories/auth_repository.dart';
import 'package:frontend/repositories/profile_repository.dart';
import 'package:frontend/repositories/trip_repository.dart';
import 'package:frontend/repositories/user_repository.dart';
import 'package:frontend/screen/group_page.dart';
import 'package:frontend/screen/login.dart';
import 'package:frontend/screen/profile.dart';
import 'package:frontend/screen/register_page.dart';
import 'package:frontend/screen/reset_password_page.dart';
// import 'package:frontend/widgets/change_password_popup.dart';
import 'package:provider/provider.dart';
import 'bloc/onboarding/onboarding_bloc.dart';
import 'bloc/onboarding/onboarding_state.dart';

import 'repositories/group_repository.dart';
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
        Provider<UserRepository>(create: (_) => UserRepository()),
        BlocProvider(
          create: (context) => LoginBloc(authRepository: AuthRepository()),
        ),
         BlocProvider(
          create: (context) => GetMeBloc( ProfileRepository())
            ..add(FetchUserData()),
        ),
          
        BlocProvider<TripBloc>(
          create: (context) => TripBloc(tripRepository: TripRepository())..add(FetchTripEvent()),
        ),
        BlocProvider(
          create: (context) => GroupBloc(groupRepository: GroupRepository()),
          child: GroupScreen(),
        )

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
          '/register': (context) =>
              RegisterPage(), // ตอนนี้ RegisterBloc ใช้ได้ทั่วแอป
          // '/changepassword': (context) => ChangePasswordDialog(),
          '/profile': (context) => ProfilePage(),
          '/resetpassword': (context) => const ResetPasswordPage(),
        },
        title: 'Plan For Travel',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
      ),
    );
  }
}
