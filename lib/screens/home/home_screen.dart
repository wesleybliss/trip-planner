import 'package:flutter/material.dart';
import '../../widgets/toolbar.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Toolbar(
        title: 'Trip Planner',
        showActions: true,
        allowBackNavigation: false,
      ),
      body: const Center(child: Text('Welcome to Trip Planner!')),
    );
  }
}
