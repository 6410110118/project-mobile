import 'package:flutter/material.dart';
import 'package:frontend/components/login.dart';

// void main() {
//   runApp(PlanForTravelApp());
// }

// class PlanForTravelApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: SignInPage(),
//       debugShowCheckedModeBanner: false,
//     );
//   }
// }

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/home.jpeg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Stack(
          children: [
            Positioned(
              top: 150,
              left: 0,
              right: 0,
              child: Column(
                children: [
                  Transform.rotate(
                    angle: 45 * 3.14159 / 180,
                    child: Icon(
                      Icons.airplanemode_active,
                      size: 80,
                      color: Colors.white,
                    ),
                  ),
                  
                  Column(
                    children: [
                      Text(
                        'Plan',
                        style: TextStyle(
                          fontSize: 48,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        'For',
                        style: TextStyle(
                          fontSize: 48,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        'Travel',
                        style: TextStyle(
                          fontSize: 48,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  )              ]),
            ),
            Positioned(
              top: 570,
              bottom: 50,
              left: 16,
              right: 16,
              child: Column(
                children: [
                  Text(
                    'Sign in and plan your trip',
                    style: TextStyle(
                      fontSize: 24,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'By continuing, you accept our Terms of Use and Privacy Statement',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => LoginPage()),
                      );
                    },
                    child: Text('Sign in', style: TextStyle(fontSize: 18, color: Colors.white)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 95, 62, 49),
                      padding: EdgeInsets.symmetric(horizontal: 60, vertical: 15),
                    ),
                  ),
                  SizedBox(height: 10),
                  TextButton(
                    onPressed: () {
                      // Add registration logic here
                    },
                    child: Text("Don't have an account? Register now",),
                    style: TextButton.styleFrom(
                    
                      foregroundColor: Colors.white, 
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