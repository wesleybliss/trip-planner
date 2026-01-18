# Fluro Router Navigation Implementation Plan

This document outlines the plan to ensure all navigation in the Trip Planner app is handled via the Fluro router instead of direct Navigator calls.

## Current State Analysis

- Fluro is already included in dependencies (version 2.0.5)
- Basic router setup exists in `lib/config/routing/` with routes and handlers
- Some screens are already using `Navigator.of(context).pushReplacementNamed(Routes.home)` for navigation
- Most screens are using direct `Navigator.push` and `Navigator.pushAndRemoveUntil` calls
- Router is initialized in `app.dart` but not widely used for navigation

## Implementation Plan

### 1. Define All Required Routes

- [ ] Define routes for all screens that currently use direct navigation
- [ ] TripListScreen (`/trips`)
- [ ] CreateTripScreen (`/trips/create`)
- [ ] TripDetailScreen (`/trips/:id`)
- [ ] EditTripScreen (`/trips/:id/edit`)
- [ ] CreatePlanScreen (`/trips/:tripId/plans/create`)
- [ ] PlanDetailScreen (`/plans/:id`)
- [ ] EditPlanScreen (`/plans/:id/edit`)
- [ ] CreateSegmentScreen (`/plans/:planId/segments/create`)
- [ ] EditSegmentScreen (`/segments/:id/edit`)
- [ ] SignInScreen (already has route but needs proper implementation)

### 2. Create Route Handlers

- [ ] Create handlers for each new route in `route_handlers.dart`
- [ ] Ensure proper parameter passing for routes with IDs
- [ ] Implement proper title handling for each screen

### 3. Update Navigation Calls

- [ ] Replace all `Navigator.push` calls with Fluro navigation
- [ ] Replace all `Navigator.pushAndRemoveUntil` calls with Fluro navigation
- [ ] Replace all `Navigator.pushReplacement` calls with Fluro navigation
- [ ] Replace all `Navigator.pop` calls where appropriate with Fluro navigation

### 4. Implement Navigation Service

- [ ] Create a navigation service to encapsulate Fluro router calls
- [ ] Add helper methods for common navigation patterns
- [ ] Ensure proper parameter encoding/decoding

### 5. Update Screens

- [ ] TripListScreen - Replace Navigator calls with Fluro navigation
- [ ] TripDetailScreen - Replace Navigator calls with Fluro navigation
- [ ] PlanDetailScreen - Replace Navigator calls with Fluro navigation
- [ ] All create/edit screens - Replace Navigator.pop with proper Fluro navigation
- [ ] SignInScreen - Ensure proper navigation to home route

### 6. Testing

- [ ] Verify all navigation flows work correctly
- [ ] Ensure back navigation works properly
- [ ] Test parameter passing between screens
- [ ] Confirm all existing tests still pass
- [ ] Add new tests for Fluro navigation if needed

### 7. Documentation

- [ ] Update any documentation to reflect the new navigation approach
- [ ] Document the new navigation patterns for future development

## Benefits of This Approach

1. Centralized route management
2. Consistent navigation patterns throughout the app
3. Better deep linking support
4. Improved testability of navigation flows
5. Easier maintenance of navigation logic

## Files to Modify

1. `lib/config/routing/routes.dart` - Add new route definitions
2. `lib/config/routing/route_handlers.dart` - Add new route handlers
3. `lib/services/navigation_service.dart` - Create new navigation service (new file)
4. All screen files that currently use Navigator directly - Update to use Fluro
5. Possibly `lib/app.dart` - If navigation service needs to be injected

## Potential Challenges

1. Ensuring proper parameter passing for complex objects
2. Handling navigation result callbacks properly
3. Maintaining back stack behavior consistency
4. Ensuring deep linking works correctly with all routes