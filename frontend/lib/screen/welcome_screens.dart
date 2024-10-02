import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/export_bloc.dart';

class TravelPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<TravelBloc, TravelState>(
        listener: (context, state) {
          if (state is TravelLoaded) {
            // Wait 3 seconds after the first page is loaded and then navigate to the Sign In page
            Future.delayed(const Duration(seconds: 3), () {
              Navigator.pushReplacementNamed(context, '/signin');
            });
          }
        },
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset(
              'assets/images/start.jpg', // Ensure your image is in assets folder
              fit: BoxFit.cover,
            ),
            const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ImageIcon(
                    AssetImage('assets/icon/flight.png'),
                    size: 128,
                    color: Colors.white,
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Plan',
                    style: TextStyle(
                      fontSize: 40,
                      color: Colors.white,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  Text(
                    'For',
                    style: TextStyle(
                      fontSize: 40,
                      color: Colors.white,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  Text(
                    'Travel',
                    style: TextStyle(
                      fontSize: 40,
                      color: Colors.white,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}