<<<<<<< HEAD
# Fix It - Home Services Booking App

<div align="center">
  <img src="assets/images/logo.png" alt="Fix It Logo" width="120" height="120">

  **A comprehensive Flutter application for booking home maintenance and repair services**

  [![Flutter](https://img.shields.io/badge/Flutter-3.10.0+-blue.svg)](https://flutter.dev/)
  [![Firebase](https://img.shields.io/badge/Firebase-Enabled-orange.svg)](https://firebase.google.com/)
  [![License](https://img.shields.io/badge/License-Private-red.svg)]()
</div>

## 📱 About Fix It

Fix It is a modern, feature-rich mobile application that connects customers with reliable home service providers. Whether you need plumbing, electrical work, cleaning, painting, or any other home maintenance service, Fix It makes it easy to find, book, and manage services with just a few taps.

## ✨ Key Features

### For Customers

- 🔍 **Service Discovery** - Browse and search from 8+ service categories
- 📍 **Location-Based Matching** - Find nearby verified service providers
- 📅 **Easy Booking** - Schedule services with flexible time slots
- 💬 **Real-Time Chat** - Communicate directly with service providers
- 💳 **Secure Payments** - Integrated Stripe payment processing
- ⭐ **Reviews & Ratings** - Rate and review service experiences
- 📱 **Push Notifications** - Stay updated on booking status
- 📊 **Service History** - Track all your bookings and payments

### For Service Providers

- 👤 **Provider Profiles** - Showcase skills, experience, and certifications
- 📋 **Job Management** - Accept, manage, and complete service requests
- 💰 **Earnings Tracking** - Monitor income and payment history
- 📈 **Performance Analytics** - Track ratings and customer feedback
- 🔔 **Real-Time Notifications** - Get instant alerts for new booking requests

### Service Categories

- 🔧 **Plumbing** - Repairs, installations, maintenance
- ⚡ **Electrical** - Wiring, fixtures, troubleshooting
- 🧹 **Cleaning** - Home, office, deep cleaning services
- 🎨 **Painting** - Interior, exterior, touch-ups
- 🪚 **Carpentry** - Furniture assembly, repairs, installations
- 🔧 **Appliance Repair** - Kitchen, laundry, HVAC appliances
- 🌡️ **HVAC** - Heating, ventilation, air conditioning
- 🌱 **Gardening** - Landscaping, maintenance, plant care

## 🏗️ Architecture

Fix It follows **Clean Architecture** principles with clear separation of concerns:

```
lib/
├── core/                    # Shared application infrastructure
│   ├── constants/          # App-wide constants and configurations
│   ├── di/                 # Dependency injection setup
│   ├── error/              # Error handling and custom exceptions
│   ├── network/            # API client and network utilities
│   ├── routes/             # Application navigation and routing
│   ├── services/           # Core services (auth, location, payment)
│   ├── theme/              # UI theme and styling
│   └── utils/              # Utility functions and helpers
# Fix It - Home Services Booking App

<div align="center">
  <img src="assets/images/logo.png" alt="Fix It Logo" width="120" height="120">

  **A comprehensive Flutter application for booking home maintenance and repair services**

  [![Flutter](https://img.shields.io/badge/Flutter-3.10.0+-blue.svg)](https://flutter.dev/)
  [![Firebase](https://img.shields.io/badge/Firebase-Enabled-orange.svg)](https://firebase.google.com/)
  [![License](https://img.shields.io/badge/License-Private-red.svg)]()
</div>

## 📱 About Fix It

Fix It is a modern, feature-rich mobile application that connects customers with reliable home service providers. Whether you need plumbing, electrical work, cleaning, painting, or any other home maintenance service, Fix It makes it easy to find, book, and manage services with just a few taps.

## ✨ Key Features

### For Customers

- 🔍 **Service Discovery** - Browse and search from 8+ service categories
- 📍 **Location-Based Matching** - Find nearby verified service providers
- 📅 **Easy Booking** - Schedule services with flexible time slots
- 💬 **Real-Time Chat** - Communicate directly with service providers
- 💳 **Secure Payments** - Integrated Stripe payment processing
- ⭐ **Reviews & Ratings** - Rate and review service experiences
- 📱 **Push Notifications** - Stay updated on booking status
- 📊 **Service History** - Track all your bookings and payments

### For Service Providers

- 👤 **Provider Profiles** - Showcase skills, experience, and certifications
- 📋 **Job Management** - Accept, manage, and complete service requests
- 💰 **Earnings Tracking** - Monitor income and payment history
- 📈 **Performance Analytics** - Track ratings and customer feedback
- 🔔 **Real-Time Notifications** - Get instant alerts for new booking requests

### Service Categories

- 🔧 **Plumbing** - Repairs, installations, maintenance
- ⚡ **Electrical** - Wiring, fixtures, troubleshooting
- 🧹 **Cleaning** - Home, office, deep cleaning services
- 🎨 **Painting** - Interior, exterior, touch-ups
- 🪚 **Carpentry** - Furniture assembly, repairs, installations
- 🔧 **Appliance Repair** - Kitchen, laundry, HVAC appliances
- 🌡️ **HVAC** - Heating, ventilation, air conditioning
- 🌱 **Gardening** - Landscaping, maintenance, plant care

## 🏗️ Architecture

Fix It follows **Clean Architecture** principles with clear separation of concerns:

```
lib/
├── core/                    # Shared application infrastructure
│   ├── constants/          # App-wide constants and configurations
│   ├── di/                 # Dependency injection setup
│   ├── error/              # Error handling and custom exceptions
│   ├── network/            # API client and network utilities
│   ├── routes/             # Application navigation and routing
│   ├── services/           # Core services (auth, location, payment)
│   ├── theme/              # UI theme and styling
│   └── utils/              # Utility functions and helpers
├── features/               # Feature-based modules
│   ├── auth/               # Authentication (sign in/up, user management)
│   ├── booking/            # Service booking and management
│   ├── chat/               # In-app messaging system
│   ├── home/               # Home screen and service discovery
│   ├── payment/            # Payment processing and history
│   ├── profile/            # User profile management
│   ├── providers/          # Service provider discovery and details
│   └── services/           # Service catalog and categories
└── main.dart               # Application entry point
```

### Architecture Layers

- **Presentation Layer**: Flutter widgets with BLoC state management
- **Domain Layer**: Business logic, use cases, and repository interfaces
- **Data Layer**: API integration, local storage, and Firebase services

## 🛠️ Technical Stack

### Frontend

- **Framework**: Flutter 3.10.0+
- **Language**: Dart 3.0+
- **State Management**: BLoC (flutter_bloc)
- **Dependency Injection**: GetIt
- **UI**: Material Design with custom theming

### Backend & Services

- **Authentication**: Firebase Authentication
- **Database**: Cloud Firestore
- **Storage**: Firebase Storage (for images/documents)
- **Payments**: Stripe integration
- **Maps**: Google Maps API
- **Notifications**: Firebase Cloud Messaging

### Key Dependencies

```yaml
# State Management & Architecture
flutter_bloc: ^9.1.1
get_it: ^8.2.0
equatable: ^2.0.5

# Firebase Services
firebase_core: ^4.0.0
firebase_auth: ^6.0.0
cloud_firestore: ^6.0.0

# Payment Processing
flutter_stripe: ^10.0.0

# Location & Maps
geolocator: ^14.0.2
google_maps_flutter: ^2.5.0

# UI & Utils
google_fonts: ^6.1.0
cached_network_image: ^3.3.0
```

## 🚀 Getting Started

### Prerequisites

- Flutter SDK 3.10.0 or later
- Dart SDK 3.0.0 or later
- Android Studio / VS Code with Flutter plugins
- iOS development: Xcode 14+ (for iOS builds)
- Firebase project setup

### Installation

1. **Clone the repository**

   ```bash
   git clone [YOUR_REPOSITORY_URL_HERE]
   cd fix_it
   ```

2. **Install dependencies**

   ```bash
   flutter pub get
   ```

3. **Firebase Setup** (Required)
   - Follow the detailed guide in [FIREBASE_SETUP.md](FIREBASE_SETUP.md)
   - Configure Firebase project with Authentication and Firestore
   - Add platform-specific configuration files

4. **Environment Configuration**

   ```bash
   # Copy and configure environment variables
   # Unix / macOS / WSL
   cp lib/app_config.dart.template lib/app_config.dart

   # Windows PowerShell
   Copy-Item lib/app_config.dart.template lib/app_config.dart

   # Update lib/app_config.dart with your API keys and configuration,
   # or supply values at build/run time with --dart-define.
   ```

5. **Generate Code** (if needed)

   ```bash
   # Recommended: run build_runner and delete conflicting outputs
   flutter packages pub run build_runner build --delete-conflicting-outputs

   # Or watch mode while developing
   flutter packages pub run build_runner watch --delete-conflicting-outputs

   # Note: some generated files (for example, *.g.dart) are intended to be
   # committed in this repo. If your CI or reviewers expect generated files,
   # commit them. Otherwise keep them out of source control per your project policy.
   ```

6. **Run the application**

   ```bash
   # Debug mode
   flutter run

   # Specific platform
   flutter run -d android
   flutter run -d ios
   flutter run -d chrome
   ```

## 🔧 Development

### Project Structure

```
features/
└── [feature_name]/
    ├── data/
    │   ├── datasources/     # Remote & local data sources
    │   ├── models/          # Data transfer objects
    │   └── repositories/    # Repository implementations
    ├── domain/
    │   ├── entities/        # Business objects
    │   ├── repositories/    # Repository interfaces
    │   └── usecases/        # Business logic use cases
    └── presentation/
        ├── bloc/            # State management
        ├── pages/           # Screen widgets
        └── widgets/         # Reusable UI components
```

### Code Generation

```bash
# Generate JSON serialization code
flutter packages pub run build_runner build

# Watch for changes
flutter packages pub run build_runner watch
```

### State Management

The app uses **BLoC pattern** for state management:

- Events trigger state changes
- States represent UI conditions
- Blocs contain business logic
- Cubits for simpler state management

## 🌐 Supported Platforms

| Platform | Status | Minimum Version |
|----------|--------|-----------------|
| Android  | ✅ Ready | Android 5.0 (API 21) |
| iOS      | ✅ Ready | iOS 12.0 |
| Web      | ✅ Ready | Modern browsers |
| Windows  | 🚧 In Development | Windows 10 |
| macOS    | 🚧 In Development | macOS 10.14 |
| Linux    | 🚧 In Development | Ubuntu 18.04+ |

## 📚 Documentation

- [Firebase Setup Guide](FIREBASE_SETUP.md) - Complete Firebase configuration
- [API Documentation](docs/API.md) - REST API endpoints and usage
- [Architecture Guide](ARCHITECTURE.md) - Detailed architecture overview
- [Contributing Guidelines](CONTRIBUTING.md) - Development guidelines
- [Deployment Guide](docs/DEPLOYMENT.md) - Build and release process
- [Testing Guide](TESTING.md) - Testing strategies and guidelines

## 🔒 Security

- Firebase Authentication with email/password
- Secure local storage using Flutter Secure Storage
- API request authentication with tokens
- Input validation and sanitization
- Firestore security rules for data protection

## 🐛 Troubleshooting

### Common Issues

#### Firebase Configuration

```bash
# Issue: Firebase not initialized
# Solution: Ensure Firebase.initializeApp() is called in main()

# Issue: Platform configuration missing
# Solution: Add google-services.json (Android) and GoogleService-Info.plist (iOS)
```

#### Flutter Issues

```bash
# Issue: Dependencies not resolving
flutter clean
flutter pub get

# Issue: Build failures
flutter doctor
# Fix any issues reported

# Issue: Hot reload not working
# Restart the app or try hot restart
```

#### Platform-Specific Issues

```bash
# Android: Gradle build errors
cd android
./gradlew clean

# iOS: Pod install errors
cd ios
pod deintegrate
pod install
```

## 📱 Screenshots

> **Note**: Screenshots will be added in the `docs/screenshots/` directory once available.

## 📄 License

This project is proprietary software. All rights reserved.

## 🤝 Support

For support, feature requests, or bug reports:

- Create an issue in the project repository
- Contact the development team
- Check the documentation for common solutions

## 🚀 Roadmap

### Version 1.1.0 (Coming Soon)

- [ ] Google Sign-In integration
- [ ] Advanced search filters
- [ ] Multi-language support
- [ ] Dark mode theme

### Version 1.2.0 (Future)

- [ ] Video call integration
- [ ] Advanced analytics dashboard
- [ ] Subscription management
- [ ] Offline mode support

---

<div align="center">
  Made with ❤️ using Flutter

  **Fix It - Your Home Services Solution**
</div>
