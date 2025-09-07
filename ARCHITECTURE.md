# Fix It App - Architecture Documentation

## Table of Contents
- [Overview](#overview)
- [Architectural Principles](#architectural-principles)
- [Clean Architecture Implementation](#clean-architecture-implementation)
- [Project Structure](#project-structure)
- [Layer Responsibilities](#layer-responsibilities)
- [State Management](#state-management)
- [Dependency Injection](#dependency-injection)
- [Data Flow](#data-flow)
- [Feature Organization](#feature-organization)
- [Core Services](#core-services)
- [Firebase Integration](#firebase-integration)
- [Error Handling](#error-handling)
- [Testing Strategy](#testing-strategy)
- [Performance Considerations](#performance-considerations)

## Overview

The Fix It app is built using **Clean Architecture** principles, providing a scalable, maintainable, and testable codebase. The architecture ensures separation of concerns, dependency inversion, and clear boundaries between different layers of the application.

## Architectural Principles

### 1. Clean Architecture
- **Independence**: Each layer is independent of external frameworks
- **Testability**: Business logic can be tested without UI, database, or external services
- **UI Independence**: UI can change without affecting business rules
- **Database Independence**: Business rules are not bound to any specific database
- **External Agency Independence**: Business rules don't know about external interfaces

### 2. SOLID Principles
- **Single Responsibility**: Each class has one reason to change
- **Open/Closed**: Open for extension, closed for modification
- **Liskov Substitution**: Objects should be replaceable with instances of their subtypes
- **Interface Segregation**: Many client-specific interfaces are better than one general-purpose interface
- **Dependency Inversion**: Depend on abstractions, not concretions

### 3. Feature-Based Organization
- Each feature is self-contained with its own layers
- Clear boundaries between features
- Minimal coupling between features
- Shared core infrastructure

## Clean Architecture Implementation

```
┌─────────────────────────────────────────────────────────┐
│                    Presentation Layer                    │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐     │
│  │   Widgets   │  │   BLoCs     │  │   Pages     │     │
│  └─────────────┘  └─────────────┘  └─────────────┘     │
└─────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────┐
│                     Domain Layer                        │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐     │
│  │  Entities   │  │  Use Cases  │  │ Repositories│     │
│  │             │  │             │  │ (Interfaces)│     │
│  └─────────────┘  └─────────────┘  └─────────────┘     │
└─────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────┐
│                      Data Layer                         │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐     │
│  │   Models    │  │ Data Sources│  │ Repositories│     │
│  │             │  │             │  │ (Impl)      │     │
│  └─────────────┘  └─────────────┘  └─────────────┘     │
└─────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────┐
│                   External Interfaces                   │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐     │
│  │  Firebase   │  │ REST APIs   │  │ Local DB    │     │
│  └─────────────┘  └─────────────┘  └─────────────┘     │
└─────────────────────────────────────────────────────────┘
```

## Project Structure

```
lib/
├── main.dart                           # Application entry point
├── app_config.dart                     # Environment configuration
├── firebase_options.dart               # Firebase configuration
│
├── core/                               # Shared infrastructure
│   ├── constants/
│   │   └── app_constants.dart          # Application constants
│   ├── di/
│   │   └── injection_container.dart    # Dependency injection setup
│   ├── error/
│   │   └── failures.dart               # Error definitions
│   ├── network/
│   │   ├── api_client.dart             # HTTP client configuration
│   │   ├── api_client.g.dart           # Generated API client
│   │   └── network_info.dart           # Network connectivity check
│   ├── routes/
│   │   └── app_routes.dart             # Application routing
│   ├── services/                       # Core services
│   │   ├── auth_service.dart           # Authentication service interface
│   │   ├── auth_service_impl.dart      # Authentication implementation
│   │   ├── file_upload_service.dart    # File upload service
│   │   ├── google_auth_service.dart    # Google authentication
│   │   ├── location_service.dart       # Location services
│   │   └── payment_service.dart        # Payment processing
│   ├── theme/
│   │   └── app_theme.dart              # Application theming
│   ├── usecases/
│   │   └── usecase.dart                # Base use case interface
│   └── utils/
│       ├── app_routes.dart             # Route constants
│       └── validators.dart             # Input validation utilities
│
└── features/                           # Feature modules
    ├── auth/                           # Authentication feature
    │   ├── data/
    │   │   ├── datasources/
    │   │   │   ├── auth_firebase_data_source.dart
    │   │   │   └── auth_local_data_source.dart
    │   │   ├── models/
    │   │   │   └── user_model.dart
    │   │   └── repositories/
    │   │       └── auth_repository_impl.dart
    │   ├── domain/
    │   │   ├── entities/
    │   │   │   └── user_entity.dart
    │   │   ├── repositories/
    │   │   │   └── auth_repository.dart
    │   │   └── usecases/
    │   │       ├── sign_in_usecase.dart
    │   │       ├── sign_up_usecase.dart
    │   │       ├── sign_out_usecase.dart
    │   │       ├── get_current_user_usecase.dart
    │   │       ├── forgot_password_usecase.dart
    │   │       └── client_sign_up_usecase.dart
    │   └── presentation/
    │       ├── bloc/
    │       │   ├── auth_bloc.dart
    │       │   ├── auth_event.dart
    │       │   ├── auth_state.dart
    │       │   └── client_sign_up/
    │       │       ├── client_sign_up_bloc.dart
    │       │       ├── client_sign_up_event.dart
    │       │       └── client_sign_up_state.dart
    │       ├── pages/
    │       │   ├── welcome_screen.dart
    │       │   ├── sign_in_screen.dart
    │       │   ├── sign_up_screen.dart
    │       │   └── forgot_password_screen.dart
    │       └── widgets/
    │           ├── auth_form.dart
    │           ├── social_login_buttons.dart
    │           └── auth_header.dart
    │
    ├── services/                       # Services catalog feature
    ├── providers/                      # Service providers feature
    ├── booking/                        # Booking management feature
    ├── chat/                          # In-app messaging feature
    ├── payment/                       # Payment processing feature
    ├── profile/                       # User profile feature
    ├── home/                          # Home screen feature
    ├── notifications/                 # Push notifications feature
    ├── help_support/                  # Help and support feature
    └── settings/                      # App settings feature
```

## Layer Responsibilities

### 1. Presentation Layer
**Location**: `features/*/presentation/`

**Responsibilities**:
- UI rendering and user interaction handling
- State management using BLoC pattern
- Navigation and routing
- Input validation and formatting
- Error display and user feedback

**Components**:
- **Pages**: Screen-level widgets representing complete UI screens
- **Widgets**: Reusable UI components
- **BLoCs**: State management and business logic coordination
- **Events**: User actions and external triggers
- **States**: UI state representations

**Example**:
```dart
// Auth BLoC handling user authentication state
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final SignInUseCase signInUseCase;
  final SignUpUseCase signUpUseCase;

  AuthBloc({
    required this.signInUseCase,
    required this.signUpUseCase,
  }) : super(AuthInitial()) {
    on<SignInRequested>(_onSignInRequested);
    on<SignUpRequested>(_onSignUpRequested);
  }
}
```

### 2. Domain Layer
**Location**: `features/*/domain/`

**Responsibilities**:
- Pure business logic
- Entity definitions
- Repository interfaces
- Use case implementations
- Business rules enforcement

**Components**:
- **Entities**: Core business objects with business rules
- **Repositories**: Data access interfaces
- **Use Cases**: Application-specific business logic
- **Value Objects**: Immutable objects representing domain concepts

**Example**:
```dart
// Use case for user sign-in
class SignInUseCase implements UseCase<UserEntity, SignInParams> {
  final AuthRepository repository;

  SignInUseCase(this.repository);

  @override
  Future<Either<Failure, UserEntity>> call(SignInParams params) async {
    return await repository.signIn(
      email: params.email,
      password: params.password,
    );
  }
}
```

### 3. Data Layer
**Location**: `features/*/data/`

**Responsibilities**:
- Data retrieval and storage
- API communication
- Local database operations
- Data transformation and caching
- Repository pattern implementation

**Components**:
- **Models**: Data transfer objects with JSON serialization
- **Data Sources**: Remote (API) and local (database) data access
- **Repositories**: Implementation of domain repository interfaces
- **Mappers**: Convert between models and entities

**Example**:
```dart
// Firebase data source implementation
class AuthFirebaseDataSourceImpl implements AuthFirebaseDataSource {
  final FirebaseAuth firebaseAuth;
  final FirebaseFirestore firestore;

  @override
  Future<UserModel> signIn(String email, String password) async {
    final userCredential = await firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    // Fetch additional user data from Firestore
    final userDoc = await firestore
        .collection('users')
        .doc(userCredential.user!.uid)
        .get();

    return UserModel.fromFirestore(userDoc);
  }
}
```

## State Management

### BLoC Pattern Implementation

The app uses the **BLoC (Business Logic Component)** pattern for state management:

```dart
// Event-driven architecture
sealed class AuthEvent extends Equatable {}

class SignInRequested extends AuthEvent {
  final String email;
  final String password;

  SignInRequested({required this.email, required this.password});
}

// State representations
sealed class AuthState extends Equatable {}

class AuthInitial extends AuthState {}
class AuthLoading extends AuthState {}
class AuthSuccess extends AuthState {
  final UserEntity user;
  AuthSuccess({required this.user});
}
class AuthFailure extends AuthState {
  final String message;
  AuthFailure({required this.message});
}
```

### State Flow

```
User Action → Event → BLoC → Use Case → Repository → Data Source
                ↓
UI Update ← State ← BLoC ← Result ← Repository ← Data Source
```

## Dependency Injection

### GetIt Service Locator

The app uses **GetIt** for dependency injection, configured in `core/di/injection_container.dart`:

```dart
final sl = GetIt.instance;

Future<void> init() async {
  // External dependencies
  sl.registerLazySingleton<FirebaseAuth>(() => FirebaseAuth.instance);
  sl.registerLazySingleton<FirebaseFirestore>(() => FirebaseFirestore.instance);

  // Core services
  sl.registerLazySingleton<AuthService>(() => AuthServiceImpl());

  // Data sources
  sl.registerLazySingleton<AuthFirebaseDataSource>(
    () => AuthFirebaseDataSourceImpl(
      firebaseAuth: sl(),
      firestore: sl(),
    ),
  );

  // Repositories
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      firebaseDataSource: sl(),
      localDataSource: sl(),
    ),
  );

  // Use cases
  sl.registerLazySingleton(() => SignInUseCase(sl()));

  // BLoCs
  sl.registerFactory(() => AuthBloc(
    signInUseCase: sl(),
    signUpUseCase: sl(),
  ));
}
```

## Data Flow

### 1. User Authentication Flow

```
┌─────────────┐    ┌─────────────┐    ┌─────────────┐
│ SignInPage  │───▶│  AuthBloc   │───▶│SignInUseCase│
└─────────────┘    └─────────────┘    └─────────────┘
       ▲                   │                   │
       │                   ▼                   ▼
┌─────────────┐    ┌─────────────┐    ┌─────────────┐
│   UI State  │◀───│ AuthState   │◀───│AuthRepository│
└─────────────┘    └─────────────┘    └─────────────┘
                                              │
                                              ▼
                                    ┌─────────────┐
                                    │ Firebase    │
                                    │ DataSource  │
                                    └─────────────┘
```

### 2. Service Booking Flow

```
User selects service → BookingBloc → CreateBookingUseCase
         ↓                 ↓               ↓
UI shows confirmation ← BookingState ← BookingRepository
         ↓                 ↓               ↓
Booking created ← Database update ← FirebaseDataSource
```

## Feature Organization

Each feature follows the same architectural pattern:

### Feature Template
```
feature_name/
├── data/
│   ├── datasources/
│   │   ├── feature_remote_data_source.dart
│   │   └── feature_local_data_source.dart
│   ├── models/
│   │   └── feature_model.dart
│   └── repositories/
│       └── feature_repository_impl.dart
├── domain/
│   ├── entities/
│   │   └── feature_entity.dart
│   ├── repositories/
│   │   └── feature_repository.dart
│   └── usecases/
│       ├── get_feature_usecase.dart
│       └── create_feature_usecase.dart
└── presentation/
    ├── bloc/
    │   ├── feature_bloc.dart
    │   ├── feature_event.dart
    │   └── feature_state.dart
    ├── pages/
    │   └── feature_page.dart
    └── widgets/
        └── feature_widget.dart
```

## Core Services

### 1. Authentication Service
```dart
abstract class AuthService {
  Future<UserEntity?> getCurrentUser();
  Future<void> signOut();
  Stream<UserEntity?> get authStateChanges;
}
```

### 2. Location Service
```dart
class LocationService {
  Future<LocationPermission> requestLocationPermission();
  Future<Position> getCurrentPosition();
  Future<List<Placemark>> getAddressFromCoordinates(double lat, double lng);
}
```

### 3. Payment Service
```dart
class PaymentService {
  Future<void> initialize();
  Future<PaymentResult> processPayment(PaymentParams params);
  Future<void> confirmPayment(String paymentIntentId);
}
```

## Firebase Integration

### 1. Authentication
- Email/password authentication
- Google Sign-In integration
- User session management
- Password reset functionality

### 2. Firestore Database
```javascript
// Firestore structure
users: {
  userId: {
    fullName: string,
    phoneNumber: string,
    userType: 'customer' | 'provider',
    profilePictureUrl: string,
    createdAt: timestamp,
    updatedAt: timestamp
  }
}

bookings: {
  bookingId: {
    customerId: string,
    providerId: string,
    serviceId: string,
    status: 'pending' | 'confirmed' | 'completed' | 'cancelled',
    scheduledDate: timestamp,
    totalAmount: number,
    createdAt: timestamp
  }
}
```

### 3. Security Rules
```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /users/{userId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }

    match /bookings/{bookingId} {
      allow read, write: if request.auth != null && 
        (resource.data.customerId == request.auth.uid || 
         resource.data.providerId == request.auth.uid);
    }
  }
}
```

## Error Handling

### 1. Failure Types
```dart
abstract class Failure extends Equatable {
  final String message;
  const Failure(this.message);
}

class ServerFailure extends Failure {
  const ServerFailure(super.message);
}

class NetworkFailure extends Failure {
  const NetworkFailure(super.message);
}

class AuthenticationFailure extends Failure {
  const AuthenticationFailure(super.message);
}
```

### 2. Error Propagation
```
Data Source → Repository → Use Case → BLoC → UI
   ↓            ↓          ↓        ↓      ↓
Exception → Either<Failure, Success> → State → Error Widget
```

## Testing Strategy

### 1. Unit Tests
- Domain layer (use cases, entities)
- Utility functions
- Business logic validation

### 2. Integration Tests
- Repository implementations
- Data source integrations
- API communication

### 3. Widget Tests
- UI component behavior
- BLoC state transitions
- User interaction flows

### 4. End-to-End Tests
- Complete user workflows
- Cross-feature interactions
- Platform-specific functionality

## Performance Considerations

### 1. State Management
- Efficient BLoC state transitions
- Minimal widget rebuilds
- Proper dispose of resources

### 2. Data Caching
- Local storage for offline support
- Image caching with `cached_network_image`
- API response caching

### 3. Memory Management
- Proper stream disposal
- Image memory optimization
- Large list pagination

### 4. Network Optimization
- Request/response compression
- Connection pooling
- Timeout configurations

## Scalability Considerations

### 1. Feature Modules
- Independent feature development
- Minimal cross-feature dependencies
- Clear feature boundaries

### 2. Code Generation
- JSON serialization
- Route generation
- Localization

### 3. Build Optimization
- Tree shaking for unused code
- Asset optimization
- Platform-specific builds

---

This architecture provides a solid foundation for the Fix It app, ensuring maintainability, testability, and scalability as the application grows in complexity and features.
