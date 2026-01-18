import 'package:flutter/material.dart';
import 'package:trip_planner/utils/logger.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final log = Logger('SettingsScreen');

  @override
  Widget build(BuildContext context) {
    return Center(child: Text("TODO"));
  }
}
