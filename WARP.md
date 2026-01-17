# WARP.md

This file provides guidance to WARP (warp.dev) when working with code in this repository.

## Development Commands

### Essential Commands
- `flutter pub get` - Install dependencies
- `flutter run` - Run app in debug mode on connected device/emulator
- `flutter run -d linux` - Run on Linux desktop
- `flutter run -d chrome --web-renderer html` - Run web version
- `dart analyze` - Run static analysis (REQUIRED after moderate code changes)
- `flutter test` - Run all tests
- `flutter clean && flutter pub get` - Clean build artifacts and reinstall dependencies

### Build Commands
- `flutter build apk --release` - Build release APK for Android
- `flutter build ios --release` - Build release IPA for iOS
- `flutter build web` - Build for web deployment
- `flutter build linux` - Build for Linux desktop

## Architecture Overview

### State Management Approach
The app uses a **hybrid state management architecture**:
- **Provider**: Theme management (`ThemeProvider`) using `ChangeNotifier`
- **Riverpod**: Primary state management system (flutter_riverpod with annotations)
- **Firebase Auth**: Authentication state managed through Firebase Auth streams
- The architecture is in transition - legacy code uses Provider, new code should use Riverpod

### Dependency Injection
- **spot_di**: Custom DI container for service locator pattern
- Configuration in `lib/domain/di/spot_module.dart`
- Access dependencies via `spot<Type>()` function
- Core services: `IDioClient` for HTTP requests

### Application Initialization Flow
1. `main.dart` → `Application.initialize()`
2. Initializes: logging, environment variables (.env), SharedPreferences, DI container
3. Initializes Firebase (Auth, Crashlytics)
4. Desktop platforms: configure window manager
5. Mounts root widget (`TripPlannerApp`) with Provider wrapping
6. App checks auth state → routes to `SignInScreen` or `TripListScreen`

### Core Domain Structure
```
lib/
├── config/              # App configuration, routing
│   ├── application.dart # Centralized app initialization
│   └── routing/         # Fluro router configuration
├── domain/              # Domain layer (DDD-influenced)
│   ├── constants/       # App-wide constants (strings, keys, routing)
│   ├── di/              # Dependency injection module
│   ├── extensions/      # Dart extension methods
│   └── io/              # I/O abstractions
│       ├── net/         # HTTP client (DioClient)
│       └── repos/       # Repository pattern implementations
├── models/              # Data models with JSON serialization
├── screens/             # UI screens organized by feature
├── services/            # Business logic services (ApiService)
├── theme/               # Theme provider
├── utils/               # Utilities (logger, Firebase utils, Crashlytics)
└── widgets/             # Reusable UI components
```

### Data Flow & API Integration
- **Backend API**: RESTful API at `https://trip-planner-basic.vercel.app/api` (production)
- **Local Dev**: Can switch to `http://localhost:3002/api` via `useLocalApiServer` flag in `constants/strings.dart`
- **HTTP Client**: `DioClient` (wraps Dio) handles all HTTP requests
- **Authentication**: Firebase Auth provides ID tokens, automatically injected as Bearer token via Dio interceptor
- **API Structure**: 
  - Auth: `/auth/me`, `/auth/signin`, `/auth/signup`
  - Trips: `/trips`, `/trips/:id`
  - Plans: `/trips/:tripId/plans`, `/plans/:id`
  - Segments: `/trips/:tripId/plans/:planId/segments`

### Entity Hierarchy
Trip (top-level) → Plans (travel itinerary phases) → Segments (specific locations/activities)
- Each entity has full CRUD operations via `ApiService`
- Models support conditional includes (`?withDetails=true`, `?withSegments=true`)

### Authentication Flow
1. Firebase Authentication handles user identity (email/password, Google, Apple)
2. On auth state change, `DioClient` interceptor adds Firebase ID token to requests
3. Backend validates Firebase token and returns/creates corresponding User record
4. App checks auth via `ApiService.getAuthenticatedUser()` → `/auth/me`

### Routing
- **Router**: Fluro (declarative routing library)
- **Configuration**: `lib/config/routing/routes.dart` defines all routes
- **Pattern**: String-based paths with handlers in `route_handlers.dart`
- **Error Handling**: Custom 404 handler with `ErrorScreen`

### Special Features
- **Schengen Tracking**: Domain logic for tracking days spent in Schengen zone countries
- **Geolocation**: Uses `geolocator` and `geocoding` packages for place identification
- **Google Maps**: Integration via `google_maps_flutter`
- **Offline Support**: Drift database setup (currently commented out but infrastructure exists)

## Code Style & Conventions

### Naming Conventions
- **Files**: snake_case (e.g., `trip_detail_screen.dart`)
- **Classes/Widgets**: PascalCase (e.g., `TripDetailScreen`)
- **Variables/Functions**: camelCase (e.g., `getTripDetails`)
- **Constants**: camelCase in classes, SCREAMING_SNAKE_CASE for top-level

### Linting
- Follows `package:flutter_lints/flutter.yaml` rules
- Check `analysis_options.yaml` for any custom overrides

### Error Handling
- Use try-catch in service methods
- Throw descriptive exceptions: `throw Exception('Failed to load trips')`
- Global error widget builder configured in `app.dart` to use `ErrorScreen`
- Firebase Crashlytics integration for production crash reporting

### Logging
- Custom `Logger` class in `utils/logger.dart`
- Configure log level via `Logger.globalLevel` in `Application.initialize()`
- Use named loggers: `final log = Logger('ClassName')`

### Environment Variables
- Stored in `.env` file at project root
- Loaded via `flutter_dotenv` during app initialization
- Access via `dotenv.env['KEY_NAME']`
- **Note**: .env contains debug credentials - never commit sensitive production values

### Commented Code
- Do NOT remove commented code unless explicitly instructed
- Some commented sections are for future features (e.g., Drift database, GraphQL setup)
- Commented imports/logic indicate work-in-progress or planned features

### Critical Practices
- **Always run `dart analyze`** after moderate code changes
- Check Firebase Auth state before making authenticated API calls
- Use `copyWith` methods on models for immutable updates
- Prefer `withDetails`/`withSegments` query params to reduce API calls when fetching nested data
