# Fix It API Documentation

This document provides comprehensive information about the Fix It application's API endpoints, data structures, and integration patterns.

## 📋 Table of Contents

- [Overview](#overview)
- [Authentication](#authentication)
- [Base URL & Versioning](#base-url--versioning)
- [Request/Response Format](#requestresponse-format)
- [Error Handling](#error-handling)
- [Rate Limiting](#rate-limiting)
- [API Endpoints](#api-endpoints)
- [Data Models](#data-models)
- [Firebase Integration](#firebase-integration)
- [Code Examples](#code-examples)

## Overview

The Fix It API provides backend services for the home services booking application. It supports both REST API endpoints for legacy functionality and Firebase services for real-time features.

### Service Architecture

```
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│   Flutter App   │───▶│   REST API      │───▶│   Database      │
└─────────────────┘    └─────────────────┘    └─────────────────┘
         │
         ▼
┌─────────────────┐    ┌─────────────────┐
│ Firebase Auth   │    │   Firestore     │
└─────────────────┘    └─────────────────┘
```

### Technology Stack

- **Authentication**: Firebase Authentication
- **Database**: Cloud Firestore
- **Storage**: Firebase Storage
- **Push Notifications**: Firebase Cloud Messaging
- **REST API**: Node.js/Express (legacy endpoints)
- **Payment Processing**: Stripe API

## Authentication

### Firebase Authentication

The app uses Firebase Authentication for user management with the following providers:

#### Supported Sign-In Methods

1. **Email/Password Authentication**
2. **Google Sign-In**
3. **Phone Number Authentication** (future)

#### Authentication Flow

```dart
// Sign In Example
try {
  final userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
    email: email,
    password: password,
  );
  final user = userCredential.user;
} on FirebaseAuthException catch (e) {
  // Handle authentication errors
}
```

#### Token Management

- **ID Tokens**: Used for Firebase service authentication
- **Custom Claims**: Role-based access control (customer/provider)
- **Token Refresh**: Automatic token refresh handled by Firebase SDK

### REST API Authentication

For legacy REST endpoints, use the Firebase ID token:

```dart
final idToken = await FirebaseAuth.instance.currentUser?.getIdToken();

final response = await dio.get(
  '/api/v1/services',
  options: Options(
    headers: {
      'Authorization': 'Bearer $idToken',
      'Content-Type': 'application/json',
    },
  ),
);
```

## Base URL & Versioning

### Environments

- **Development**: `https://dev-api.fixit.com/api/v1`
- **Staging**: `https://staging-api.fixit.com/api/v1`
- **Production**: `https://api.fixit.com/api/v1`

### API Versioning

The API uses URL versioning with the format: `/api/v{version}`

Current version: **v1**

### Configuration

```dart
// In app_constants.dart
class AppConstants {
  static const String baseUrl = 'https://api.fixit.com/api/v1';
  static const String apiVersion = 'v1';
}
```

## Request/Response Format

### Request Headers

All API requests should include:

```http
Content-Type: application/json
Authorization: Bearer <firebase_id_token>
X-App-Version: 1.0.0
X-Platform: android|ios|web
```

### Response Format

#### Success Response

```json
{
  "success": true,
  "data": {
    // Response data
  },
  "message": "Operation completed successfully",
  "timestamp": "2024-01-15T10:30:00Z"
}
```

#### Error Response

```json
{
  "success": false,
  "error": {
    "code": "VALIDATION_ERROR",
    "message": "Invalid input parameters",
    "details": {
      "field": "email",
      "reason": "Invalid email format"
    }
  },
  "timestamp": "2024-01-15T10:30:00Z"
}
```

## Error Handling

### HTTP Status Codes

| Status Code | Description | Usage |
|-------------|-------------|-------|
| 200 | OK | Successful request |
| 201 | Created | Resource created successfully |
| 400 | Bad Request | Invalid request parameters |
| 401 | Unauthorized | Authentication required |
| 403 | Forbidden | Insufficient permissions |
| 404 | Not Found | Resource not found |
| 409 | Conflict | Resource already exists |
| 422 | Unprocessable Entity | Validation errors |
| 429 | Too Many Requests | Rate limit exceeded |
| 500 | Internal Server Error | Server error |
| 503 | Service Unavailable | Server maintenance |

### Error Codes

```dart
class ApiErrorCodes {
  static const String validationError = 'VALIDATION_ERROR';
  static const String authenticationError = 'AUTHENTICATION_ERROR';
  static const String authorizationError = 'AUTHORIZATION_ERROR';
  static const String resourceNotFound = 'RESOURCE_NOT_FOUND';
  static const String serviceUnavailable = 'SERVICE_UNAVAILABLE';
  static const String rateLimitExceeded = 'RATE_LIMIT_EXCEEDED';
}
```

## Rate Limiting

### Rate Limits

- **Authenticated Users**: 1000 requests per hour
- **Unauthenticated Users**: 100 requests per hour
- **Critical Operations**: 10 requests per minute

### Rate Limit Headers

```http
X-RateLimit-Limit: 1000
X-RateLimit-Remaining: 999
X-RateLimit-Reset: 1642262400
```

## API Endpoints

### Authentication Endpoints

#### POST /auth/refresh
Refresh authentication token (if using custom auth)

**Request:**
```json
{
  "refreshToken": "eyJhbGciOiJIUzI1NiIs..."
}
```

**Response:**
```json
{
  "success": true,
  "data": {
    "accessToken": "eyJhbGciOiJIUzI1NiIs...",
    "refreshToken": "eyJhbGciOiJIUzI1NiIs...",
    "expiresIn": 3600
  }
}
```

### User Management

#### GET /users/profile
Get current user profile

**Response:**
```json
{
  "success": true,
  "data": {
    "id": "user123",
    "fullName": "John Doe",
    "email": "john@example.com",
    "phoneNumber": "+1234567890",
    "userType": "customer",
    "profilePictureUrl": "https://...",
    "address": {
      "street": "123 Main St",
      "city": "New York",
      "state": "NY",
      "zipCode": "10001",
      "coordinates": {
        "latitude": 40.7128,
        "longitude": -74.0060
      }
    },
    "createdAt": "2024-01-01T00:00:00Z",
    "isActive": true
  }
}
```

#### PUT /users/profile
Update user profile

**Request:**
```json
{
  "fullName": "John Doe",
  "phoneNumber": "+1234567890",
  "address": {
    "street": "123 Main St",
    "city": "New York",
    "state": "NY",
    "zipCode": "10001"
  }
}
```

### Services Management

#### GET /services
Get list of available services

**Query Parameters:**
- `category` (optional): Filter by service category
- `location` (optional): Filter by location (lat,lng)
- `radius` (optional): Search radius in km (default: 10)
- `page` (optional): Page number (default: 1)
- `limit` (optional): Items per page (default: 20)

**Response:**
```json
{
  "success": true,
  "data": {
    "services": [
      {
        "id": "service123",
        "name": "Emergency Plumbing Repair",
        "description": "24/7 emergency plumbing services",
        "category": "plumbing",
        "price": 150.00,
        "duration": 120,
        "providerId": "provider123",
        "providerName": "John's Plumbing",
        "providerRating": 4.8,
        "images": [
          "https://storage.googleapis.com/..."
        ],
        "location": {
          "latitude": 40.7128,
          "longitude": -74.0060
        },
        "isActive": true,
        "tags": ["emergency", "24/7", "licensed"]
      }
    ],
    "pagination": {
      "currentPage": 1,
      "totalPages": 5,
      "totalItems": 100,
      "itemsPerPage": 20
    }
  }
}
```

#### GET /services/{serviceId}
Get service details

**Response:**
```json
{
  "success": true,
  "data": {
    "id": "service123",
    "name": "Emergency Plumbing Repair",
    "description": "Comprehensive plumbing repair services...",
    "category": "plumbing",
    "price": 150.00,
    "duration": 120,
    "providerId": "provider123",
    "provider": {
      "id": "provider123",
      "name": "John's Plumbing",
      "rating": 4.8,
      "reviewCount": 156,
      "profilePicture": "https://...",
      "isVerified": true,
      "experience": "10+ years"
    },
    "images": ["https://..."],
    "location": {
      "latitude": 40.7128,
      "longitude": -74.0060
    },
    "availability": {
      "monday": ["09:00", "17:00"],
      "tuesday": ["09:00", "17:00"]
    },
    "reviews": [
      {
        "id": "review123",
        "customerName": "Jane Smith",
        "rating": 5,
        "comment": "Excellent service!",
        "createdAt": "2024-01-10T14:30:00Z"
      }
    ]
  }
}
```

### Booking Management

#### POST /bookings
Create a new booking

**Request:**
```json
{
  "serviceId": "service123",
  "providerId": "provider123",
  "scheduledDateTime": "2024-01-20T10:00:00Z",
  "address": {
    "street": "123 Main St",
    "city": "New York",
    "state": "NY",
    "zipCode": "10001",
    "instructions": "Ring doorbell twice"
  },
  "notes": "Kitchen sink is completely blocked"
}
```

**Response:**
```json
{
  "success": true,
  "data": {
    "id": "booking123",
    "customerId": "customer123",
    "providerId": "provider123",
    "serviceId": "service123",
    "status": "pending",
    "scheduledDateTime": "2024-01-20T10:00:00Z",
    "totalAmount": 150.00,
    "paymentStatus": "pending",
    "createdAt": "2024-01-15T10:30:00Z"
  }
}
```

#### GET /bookings
Get user's bookings

**Query Parameters:**
- `status` (optional): Filter by booking status
- `page` (optional): Page number
- `limit` (optional): Items per page

**Response:**
```json
{
  "success": true,
  "data": {
    "bookings": [
      {
        "id": "booking123",
        "service": {
          "id": "service123",
          "name": "Emergency Plumbing Repair",
          "category": "plumbing"
        },
        "provider": {
          "id": "provider123",
          "name": "John's Plumbing",
          "phoneNumber": "+1234567890"
        },
        "status": "confirmed",
        "scheduledDateTime": "2024-01-20T10:00:00Z",
        "totalAmount": 150.00,
        "paymentStatus": "paid",
        "address": {
          "street": "123 Main St",
          "city": "New York"
        }
      }
    ]
  }
}
```

#### PUT /bookings/{bookingId}/status
Update booking status

**Request:**
```json
{
  "status": "confirmed",
  "notes": "Provider confirmed availability"
}
```

### Provider Management

#### GET /providers
Get list of service providers

**Query Parameters:**
- `category` (optional): Filter by service category
- `location` (optional): Filter by location
- `rating` (optional): Minimum rating filter

**Response:**
```json
{
  "success": true,
  "data": {
    "providers": [
      {
        "id": "provider123",
        "name": "John's Plumbing",
        "description": "Professional plumbing services...",
        "categories": ["plumbing", "hvac"],
        "rating": 4.8,
        "reviewCount": 156,
        "location": {
          "latitude": 40.7128,
          "longitude": -74.0060
        },
        "isVerified": true,
        "profilePicture": "https://...",
        "responseTime": "30 minutes"
      }
    ]
  }
}
```

### Payment Processing

#### POST /payments/create-intent
Create payment intent for booking

**Request:**
```json
{
  "bookingId": "booking123",
  "amount": 15000,
  "currency": "usd",
  "paymentMethod": "card"
}
```

**Response:**
```json
{
  "success": true,
  "data": {
    "clientSecret": "pi_1234567890_secret_abcdef",
    "paymentIntentId": "pi_1234567890"
  }
}
```

## Data Models

### User Entity

```dart
class UserEntity extends Equatable {
  final String id;
  final String fullName;
  final String email;
  final String? phoneNumber;
  final UserType userType;
  final String? profilePictureUrl;
  final AddressEntity? address;
  final DateTime createdAt;
  final bool isActive;

  const UserEntity({
    required this.id,
    required this.fullName,
    required this.email,
    this.phoneNumber,
    required this.userType,
    this.profilePictureUrl,
    this.address,
    required this.createdAt,
    required this.isActive,
  });

  @override
  List<Object?> get props => [
    id, fullName, email, phoneNumber, userType,
    profilePictureUrl, address, createdAt, isActive,
  ];
}

enum UserType { customer, provider }
```

### Service Entity

```dart
class ServiceEntity extends Equatable {
  final String id;
  final String name;
  final String description;
  final ServiceCategory category;
  final double price;
  final int duration; // in minutes
  final String providerId;
  final String providerName;
  final double providerRating;
  final List<String> images;
  final LocationEntity location;
  final bool isActive;
  final List<String> tags;

  const ServiceEntity({
    required this.id,
    required this.name,
    required this.description,
    required this.category,
    required this.price,
    required this.duration,
    required this.providerId,
    required this.providerName,
    required this.providerRating,
    required this.images,
    required this.location,
    required this.isActive,
    required this.tags,
  });
}
```

### Booking Entity

```dart
class BookingEntity extends Equatable {
  final String id;
  final String customerId;
  final String providerId;
  final String serviceId;
  final BookingStatus status;
  final DateTime scheduledDateTime;
  final DateTime? completedDateTime;
  final AddressEntity address;
  final double totalAmount;
  final PaymentStatus paymentStatus;
  final String? notes;
  final DateTime createdAt;

  const BookingEntity({
    required this.id,
    required this.customerId,
    required this.providerId,
    required this.serviceId,
    required this.status,
    required this.scheduledDateTime,
    this.completedDateTime,
    required this.address,
    required this.totalAmount,
    required this.paymentStatus,
    this.notes,
    required this.createdAt,
  });
}

enum BookingStatus {
  pending,
  confirmed,
  inProgress,
  completed,
  cancelled,
}

enum PaymentStatus {
  pending,
  paid,
  refunded,
}
```

## Firebase Integration

### Firestore Collections

#### Users Collection

```typescript
// firestore/users/{userId}
interface User {
  fullName: string;
  email: string;
  phoneNumber?: string;
  userType: 'customer' | 'provider';
  profilePictureUrl?: string;
  address?: {
    street: string;
    city: string;
    state: string;
    zipCode: string;
    coordinates: FirebaseFirestore.GeoPoint;
  };
  isEmailVerified: boolean;
  isPhoneVerified: boolean;
  createdAt: FirebaseFirestore.Timestamp;
  updatedAt: FirebaseFirestore.Timestamp;
  isActive: boolean;
}
```

#### Bookings Collection

```typescript
// firestore/bookings/{bookingId}
interface Booking {
  customerId: string;
  customerName: string;
  providerId: string;
  providerName: string;
  serviceId: string;
  serviceName: string;
  status: 'pending' | 'confirmed' | 'in_progress' | 'completed' | 'cancelled';
  scheduledDateTime: FirebaseFirestore.Timestamp;
  completedDateTime?: FirebaseFirestore.Timestamp;
  address: {
    street: string;
    city: string;
    coordinates: FirebaseFirestore.GeoPoint;
    instructions?: string;
  };
  totalAmount: number;
  paymentStatus: 'pending' | 'paid' | 'refunded';
  paymentMethod: string;
  notes?: string;
  createdAt: FirebaseFirestore.Timestamp;
  updatedAt: FirebaseFirestore.Timestamp;
}
```

### Firestore Security Rules

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Users can only access their own data
    match /users/{userId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }

    // Bookings can be read by customer or provider
    match /bookings/{bookingId} {
      allow read: if request.auth != null && 
        (resource.data.customerId == request.auth.uid || 
         resource.data.providerId == request.auth.uid);

      allow create: if request.auth != null && 
        resource.data.customerId == request.auth.uid;

      allow update: if request.auth != null && 
        (resource.data.customerId == request.auth.uid || 
         resource.data.providerId == request.auth.uid);
    }

    // Services are read-only for customers, read-write for providers
    match /services/{serviceId} {
      allow read: if request.auth != null;
      allow write: if request.auth != null && 
        resource.data.providerId == request.auth.uid;
    }
  }
}
```

## Code Examples

### API Client Implementation

```dart
@RestApi(baseUrl: AppConstants.baseUrl)
abstract class ApiClient {
  factory ApiClient(Dio dio, {String baseUrl}) = _ApiClient;

  @GET('/services')
  Future<ApiResponse<ServicesResponse>> getServices({
    @Query('category') String? category,
    @Query('location') String? location,
    @Query('radius') int? radius,
    @Query('page') int page = 1,
    @Query('limit') int limit = 20,
  });

  @GET('/services/{id}')
  Future<ApiResponse<ServiceResponse>> getServiceDetails(@Path('id') String serviceId);

  @POST('/bookings')
  Future<ApiResponse<BookingResponse>> createBooking(@Body() CreateBookingRequest request);

  @GET('/bookings')
  Future<ApiResponse<BookingsResponse>> getBookings({
    @Query('status') String? status,
    @Query('page') int page = 1,
    @Query('limit') int limit = 20,
  });
}
```

### Error Handling

```dart
class ApiErrorHandler {
  static Failure handleError(DioError error) {
    switch (error.type) {
      case DioErrorType.connectionTimeout:
      case DioErrorType.receiveTimeout:
        return const NetworkFailure('Connection timeout');

      case DioErrorType.response:
        final statusCode = error.response?.statusCode;
        final errorData = error.response?.data;

        switch (statusCode) {
          case 400:
            return ValidationFailure(errorData['error']['message']);
          case 401:
            return const AuthenticationFailure('Authentication required');
          case 403:
            return const AuthenticationFailure('Insufficient permissions');
          case 404:
            return const ServerFailure('Resource not found');
          case 500:
            return const ServerFailure('Internal server error');
          default:
            return ServerFailure('Server error: $statusCode');
        }

      default:
        return const NetworkFailure('Network error occurred');
    }
  }
}
```

### Repository Implementation

```dart
class ServiceRepositoryImpl implements ServiceRepository {
  final ApiClient apiClient;
  final ServiceLocalDataSource localDataSource;

  ServiceRepositoryImpl({
    required this.apiClient,
    required this.localDataSource,
  });

  @override
  Future<Either<Failure, List<ServiceEntity>>> getServices({
    String? category,
    String? location,
    int? radius,
    int page = 1,
    int limit = 20,
  }) async {
    try {
      final response = await apiClient.getServices(
        category: category,
        location: location,
        radius: radius,
        page: page,
        limit: limit,
      );

      final services = response.data.services
          .map((model) => model.toEntity())
          .toList();

      // Cache services locally
      await localDataSource.cacheServices(services);

      return Right(services);
    } on DioError catch (e) {
      return Left(ApiErrorHandler.handleError(e));
    } catch (e) {
      return Left(UnknownFailure('Unexpected error: $e'));
    }
  }
}
```

This API documentation provides a comprehensive guide for integrating with the Fix It backend services. For additional examples and updates, refer to the specific implementation files in the codebase.