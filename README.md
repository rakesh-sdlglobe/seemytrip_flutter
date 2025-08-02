# SeeMyTrip - Travel Booking App

A comprehensive travel booking application built with Flutter that allows users to book flights, trains, buses, hotels, and holiday packages.

## 🚀 Features

- **Multi-modal Travel Booking**: Book flights, trains, buses, and hotels
- **User Authentication**: Secure login/signup with email and social media
- **Real-time Availability**: Check real-time seat/room availability
- **Secure Payments**: Integrated payment gateway for secure transactions
- **Booking Management**: View and manage all your bookings in one place
- **Offline Support**: Access important information even without internet
- **Multi-language Support**: Available in multiple languages
- **Dark Mode**: Eye-friendly dark theme option

## 🛠 Tech Stack

- **Framework**: Flutter
- **State Management**: GetX
- **Backend**: Firebase (Authentication, Firestore, Cloud Functions)
- **Maps**: Google Maps API
- **Local Storage**: Hive
- **Networking**: Dio
- **Dependency Injection**: GetIt
- **Analytics**: Firebase Analytics
- **Push Notifications**: Firebase Cloud Messaging

## 📱 Screenshots

*(Screenshots will be added here)*

## 📦 Prerequisites

- Flutter SDK (latest stable version)
- Dart SDK (latest stable version)
- Android Studio / Xcode (for building to respective platforms)
- Firebase account (for backend services)
- Google Maps API key

## 🚀 Getting Started

### 1. Clone the repository
```bash
git clone https://github.com/rakesh-sdlglobe/seemytrip_flutter.git
cd seemytrip_flutter
```

### 2. Install dependencies
```bash
flutter pub get
```

### 3. Setup environment variables
Create a `.env` file in the root directory and add your API keys:
```env
GOOGLE_MAPS_API_KEY=your_google_maps_api_key
FIREBASE_API_KEY=your_firebase_api_key
# Add other environment variables as needed
```

### 4. Run the app
```bash
flutter run
```

## 🏗 Project Structure

```
lib/
├── core/                  # Core functionality
│   ├── constants/        # App-wide constants
│   ├── services/         # Business logic services
│   ├── theme/            # App theming
│   └── utils/            # Utility functions
│
├── features/             # Feature-based modules
│   ├── auth/             # Authentication
│   ├── booking/          # Booking management
│   ├── flights/          # Flight booking
│   ├── trains/           # Train booking
│   ├── buses/            # Bus booking
│   ├── hotels/           # Hotel booking
│   └── profile/          # User profile
│
├── shared/               # Shared resources
│   ├── models/           # Data models
│   ├── widgets/          # Reusable widgets
│   └── services/         # Shared services
│
└── main.dart             # App entry point
```

## 🔧 Environment Setup

### Android
1. Update `android/local.properties` with your configuration
2. Add your Google Maps API key to `android/app/src/main/AndroidManifest.xml`

### iOS
1. Run `pod install` in the `ios` directory
2. Update the bundle identifier in Xcode
3. Add your Google Maps API key to `ios/Runner/AppDelegate.swift`

## 🤝 Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- [Flutter](https://flutter.dev/)
- [Firebase](https://firebase.google.com/)
- [GetX](https://pub.dev/packages/get)
- All other amazing open-source packages used in this project
