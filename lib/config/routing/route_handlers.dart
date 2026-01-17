import 'package:trip_planner/domain/constants/constants.dart';
import 'package:trip_planner/l10n/app_localizations.dart';
import 'package:trip_planner/screens/error/error_screen.dart';
import 'package:trip_planner/screens/home/home_screen.dart';
import 'package:trip_planner/screens/settings/settings_screen.dart';
import 'package:trip_planner/widgets/toolbar.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';

typedef ParamsHandler = Widget Function(Map<String, dynamic> params);

Widget _render(
  Widget child,
  String title, {
  bool allowBackNavigation = true,
  bool withScaffold = true,
}) =>
    withScaffold
        ? Scaffold(
          appBar: Toolbar(title: title, allowBackNavigation: allowBackNavigation),
          body: child,
        )
        : child;

Handler handlerFor(
  Widget child,
  String Function(BuildContext) titleBuilder, {
  withScaffold = true,
  bool allowBackNavigation = true,
}) {
  return Handler(
    handlerFunc: (context, params) {
      if (context == null) {
        throw Exception("Context is required for localization.");
      }
      final title = titleBuilder(context);
      return _render(child, title, withScaffold: withScaffold, allowBackNavigation: allowBackNavigation);
    },
  );
}

Handler paramsHandlerFor(ParamsHandler childFn, String Function(BuildContext) titleBuilder, {withScaffold = true}) {
  return Handler(
    handlerFunc: (BuildContext? context, Map<String, dynamic> params) {
      if (context == null) {
        throw Exception("Context is required for localization.");
      }
      final title = titleBuilder(context);
      final child = childFn(params);
      return _render(child, title, withScaffold: withScaffold);
    },
  );
}

final errorHandler = Handler(
  handlerFunc: (BuildContext? context, Map<String, dynamic> params) {
    if (context == null) {
      throw Exception("Context is required for localization.");
    }
    
    // Extract error message from URL params (comes as List<String> from Fluro)
    final messageParam = params['message'];
    final message = messageParam is List ? messageParam.first : messageParam?.toString();
    
    // Create exception from message if provided
    final errorArg = message != null ? Exception(message) : null;
    final title = Constants.strings.appName;
    
    return _render(
      ErrorScreen(error: errorArg, stackTrace: null),
      title,
    );
  },
);
//final splashHandler = handlerFor(SplashScreen(), RouteWrapper.none);

/*final debugHandler = handlerFor(const DebugScreen(), (context) => "Debug");
final debugThemeHandler = handlerFor(const DebugThemeScreen(), (context) => "Debug Theme");
final debugSqlTestHandler = handlerFor(const DebugSqlTestScreen(), (context) => "Debug Sql Test");*/

final homeHandler = Handler(
  handlerFunc: (context, params) {
    if (context == null) {
      throw Exception("Context is required for localization.");
    }
    // No Scaffold wrapper - MainScreen provides the shared AppBar
    return const HomeScreen();
  },
);
final settingsHandler = handlerFor(const SettingsScreen(), (context) => AppLocalizations.of(context)!.settings);

