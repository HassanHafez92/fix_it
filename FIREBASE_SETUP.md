# Firebase Setup for Fix It App

## Overview
The Fix It app has been migrated from REST API authentication to Firebase Authentication with Firestore for user data storage.

## Firebase Configuration

### 1. Firebase Project Setup
1. Create a new Firebase project at [Firebase Console](https://console.firebase.google.com/)
2. Enable Authentication with Email/Password provider
3. Create a Firestore database in test mode
4. Set up security rules for Firestore

### 2. Firebase Configuration Files
Replace the placeholder values in `lib/firebase_options.dart` with your actual Firebase configuration:

```dart
// Example for Android
static const FirebaseOptions android = FirebaseOptions(
  apiKey: 'YOUR_ACTUAL_API_KEY',
  appId: 'YOUR_ACTUAL_APP_ID',
  messagingSenderId: 'YOUR_ACTUAL_SENDER_ID',
  projectId: 'YOUR_PROJECT_ID',
  storageBucket: 'YOUR_STORAGE_BUCKET',
);
```

### 3. Platform-Specific Setup

#### Android
1. Download `google-services.json` from Firebase Console
2. Place it in `android/app/`
3. Update `android/build.gradle` to include Google Services plugin
4. Update `android/app/build.gradle` to apply the plugin

#### iOS
1. Download `GoogleService-Info.plist` from Firebase Console
2. Add it to your iOS project using Xcode
3. Update `ios/Runner/Info.plist` if needed

#### Web
1. Add Firebase SDK to `web/index.html`
2. Configure Firebase in the web app

## Authentication Features

### Implemented Features
- ✅ Email/Password Sign Up
- ✅ Email/Password Sign In
- ✅ Password Reset
- ✅ User Profile Management
- ✅ Sign Out
- ✅ Real-time Authentication State

### User Data Structure in Firestore
```json
{
  "users": {
    "userId": {
      "fullName": "John Doe",
      "phoneNumber": "+1234567890",
      "userType": "customer", 
      "profilePictureUrl": "https://...",
      "createdAt": "2024-01-01T00:00:00.000Z",
      "updatedAt": "2024-01-01T00:00:00.000Z"
    }
  }
}
```

## Security Rules for Firestore

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Users can only read/write their own data
    match /users/{userId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }
  }
}
```

## Migration Notes

### Changes Made
1. **Authentication Data Source**: Replaced `AuthRemoteDataSource` with `AuthFirebaseDataSource`
2. **Repository**: Updated `AuthRepositoryImpl` to use Firebase
3. **Dependency Injection**: Updated DI container to register Firebase services
4. **Main App**: Added Firebase initialization
5. **User Model**: Updated to work with Firestore data structure

### Benefits
- ✅ Real-time authentication state
- ✅ Built-in security features
- ✅ Scalable user management
- ✅ Offline support
- ✅ Cross-platform consistency

### Next Steps
1. Configure Firebase project with actual credentials
2. Set up proper security rules
3. Test authentication flow
4. Implement additional Firebase features (Cloud Storage, Cloud Functions, etc.)

## Testing
To test the Firebase authentication:
1. Run the app
2. Try signing up with a new email
3. Try signing in with existing credentials
4. Test password reset functionality
5. Verify user data is stored in Firestore

## Troubleshooting
- Ensure Firebase is properly initialized before using auth features
- Check network connectivity for Firebase operations
- Verify Firestore security rules allow read/write operations
- Monitor Firebase Console for authentication events 