# SeeMyTrip Developer Documentation

## 1. Project Overview

**SeeMyTrip** is a comprehensive travel booking application built with Flutter. It allows users to book flights, trains, buses, hotels, and holiday packages. The application features a modern UI, secure authentication, real-time availability checks, and multi-language support.

### Key Features
- **Multi-modal Booking**: Flights, Hotels, Buses, Trains.
- **Authentication**: Email/Password and Google Sign-In via Firebase.
- **State Management**: Powered by **GetX** for reactive state management and dependency injection.
- **Localization**: Support for multiple languages including English, Hindi, French, Spanish, etc.
- **Theming**: Light and Dark mode support.
- **Offline Support**: Connectivity monitoring and local storage.

---

## 2. Tech Stack

- **Framework**: Flutter (Dart)
- **State Management**: GetX
- **Backend Services**: 
  - Firebase (Auth, Core)
  - REST APIs (Custom Backend)
- **Networking**: `http` and `dio`
- **Local Storage**: `SharedPreferences`, `GetStorage`
- **Maps**: `google_maps_flutter`, `flutter_map` (Leaflet)
- **Payment**: Razorpay, Easebuzz
- **UI Components**: `flutter_svg`, `lottie`, `shimmer`, `carousel_slider`

---

## 3. Project Structure

The project follows a **Feature-First** architecture, organizing code by business features rather than technical layers.

```
lib/
├── core/                  # Core functionality shared across the app
│   ├── config/           # App configuration (API URLs, Env vars)
│   ├── controllers/      # Global controllers (Network, etc.)
│   ├── routes/           # App routing (AppRoutes)
│   ├── theme/            # Theme definitions (AppTheme, ThemeService)
│   ├── utils/            # Helper functions and constants
│   └── widgets/          # Global reusable widgets
│
├── features/             # Feature modules
│   ├── auth/             # Authentication (Login, Signup)
│   ├── home/             # Home screen and dashboard
│   ├── flights/          # Flight booking flow
│   ├── hotels/           # Hotel booking flow
│   ├── buses/            # Bus booking flow
│   ├── train/            # Train booking flow
│   ├── profile/          # User profile management
│   └── shared/           # Shared resources within features
│
├── shared/               # Shared services and models
│   └── services/         # API services
│
├── translations/         # Localization files (AppTranslations)
└── main.dart             # Application entry point
```

---

## 4. Setup & Installation

### Prerequisites
- Flutter SDK (>=2.17.1 <3.0.0)
- Dart SDK
- Android Studio / Xcode
- Git

### Installation Steps

1.  **Clone the Repository**
    ```bash
    git clone <repository-url>
    cd seemytrip_flutter
    ```

2.  **Install Dependencies**
    ```bash
    flutter pub get
    ```

3.  **Configuration**
    - Ensure `google-services.json` (Android) and `GoogleService-Info.plist` (iOS) are present for Firebase.
    - Check `lib/core/config/app_config.dart` for API endpoints.

4.  **Code Generation** (Optional but recommended)
    ```bash
    flutter pub run build_runner build --delete-conflicting-outputs
    ```

5.  **Run the App**
    ```bash
    flutter run
    ```

---

## 5. Key Modules & Implementation Details

### 5.1 Authentication (`features/auth`)
- **Controllers**: `LoginController` handles login, signup, and Google Auth.
- **Networking**: Uses `http` package for API calls to the backend.
- **Token Management**: Access tokens are stored in `SharedPreferences`.
- **Firebase**: Used for Google Sign-In and initial auth verification.

### 5.2 Navigation & Routing
- **System**: GetX Navigation (`Get.to`, `Get.offAll`).
- **Routes**: Defined in `lib/core/routes/app_routes.dart`.
- **Bottom Navigation**: Managed in `NavigationScreen` (often part of Home or Core).

### 5.3 State Management (GetX)
- **Reactive State**: Variables are made observable (`.obs`) and UI updates automatically using `Obx(() => ...)`.
- **Dependency Injection**: Controllers are injected using `Get.put()` or `Get.lazyPut()`.
- **Bindings**: Used to initialize controllers when a route is loaded.

### 5.4 Networking
- **Clients**: The app uses a mix of `http` (Auth) and `Dio` (Trains/others).
- **Connectivity**: `NetworkController` (`lib/core/controllers/network_controller.dart`) monitors internet connection using `connectivity_plus` and pings `google.com` for verification.

### 5.5 Theming
- **Service**: `ThemeService` (`lib/core/theme/theme_service.dart`) manages theme switching.
- **Persistence**: Theme preference is saved using `GetStorage` or `SharedPreferences`.
- **Fonts**: The app uses the **Poppins** font family.

### 5.6 Localization
- **Setup**: `AppTranslations` class defines strings for supported languages.
- **Controller**: `LanguageController` manages the current locale.
- **Supported Locales**: English, Hindi, Tamil, Kannada, Telugu, Odia, French, Spanish, Arabic, German, Chinese.

---

## 6. API Integration

### Base URLs
API endpoints are typically defined in `lib/core/config/app_config.dart`.

### Common Patterns
1.  **Request**: Controller creates a request object/map.
2.  **Call**: `http.post()` or `dio.get()` is called.
3.  **Response**: JSON response is parsed.
4.  **Error Handling**: `try-catch` blocks handle network errors and non-200 status codes.
5.  **UI Feedback**: `Get.snackbar()` is used to show success or error messages.

---

## 7. Build & Deployment

### Android
- **Build APK**: `flutter build apk --release`
- **Build App Bundle**: `flutter build appbundle --release`
- **Keystore**: Ensure `key.properties` is configured for signing.

### iOS
- **Build Archive**: `flutter build ipa --release`
- **Pod Install**: Run `cd ios && pod install` before building.

---

## 8. Troubleshooting

- **Gradle Errors**: Check `android/build.gradle` and `android/app/build.gradle` for Kotlin/Gradle version compatibility.
- **CocoaPods Issues**: Run `pod deintegrate` and `pod install` in `ios/` directory.
- **Assets Not Found**: Verify `pubspec.yaml` asset paths and run `flutter pub get`.
- **Map Issues**: Ensure Google Maps API key is valid and enabled in Google Cloud Console.

---

## 9. Coding Guidelines

- **File Naming**: snake_case (e.g., `home_screen.dart`).
- **Class Naming**: PascalCase (e.g., `HomeScreen`).
- **Imports**: Use relative imports for files within the same feature, and package imports for core/shared modules.
- **Comments**: Document complex logic and API integrations.

---

## 10. Utility Scripts

The project includes PowerShell scripts for maintenance and optimization:

-   **`convert_to_webp.ps1`**: Converts PNG/JPG assets to WebP format to reduce app size. Requires `cwebp` tool.
-   **`compress_apk_assets.ps1`**: Analyzes and compresses assets within a built APK.

