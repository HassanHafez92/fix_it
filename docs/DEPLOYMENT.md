# Deployment Guide

This guide covers the complete deployment process for the Fix It application across all supported platforms.

## 📋 Table of Contents

- [Prerequisites](#prerequisites)
- [Environment Configuration](#environment-configuration)
- [Build Configuration](#build-configuration)
- [Platform-Specific Deployment](#platform-specific-deployment)
- [CI/CD Pipeline](#cicd-pipeline)
- [Release Process](#release-process)
- [Monitoring and Maintenance](#monitoring-and-maintenance)
- [Troubleshooting](#troubleshooting)

## Prerequisites

### Required Tools

- **Flutter SDK**: 3.10.0+
- **Dart SDK**: 3.0.0+
- **Android Studio**: Latest stable version
- **Xcode**: 14+ (for iOS builds)
- **Firebase CLI**: Latest version
- **Git**: For version control

### Accounts and Credentials

- [ ] Google Play Console account (Android)
- [ ] Apple Developer account (iOS)
- [ ] Firebase project with billing enabled
- [ ] Stripe account for payments
- [ ] Google Cloud Console access

### Environment Setup

```bash
# Install required tools
dart pub global activate flutterfire_cli
npm install -g firebase-tools

# Verify installation
flutter doctor
firebase --version
```

## Environment Configuration

### Environment Types

1. **Development** - Local development and testing
2. **Staging** - Pre-production testing
3. **Production** - Live application

### Configuration Files

#### Environment-Specific Firebase Options

Create separate Firebase projects for each environment:

```dart
// lib/config/dev_firebase_options.dart
class DevFirebaseOptions {
  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'dev-android-api-key',
    appId: 'dev-android-app-id',
    messagingSenderId: 'dev-sender-id',
    projectId: 'fix-it-dev',
    storageBucket: 'fix-it-dev.appspot.com',
  );
  // iOS and web configurations...
}

// lib/config/prod_firebase_options.dart
class ProdFirebaseOptions {
  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'prod-android-api-key',
    appId: 'prod-android-app-id',
    messagingSenderId: 'prod-sender-id',
    projectId: 'fix-it-prod',
    storageBucket: 'fix-it-prod.appspot.com',
  );
  // iOS and web configurations...
}
```

#### App Configuration

```dart
// lib/config/app_config.dart
class AppConfig {
  static const String environment = String.fromEnvironment(
    'ENVIRONMENT',
    defaultValue: 'development',
  );

  static const String baseUrl = String.fromEnvironment(
    'BASE_URL',
    defaultValue: 'https://dev-api.fixit.com/api/v1',
  );

  static const bool enableAnalytics = bool.fromEnvironment(
    'ENABLE_ANALYTICS',
    defaultValue: false,
  );

  static const bool enableCrashlytics = bool.fromEnvironment(
    'ENABLE_CRASHLYTICS',
    defaultValue: false,
  );

  // Environment-specific configurations
  static bool get isProduction => environment == 'production';
  static bool get isStaging => environment == 'staging';
  static bool get isDevelopment => environment == 'development';

  static FirebaseOptions get firebaseOptions {
    switch (environment) {
      case 'production':
        return ProdFirebaseOptions.currentPlatform;
      case 'staging':
        return StagingFirebaseOptions.currentPlatform;
      default:
        return DevFirebaseOptions.currentPlatform;
    }
  }
}
```

## Build Configuration

### Version Management

#### pubspec.yaml

```yaml
name: fix_it
description: A Flutter application for booking home maintenance and repair services
version: 1.0.0+1

environment:
  sdk: '>=3.0.0 <4.0.0'
  flutter: ">=3.10.0"
```

#### Version Numbering Strategy

- **Major.Minor.Patch+BuildNumber**
- **Major**: Breaking changes or major feature releases
- **Minor**: New features, backward compatible
- **Patch**: Bug fixes, backward compatible
- **BuildNumber**: Incremental build identifier

### Build Scripts

#### build.sh (Linux/macOS)

```bash
#!/bin/bash

# Build script for Fix It app
set -e

ENVIRONMENT=${1:-development}
PLATFORM=${2:-android}
BUILD_TYPE=${3:-debug}

echo "Building Fix It app..."
echo "Environment: $ENVIRONMENT"
echo "Platform: $PLATFORM"
echo "Build Type: $BUILD_TYPE"

# Clean previous builds
flutter clean
flutter pub get

# Generate code if needed
flutter packages pub run build_runner build --delete-conflicting-outputs

# Build based on platform
case $PLATFORM in
  android)
    if [ "$BUILD_TYPE" = "release" ]; then
      flutter build apk --release         --dart-define=ENVIRONMENT=$ENVIRONMENT         --dart-define=BASE_URL=$BASE_URL         --dart-define=ENABLE_ANALYTICS=true
    else
      flutter build apk --debug         --dart-define=ENVIRONMENT=$ENVIRONMENT
    fi
    ;;
  ios)
    if [ "$BUILD_TYPE" = "release" ]; then
      flutter build ios --release         --dart-define=ENVIRONMENT=$ENVIRONMENT         --dart-define=BASE_URL=$BASE_URL         --dart-define=ENABLE_ANALYTICS=true
    else
      flutter build ios --debug         --dart-define=ENVIRONMENT=$ENVIRONMENT
    fi
    ;;
  web)
    flutter build web --release       --dart-define=ENVIRONMENT=$ENVIRONMENT       --dart-define=BASE_URL=$BASE_URL
    ;;
esac

echo "Build completed successfully!"
```

#### build.bat (Windows)

```batch
@echo off
setlocal enabledelayedexpansion

set ENVIRONMENT=%1
set PLATFORM=%2
set BUILD_TYPE=%3

if "%ENVIRONMENT%"=="" set ENVIRONMENT=development
if "%PLATFORM%"=="" set PLATFORM=android
if "%BUILD_TYPE%"=="" set BUILD_TYPE=debug

echo Building Fix It app...
echo Environment: %ENVIRONMENT%
echo Platform: %PLATFORM%
echo Build Type: %BUILD_TYPE%

flutter clean
flutter pub get

if "%PLATFORM%"=="android" (
    if "%BUILD_TYPE%"=="release" (
        flutter build apk --release --dart-define=ENVIRONMENT=%ENVIRONMENT%
    ) else (
        flutter build apk --debug --dart-define=ENVIRONMENT=%ENVIRONMENT%
    )
)

echo Build completed successfully!
```

## Platform-Specific Deployment

### Android Deployment

#### 1. Signing Configuration

Create `android/key.properties`:

```properties
storePassword=your_store_password
keyPassword=your_key_password
keyAlias=your_key_alias
storeFile=../keystore/release.jks
```

#### 2. Update build.gradle

```gradle
// android/app/build.gradle

def keystoreProperties = new Properties()
def keystorePropertiesFile = rootProject.file('key.properties')
if (keystorePropertiesFile.exists()) {
    keystoreProperties.load(new FileInputStream(keystorePropertiesFile))
}

android {
    compileSdkVersion 34

    defaultConfig {
        applicationId "com.fixit.app"
        minSdkVersion 21
        targetSdkVersion 34
        versionCode flutterVersionCode.toInteger()
        versionName flutterVersionName
        multiDexEnabled true
    }

    signingConfigs {
        release {
            keyAlias keystoreProperties['keyAlias']
            keyPassword keystoreProperties['keyPassword']
            storeFile keystoreProperties['storeFile'] ? file(keystoreProperties['storeFile']) : null
            storePassword keystoreProperties['storePassword']
        }
    }

    buildTypes {
        release {
            signingConfig signingConfigs.release
            minifyEnabled true
            shrinkResources true
            proguardFiles getDefaultProguardFile('proguard-android-optimize.txt'), 'proguard-rules.pro'
        }
    }

    flavorDimensions "environment"
    productFlavors {
        development {
            dimension "environment"
            applicationIdSuffix ".dev"
            versionNameSuffix "-dev"
        }
        staging {
            dimension "environment"
            applicationIdSuffix ".staging"
            versionNameSuffix "-staging"
        }
        production {
            dimension "environment"
        }
    }
}
```

#### 3. Build Commands

```bash
# Debug build
flutter build apk --debug --flavor development

# Release build for staging
flutter build apk --release --flavor staging

# Release build for production
flutter build apk --release --flavor production

# App Bundle for Play Store
flutter build appbundle --release --flavor production
```

#### 4. Play Store Deployment

```bash
# Install Fastlane (optional)
sudo gem install fastlane

# Upload to Play Store
fastlane supply --aab build/app/outputs/bundle/productionRelease/app-production-release.aab
```

### iOS Deployment

#### 1. Xcode Configuration

1. **Open iOS project in Xcode**
   ```bash
   open ios/Runner.xcworkspace
   ```

2. **Configure signing**
   - Select Runner target
   - Go to Signing & Capabilities
   - Select your development team
   - Configure App ID and provisioning profiles

3. **Update Info.plist**
   ```xml
   <!-- ios/Runner/Info.plist -->
   <key>CFBundleDisplayName</key>
   <string>Fix It</string>
   <key>CFBundleIdentifier</key>
   <string>com.fixit.app</string>
   <key>CFBundleVersion</key>
   <string>$(FLUTTER_BUILD_NUMBER)</string>
   <key>CFBundleShortVersionString</key>
   <string>$(FLUTTER_BUILD_NAME)</string>
   ```

#### 2. Build Commands

```bash
# Debug build
flutter build ios --debug

# Release build
flutter build ios --release

# Build and archive for App Store
flutter build ipa --release
```

#### 3. App Store Deployment

```bash
# Upload to App Store Connect
xcrun altool --upload-app --type ios   --file build/ios/ipa/fix_it.ipa   --username "your-apple-id@example.com"   --password "app-specific-password"

# Or use Fastlane
fastlane pilot upload --ipa build/ios/ipa/fix_it.ipa
```

### Web Deployment

#### 1. Build Configuration

```bash
# Build for web
flutter build web --release   --dart-define=ENVIRONMENT=production   --base-href="/fix-it/"
```

#### 2. Firebase Hosting

```bash
# Install Firebase CLI
npm install -g firebase-tools

# Login to Firebase
firebase login

# Initialize hosting
firebase init hosting

# Deploy to Firebase Hosting
firebase deploy --only hosting
```

#### 3. Custom Domain Setup

```json
// firebase.json
{
  "hosting": {
    "public": "build/web",
    "ignore": [
      "firebase.json",
      "**/.*",
      "**/node_modules/**"
    ],
    "rewrites": [
      {
        "source": "**",
        "destination": "/index.html"
      }
    ],
    "headers": [
      {
        "source": "/service-worker.js",
        "headers": [
          {
            "key": "Cache-Control",
            "value": "no-cache"
          }
        ]
      }
    ]
  }
}
```

## CI/CD Pipeline

### GitHub Actions

#### .github/workflows/build-and-test.yml

```yaml
name: Build and Test

on:
  push:
    branches: [main, develop]
  pull_request:
    branches: [main, develop]

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3

      - name: Setup Flutter
        uses: subosito/flutter-action@v2
        with:
          flutter-version: '3.10.0'
          channel: 'stable'

      - name: Install dependencies
        run: flutter pub get

      - name: Run tests
        run: flutter test --coverage

      - name: Upload coverage
        uses: codecov/codecov-action@v3
        with:
          file: coverage/lcov.info

  build-android:
    needs: test
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3

      - name: Setup Flutter
        uses: subosito/flutter-action@v2
        with:
          flutter-version: '3.10.0'

      - name: Setup Java
        uses: actions/setup-java@v3
        with:
          java-version: '11'
          distribution: 'temurin'

      - name: Install dependencies
        run: flutter pub get

      - name: Build APK
        run: flutter build apk --release

      - name: Upload APK
        uses: actions/upload-artifact@v3
        with:
          name: app-release.apk
          path: build/app/outputs/flutter-apk/app-release.apk

  build-ios:
    needs: test
    runs-on: macos-latest
    steps:
      - uses: actions/checkout@v3

      - name: Setup Flutter
        uses: subosito/flutter-action@v2
        with:
          flutter-version: '3.10.0'

      - name: Install dependencies
        run: flutter pub get

      - name: Build iOS
        run: flutter build ios --release --no-codesign
```

#### .github/workflows/deploy.yml

```yaml
name: Deploy

on:
  push:
    tags:
      - 'v*.*.*'

jobs:
  deploy-android:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3

      - name: Setup Flutter
        uses: subosito/flutter-action@v2
        with:
          flutter-version: '3.10.0'

      - name: Setup Java
        uses: actions/setup-java@v3
        with:
          java-version: '11'
          distribution: 'temurin'

      - name: Decode Keystore
        run: |
          echo ${{ secrets.KEYSTORE_BASE64 }} | base64 -d > android/keystore/release.jks

      - name: Create key.properties
        run: |
          echo "storePassword=${{ secrets.STORE_PASSWORD }}" > android/key.properties
          echo "keyPassword=${{ secrets.KEY_PASSWORD }}" >> android/key.properties
          echo "keyAlias=${{ secrets.KEY_ALIAS }}" >> android/key.properties
          echo "storeFile=../keystore/release.jks" >> android/key.properties

      - name: Install dependencies
        run: flutter pub get

      - name: Build App Bundle
        run: flutter build appbundle --release

      - name: Deploy to Play Store
        uses: r0adkll/upload-google-play@v1
        with:
          serviceAccountJsonPlainText: ${{ secrets.GOOGLE_PLAY_SERVICE_ACCOUNT }}
          packageName: com.fixit.app
          releaseFiles: build/app/outputs/bundle/release/app-release.aab
          track: production

  deploy-web:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3

      - name: Setup Flutter
        uses: subosito/flutter-action@v2
        with:
          flutter-version: '3.10.0'

      - name: Install dependencies
        run: flutter pub get

      - name: Build Web
        run: flutter build web --release

      - name: Deploy to Firebase Hosting
        uses: FirebaseExtended/action-hosting-deploy@v0
        with:
          repoToken: '${{ secrets.GITHUB_TOKEN }}'
          firebaseServiceAccount: '${{ secrets.FIREBASE_SERVICE_ACCOUNT }}'
          projectId: fix-it-prod
```

## Release Process

### Pre-Release Checklist

- [ ] All tests pass
- [ ] Code review completed
- [ ] Documentation updated
- [ ] Version number incremented
- [ ] Changelog updated
- [ ] Firebase configuration verified
- [ ] API endpoints tested
- [ ] Performance testing completed

### Release Steps

1. **Prepare Release Branch**
   ```bash
   git checkout develop
   git pull origin develop
   git checkout -b release/v1.0.0
   ```

2. **Update Version**
   ```yaml
   # pubspec.yaml
   version: 1.0.0+1
   ```

3. **Update Changelog**
   ```markdown
   ## [1.0.0] - 2024-01-15
   ### Added
   - New feature descriptions
   ### Fixed
   - Bug fix descriptions
   ```

4. **Build and Test**
   ```bash
   ./scripts/build.sh production android release
   ./scripts/build.sh production ios release
   flutter test
   ```

5. **Create Release**
   ```bash
   git add .
   git commit -m "chore: prepare release v1.0.0"
   git checkout main
   git merge release/v1.0.0
   git tag v1.0.0
   git push origin main --tags
   ```

### Post-Release Steps

1. **Monitor Deployment**
   - Check CI/CD pipeline status
   - Verify app store submissions
   - Monitor crash reports

2. **Update Documentation**
   - Update API documentation
   - Refresh deployment guides
   - Update user documentation

3. **Cleanup**
   ```bash
   git checkout develop
   git merge main
   git branch -d release/v1.0.0
   ```

## Monitoring and Maintenance

### Crash Reporting

#### Firebase Crashlytics

```dart
// Enable Crashlytics in production
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (AppConfig.isProduction) {
    FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;
  }

  runZonedGuarded(() async {
    await Firebase.initializeApp(options: AppConfig.firebaseOptions);
    runApp(const FixItApp());
  }, (error, stack) {
    if (AppConfig.isProduction) {
      FirebaseCrashlytics.instance.recordError(error, stack);
    }
  });
}
```

### Performance Monitoring

```dart
// Track performance metrics
class PerformanceService {
  static Future<void> trackScreenLoad(String screenName) async {
    if (AppConfig.enableAnalytics) {
      final trace = FirebasePerformance.instance.newTrace('screen_load_$screenName');
      await trace.start();
      // ... screen loading logic
      await trace.stop();
    }
  }
}
```

### Analytics

```dart
// Track user events
class AnalyticsService {
  static Future<void> logEvent(String eventName, Map<String, dynamic> parameters) async {
    if (AppConfig.enableAnalytics) {
      await FirebaseAnalytics.instance.logEvent(
        name: eventName,
        parameters: parameters,
      );
    }
  }
}
```

## Troubleshooting

### Common Issues

#### Build Failures

**Issue**: Gradle build fails
```bash
# Solution: Clean and rebuild
flutter clean
cd android && ./gradlew clean
cd .. && flutter pub get
flutter build apk
```

**Issue**: iOS build fails
```bash
# Solution: Clean derived data
rm -rf ~/Library/Developer/Xcode/DerivedData
flutter clean
flutter pub get
flutter build ios
```

#### Deployment Issues

**Issue**: Play Store upload fails
- Verify app signing configuration
- Check version number increment
- Ensure all required permissions are declared

**Issue**: App Store upload fails
- Verify provisioning profiles
- Check bundle identifier
- Ensure Info.plist is correctly configured

### Support Contacts

- **Development Team**: dev-team@fixit.com
- **DevOps Support**: devops@fixit.com
- **Emergency Contact**: emergency@fixit.com

---

**Note**: Always test deployment procedures in staging environment before applying to production.