# SMA N 1 Girsang Sipangan Bolon Mobile App

A Flutter application for students and teachers of SMA N 1 Girsang Sipangan Bolon.

## Features

- Login for students and teachers
- View announcements
- Check attendance records
- View class schedules
- Access academic calendar
- Receive notifications

## Getting Started

### Prerequisites

- Flutter SDK (version 3.0.0 or higher)
- Dart SDK
- Android Studio or VS Code with Flutter extensions

### Installation

1. Clone this repository
   ```bash
   git clone https://your-repository-url-here
   ```

2. Navigate to the project directory
   ```bash
   cd sma
   ```

3. Install dependencies
   ```bash
   flutter pub get
   ```

4. Run the app
   ```bash
   flutter run
   ```

## Architecture

This app follows a Provider pattern for state management with a clean architecture approach:

- `lib/models/` - Data models
- `lib/screens/` - UI screens
- `lib/providers/` - State management
- `lib/services/` - API services and business logic
- `lib/utils/` - Helper functions and utilities

## Backend Integration

This mobile app integrates with a Laravel backend. See API_INTEGRATION.md in the server repository for detailed API documentation.

## Theme Customization

The app uses a consistent theme based on the school's colors. To modify the theme, edit the `ThemeData` in `lib/main.dart`.
