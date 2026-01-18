# Trip Planner Project Guidelines

## Core Features

### 1. Trip Planning & Management
- **Trips**: Create and manage multiple trips with customizable details
- **Plans**: Organize trips into detailed plans with start/end dates
- **Segments**: Break down plans into specific segments with places and bookings
- **Schengen Tracking**: Monitor days spent in Schengen region countries for visa compliance

### 2. Geolocation Services
- **Place Identification**: Integrate with geolocation services to identify and validate travel destinations
- **Map Integration**: Visual representation of travel routes and destinations using Google Maps

### 3. Authentication
- **Sign-in Options**: Support for Google Sign-In and Apple Sign-In
- **Secure Storage**: Use of flutter_secure_storage for sensitive user data

### 4. Data Persistence
- **Local Storage**: SharedPreferences for user preferences and lightweight data
- **Remote API**: Integration with backend services via RESTful API
- **Environment Configuration**: Use of flutter_dotenv for environment-specific configurations

## User Experience

### 1. Themed Interface
- **Light/Dark Mode**: Toggle between themes using the theme switcher in the app bar
- **Material Design**: Consistent with Flutter's Material Design guidelines
- **Custom Fonts**: Integration with Google Fonts for enhanced typography

### 2. Intuitive Navigation
- **Hierarchical Structure**: Navigate from Trips → Plans → Segments
- **CRUD Operations**: Create, read, update, and delete functionality for all entities
- **Visual Hierarchy**: Cards-based UI for easy scanning of trips and plans

### 3. Date & Time Management
- **Internationalization**: Using intl package for date/time formatting
- **Calendar Views**: Visual scheduling with proper date handling

## Project Structure
```
lib/
├── models/          # Data models (Trip, Plan, Segment, Place)
├── screens/         # UI Screens for different app views
├── services/        # API and remote service integrations
├── theme/           # Theme provider for light/dark mode
├── widgets/         # Reusable UI components
└── main.dart        # Entry point
```

## Build & Development Commands
- `flutter clean && flutter pub get` - Reset dependencies
- `flutter analyze` - Run static analysis
- `flutter test` - Run all tests
- `flutter build apk --release` - Build release APK for Android
- `flutter build ios --release` - Build release IPA for iOS
- `flutter build web` - Build for web deployment

## Code Style Guidelines
- **Architecture**: Follow entity-based organization with Provider for state management
- **Naming**: PascalCase for classes/widgets, camelCase for variables/functions, snake_case for files
- **Data Models**: Comprehensive JSON serialization/deserialization
- **State Management**: Provider for theme and potentially other app states
- **UI Components**: Small, composable widgets with clear responsibilities
- **Geolocation**: Proper integration with geolocator and geocoding packages
- **Security**: Secure storage for authentication tokens and sensitive data
- **API Integration**: DIO or HTTP client for REST API communications
- **Error Handling**: Implement proper error handling for network requests and user inputs
- **Check Your Work**: Always run `dart fix --apply` and/or `dart analyze` after any moderate code change.
- **No Clobber**: Never remove commented code unless it's very clear you were asked to refactor that specific part. Some things are commented for future use.

Refer to analysis_options.yaml for linting rules (flutter_lints package).
