import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:trip_planner/app.dart';
import 'package:trip_planner/config/application.dart';
import 'package:trip_planner/domain/di/spot_module.dart';
import 'package:trip_planner/utils/firebase.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart' as riverpod;
import 'theme/theme_provider.dart';
import 'package:window_manager/window_manager.dart';

void main(List<String> args) async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");

  // Initialize Firebase, crash logging, etc. and get AuthService
  final authService = await initializeFirebase();

  // Initialize the main application & it's dependencies
  await Application.initialize();

  // Register AuthService after Spot is initialized
  SpotModule.registerAuthService(authService);

  if (Platform.isLinux || Platform.isWindows || Platform.isMacOS) {
    await windowManager.ensureInitialized();

    // Get screen size to better configure initial window size
    final screenSize = WidgetsBinding.instance.window.physicalSize;
    final devicePixelRatio = WidgetsBinding.instance.window.devicePixelRatio;

    final initialWidth = screenSize.width / devicePixelRatio > 800.0
        ? 800.0
        : screenSize.width / devicePixelRatio * 0.8;

    final initialHeight = screenSize.height / devicePixelRatio > 1000.0
        ? 1000.0
        : screenSize.height / devicePixelRatio * 0.8;

    WindowOptions windowOptions = WindowOptions(
      size: Size(initialWidth.toDouble(), initialHeight.toDouble()),
      minimumSize: const Size(400, 500),
      center: true,
    );

    windowManager.waitUntilReadyToShow(windowOptions, () async {
      await windowManager.show();
      await windowManager.focus();
    });
  }

  runApp(
    riverpod.ProviderScope(
      child: ChangeNotifierProvider(
        create: (context) => ThemeProvider(),
        child: TripPlannerApp(),
      ),
    ),
  );
}
