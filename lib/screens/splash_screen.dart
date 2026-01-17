import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'home/home_screen.dart';
import 'signin_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkAuth();
  }

  void _checkAuth() async {
    // Give Firebase a moment to restore auth state if needed, 
    // or just check currentUser if it's already available after main's init.
    // Waiting for the first event on authStateChanges is safer.
    final user = await FirebaseAuth.instance.authStateChanges().first;
    
    if (mounted) {
      if (user != null) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const HomeScreen()),
        );
      } else {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const SignInScreen()),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
