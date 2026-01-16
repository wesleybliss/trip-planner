# Trip Planner - Blueprint

## Overview

A comprehensive trip planning application designed to help travelers organize itineraries, visualize schedules, and track important details like Schengen zone days.

## Features & Style

### Implemented

*   **Initial Project Setup:**
    *   Created the Flutter project.
    *   Added necessary dependencies: `provider`, `google_fonts`, `http`, and `intl`.
    *   Defined data models for `ApiResponse`, `User`, `Trip`, `Plan`, `Segment`, and `Place`.
    *   Created a mock `ApiService` to simulate fetching trip data.
    *   Set up the basic app structure with a `HomeScreen` and `TripDetailScreen`.
    *   Implemented a basic theme with light and dark modes using `provider`.
*   **Trip Management (CRUD):**
    *   Implemented the ability to create, read, update, and delete trips.
    *   Created `create_trip_screen.dart` and `edit_trip_screen.dart`.
    *   The `HomeScreen` displays a list of trips, and users can tap on a trip to view its details.
*   **Plan Management (CRUD):**
    *   Implemented the ability to create, read, update, and delete plans within a trip.
    *   Created `create_plan_screen.dart` and `edit_plan_screen.dart`.
    *   The `TripDetailScreen` displays a list of plans for a trip.
*   **Segment Management (CRUD):**
    *   Implemented the ability to create, read, update, and delete segments within a plan.
    *   Created `create_segment_screen.dart` and `edit_segment_screen.dart`.
    *   The `PlanDetailScreen` displays a list of segments for a plan.

### Current Plan

*   **UI/UX Enhancements:**
    *   Refine the visual design of all screens for a more polished and intuitive user experience.
    *   Add a calendar view to visualize the trip schedule.
    *   Implement a more user-friendly way to select places (e.g., using a map or a search API).
*   **Backend Integration:**
    *   Replace the mock `ApiService` with a real backend implementation (e.g., using Firebase or a custom REST API).
*   **Schengen Zone Tracking:**
    *   Implement the logic to calculate and display the number of days spent in the Schengen zone.

## Project Setup Checklist

- [x] Create Flutter project
- [x] Update `pubspec.yaml` with dependencies
- [x] Create data models
- [x] Create mock API service
- [x] Update `main.dart`
- [x] Create project setup checklist file
- [x] Implement Trip CRUD
- [x] Implement Plan CRUD
- [x] Implement Segment CRUD
