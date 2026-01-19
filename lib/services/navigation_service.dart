import 'package:flutter/material.dart';
import '../config/application.dart';
import '../config/routing/routes.dart' as app_routes;

class NavigationService {
  static final NavigationService _instance = NavigationService._internal();

  factory NavigationService() => _instance;

  NavigationService._internal();

  Future<T?> navigateTo<T extends Object?>(
    BuildContext context,
    String route, {
    Map<String, dynamic>? params,
    bool replace = false,
    bool clearStack = false,
  }) async {
    String fullRoute = route;

    // Add query parameters if provided
    if (params != null && params.isNotEmpty) {
      final queryParams = <String>[];
      params.forEach((key, value) {
        if (value != null) {
          queryParams.add('$key=${Uri.encodeComponent(value.toString())}');
        }
      });
      if (queryParams.isNotEmpty) {
        fullRoute += '?${queryParams.join('&')}';
      }
    }

    if (clearStack) {
      final result = await Application.router.navigateTo(
        context,
        fullRoute,
        replace: true,
        clearStack: true,
      );
      return result as T?;
    } else if (replace) {
      final result = await Application.router.navigateTo(
        context,
        fullRoute,
        replace: true,
      );
      return result as T?;
    } else {
      final result = await Application.router.navigateTo(context, fullRoute);
      return result as T?;
    }
  }

  Future<T?> navigateToWithResult<T extends Object?>(
    BuildContext context,
    String route, {
    Map<String, dynamic>? params,
  }) async {
    String fullRoute = route;

    // Add query parameters if provided
    if (params != null && params.isNotEmpty) {
      final queryParams = <String>[];
      params.forEach((key, value) {
        if (value != null) {
          queryParams.add('$key=${Uri.encodeComponent(value.toString())}');
        }
      });
      if (queryParams.isNotEmpty) {
        fullRoute += '?${queryParams.join('&')}';
      }
    }
    
    final result = await Application.router.navigateTo(context, fullRoute);
    return result as T?;
  }

  void pop<T extends Object?>([T? result]) {
    // For now, we'll use the standard navigator for popping
    // This is because Fluro doesn't provide a direct way to pop
    // We'll need to get the context from somewhere
  }

  // Helper methods for common navigation patterns
  Future<T?> navigateToTrips<T extends Object?>(BuildContext context) {
    return navigateTo(context, app_routes.Routes.trips);
  }

  Future<T?> navigateToCreateTrip<T extends Object?>(BuildContext context) {
    return navigateTo(context, app_routes.Routes.createTrip);
  }

  Future<T?> navigateToTripDetail<T extends Object?>(BuildContext context, int tripId) {
    return navigateTo(context, app_routes.Routes.tripDetail.replaceFirst(':id', tripId.toString()));
  }

  Future<T?> navigateToEditTrip<T extends Object?>(BuildContext context, int tripId) {
    return navigateTo(context, app_routes.Routes.editTrip.replaceFirst(':id', tripId.toString()));
  }

  Future<T?> navigateToCreatePlan<T extends Object?>(BuildContext context, int tripId) {
    return navigateTo(
      context,
      app_routes.Routes.createPlan.replaceFirst(':tripId', tripId.toString()),
    );
  }

  Future<T?> navigateToPlanDetail<T extends Object?>(BuildContext context, int tripId, int planId) {
    return navigateTo(
      context,
      app_routes.Routes.planDetail
          .replaceFirst(':tripId', tripId.toString())
          .replaceFirst(':id', planId.toString()),
    );
  }

  Future<T?> navigateToEditPlan<T extends Object?>(BuildContext context, int tripId, int planId) {
    return navigateTo(
      context,
      app_routes.Routes.editPlan
          .replaceFirst(':tripId', tripId.toString())
          .replaceFirst(':id', planId.toString()),
    );
  }

  Future<T?> navigateToCreateSegment<T extends Object?>(BuildContext context, int planId) {
    return navigateTo(
      context,
      app_routes.Routes.createSegment.replaceFirst(':planId', planId.toString()),
    );
  }

  Future<T?> navigateToEditSegment<T extends Object?>(BuildContext context, int segmentId) {
    return navigateTo(
      context,
      app_routes.Routes.editSegment.replaceFirst(':id', segmentId.toString()),
    );
  }

  Future<T?> navigateToHome<T extends Object?>(BuildContext context) {
    return navigateTo(context, app_routes.Routes.home, clearStack: true);
  }

  Future<T?> navigateToSettings<T extends Object?>(BuildContext context) {
    return navigateTo(context, app_routes.Routes.settings);
  }
}