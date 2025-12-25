#  Advanced Counter App

<div align="center">

![Flutter](https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white)
![Dart](https://img.shields.io/badge/Dart-0175C2?style=for-the-badge&logo=dart&logoColor=white)
![Material Design](https://img.shields.io/badge/Material%20Design-757575?style=for-the-badge&logo=material-design&logoColor=white)

**A feature-rich, production-ready Flutter counter application with modern UI/UX**

</div>

---

## 📋 Table of Contents

- [Overview](#-overview)
- [Features](#-features)
- [Installation](#-installation)
- [Project Structure](#-project-structure)
- [Architecture](#-architecture)
- [Technologies Used](#-technologies-used)
- [Usage Guide](#-usage-guide)
  
---

##  Overview

Advanced Counter App is a comprehensive Flutter application that demonstrates modern mobile development practices. It goes beyond a simple counter by implementing multiple advanced features including persistent storage, animations, theming, haptic feedback, and more.

---

##  Features

### Core Features

| Feature | Description |
|---------|-------------|
|  **Multiple Counters** | Create unlimited counters for different purposes |
|  **Goal Tracking** | Set custom goals and track progress with visual indicators |
|  **History Tracking** | View last 5 counter actions with timestamps |
|  **Undo/Redo** | Stack-based navigation to revert changes |
|  **Data Persistence** | All data saved locally using SharedPreferences |

### UI/UX Features

| Feature | Description |
|---------|-------------|
|  **Dark Mode** | Toggle between light and dark themes |
|  **Color Themes** | 5 beautiful color schemes (Indigo, Emerald, Rose, Amber, Cyan) |
|  **Animations** | Smooth scale animations and transitions |
|  **Confetti** | Celebrate goal achievements with confetti animation |
|  **Animated Background** | Subtle gradient animations |

### Interactive Features

| Feature | Description |
|---------|-------------|
|  **Export & Share** | Share counter as text or image |
|  **Sound Effects** | Audio feedback for actions (toggleable) |
|  **Haptic Feedback** | Vibration on button press (toggleable) |
|  **Custom Fonts** | Google Fonts (Poppins) integration |
|  **Settings** | Centralized configuration management |

---

##  Installation

### Prerequisites

- Flutter SDK (>=3.0.0)
- Dart SDK (>=3.0.0)
- Android Studio / VS Code
- iOS Simulator / Android Emulator (or physical device)

### Steps

1. **Clone the repository**
   ```bash
   git clone https://github.com/Abdelrahman2610/counter_app.git
   cd counter_app
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Run the app**
   ```bash
   # For default device
   flutter run

   # For specific device
   flutter devices
   flutter run -d <device-id>

   # For web
   flutter run -d chrome
   ```

4. **Build APK (Android)**
   ```bash
   flutter build apk --release
   ```

5. **Build iOS (macOS only)**
   ```bash
   flutter build ios --release
   ```

---

##  Project Structure

```
counter_app/
├── lib/
│   ├── main.dart                      # App entry point
│   ├── models/                        # Data models
│   │   ├── counter_model.dart         # Counter data structure
│   │   └── counter_history.dart       # History entry model
│   ├── screens/                       # Application screens
│   │   ├── multi_counter_screen.dart  # Home screen with tabs
│   │   ├── counter_screen.dart        # Individual counter detail
│   │   └── settings_screen.dart       # App settings
│   ├── widgets/                       # Reusable UI components
│   │   ├── counter_display.dart       # Counter value display
│   │   ├── action_button.dart         # Custom action button
│   │   ├── history_list.dart          # History list widget
│   │   ├── progress_goal.dart         # Goal progress indicator
│   │   ├── animated_background.dart   # Gradient background
│   │   └── counter_card.dart          # Counter card widget
│   ├── services/                      # Business logic services
│   │   ├── sound_service.dart         # Audio management
│   │   ├── haptic_service.dart        # Vibration feedback
│   │   ├── storage_service.dart       # Data persistence
│   │   └── export_service.dart        # Share functionality
│   ├── theme/                         # Theme configuration
│   │   └── app_theme.dart             # Light/Dark themes
│   ├── utils/                         # Utility classes
│   │   └── color_themes.dart          # Color scheme definitions
│   └── constants/                     # App constants
│       └── app_constants.dart         # Configuration values
├── assets/
│   └── sounds/                        # Audio files (optional)
├── pubspec.yaml                       # Dependencies
└──README.md                          # This file
```

---

##  Technologies Used

### Core Framework
- **Flutter**: ^3.0.0 - UI framework
- **Dart**: ^3.0.0 - Programming language

### Key Packages

| Package | Version | Purpose |
|---------|---------|---------|
| `google_fonts` | ^6.1.0 | Custom typography (Poppins) |
| `shared_preferences` | ^2.2.2 | Local data persistence |
| `confetti` | ^0.7.0 | Celebration animations |
| `audioplayers` | ^5.2.1 | Sound effects |
| `share_plus` | ^7.2.1 | Social sharing |
| `screenshot` | ^3.0.0 | Image capture for sharing |
| `path_provider` | ^2.1.1 | File system access |

### Design System
- **Material Design 3**: Modern UI components
- **Custom Color Schemes**: 5 theme variants
- **Responsive Layout**: Adapts to different screen sizes

---

##  Usage Guide

### Creating Your First Counter

1. Launch the app
2. Tap the **"+ New Counter"** floating action button
3. Enter a name (e.g., "Daily Steps")
4. Set a goal (e.g., 10000)
5. Tap **"Create"**

### Using a Counter

1. **Increment**: Tap the green **"+"** button or FAB
2. **Decrement**: Tap the red **"-"** button
3. **Reset**: Tap **"Reset Counter"** button
4. **Undo**: Tap the undo icon in the app bar
5. **Edit Goal**: Tap **"Edit"** in the progress card

### Customizing Appearance

1. Open **Settings** from the app bar
2. **Dark Mode**: Toggle the switch
3. **Color Theme**: Select from 5 options
   - Indigo (default)
   - Emerald
   - Rose
   - Amber
   - Cyan

### Managing Feedback

In **Settings**, you can control:
- **Sound Effects**: Toggle audio feedback
- **Haptic Feedback**: Toggle vibration

### Sharing Your Progress

1. Open any counter detail
2. Tap the **Share** icon
3. Choose:
   - **Text**: Share as formatted text
   - **Image**: Share as screenshot

---
