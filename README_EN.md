[中文](README.md)

# Graduate Entrance Examination Artifact

A Flutter application to help graduate entrance examination students efficiently manage key points and notes.

## Application Introduction

Graduate Entrance Examination Artifact is a learning assistant tool designed specifically for graduate entrance examination students, helping users systematically manage key points and related notes for various subjects to improve review efficiency. The application features a modern UI design, easy operation, and practical functionality.

## Main Features

### Subject Management
- Built-in fixed subjects: Politics, English, and Mathematics
- Support for adding, editing, and deleting professional subjects
- Clear subject classification for systematic review

### Key Points Management
- Add important key points for each subject
- Support for adding, editing, and deleting key points
- Key point search function for quick content location

### Note System
- Add detailed notes for each key point
- Notes support title and content formatting
- Note adding, editing, and deleting functionality
- Note search function for easy retrieval

### Data Persistence
- Use SharedPreferences for local data storage
- Automatically save all user-added content
- Data retention after application restart

### AI-powered Q&A
- For each note, supports calling AI API to automatically generate detailed explanations and answers
- Supports caching AI responses to reduce duplicate requests

### Theme Settings
- Supports light, dark, and system theme modes
- Switch theme in the settings page

## Technical Implementation

- Developed using Flutter framework, supporting multi-platform deployment
- Material Design 3 style
- Responsive UI design, adapting to different screen sizes
- Using SharedPreferences for data persistence storage
- Integrated AI API for intelligent Q&A
- Supports theme switching (light/dark/system)

## Development Environment

- Flutter SDK: ^3.7.2
- Dart SDK: Version compatible with Flutter SDK
- Dependencies:
  - shared_preferences: ^2.5.3
  - cupertino_icons: ^1.0.8
  - http: ^1.1.0
  - flutter_markdown: ^0.6.18+3

## Installation and Usage

1. Ensure Flutter environment is installed
2. Clone the project locally
3. Run the following command to install dependencies:
   ```
   flutter pub get
   ```
4. Connect device or start emulator, run the application:
   ```
   flutter run
   ```

## Project Structure

- `lib/main.dart`: Application main entry, includes homepage, subject management, and theme switching functionality
- `lib/note_page.dart`: Notes page, implements note CRUD and AI Q&A entry
- `lib/ai_response_page.dart`: AI Q&A page, auto-generates detailed note explanations
- `lib/settings_page.dart`: Settings page, supports theme switching
- `assets/`: Stores application icons and other resource files

## Contribution Guidelines

Welcome to submit Issues or Pull Requests to improve this project.