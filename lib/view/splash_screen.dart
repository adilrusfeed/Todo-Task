// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';

// class SplashScreen extends StatefulWidget {
//   const SplashScreen({super.key});

//   @override
//   State<SplashScreen> createState() => _SplashScreenState();
// }

// class _SplashScreenState extends State<SplashScreen> {
//   @override
//   void initState() {
//     goToLogin(context);
//     super.initState();
//   }

//   Widget build(BuildContext context) {
//     return const Scaffold(
//       body: Center(
//         child: Image(image: AssetImage("assets/todo-cloud-hero.png")),
//       ),
//     );
//   }

// ignore_for_file: prefer_const_constructors

//   goToLogin(context) async {
//     User? currentUser = FirebaseAuth.instance.currentUser;
//     if (currentUser != null) {}
//   }
// }
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:todotask/view/authentication/sign_in.dart';
import 'package:todotask/view/home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToNextScreen();
  }

  Future<void> _navigateToNextScreen() async {
    await Future.delayed(
        Duration(seconds: 2)); // Duration for the splash screen
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen()),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => SignInScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image.asset(
            "assets/todo-cloud-hero.png"), // Your splash screen image
      ),
    );
  }
}
