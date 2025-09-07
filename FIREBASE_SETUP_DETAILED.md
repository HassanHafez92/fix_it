# Firebase Setup Guide for Fix It App

## 📋 Overview

This comprehensive guide will walk you through setting up Firebase for the Fix It application, from initial project creation to production deployment.

## 🎯 Prerequisites

Before starting, ensure you have:
- [ ] Google account for Firebase Console access
- [ ] Flutter SDK 3.10.0+ installed
- [ ] Android Studio or Xcode for mobile development
- [ ] Git for version control
- [ ] Basic understanding of Firebase services

## 🚀 Part 1: Firebase Project Setup

### Step 1: Create Firebase Project

1. **Navigate to Firebase Console**
   ```
   https://console.firebase.google.com/
   ```

2. **Create New Project**
   - Click "Create a project"
   - Project name: `fix-it-app` (or your preferred name)
   - Enable Google Analytics: ✅ Recommended
   - Choose analytics account or create new one
   - Click "Create project"

3. **Wait for Project Creation**
   - Firebase will provision your project
   - This usually takes 1-2 minutes

### Step 2: Configure Authentication

1. **Enable Authentication**
   ```
   Firebase Console → Authentication → Get started
   ```

2. **Configure Sign-in Methods**
   - Go to "Sign-in method" tab
   - Enable "Email/Password"
   - ✅ Enable "Email link (passwordless sign-in)" if desired
   - Configure authorized domains (add your production domain)

3. **Optional: Configure Additional Providers**
   ```bash
   # For future implementation
   - Google Sign-In
   - Apple Sign-In
   - Phone Authentication
   ```

### Step 3: Set Up Firestore Database

1. **Create Firestore Database**
   ```
   Firebase Console → Firestore Database → Create database
   ```

2. **Choose Security Rules Mode**
   - Start in **test mode** for development
   - ⚠️ Remember to update rules before production

3. **Select Database Location**
   - Choose region closest to your users
   - ⚠️ Location cannot be changed later

4. **Configure Security Rules**
   ```javascript
   rules_version = '2';
   service cloud.firestore {
     match /databases/{database}/documents {
       // Users can only access their own data
       match /users/{userId} {
         allow read, write: if request.auth != null && request.auth.uid == userId;
       }

       // Service categories are public read-only
       match /serviceCategories/{categoryId} {
         allow read: if true;
         allow write: if false; // Only admin can write
       }

       // Bookings can be read/written by involved parties
       match /bookings/{bookingId} {
         allow read, write: if request.auth != null && 
           (resource.data.customerId == request.auth.uid || 
            resource.data.providerId == request.auth.uid);
       }

       // Providers can be read by anyone, written by owner
       match /providers/{providerId} {
         allow read: if true;
         allow write: if request.auth != null && request.auth.uid == providerId;
       }
     }
   }
   ```

### Step 4: Configure Firebase Storage

1. **Set Up Storage**
   ```
   Firebase Console → Storage → Get started
   ```

2. **Configure Storage Rules**
   ```javascript
   rules_version = '2';
   service firebase.storage {
     match /b/{bucket}/o {
       // User profile pictures
       match /users/{userId}/profile/{allPaths=**} {
         allow read: if true;
         allow write: if request.auth != null && request.auth.uid == userId;
       }

       // Service provider documents
       match /providers/{providerId}/documents/{allPaths=**} {
         allow read: if request.auth != null;
         allow write: if request.auth != null && request.auth.uid == providerId;
       }

       // Booking related files
       match /bookings/{bookingId}/{allPaths=**} {
         allow read, write: if request.auth != null;
       }
     }
   }
   ```

## 📱 Part 2: Platform Configuration

### Android Setup

1. **Register Android App**
   ```
   Firebase Console → Project Settings → Add app → Android
   ```

2. **Configure App Details**
   ```
   Android package name: com.example.fix_it
   App nickname: Fix It Android
   Debug signing certificate SHA-1: [Optional for now]
   ```

3. **Download Configuration File**
   - Download `google-services.json`
   - Place in `android/app/` directory

4. **Update Gradle Files**

   **android/build.gradle**:
   ```gradle
   buildscript {
       dependencies {
           // Add this line
           classpath 'com.google.gms:google-services:4.4.0'
       }
   }
   ```

   **android/app/build.gradle**:
   ```gradle
   // Add at the bottom of the file
   apply plugin: 'com.google.gms.google-services'

   android {
       compileSdkVersion 34
       minSdkVersion 21
       targetSdkVersion 34
   }

   dependencies {
       implementation platform('com.google.firebase:firebase-bom:32.7.0')
       implementation 'com.google.firebase:firebase-analytics'
   }
   ```

### iOS Setup

1. **Register iOS App**
   ```
   Firebase Console → Project Settings → Add app → iOS
   ```

2. **Configure App Details**
   ```
   iOS bundle ID: com.example.fixIt
   App nickname: Fix It iOS
   App Store ID: [Leave empty for now]
   ```

3. **Download Configuration File**
   - Download `GoogleService-Info.plist`
   - Add to iOS project using Xcode:
     - Open `ios/Runner.xcworkspace` in Xcode
     - Right-click `Runner` → Add Files to "Runner"
     - Select `GoogleService-Info.plist`
     - Ensure "Copy items if needed" is checked
     - Add to `Runner` target

4. **Update iOS Configuration**

   **ios/Runner/Info.plist**:
   ```xml
   <key>CFBundleURLTypes</key>
   <array>
       <dict>
           <key>CFBundleURLName</key>
           <string>REVERSED_CLIENT_ID</string>
           <key>CFBundleURLSchemes</key>
           <array>
               <string>YOUR_REVERSED_CLIENT_ID</string>
           </array>
       </dict>
   </array>
   ```

### Web Setup

1. **Register Web App**
   ```
   Firebase Console → Project Settings → Add app → Web
   ```

2. **Configure App Details**
   ```
   App nickname: Fix It Web
   ✅ Also set up Firebase Hosting
   ```

3. **Update Web Configuration**

   **web/index.html**:
   ```html
   <script src="https://www.gstatic.com/firebasejs/10.7.1/firebase-app.js"></script>
   <script src="https://www.gstatic.com/firebasejs/10.7.1/firebase-auth.js"></script>
   <script src="https://www.gstatic.com/firebasejs/10.7.1/firebase-firestore.js"></script>

   <script>
     const firebaseConfig = {
       apiKey: "your-api-key",
       authDomain: "your-project.firebaseapp.com",
       projectId: "your-project-id",
       storageBucket: "your-project.appspot.com",
       messagingSenderId: "123456789",
       appId: "your-app-id"
     };

     firebase.initializeApp(firebaseConfig);
   </script>
   ```

## 🔧 Part 3: Flutter Configuration

### Update Firebase Options

Replace content in `lib/firebase_options.dart`:

```dart
// File generated by FlutterFire CLI.
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'YOUR_WEB_API_KEY',
    appId: 'YOUR_WEB_APP_ID',
    messagingSenderId: 'YOUR_SENDER_ID',
    projectId: 'YOUR_PROJECT_ID',
    authDomain: 'YOUR_PROJECT.firebaseapp.com',
    storageBucket: 'YOUR_PROJECT.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'YOUR_ANDROID_API_KEY',
    appId: 'YOUR_ANDROID_APP_ID',
    messagingSenderId: 'YOUR_SENDER_ID',
    projectId: 'YOUR_PROJECT_ID',
    storageBucket: 'YOUR_PROJECT.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'YOUR_IOS_API_KEY',
    appId: 'YOUR_IOS_APP_ID',
    messagingSenderId: 'YOUR_SENDER_ID',
    projectId: 'YOUR_PROJECT_ID',
    storageBucket: 'YOUR_PROJECT.appspot.com',
    iosBundleId: 'com.example.fixIt',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'YOUR_MACOS_API_KEY',
    appId: 'YOUR_MACOS_APP_ID',
    messagingSenderId: 'YOUR_SENDER_ID',
    projectId: 'YOUR_PROJECT_ID',
    storageBucket: 'YOUR_PROJECT.appspot.com',
    iosBundleId: 'com.example.fixIt',
  );
}
```

### Environment Configuration Template

Create `lib/app_config.dart.template`:

```dart
/// Application configuration for different environments.
///
/// Copy this file to `app_config.dart` and update with your actual values.
class AppConfig {
  /// Firebase project configuration
  static const String firebaseProjectId = 'YOUR_PROJECT_ID';
  static const String firebaseApiKey = 'YOUR_API_KEY';
  static const String firebaseAuthDomain = 'YOUR_PROJECT.firebaseapp.com';

  /// Stripe payment configuration
  static const String stripePublishableKey = 'pk_test_YOUR_STRIPE_KEY';
  static const String stripeSecretKey = 'sk_test_YOUR_STRIPE_SECRET';

  /// Google Maps API configuration
  static const String googleMapsApiKey = 'YOUR_GOOGLE_MAPS_API_KEY';

  /// App-specific configuration
  static const String appName = 'Fix It';
  static const String supportEmail = 'support@fixit.com';
  static const String privacyPolicyUrl = 'https://fixit.com/privacy';
  static const String termsOfServiceUrl = 'https://fixit.com/terms';

  /// Feature flags
  static const bool enableGoogleSignIn = false;
  static const bool enableAppleSignIn = false;
  static const bool enablePhoneAuth = false;
  static const bool enablePushNotifications = true;

  /// Development flags
  static const bool isDebugMode = true;
  static const bool enableAnalytics = false;
}
```

## 🧪 Part 4: Testing Configuration

### Test Data Structure

Create test collections in Firestore:

```json
{
  "serviceCategories": {
    "plumbing": {
      "name": "Plumbing",
      "description": "Water and pipe related services",
      "iconUrl": "assets/images/plumbing.png",
      "isActive": true
    },
    "electrical": {
      "name": "Electrical",
      "description": "Electrical installations and repairs",
      "iconUrl": "assets/images/electrical.png",
      "isActive": true
    }
  },
  "users": {
    "testUser123": {
      "fullName": "Test User",
      "email": "test@example.com",
      "userType": "client",
      "phoneNumber": "+1234567890",
      "createdAt": "2024-01-01T00:00:00.000Z",
      "updatedAt": "2024-01-01T00:00:00.000Z"
    }
  }
}
```

### Authentication Test Users

Create test accounts in Firebase Console:
```
test.client@fixit.com / password123
test.provider@fixit.com / password123
```

## 🚀 Part 5: Deployment Configuration

### Production Security Rules

**Firestore Production Rules**:
```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Helper functions
    function isAuthenticated() {
      return request.auth != null;
    }

    function isOwner(userId) {
      return request.auth.uid == userId;
    }

    function isValidUserData() {
      return request.resource.data.keys().hasAll(['fullName', 'email', 'userType']) &&
             request.resource.data.userType in ['client', 'provider'];
    }

    // User documents
    match /users/{userId} {
      allow read, write: if isAuthenticated() && isOwner(userId) && isValidUserData();
    }

    // Service categories (admin only write)
    match /serviceCategories/{categoryId} {
      allow read: if true;
      allow write: if false; // Admin only through Firebase Console
    }

    // Bookings
    match /bookings/{bookingId} {
      allow read, write: if isAuthenticated() && 
        (resource.data.customerId == request.auth.uid || 
         resource.data.providerId == request.auth.uid);
    }

    // Provider profiles
    match /providers/{providerId} {
      allow read: if true;
      allow write: if isAuthenticated() && isOwner(providerId);
    }
  }
}
```

### Environment-Specific Configuration

**Development**:
```dart
class DevConfig extends AppConfig {
  static const String environment = 'development';
  static const bool enableLogging = true;
  static const bool useFirebaseEmulator = true;
}
```

**Production**:
```dart
class ProdConfig extends AppConfig {
  static const String environment = 'production';
  static const bool enableLogging = false;
  static const bool useFirebaseEmulator = false;
}
```

## 🔍 Part 6: Verification & Testing

### Verification Checklist

- [ ] Firebase project created and configured
- [ ] Authentication enabled with email/password
- [ ] Firestore database created with security rules
- [ ] Storage configured with proper rules
- [ ] Android app registered with google-services.json
- [ ] iOS app registered with GoogleService-Info.plist
- [ ] Web app configured (if applicable)
- [ ] Flutter app builds without errors
- [ ] Authentication flow works end-to-end
- [ ] Firestore read/write operations work
- [ ] Storage upload/download works

### Test Commands

```bash
# Verify Flutter configuration
flutter doctor

# Check Firebase connection
flutter run --debug

# Run authentication tests
flutter test test/features/auth/

# Verify Firestore connection
# (Run app and check Firebase Console for user data)
```

## 🐛 Troubleshooting

### Common Issues

**Firebase not initialized**:
```dart
// Ensure this is in main()
await Firebase.initializeApp(
  options: DefaultFirebaseOptions.currentPlatform,
);
```

**Platform configuration missing**:
```bash
# Android: Check google-services.json location
ls android/app/google-services.json

# iOS: Verify in Xcode project
open ios/Runner.xcworkspace
```

**Permission denied errors**:
- Check Firestore security rules
- Verify user authentication state
- Ensure proper user ID matching

**Build errors**:
```bash
# Clean and rebuild
flutter clean
flutter pub get
flutter run
```

## 📚 Next Steps

1. **Set up Cloud Functions** (for server-side logic)
2. **Configure Firebase Cloud Messaging** (for push notifications)
3. **Set up Firebase Analytics** (for user behavior tracking)
4. **Implement Firebase Performance Monitoring**
5. **Configure Firebase Crashlytics** (for crash reporting)

## 🔗 Additional Resources

- [Firebase Documentation](https://firebase.google.com/docs)
- [FlutterFire Documentation](https://firebase.flutter.dev/)
- [Firebase Security Rules Guide](https://firebase.google.com/docs/rules)
- [Firebase Best Practices](https://firebase.google.com/docs/rules/best-practices)
