import 'package:trip_planner/domain/constants/constants.dart';
import 'package:trip_planner/l10n/app_localizations.dart';
import 'package:trip_planner/screens/error/error_screen.dart';
import 'package:trip_planner/screens/settings/settings_screen.dart';
import 'package:trip_planner/screens/trip_list_screen.dart';
import 'package:trip_planner/screens/trip_detail_screen.dart';
import 'package:trip_planner/screens/create_trip_screen.dart';
import 'package:trip_planner/screens/edit_trip_screen.dart';
import 'package:trip_planner/screens/plan_detail_screen.dart';
import 'package:trip_planner/screens/create_plan_screen.dart';
import 'package:trip_planner/screens/edit_plan_screen.dart';
import 'package:trip_planner/screens/create_segment_screen.dart';
import 'package:trip_planner/screens/edit_segment_screen.dart';
import 'package:trip_planner/screens/auth/signin_screen.dart';
import 'package:trip_planner/widgets/toolbar.dart';
import 'package:trip_planner/utils/route_utils.dart';
import 'package:trip_planner/services/auth_service.dart';
import 'package:spot_di/spot_di.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';

typedef ParamsHandler = Widget Function(Map<String, dynamic> params);

Widget _render(
  Widget child,
  String title, {
  bool allowBackNavigation = true,
  bool withScaffold = true,
}) => withScaffold
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
      return _render(
        child,
        title,
        withScaffold: withScaffold,
        allowBackNavigation: allowBackNavigation,
      );
    },
  );
}

Handler paramsHandlerFor(
  ParamsHandler childFn,
  String Function(BuildContext) titleBuilder, {
  withScaffold = true,
}) {
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

// Helper function to parse int parameters
int _parseIntParam(Map<String, dynamic> params, String key, [int? defaultValue]) {
  final param = paramOf<String>(params, key);
  if (param == null) {
    if (defaultValue != null) {
      return defaultValue;
    }
    throw Exception('Required parameter $key is missing');
  }
  return int.parse(param);
}

final errorHandler = Handler(
  handlerFunc: (BuildContext? context, Map<String, dynamic> params) {
    if (context == null) {
      throw Exception("Context is required for localization.");
    }

    // Extract error message from URL params (comes as List<String> from Fluro)
    final messageParam = params['message'];
    final message = messageParam is List
        ? messageParam.first
        : messageParam?.toString();

    // Create exception from message if provided
    final errorArg = message != null ? Exception(message) : null;
    final title = Constants.strings.appName;

    return _render(ErrorScreen(error: errorArg, stackTrace: null), title);
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

    final authService = spot<AuthService>();

    return StreamBuilder<AuthUser?>(
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
    );
  },
);

final tripsHandler = handlerFor(
  const TripListScreen(),
  (context) => 'My Trips',
  withScaffold: false,
);

final createTripHandler = handlerFor(
  const CreateTripScreen(),
  (context) => 'Create Trip',
  withScaffold: false,
);

final tripDetailHandler = paramsHandlerFor(
  (params) {
    final tripId = _parseIntParam(params, 'id');
    // Pass just the ID and let the screen fetch the data
    return TripDetailScreen(tripId: tripId);
  },
  (context) => 'Trip Details',
  withScaffold: false,
);

final editTripHandler = paramsHandlerFor(
  (params) {
    final tripId = _parseIntParam(params, 'id');
    // Pass just the ID and let the screen fetch the data
    return EditTripScreen(tripId: tripId);
  },
  (context) => 'Edit Trip',
  withScaffold: false,
);

final createPlanHandler = paramsHandlerFor(
  (params) {
    final tripId = _parseIntParam(params, 'tripId');
    return CreatePlanScreen(tripId: tripId);
  },
  (context) => 'Create Plan',
  withScaffold: false,
);

final planDetailHandler = paramsHandlerFor(
  (params) {
    final planId = _parseIntParam(params, 'id');
    final tripId = _parseIntParam(params, 'tripId');
    return PlanDetailScreen(planId: planId, tripId: tripId);
  },
  (context) => 'Plan Details',
  withScaffold: false,
);

final editPlanHandler = paramsHandlerFor(
  (params) {
    final planId = _parseIntParam(params, 'id');
    final tripId = _parseIntParam(params, 'tripId');
    return EditPlanScreen(planId: planId, tripId: tripId);
  },
  (context) => 'Edit Plan',
  withScaffold: false,
);

final createSegmentHandler = paramsHandlerFor(
  (params) {
    final planId = _parseIntParam(params, 'planId');
    // We'll need to pass the planId and let the screen figure out other details
    return CreateSegmentScreen(planId: planId);
  },
  (context) => 'Create Segment',
  withScaffold: false,
);

final editSegmentHandler = paramsHandlerFor(
  (params) {
    final segmentId = _parseIntParam(params, 'id');
    // Pass just the ID and let the screen fetch the data
    return EditSegmentScreen(segmentId: segmentId);
  },
  (context) => 'Edit Segment',
  withScaffold: false,
);

final settingsHandler = handlerFor(
  const SettingsScreen(),
  (context) => AppLocalizations.of(context)!.settings,
);
