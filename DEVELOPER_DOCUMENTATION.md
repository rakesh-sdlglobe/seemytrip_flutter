# SeeMyTrip Flutter App - Developer Documentation

## Table of Contents
1. [Project Overview](#project-overview)
2. [Architecture & Design Patterns](#architecture--design-patterns)
3. [Project Structure](#project-structure)
4. [Core Features](#core-features)
5. [State Management](#state-management)
6. [API Integration](#api-integration)
7. [Authentication System](#authentication-system)
8. [Payment Integration](#payment-integration)
9. [Multi-language Support](#multi-language-support)
10. [Theme System](#theme-system)
11. [Dependencies](#dependencies)
12. [Setup & Installation](#setup--installation)
13. [Development Guidelines](#development-guidelines)
14. [Testing](#testing)
15. [Deployment](#deployment)
16. [Troubleshooting](#troubleshooting)

---

## Project Overview

**SeeMyTrip** is a comprehensive travel booking application built with Flutter that enables users to book flights, trains, buses, hotels, and holiday packages. The app provides a seamless booking experience with real-time availability, secure payments, and multi-language support.

### Key Features
- **Multi-modal Travel Booking**: Flights, Trains, Buses, Hotels
- **User Authentication**: Email/Password + Google Sign-In
- **Real-time Search**: Live availability and pricing
- **Secure Payments**: Razorpay integration
- **Multi-language Support**: 10+ languages
- **Dark/Light Theme**: Adaptive theming
- **Offline Support**: Cached data and offline capabilities
- **Booking Management**: Trip history and management

---

## Architecture & Design Patterns

### Architecture Pattern
The app follows **Feature-Based Architecture** with **GetX** state management:

```
lib/
├── core/                    # Core functionality
│   ├── config/             # App configuration
│   ├── presentation/       # Core UI components
│   ├── routes/             # App routing
│   ├── theme/              # Theme management
│   └── utils/              # Utility functions
├── features/               # Feature modules
│   ├── auth/               # Authentication
│   ├── flights/            # Flight booking
│   ├── trains/             # Train booking
│   ├── buses/              # Bus booking
│   ├── hotels/             # Hotel booking
│   ├── profile/            # User profile
│   └── shared/             # Shared components
└── main.dart               # App entry point
```

### Design Patterns Used
1. **MVC (Model-View-Controller)**: Clear separation of concerns
2. **Repository Pattern**: Data access abstraction
3. **Observer Pattern**: GetX reactive programming
4. **Factory Pattern**: Widget creation and configuration
5. **Singleton Pattern**: Controllers and services

---

## Project Structure

### Core Module (`lib/core/`)
```
core/
├── config/
│   └── app_config.dart          # API endpoints and configuration
├── presentation/
│   ├── screens/
│   │   ├── splash/             # Splash screen
│   │   └── navigation/         # Main navigation
│   └── widgets/                # Reusable UI components
├── routes/
│   └── app_routes.dart         # Route definitions
├── theme/
│   ├── app_colors.dart         # Color definitions
│   ├── app_theme.dart          # Theme configuration
│   ├── app_text_styles.dart    # Typography
│   └── theme_service.dart      # Theme management
└── utils/
    ├── constants.dart          # App constants
    ├── helpers/                # Helper functions
    └── extensions/             # Dart extensions
```

### Feature Modules (`lib/features/`)
Each feature follows the same structure:
```
features/[feature_name]/
├── data/
│   ├── models/                 # Data models
│   └── services/               # API services
├── domain/
│   └── models/                 # Business models
└── presentation/
    ├── controllers/            # GetX controllers
    ├── screens/                # UI screens
    └── widgets/                # Feature-specific widgets
```

---

## Core Features

### 1. Flight Booking
**Location**: `lib/features/flights/`

**Key Components**:
- `FlightController`: Manages flight search and booking
- `FlightSearchController`: Handles search form logic
- `FlightModel`: Data models for flight information

**Features**:
- One-way, Round-trip, and Multi-city searches
- Real-time flight availability
- Price comparison and filtering
- Seat selection and passenger details
- Booking confirmation and payment

**API Integration**:
```dart
// Flight search endpoint
static const String flightsSearch = '$baseUrl/flights/getFlightsList';
static const String flightsAirports = '$baseUrl/flights/getFlightsAirports';
```

### 2. Hotel Booking
**Location**: `lib/features/hotels/`

**Key Components**:
- `HotelController`: Manages hotel search and booking
- `HotelFilterController`: Handles filtering and sorting
- `HotelPaymentController`: Payment processing

**Features**:
- City-based hotel search
- Date range selection
- Room and guest configuration
- Hotel details and images
- Booking preview and payment

**API Integration**:
```dart
// Hotel endpoints
static const String hotelCities = '$baseUrl/hotels/getHotelCities';
static const String hotelsList = '$baseUrl/hotels/getHotelsList';
static const String hotelDetails = '$baseUrl/hotels/getHoteldetails';
```

### 3. Train Booking
**Location**: `lib/features/train/`

**Features**:
- Station search and selection
- Train schedule and availability
- Seat selection and booking
- PNR status checking

### 4. Bus Booking
**Location**: `lib/features/bus/`

**Key Components**:
- `BusController`: Manages bus search and booking
- `BusSearchResult`: Data model for search results

**Features**:
- City-based bus search
- Date and time selection
- Seat layout and selection
- Boarding point details

**API Integration**:
```dart
// Bus endpoints
static const String busAuth = '$baseUrl/bus/authenticateBusAPI';
static const String busCities = '$baseUrl/bus/getBusCityList';
static const String busSearch = '$baseUrl/bus/busSearch';
```

---

## State Management

### GetX Implementation
The app uses **GetX** for state management, providing:
- **Reactive Programming**: `Rx` variables for reactive UI
- **Dependency Injection**: `Get.put()`, `Get.find()`
- **Route Management**: `Get.to()`, `Get.offAll()`
- **State Management**: Controllers with `GetxController`

### Controller Pattern
```dart
class FlightController extends GetxController {
  // Reactive variables
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;
  final RxList<Flight> flights = <Flight>[].obs;
  
  // Methods
  Future<void> searchFlights() async {
    isLoading.value = true;
    try {
      // API call logic
      flights.value = await flightService.searchFlights();
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }
}
```

### State Management Best Practices
1. **Single Responsibility**: Each controller handles one feature
2. **Reactive Updates**: Use `.obs` for UI-reactive variables
3. **Error Handling**: Proper try-catch with user feedback
4. **Loading States**: Show loading indicators during API calls
5. **Memory Management**: Dispose controllers when not needed

---

## API Integration

### Configuration
**File**: `lib/core/config/app_config.dart`

```dart
class AppConfig {
  static const String baseUrl = 'http://192.168.0.12:3002/api';
  
  // Auth endpoints
  static const String login = '$baseUrl/login';
  static const String signUp = '$baseUrl/signup';
  
  // Feature endpoints
  static const String flightsSearch = '$baseUrl/flights/getFlightsList';
  static const String hotelsList = '$baseUrl/hotels/getHotelsList';
  // ... more endpoints
}
```

### HTTP Client
The app uses both `http` and `dio` packages for API calls:

```dart
// Using http package
final response = await http.post(
  Uri.parse(AppConfig.flightsSearch),
  headers: {'Content-Type': 'application/json'},
  body: jsonEncode(requestData),
);

// Using dio package
final response = await dio.post(
  AppConfig.hotelsList,
  data: requestData,
  options: Options(headers: {'Content-Type': 'application/json'}),
);
```

### Error Handling
```dart
try {
  final response = await apiCall();
  if (response.statusCode == 200) {
    // Success handling
  } else {
    // Error handling
    throw Exception('API Error: ${response.statusCode}');
  }
} catch (e) {
  // User-friendly error message
  Get.snackbar('Error', 'Failed to load data: $e');
}
```

---

## Authentication System

### Implementation
**Location**: `lib/features/auth/`

### Authentication Methods
1. **Email/Password Login**
2. **Google Sign-In**
3. **Mobile OTP** (planned)

### Key Components
- `LoginController`: Manages authentication logic
- `LoginScreen`: UI for login/signup
- `OTPController`: Handles OTP verification

### Firebase Integration
```dart
// Firebase Auth setup
final FirebaseAuth _auth = FirebaseAuth.instance;
final GoogleSignIn _googleSignIn = GoogleSignIn();

// Google Sign-In flow
Future<void> signInWithGoogle() async {
  final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
  final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
  final OAuthCredential credential = GoogleAuthProvider.credential(
    accessToken: googleAuth.accessToken,
    idToken: googleAuth.idToken,
  );
  await _auth.signInWithCredential(credential);
}
```

### Token Management
```dart
// Save token
final SharedPreferences prefs = await SharedPreferences.getInstance();
await prefs.setString('accessToken', token);

// Use token in API calls
final String? token = prefs.getString('accessToken');
headers: {'Authorization': 'Bearer $token'}
```

---

## Payment Integration

### Razorpay Integration
**Location**: `lib/components/payment_controller.dart`

### Implementation
```dart
class PaymentController extends GetxController {
  final Razorpay _razorpay = Razorpay();
  final String razorpayKey = 'rzp_test_8PKYstLwYTk5Qy';
  
  void openRazorpay({
    required String orderId,
    required double amount,
    required String name,
    required String email,
    required String phone,
  }) {
    final options = {
      'key': razorpayKey,
      'amount': (amount * 100).toInt(),
      'name': name,
      'description': 'Booking Payment',
      'order_id': orderId,
      'prefill': {'contact': phone, 'email': email, 'name': name},
    };
    _razorpay.open(options);
  }
}
```

### Payment Flow
1. **Create Order**: Backend creates Razorpay order
2. **Open Payment**: Razorpay payment gateway
3. **Handle Response**: Success/Error callbacks
4. **Confirm Booking**: Update booking status

### Payment Methods Supported
- UPI
- Credit/Debit Cards
- Net Banking
- Wallets (Paytm, PhonePe, etc.)

---

## Multi-language Support

### Implementation
**File**: `lib/translations/app_translations.dart`

### Supported Languages
- English (en)
- Hindi (hi)
- Tamil (ta)
- Kannada (kn)
- Telugu (te)
- Odia (or)
- French (fr)
- Spanish (es)
- Arabic (ar)
- German (de)
- Chinese (zh)

### Usage
```dart
// In widgets
Text('welcome'.tr)

// In controllers
Get.find<LanguageController>().changeLanguage('hi');
```

### Language Controller
```dart
class LanguageController extends GetxController {
  final Rx<Locale> currentLocale = const Locale('en').obs;
  
  void changeLanguage(String languageCode) {
    currentLocale.value = Locale(languageCode);
    Get.updateLocale(Locale(languageCode));
  }
}
```

---

## Theme System

### Color System
**File**: `lib/core/theme/app_colors.dart`

```dart
class AppColors {
  // Primary colors
  static const Color primary = Color(0xFF2196F3);
  static const Color primaryDark = Color(0xFF1976D2);
  static const Color secondary = Color(0xFF03DAC5);
  
  // Light theme colors
  static const Color background = Color(0xFFF5F5F5);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color textPrimary = Color(0xFF000000);
  
  // Dark theme colors
  static const Color backgroundDark = Color(0xFF121212);
  static const Color surfaceDark = Color(0xFF1E1E1E);
}
```

### Theme Configuration
**File**: `lib/core/theme/app_theme.dart`

```dart
class AppTheme {
  static ThemeData get lightTheme => ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.light(
      primary: AppColors.primary,
      secondary: AppColors.secondary,
      // ... more colors
    ),
    // ... theme configuration
  );
  
  static ThemeData get darkTheme => ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.dark(
      primary: AppColors.primary,
      secondary: AppColors.secondary,
      // ... more colors
    ),
    // ... theme configuration
  );
}
```

### Typography
**File**: `lib/core/theme/app_text_styles.dart`

```dart
class AppTextStyles {
  static const TextStyle heading1 = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.bold,
    fontFamily: 'PoppinsBold',
  );
  
  static const TextStyle bodyLarge = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.normal,
    fontFamily: 'PoppinsRegular',
  );
}
```

---

## Dependencies

### Core Dependencies
```yaml
dependencies:
  flutter:
    sdk: flutter
  
  # State Management
  get: ^4.6.6
  get_storage: ^2.1.1
  
  # HTTP & Networking
  http: ^1.2.2
  dio: ^5.7.0
  
  # Authentication
  firebase_core: ^3.13.0
  firebase_auth: ^5.3.4
  google_sign_in: ^6.2.2
  
  # UI Components
  flutter_svg: ^2.1.0
  carousel_slider: ^5.0.0
  table_calendar: ^3.0.8
  lottie: ^3.3.1
  shimmer: ^3.0.0
  cached_network_image: ^3.3.1
  
  # Payment
  razorpay_flutter: ^1.3.15
  
  # Localization
  flutter_localizations:
    sdk: flutter
  intl: ^0.20.2
  
  # Storage
  shared_preferences: ^2.3.2
  
  # Maps & Location
  latlong2: ^0.9.1
  flutter_map: ^8.1.1
  
  # Utilities
  connectivity_plus: ^6.1.4
  url_launcher: ^6.3.1
  html: ^0.15.4
  flutter_html: ^3.0.0
```

### Development Dependencies
```yaml
dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^2.0.0
  build_runner: ^2.7.1
  json_serializable: ^6.11.1
  mockito: ^5.4.4
  integration_test:
    sdk: flutter
```

---

## Setup & Installation

### Prerequisites
- Flutter SDK (>=2.17.1)
- Dart SDK (>=2.17.1)
- Android Studio / VS Code
- Firebase account
- Razorpay account

### Installation Steps

1. **Clone Repository**
```bash
git clone https://github.com/rakesh-sdlglobe/seemytrip_flutter.git
cd seemytrip_flutter
```

2. **Install Dependencies**
```bash
flutter pub get
```

3. **Configure Firebase**
   - Add `google-services.json` to `android/app/`
   - Add `GoogleService-Info.plist` to `ios/Runner/`

4. **Configure API Endpoints**
   - Update `lib/core/config/app_config.dart`
   - Set correct `baseUrl` for your backend

5. **Configure Razorpay**
   - Update Razorpay key in `lib/components/payment_controller.dart`

6. **Run the App**
```bash
flutter run
```

### Environment Configuration
Create `.env` file in project root:
```env
GOOGLE_MAPS_API_KEY=your_google_maps_api_key
FIREBASE_API_KEY=your_firebase_api_key
RAZORPAY_KEY=your_razorpay_key
```

---

## Development Guidelines

### Code Style
1. **Naming Conventions**:
   - Files: `snake_case.dart`
   - Classes: `PascalCase`
   - Variables: `camelCase`
   - Constants: `UPPER_SNAKE_CASE`

2. **File Organization**:
   - One class per file
   - Group related files in folders
   - Use meaningful file names

3. **Widget Structure**:
```dart
class MyWidget extends StatelessWidget {
  const MyWidget({Key? key}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Container(
      // Widget implementation
    );
  }
}
```

### State Management Best Practices
1. **Controller Lifecycle**:
```dart
@override
void onInit() {
  super.onInit();
  // Initialize data
}

@override
void onClose() {
  // Dispose resources
  super.onClose();
}
```

2. **Reactive Variables**:
```dart
// Use .obs for reactive variables
final RxBool isLoading = false.obs;
final RxList<String> items = <String>[].obs;

// Update values
isLoading.value = true;
items.add('new item');
```

### Error Handling
```dart
try {
  // API call or operation
  final result = await apiCall();
  // Handle success
} catch (e) {
  // Log error
  print('Error: $e');
  // Show user-friendly message
  Get.snackbar('Error', 'Something went wrong');
}
```

### Performance Optimization
1. **Image Caching**: Use `CachedNetworkImage`
2. **List Optimization**: Use `ListView.builder` for large lists
3. **Memory Management**: Dispose controllers properly
4. **Lazy Loading**: Load data on demand

---

## Testing

### Unit Testing
```dart
// Example test
void main() {
  group('FlightController Tests', () {
    late FlightController controller;
    
    setUp(() {
      controller = FlightController();
    });
    
    test('should initialize with empty flights list', () {
      expect(controller.flights.length, 0);
    });
    
    test('should search flights successfully', () async {
      // Mock API response
      when(mockApiService.searchFlights(any))
          .thenAnswer((_) async => mockFlights);
      
      await controller.searchFlights();
      
      expect(controller.flights.length, greaterThan(0));
    });
  });
}
```

### Widget Testing
```dart
void main() {
  testWidgets('FlightSearchScreen displays correctly', (tester) async {
    await tester.pumpWidget(
      GetMaterialApp(
        home: FlightSearchScreen(),
      ),
    );
    
    expect(find.text('Flight Search'), findsOneWidget);
    expect(find.byType(TextField), findsNWidgets(2));
  });
}
```

### Integration Testing
```dart
void main() {
  group('Flight Booking Flow', () {
    testWidgets('Complete flight booking flow', (tester) async {
      // Test complete user journey
      await tester.pumpWidget(MyApp());
      
      // Navigate to flight search
      await tester.tap(find.text('Flight'));
      await tester.pumpAndSettle();
      
      // Fill search form
      await tester.enterText(find.byKey(Key('fromField')), 'DEL');
      await tester.enterText(find.byKey(Key('toField')), 'BOM');
      
      // Submit search
      await tester.tap(find.text('Search Flights'));
      await tester.pumpAndSettle();
      
      // Verify results
      expect(find.text('Flight Results'), findsOneWidget);
    });
  });
}
```

---

## Deployment

### Android Deployment

1. **Generate Signed APK**:
```bash
flutter build apk --release
```

2. **Generate App Bundle**:
```bash
flutter build appbundle --release
```

3. **Configure ProGuard** (if needed):
```proguard
# android/app/proguard-rules.pro
-keep class com.razorpay.** { *; }
-keep class com.google.android.gms.** { *; }
```

### iOS Deployment

1. **Build for iOS**:
```bash
flutter build ios --release
```

2. **Archive in Xcode**:
   - Open `ios/Runner.xcworkspace`
   - Select "Any iOS Device"
   - Product → Archive

### Web Deployment

1. **Build for Web**:
```bash
flutter build web --release
```

2. **Deploy to Firebase Hosting**:
```bash
firebase deploy
```

---

## Troubleshooting

### Common Issues

1. **Build Errors**:
   - Clean build: `flutter clean && flutter pub get`
   - Check Flutter version: `flutter doctor`
   - Update dependencies: `flutter pub upgrade`

2. **API Connection Issues**:
   - Check network connectivity
   - Verify API endpoints in `app_config.dart`
   - Check CORS settings on backend

3. **Payment Issues**:
   - Verify Razorpay key configuration
   - Check test/live mode settings
   - Ensure proper error handling

4. **State Management Issues**:
   - Check controller initialization
   - Verify reactive variable updates
   - Ensure proper disposal of controllers

### Debug Tools

1. **Flutter Inspector**: Debug widget tree
2. **Network Inspector**: Monitor API calls
3. **GetX Inspector**: Debug state management
4. **Firebase Console**: Monitor authentication

### Performance Issues

1. **Memory Leaks**:
   - Dispose controllers properly
   - Use `const` constructors where possible
   - Avoid creating widgets in build methods

2. **Slow UI**:
   - Use `ListView.builder` for large lists
   - Implement proper image caching
   - Optimize widget rebuilds

---

## Contributing

### Development Workflow
1. Fork the repository
2. Create feature branch: `git checkout -b feature/new-feature`
3. Make changes and test
4. Commit changes: `git commit -m 'Add new feature'`
5. Push to branch: `git push origin feature/new-feature`
6. Create Pull Request

### Code Review Guidelines
1. Follow existing code style
2. Add proper documentation
3. Include unit tests for new features
4. Ensure all tests pass
5. Update documentation if needed

---

## Support & Contact

- **Repository**: [GitHub Repository](https://github.com/rakesh-sdlglobe/seemytrip_flutter)
- **Issues**: [GitHub Issues](https://github.com/rakesh-sdlglobe/seemytrip_flutter/issues)
- **Documentation**: This file and inline code comments

---

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

*Last updated: December 2024*
*Version: 1.0.0*
