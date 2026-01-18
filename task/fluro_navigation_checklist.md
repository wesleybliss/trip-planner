# Fluro Router Implementation Checklist

This checklist provides a detailed breakdown of all the changes needed to fully implement Fluro router navigation throughout the Trip Planner application.

## 1. Route Definitions

### 1.1 Add New Routes to `lib/config/routing/routes.dart`

- [ ] Add route constants for all screens:
  - [ ] `static const String trips = '/trips';`
  - [ ] `static const String createTrip = '/trips/create';`
  - [ ] `static const String tripDetail = '/trips/:id';`
  - [ ] `static const String editTrip = '/trips/:id/edit';`
  - [ ] `static const String createPlan = '/trips/:tripId/plans/create';`
  - [ ] `static const String planDetail = '/plans/:id';`
  - [ ] `static const String editPlan = '/plans/:id/edit';`
  - [ ] `static const String createSegment = '/plans/:planId/segments/create';`
  - [ ] `static const String editSegment = '/segments/:id/edit';`

### 1.2 Register Routes in `configureRoutes` Method

- [ ] Add route definitions for all new routes using appropriate handlers
- [ ] Ensure proper transition types are set for each route

## 2. Route Handlers

### 2.1 Create New Handlers in `lib/config/routing/route_handlers.dart`

- [ ] Create handler for TripListScreen
- [ ] Create handler for CreateTripScreen (with parameter handling)
- [ ] Create handler for TripDetailScreen (with ID parameter)
- [ ] Create handler for EditTripScreen (with ID parameter)
- [ ] Create handler for CreatePlanScreen (with tripId parameter)
- [ ] Create handler for PlanDetailScreen (with ID parameter)
- [ ] Create handler for EditPlanScreen (with ID parameter)
- [ ] Create handler for CreateSegmentScreen (with planId parameter)
- [ ] Create handler for EditSegmentScreen (with ID parameter)

## 3. Navigation Service

### 3.1 Create Navigation Service (`lib/services/navigation_service.dart`)

- [ ] Create `NavigationService` class
- [ ] Add dependency on `Application.router`
- [ ] Implement `navigateTo` method for simple navigation
- [ ] Implement `navigateToWithParams` method for parameterized navigation
- [ ] Implement `navigateAndClearStack` method for authentication flows
- [ ] Implement `pop` method for going back
- [ ] Implement `popWithResult` method for returning results

## 4. Update Screen Navigation

### 4.1 TripListScreen (`lib/screens/trip_list_screen.dart`)

- [ ] Replace `_addTrip()` Navigator.push with Fluro navigation to create trip route
- [ ] Replace `_navigateToTripDetail()` Navigator.push with Fluro navigation to trip detail route
- [ ] Replace `_signOut()` Navigator.pushAndRemoveUntil with Fluro navigation to sign in route

### 4.2 TripDetailScreen (`lib/screens/trip_detail_screen.dart`)

- [ ] Replace `_editTrip()` Navigator.push with Fluro navigation to edit trip route
- [ ] Replace `_addPlan()` Navigator.push with Fluro navigation to create plan route
- [ ] Replace `_navigateToPlanDetail()` Navigator.push with Fluro navigation to plan detail route

### 4.3 PlanDetailScreen (`lib/screens/plan_detail_screen.dart`)

- [ ] Replace `_editPlan()` Navigator.push with Fluro navigation to edit plan route
- [ ] Replace `_addSegment()` Navigator.push with Fluro navigation to create segment route
- [ ] Replace `_navigateToSegmentDetail()` Navigator.push with Fluro navigation to segment detail route

### 4.4 Create/Edit Screens

- [ ] CreateTripScreen (`lib/screens/create_trip_screen.dart`):
  - [ ] Replace Navigator.pop with Fluro navigation result
- [ ] EditTripScreen (`lib/screens/edit_trip_screen.dart`):
  - [ ] Replace Navigator.pop with Fluro navigation result
- [ ] CreatePlanScreen (`lib/screens/create_plan_screen.dart`):
  - [ ] Replace Navigator.pop with Fluro navigation result
- [ ] EditPlanScreen (`lib/screens/edit_plan_screen.dart`):
  - [ ] Replace Navigator.pop with Fluro navigation result
- [ ] CreateSegmentScreen (`lib/screens/create_segment_screen.dart`):
  - [ ] Replace Navigator.pop with Fluro navigation result
- [ ] EditSegmentScreen (`lib/screens/edit_segment_screen.dart`):
  - [ ] Replace Navigator.pop with Fluro navigation result

## 5. App Configuration

### 5.1 Update `lib/app.dart`

- [ ] Ensure router is properly initialized before use
- [ ] Register NavigationService with dependency injection if needed
- [ ] Update MaterialApp to use router for navigation

## 6. Parameter Handling

### 6.1 Implement Parameter Conversion Utilities

- [ ] Add utilities to safely convert route parameters to appropriate types
- [ ] Handle optional parameters gracefully
- [ ] Implement proper error handling for invalid parameters

## 7. Testing

### 7.1 Verify All Navigation Flows

- [ ] Test trip creation flow
- [ ] Test trip editing flow
- [ ] Test plan creation flow
- [ ] Test plan editing flow
- [ ] Test segment creation flow
- [ ] Test segment editing flow
- [ ] Test sign out flow
- [ ] Test deep linking scenarios

### 7.2 Update Tests

- [ ] Update existing tests to work with new navigation approach
- [ ] Add new tests for Fluro navigation if needed

## 8. Validation

### 8.1 Code Review Checklist

- [ ] All Navigator.push calls replaced with Fluro navigation
- [ ] All Navigator.pushReplacement calls replaced with Fluro navigation
- [ ] All Navigator.pushAndRemoveUntil calls replaced with Fluro navigation
- [ ] All Navigator.pop calls properly handled or replaced
- [ ] Parameters correctly passed between screens
- [ ] Back navigation works correctly
- [ ] No direct route name strings used (all referenced via Routes constants)
- [ ] Error handling implemented for navigation failures

## 9. Documentation

### 9.1 Update Documentation

- [ ] Document new navigation patterns
- [ ] Update README if necessary
- [ ] Add comments to code where appropriate

By following this checklist, we can systematically ensure that all navigation throughout the Trip Planner application is handled via the Fluro router, providing a consistent and maintainable navigation architecture.