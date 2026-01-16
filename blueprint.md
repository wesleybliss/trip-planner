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
*   **Plan Details:**
    *   Created a `PlanDetailScreen` to display the segments of a plan.
    *   Added navigation from the `TripDetailScreen` to the `PlanDetailScreen`.

### Current Plan

*   Enhance the visual design of the trip and plan detail screens.
*   Implement the ability to create, edit, and delete trips and plans.
*   Add a calendar view to visualize the trip schedule.

## Project Setup Checklist

- [x] Create Flutter project
- [x] Update `pubspec.yaml` with dependencies
- [x] Create data models
- [x] Create mock API service
- [x] Update `main.dart`
- [x] Create project setup checklist file
