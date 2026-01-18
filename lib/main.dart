import 'dart:io';
import 'package:desktop_webview_window/desktop_webview_window.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trip_planner/app.dart';
import 'package:trip_planner/config/application.dart';
import 'package:trip_planner/domain/di/spot_module.dart';
import 'package:trip_planner/utils/firebase.dart';
import 'theme/theme_provider.dart';
import 'package:window_manager/window_manager.dart';

void main(List<String> args) async {
  if (runWebViewTitleBarWidget(args)) {
    return;
  }
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase, crash logging, etc. and get AuthService
  final authService = await initializeFirebase();

  // Initialize the main application & it's dependencies
  await Application.initialize();

  // Register AuthService after Spot is initialized
  SpotModule.registerAuthService(authService);

  if (Platform.isLinux || Platform.isWindows || Platform.isMacOS) {
    await windowManager.ensureInitialized();
    WindowOptions windowOptions = const WindowOptions(
      size: Size(600, 800),
      minimumSize: Size(300, 400),
    );
    windowManager.waitUntilReadyToShow(windowOptions, () async {
      await windowManager.show();
    });
  }

  runApp(
    ChangeNotifierProvider(
      create: (context) => ThemeProvider(),
      child: TripPlannerApp(),
    ),
  );
}
