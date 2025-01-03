# mit_event

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

Architecture--->

##
lib/
├── main.dart                   # Entry point of the application
├── core/
│   ├── models/                 # Data models for the app
│   │   ├── user_model.dart     # User model (student/admin)
│   │   ├── event_model.dart    # Event model (event details)
│   └── providers/              # State management providers
│       ├── auth_provider.dart  # Authentication state (login/logout)
│       ├── event_provider.dart # Event state (create/view/manage events)
│       ├── user_provider.dart  # User-specific state (profiles, registrations)
├── data/
│   ├── repositories/           # Handles API and database interactions
│   │   ├── event_repository.dart # Event-related API/database logic
│   │   ├── user_repository.dart # User-related API/database logic
│   └── services/               # Services for external APIs, notifications, etc.
│       ├── notification_service.dart # Push notification logic
│       ├── api_service.dart    # Base API handling (HTTP requests)
│       ├── firebase_service.dart # Firebase integrations (optional)
├── ui/
│   ├── screens/                # All app screens
│   │   ├── auth/               # Authentication screens
│   │   │   ├── login_screen.dart   # Login screen
│   │   │   ├── register_screen.dart # Registration screen
│   │   ├── student/            # Screens for students
│   │   │   ├── student_dashboard_screen.dart # Event feed for students
│   │   │   ├── event_detail_screen.dart      # Detailed view of an event
│   │   │   ├── profile_screen.dart           # Student profile
│   │   ├── admin/              # Screens for club admins
│   │   │   ├── admin_dashboard_screen.dart # Admin dashboard
│   │   │   ├── create_event_screen.dart    # Event creation
│   │   │   ├── manage_events_screen.dart   # Edit/delete events
│   │   ├── common/             # Screens shared by both students and admins
│   │       ├── splash_screen.dart   # Splash/loading screen
│   │       ├── notification_screen.dart # View notifications
│   ├── widgets/                # Reusable UI components
│       ├── event_card.dart     # Card widget for event display
│       ├── custom_button.dart  # Custom button styles
│       ├── input_field.dart    # Reusable input fields
│       ├── app_drawer.dart     # Side navigation drawer
├── utils/
│   ├── constants.dart          # App-wide constants (e.g., colors, fonts)
│   ├── helpers.dart            # Helper functions (e.g., formatting dates)
│   ├── app_routes.dart         # Route definitions for navigation
│   ├── themes.dart             # Theme and styling for the app
└── assets/
    ├── images/                 # App images and icons
    ├── fonts/                  # Custom fonts
    ├── json/                   # Local JSON files for testing

