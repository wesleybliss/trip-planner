import 'package:flutter/material.dart';
import 'package:spot_di/spot_di.dart';
import 'package:trip_planner/config/routing/routes.dart';
import 'package:trip_planner/services/auth_service.dart';
import 'package:trip_planner/utils/logger.dart';
import 'package:trip_planner/widgets/toolbar.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final log = Logger("SignInScreen");
  bool _isLoading = false;

  Future<void> _signInWithGoogle() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final authService = spot<AuthService>();
      final user = await authService.signInWithGoogle();

      if (!mounted) return;

      if (user != null) {
        log.d("Sign in successful: ${user.email}");
        Navigator.of(context).pushReplacementNamed(Routes.home);
      } else {
        log.d("Sign in cancelled by user");
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text("Sign in cancelled")));
      }
    } catch (e) {
      log.e("Sign in failed", e);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Sign in failed: ${e.toString()}")),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const Toolbar(title: 'Sign In'),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Welcome to Trip Planner",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 32),
              const Text(
                "Please sign in to continue",
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 32),
              _isLoading
                  ? const CircularProgressIndicator()
                  : ElevatedButton.icon(
                      onPressed: _signInWithGoogle,
                      icon: const Icon(Icons.login),
                      label: const Text('Sign In with Google'),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
