import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:provider/provider.dart' as provider;
import 'package:spot_di/spot_di.dart';
import 'package:trip_planner/config/application.dart';
import 'package:trip_planner/config/routing/routes.dart';
import 'package:trip_planner/screens/error/error_screen.dart';
import 'theme/theme_provider.dart';
import 'services/api_service.dart';
import 'services/auth_service.dart';
import 'screens/auth/signin_screen.dart';
import 'screens/trip_list_screen.dart';

const overrideLocale = true;

class TripPlannerApp extends ConsumerWidget {
  static bool _errorWidgetBuilderSet = false;

  TripPlannerApp({super.key}) {
    if (Application.isInitialized) return;

    final router = FluroRouter();
    Routes.configureRoutes(router);
    Application.router = router;

    // Configure global error widget builder to use our ErrorScreen
    // Skip this in test environment as the test framework requires ErrorWidget.builder to remain unchanged
    // We detect test environment by checking the binding type string
    final bindingType = WidgetsBinding.instance.runtimeType.toString();
    final isTestEnvironment = bindingType.contains('Test');

    if (!_errorWidgetBuilderSet && !isTestEnvironment) {
      _errorWidgetBuilderSet = true;
      ErrorWidget.builder = (FlutterErrorDetails details) {
        final exception = details.exception is Exception
            ? details.exception as Exception
            : Exception(details.exception.toString());
        return ErrorScreen(error: exception, stackTrace: details.stack);
      };
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authService = spot<AuthService>();

    return provider.Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: true,
          title: 'Trip Planner',
          theme: themeProvider.lightTheme,
          darkTheme: themeProvider.darkTheme,
          themeMode: themeProvider.themeMode,
          home: StreamBuilder<AuthUser?>(
            stream: authService.authStateChanges,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Scaffold(
                  body: Center(child: CircularProgressIndicator()),
                );
              } else if (snapshot.hasData) {
                return const TripListScreen();
              } else {
                return const SignInScreen();
              }
            },
          ),
        );
      },
    );
  }
}
