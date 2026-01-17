import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:trip_planner/utils/logger.dart';
import 'package:trip_planner/utils/utils.dart';
import '../../services/api_service.dart';
import '../trip_list_screen.dart';
import 'signup_screen.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final log = Logger("SignInScreen");
  final ApiService _apiService = ApiService();
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  
  String getValue(String? value, String debugKey) {
    if (value == null || value.isEmpty) {
      return dotenv.env[debugKey] ?? '';
    }
    
    return value;
  }
  
  String get emailValue => getValue(_emailController.text, 'DEBUG_QUICK_SIGNIN_EMAIL');
  String get passwordValue => getValue(_passwordController.text, 'DEBUG_QUICK_SIGNIN_PASSWORD');
  
  void _signIn() async {
    log.d("_signIn(): email=$emailValue, password=${Utils.mask(passwordValue)}");
    
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      
      try {
        await _apiService.signIn(emailValue, passwordValue);
        if (mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const TripListScreen()),
          );
        }
      } catch (e) {
        log.e("_signIn():", e);
        
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(e.toString())),
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign In'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  final debugValue = dotenv.env['DEBUG_QUICK_SIGNIN_EMAIL'];
                  if ((value == null || value.isEmpty) && debugValue?.isEmpty == true) {
                    return 'Please enter your email';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: _passwordController,
                decoration: const InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(),
                ),
                obscureText: true,
                validator: (value) {
                  final debugValue = dotenv.env['DEBUG_QUICK_SIGNIN_PASSWORD'];
                  if ((value == null || value.isEmpty) && debugValue?.isEmpty == true) {
                    return 'Please enter your password';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 26.0),
              _isLoading
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: _signIn,
                      child: const Text('Sign In'),
                    ),
              const SizedBox(height: 16.0),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const SignUpScreen()),
                  );
                },
                child: const Text('Don\'t have an account? Sign up'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
