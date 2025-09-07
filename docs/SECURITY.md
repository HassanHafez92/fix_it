# Security Guide

This document outlines the security measures, best practices, and implementation details for the Fix It application.

## 📋 Table of Contents

- [Security Overview](#security-overview)
- [Authentication Security](#authentication-security)
- [Data Protection](#data-protection)
- [API Security](#api-security)
- [Client-Side Security](#client-side-security)
- [Firebase Security](#firebase-security)
- [Payment Security](#payment-security)
- [Privacy Protection](#privacy-protection)
- [Security Testing](#security-testing)
- [Incident Response](#incident-response)
- [Compliance](#compliance)

## Security Overview

### Security Architecture

```
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│   Flutter App   │───▶│  Firebase Auth  │───▶│   Firestore     │
│                 │    │                 │    │   (Secured)     │
│ • Input Valid.  │    │ • JWT Tokens    │    │ • Security      │
│ • Secure Store  │    │ • MFA Support   │    │   Rules         │
│ • Encryption    │    │ • Rate Limiting │    │ • Encryption    │
└─────────────────┘    └─────────────────┘    └─────────────────┘
         │                       │                       │
         ▼                       ▼                       ▼
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│  Local Storage  │    │   Stripe API    │    │  Firebase       │
│                 │    │                 │    │  Storage        │
│ • Encrypted     │    │ • PCI DSS       │    │                 │
│ • Secure Keys   │    │ • Tokenization  │    │ • Access Rules  │
│ • Biometric     │    │ • 3D Secure     │    │ • Encryption    │
└─────────────────┘    └─────────────────┘    └─────────────────┘
```

### Security Principles

1. **Defense in Depth**: Multiple layers of security controls
2. **Least Privilege**: Minimum necessary permissions
3. **Zero Trust**: Verify everything, trust nothing
4. **Encryption Everywhere**: Data encrypted in transit and at rest
5. **Regular Updates**: Keep dependencies and systems current

## Authentication Security

### Firebase Authentication

#### Supported Authentication Methods

```dart
class AuthenticationMethods {
  // Email/Password with strong validation
  static const emailPassword = 'email_password';

  // Google Sign-In with OAuth 2.0
  static const googleSignIn = 'google_oauth';

  // Phone authentication with SMS verification
  static const phoneAuth = 'phone_sms';

  // Multi-factor authentication (future)
  static const mfa = 'multi_factor';
}
```

#### Password Security Requirements

```dart
class PasswordValidator {
  static const int minLength = 8;
  static const int maxLength = 128;

  // Password strength requirements
  static bool isValid(String password) {
    return password.length >= minLength &&
           password.length <= maxLength &&
           hasUppercase(password) &&
           hasLowercase(password) &&
           hasDigit(password) &&
           hasSpecialCharacter(password);
  }

  static bool hasUppercase(String password) =>
      password.contains(RegExp(r'[A-Z]'));

  static bool hasLowercase(String password) =>
      password.contains(RegExp(r'[a-z]'));

  static bool hasDigit(String password) =>
      password.contains(RegExp(r'[0-9]'));

  static bool hasSpecialCharacter(String password) =>
      password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'));
}
```

#### Token Management

```dart
class TokenManager {
  static const Duration tokenRefreshThreshold = Duration(minutes: 5);

  /// Securely retrieve and refresh Firebase ID token
  static Future<String?> getValidToken() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return null;

    try {
      // Force refresh if token is about to expire
      final token = await user.getIdToken(true);
      return token;
    } catch (e) {
      // Handle token refresh errors
      await _handleTokenError(e);
      return null;
    }
  }

  static Future<void> _handleTokenError(dynamic error) async {
    // Log security event
    SecurityLogger.logTokenError(error);

    // Force user re-authentication if needed
    if (error is FirebaseAuthException) {
      switch (error.code) {
        case 'user-token-expired':
        case 'user-disabled':
          await FirebaseAuth.instance.signOut();
          break;
      }
    }
  }
}
```

### Session Management

```dart
class SessionManager {
  static const Duration maxSessionDuration = Duration(hours: 24);
  static const Duration inactivityTimeout = Duration(minutes: 30);

  static Timer? _sessionTimer;
  static Timer? _inactivityTimer;

  /// Start session monitoring
  static void startSession() {
    _resetSessionTimer();
    _resetInactivityTimer();

    // Monitor app lifecycle for security
    WidgetsBinding.instance.addObserver(_AppLifecycleObserver());
  }

  /// Reset inactivity timer on user interaction
  static void recordUserActivity() {
    _resetInactivityTimer();
  }

  static void _resetSessionTimer() {
    _sessionTimer?.cancel();
    _sessionTimer = Timer(maxSessionDuration, () {
      _forceLogout('Session expired');
    });
  }

  static void _resetInactivityTimer() {
    _inactivityTimer?.cancel();
    _inactivityTimer = Timer(inactivityTimeout, () {
      _forceLogout('Session timeout due to inactivity');
    });
  }

  static Future<void> _forceLogout(String reason) async {
    SecurityLogger.logSessionEvent(reason);
    await FirebaseAuth.instance.signOut();
    // Navigate to login screen
  }
}
```

## Data Protection

### Local Data Security

#### Secure Storage Implementation

```dart
class SecureDataManager {
  static const FlutterSecureStorage _secureStorage = FlutterSecureStorage(
    aOptions: AndroidOptions(
      encryptedSharedPreferences: true,
      sharedPreferencesName: 'fix_it_secure_prefs',
      preferencesKeyPrefix: 'fix_it_',
    ),
    iOptions: IOSOptions(
      groupId: 'group.com.fixit.app',
      accountName: 'fix_it_keychain',
      accessibility: IOSAccessibility.first_unlock_this_device,
    ),
  );

  /// Store sensitive data with encryption
  static Future<void> storeSecureData(String key, String value) async {
    try {
      await _secureStorage.write(key: key, value: value);
    } catch (e) {
      SecurityLogger.logStorageError('Failed to store secure data', e);
      throw SecurityException('Failed to store sensitive data');
    }
  }

  /// Retrieve and decrypt sensitive data
  static Future<String?> getSecureData(String key) async {
    try {
      return await _secureStorage.read(key: key);
    } catch (e) {
      SecurityLogger.logStorageError('Failed to retrieve secure data', e);
      return null;
    }
  }

  /// Clear all secure data (on logout)
  static Future<void> clearSecureData() async {
    try {
      await _secureStorage.deleteAll();
    } catch (e) {
      SecurityLogger.logStorageError('Failed to clear secure data', e);
    }
  }
}
```

#### Data Encryption

```dart
class DataEncryption {
  static const String _algorithm = 'AES-256-GCM';

  /// Encrypt sensitive data before storage
  static Future<String> encryptData(String plaintext) async {
    try {
      final key = await _generateOrRetrieveKey();
      final iv = _generateIV();

      // Use platform-specific encryption
      final encrypted = await _platformEncrypt(plaintext, key, iv);

      return base64Encode(encrypted);
    } catch (e) {
      SecurityLogger.logEncryptionError('Encryption failed', e);
      throw SecurityException('Failed to encrypt data');
    }
  }

  /// Decrypt sensitive data after retrieval
  static Future<String> decryptData(String ciphertext) async {
    try {
      final key = await _generateOrRetrieveKey();
      final encrypted = base64Decode(ciphertext);

      final decrypted = await _platformDecrypt(encrypted, key);

      return utf8.decode(decrypted);
    } catch (e) {
      SecurityLogger.logEncryptionError('Decryption failed', e);
      throw SecurityException('Failed to decrypt data');
    }
  }

  static Future<Uint8List> _generateOrRetrieveKey() async {
    // Generate or retrieve encryption key from secure storage
    // Implementation depends on platform capabilities
  }
}
```

### Data Sanitization

```dart
class DataSanitizer {
  /// Sanitize user input to prevent injection attacks
  static String sanitizeInput(String input) {
    if (input.isEmpty) return input;

    return input
        .trim()
        .replaceAll(RegExp(r'<script[^>]*>.*?</script>', caseSensitive: false), '')
        .replaceAll(RegExp(r'javascript:', caseSensitive: false), '')
        .replaceAll(RegExp(r'on\w+\s*=', caseSensitive: false), '');
  }

  /// Validate and sanitize email addresses
  static String? sanitizeEmail(String email) {
    final sanitized = sanitizeInput(email.toLowerCase());

    if (!RegExp(AppConstants.emailPattern).hasMatch(sanitized)) {
      return null;
    }

    return sanitized;
  }

  /// Sanitize phone numbers
  static String? sanitizePhoneNumber(String phone) {
    final digits = phone.replaceAll(RegExp(r'[^\d+]'), '');

    if (!RegExp(AppConstants.phonePattern).hasMatch(digits)) {
      return null;
    }

    return digits;
  }
}
```

## API Security

### Request Security

```dart
class SecureApiClient {
  late final Dio _dio;

  SecureApiClient() {
    _dio = Dio(BaseOptions(
      baseUrl: AppConstants.baseUrl,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      headers: {
        'Content-Type': 'application/json',
        'X-App-Version': AppConstants.appVersion,
        'X-Platform': Platform.operatingSystem,
      },
    ));

    _setupInterceptors();
  }

  void _setupInterceptors() {
    // Request interceptor for authentication
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        // Add authentication token
        final token = await TokenManager.getValidToken();
        if (token != null) {
          options.headers['Authorization'] = 'Bearer $token';
        }

        // Add request signature for integrity
        final signature = await _generateRequestSignature(options);
        options.headers['X-Request-Signature'] = signature;

        // Add timestamp to prevent replay attacks
        options.headers['X-Timestamp'] = DateTime.now().millisecondsSinceEpoch.toString();

        handler.next(options);
      },

      onResponse: (response, handler) {
        // Verify response integrity
        if (!_verifyResponseIntegrity(response)) {
          handler.reject(DioException(
            requestOptions: response.requestOptions,
            message: 'Response integrity check failed',
          ));
          return;
        }

        handler.next(response);
      },

      onError: (error, handler) async {
        // Handle authentication errors
        if (error.response?.statusCode == 401) {
          await _handleUnauthorizedError();
        }

        // Log security-related errors
        SecurityLogger.logApiError(error);

        handler.next(error);
      },
    ));

    // Certificate pinning interceptor
    _dio.interceptors.add(CertificatePinningInterceptor());
  }

  Future<String> _generateRequestSignature(RequestOptions options) async {
    // Generate HMAC signature for request integrity
    final content = '${options.method}${options.path}${options.data ?? ''}';
    final key = await _getSigningKey();

    final hmac = Hmac(sha256, utf8.encode(key));
    final digest = hmac.convert(utf8.encode(content));

    return digest.toString();
  }

  bool _verifyResponseIntegrity(Response response) {
    // Verify response hasn't been tampered with
    final signature = response.headers.value('x-response-signature');
    if (signature == null) return false;

    // Verify signature logic here
    return true;
  }
}
```

### Rate Limiting

```dart
class RateLimiter {
  static final Map<String, List<DateTime>> _requestHistory = {};
  static const int maxRequestsPerMinute = 60;
  static const Duration timeWindow = Duration(minutes: 1);

  /// Check if request is allowed based on rate limits
  static bool isRequestAllowed(String endpoint) {
    final now = DateTime.now();
    final history = _requestHistory[endpoint] ?? [];

    // Remove old requests outside time window
    history.removeWhere((time) => now.difference(time) > timeWindow);

    // Check if under rate limit
    if (history.length >= maxRequestsPerMinute) {
      SecurityLogger.logRateLimitExceeded(endpoint);
      return false;
    }

    // Record this request
    history.add(now);
    _requestHistory[endpoint] = history;

    return true;
  }
}
```

## Firebase Security

### Firestore Security Rules

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Users can only access their own data
    match /users/{userId} {
      allow read, write: if isOwner(userId) && isAuthenticated();

      function isOwner(userId) {
        return request.auth.uid == userId;
      }
    }

    // Service providers can manage their services
    match /services/{serviceId} {
      allow read: if isAuthenticated();
      allow create, update: if isProvider() && isOwner(resource.data.providerId);
      allow delete: if isProvider() && isOwner(resource.data.providerId);

      function isProvider() {
        return request.auth.token.userType == 'provider';
      }
    }

    // Booking access control
    match /bookings/{bookingId} {
      allow read, write: if isAuthenticated() && 
        (isOwner(resource.data.customerId) || isOwner(resource.data.providerId));

      function isOwner(userId) {
        return request.auth.uid == userId;
      }
    }

    // Chat messages security
    match /chats/{chatId} {
      allow read, write: if isAuthenticated() && isParticipant(chatId);

      function isParticipant(chatId) {
        return request.auth.uid in resource.data.participants;
      }

      match /messages/{messageId} {
        allow read, write: if isAuthenticated() && isParticipant(chatId);
      }
    }

    // Reviews can be read by anyone, written by customers only
    match /reviews/{reviewId} {
      allow read: if true;
      allow create: if isAuthenticated() && isCustomer() && 
        request.auth.uid == request.resource.data.customerId;
      allow update: if isAuthenticated() && isOwner(resource.data.customerId);

      function isCustomer() {
        return request.auth.token.userType == 'customer';
      }
    }

    // Helper functions
    function isAuthenticated() {
      return request.auth != null && request.auth.uid != null;
    }

    function isValidEmail() {
      return request.auth.token.email_verified == true;
    }

    function isValidTimestamp(timestamp) {
      return timestamp is timestamp && 
        timestamp > request.time - duration.value(1, 'h') &&
        timestamp < request.time + duration.value(1, 'h');
    }
  }
}
```

### Firebase Storage Security

```javascript
rules_version = '2';
service firebase.storage {
  match /b/{bucket}/o {
    // User profile images
    match /users/{userId}/profile/{fileName} {
      allow read: if true;
      allow write: if isOwner(userId) && isAuthenticated() && 
        isValidImage() && isValidSize();

      function isOwner(userId) {
        return request.auth.uid == userId;
      }

      function isValidImage() {
        return resource.contentType.matches('image/.*');
      }

      function isValidSize() {
        return resource.size < 5 * 1024 * 1024; // 5MB limit
      }
    }

    // Service images (providers only)
    match /services/{serviceId}/{fileName} {
      allow read: if true;
      allow write: if isAuthenticated() && isProvider() && isValidImage();

      function isProvider() {
        return request.auth.token.userType == 'provider';
      }
    }

    // Chat attachments
    match /chats/{chatId}/{fileName} {
      allow read, write: if isAuthenticated() && isParticipant(chatId);

      function isParticipant(chatId) {
        // Verify user is participant in chat
        return true; // Implement chat participant verification
      }
    }

    function isAuthenticated() {
      return request.auth != null;
    }
  }
}
```

## Payment Security

### PCI DSS Compliance

```dart
class PaymentSecurity {
  /// Never store sensitive payment data locally
  static const List<String> forbiddenData = [
    'card_number',
    'cvv',
    'pin',
    'magnetic_stripe',
  ];

  /// Use Stripe's secure tokenization
  static Future<PaymentMethod> createSecurePaymentMethod({
    required String cardNumber,
    required String expiryMonth,
    required String expiryYear,
    required String cvc,
  }) async {
    try {
      // Validate card data before sending to Stripe
      _validateCardData(cardNumber, expiryMonth, expiryYear, cvc);

      // Create payment method using Stripe SDK (tokenization)
      final paymentMethod = await Stripe.instance.createPaymentMethod(
        params: PaymentMethodParams.card(
          paymentMethodData: PaymentMethodData(
            billingDetails: BillingDetails(), // Add billing details
          ),
        ),
      );

      // Never log or store actual card data
      SecurityLogger.logPaymentEvent('Payment method created', {
        'payment_method_id': paymentMethod.id,
        'card_last_four': cardNumber.substring(cardNumber.length - 4),
      });

      return paymentMethod;
    } catch (e) {
      SecurityLogger.logPaymentError('Payment method creation failed', e);
      throw PaymentSecurityException('Failed to create secure payment method');
    }
  }

  static void _validateCardData(String cardNumber, String expiryMonth, 
      String expiryYear, String cvc) {
    // Implement card validation logic
    if (!_isValidCardNumber(cardNumber)) {
      throw PaymentValidationException('Invalid card number');
    }

    if (!_isValidExpiry(expiryMonth, expiryYear)) {
      throw PaymentValidationException('Invalid expiry date');
    }

    if (!_isValidCVC(cvc)) {
      throw PaymentValidationException('Invalid CVC');
    }
  }
}
```

### 3D Secure Implementation

```dart
class ThreeDSecureManager {
  /// Implement 3D Secure for enhanced payment security
  static Future<PaymentIntent> processSecurePayment({
    required String paymentIntentId,
    required BuildContext context,
  }) async {
    try {
      // Confirm payment with 3D Secure if required
      final paymentIntent = await Stripe.instance.confirmPayment(
        paymentIntentClientSecret: paymentIntentId,
        data: PaymentMethodParams.card(),
      );

      // Handle 3D Secure authentication
      if (paymentIntent.status == PaymentIntentsStatus.RequiresAction) {
        final authenticatedIntent = await Stripe.instance.handleNextAction(
          paymentIntentClientSecret: paymentIntentId,
        );

        return authenticatedIntent;
      }

      return paymentIntent;
    } catch (e) {
      SecurityLogger.logPaymentError('3D Secure authentication failed', e);
      throw PaymentSecurityException('Payment authentication failed');
    }
  }
}
```

## Privacy Protection

### Data Anonymization

```dart
class PrivacyManager {
  /// Anonymize user data for analytics
  static Map<String, dynamic> anonymizeUserData(UserEntity user) {
    return {
      'user_id': _hashUserId(user.id),
      'user_type': user.userType,
      'registration_date': user.createdAt.toIso8601String(),
      'location_region': _getRegionFromAddress(user.address),
      // Never include PII like email, phone, exact address
    };
  }

  /// Hash user ID for privacy
  static String _hashUserId(String userId) {
    final bytes = utf8.encode(userId + _getSalt());
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  /// Remove or mask PII from logs
  static Map<String, dynamic> sanitizeLogData(Map<String, dynamic> data) {
    final sanitized = Map<String, dynamic>.from(data);

    // Remove sensitive fields
    sanitized.remove('email');
    sanitized.remove('phone_number');
    sanitized.remove('password');
    sanitized.remove('card_number');

    // Mask partial data
    if (sanitized.containsKey('user_id')) {
      sanitized['user_id'] = _maskString(sanitized['user_id']);
    }

    return sanitized;
  }

  static String _maskString(String value) {
    if (value.length <= 4) return '****';
    return value.substring(0, 2) + '****' + value.substring(value.length - 2);
  }
}
```

### GDPR Compliance

```dart
class GDPRCompliance {
  /// Allow users to request their data
  static Future<Map<String, dynamic>> exportUserData(String userId) async {
    try {
      final userData = await _collectUserData(userId);

      // Log data export request
      SecurityLogger.logPrivacyEvent('Data export requested', {
        'user_id': userId,
        'timestamp': DateTime.now().toIso8601String(),
      });

      return {
        'user_profile': userData['profile'],
        'bookings': userData['bookings'],
        'reviews': userData['reviews'],
        'chat_history': userData['chats'],
        'export_date': DateTime.now().toIso8601String(),
      };
    } catch (e) {
      SecurityLogger.logPrivacyError('Data export failed', e);
      throw PrivacyException('Failed to export user data');
    }
  }

  /// Allow users to delete their data
  static Future<void> deleteUserData(String userId) async {
    try {
      // Anonymize instead of delete for business records
      await _anonymizeUserData(userId);

      // Delete authentication data
      await FirebaseAuth.instance.currentUser?.delete();

      SecurityLogger.logPrivacyEvent('User data deleted', {
        'user_id': userId,
        'timestamp': DateTime.now().toIso8601String(),
      });
    } catch (e) {
      SecurityLogger.logPrivacyError('Data deletion failed', e);
      throw PrivacyException('Failed to delete user data');
    }
  }
}
```

## Security Testing

### Penetration Testing Checklist

- [ ] **Authentication Testing**
  - [ ] Brute force protection
  - [ ] Session management
  - [ ] Token security
  - [ ] Multi-factor authentication

- [ ] **API Security Testing**
  - [ ] SQL injection prevention
  - [ ] XSS protection
  - [ ] CSRF protection
  - [ ] Rate limiting
  - [ ] Input validation

- [ ] **Data Protection Testing**
  - [ ] Encryption verification
  - [ ] Secure storage testing
  - [ ] Data leakage prevention
  - [ ] Privacy controls

- [ ] **Infrastructure Testing**
  - [ ] Certificate pinning
  - [ ] Network security
  - [ ] Firewall configuration
  - [ ] Access controls

### Security Testing Tools

```bash
# Static analysis
flutter analyze --fatal-infos

# Dependency vulnerability scanning
dart pub deps --style=compact | grep -E "(CRITICAL|HIGH)"

# Code security scanning
semgrep --config=auto lib/

# Network security testing
nmap -sV -sC api.fixit.com

# SSL/TLS testing
testssl.sh api.fixit.com
```

## Incident Response

### Security Incident Response Plan

#### 1. Detection and Analysis
- Monitor security logs and alerts
- Analyze potential security incidents
- Determine severity and impact

#### 2. Containment and Eradication
- Isolate affected systems
- Remove malicious code or access
- Patch vulnerabilities

#### 3. Recovery and Post-Incident
- Restore systems from clean backups
- Monitor for additional activity
- Document lessons learned

### Security Monitoring

```dart
class SecurityLogger {
  static Future<void> logSecurityEvent(String event, Map<String, dynamic> details) async {
    final logEntry = {
      'timestamp': DateTime.now().toIso8601String(),
      'event_type': 'security',
      'event': event,
      'details': PrivacyManager.sanitizeLogData(details),
      'app_version': AppConstants.appVersion,
      'platform': Platform.operatingSystem,
    };

    // Send to security monitoring system
    await _sendToSecurityMonitoring(logEntry);

    // Log locally for debugging
    debugPrint('Security Event: ${jsonEncode(logEntry)}');
  }

  static Future<void> logSuspiciousActivity(String activity, String userId) async {
    await logSecurityEvent('suspicious_activity', {
      'activity': activity,
      'user_id': userId,
      'risk_level': 'medium',
    });

    // Alert security team for investigation
    await _alertSecurityTeam(activity, userId);
  }
}
```

## Compliance

### Security Standards Compliance

#### SOC 2 Type II
- [ ] Security controls implementation
- [ ] Availability monitoring
- [ ] Processing integrity
- [ ] Confidentiality measures
- [ ] Privacy protection

#### ISO 27001
- [ ] Information security management system
- [ ] Risk assessment and treatment
- [ ] Security controls implementation
- [ ] Continuous monitoring and improvement

#### OWASP Mobile Top 10
- [ ] M1: Improper Platform Usage
- [ ] M2: Insecure Data Storage
- [ ] M3: Insecure Communication
- [ ] M4: Insecure Authentication
- [ ] M5: Insufficient Cryptography
- [ ] M6: Insecure Authorization
- [ ] M7: Client Code Quality
- [ ] M8: Code Tampering
- [ ] M9: Reverse Engineering
- [ ] M10: Extraneous Functionality

### Regular Security Reviews

- **Monthly**: Security patch updates
- **Quarterly**: Security architecture review
- **Annually**: Penetration testing
- **Continuous**: Vulnerability monitoring

---

**Note**: This security guide should be regularly updated as new threats emerge and security practices evolve. All team members should be familiar with these security measures and their implementation.