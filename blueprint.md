# Trip Planner Application Blueprint

## Overview

This document outlines the architecture, features, and design of the Trip Planner application. This is a comprehensive trip planning application designed to help travelers organize itineraries, visualize schedules, and track important details like Schengen zone days.

## Style, Design, and Features

### Authentication

*   **Firebase Integration:** The application uses `firebase_dart` for a consistent, cross-platform authentication experience across Web, Desktop, and Mobile.
*   **Google Sign-In:** Users can sign in using their Google accounts. The flow uses the `google_sign_in` package to obtain OAuth credentials, which are then passed to Firebase via `firebase_dart`.
*   **Session Management:** The app maintains user sessions using Firebase's persistent authentication state.
*   **Sign-out:** A sign-out feature is available in the main trip list screen, clearing both the Firebase session and Google Sign-In state.

### Home Screen

*   **Trip List:** Displays a list of all the user's trips, with a visually appealing card for each trip.
*   **Create Trip:** A floating action button allows users to create a new trip.
*   **Edit and Delete Trip:** Users can edit or delete a trip from the home screen.

### Trip Detail Screen

*   **Trip Details:** Displays the trip's name, description, and a cover image.
*   **Plan List:** Displays a list of all the plans for the trip.
*   **Create, Edit, and Delete Plan:** Users can create, edit, or delete a plan from the trip detail screen.

### Plan Detail Screen

*   **Plan Details:** Displays the plan's name and description.
*   **Segment List:** Displays a list of all the segments for the plan.
*   **Create, Edit, and Delete Segment:** Users can create, edit, or delete a segment from the plan detail screen.

### Segment Creation and Editing

*   **Segment Form:** A form allows users to enter the segment's name, start and end dates, and place.
*   **Place Creation:** Users can create a new place from the segment form.

### Schengen Zone Tracking

*   **`isShengenRegion` field:** The `place` model now includes an `isShengenRegion` boolean field.
*   **UI for Schengen Selection:** The UI for creating and editing segments now includes a checkbox to mark a place as being in the Schengen Zone.
*   **Schengen Days Display:** The total number of days spent in the Schengen Zone is displayed on the trip and plan detail screens.
*   **Schengen Days Visualization:** A progress bar visualizes the number of Schengen days used out of the 90-day limit.

### Theme

*   **Light and Dark Mode:** The app supports both light and dark modes, with a theme toggle in the app bar.
*   **Customizable Theme:** The app uses a customizable theme with a primary seed color.
