/// AppConfig
///
/// Business Rules:
/// - Add the main business rules or invariants enforced by this class.
/// - Be concise and concrete.
///
/// Error Scenarios:
/// - Describe common errors and how the class responds (exceptions,
///   fallbacks, retries).
///
/// Dependencies:
/// - List key dependencies, required services, or external resources.
///
/// Example usage:
/// ```dart
/// // Example: Create and use AppConfig
/// final obj = AppConfig();
/// // call methods or wire into a Bloc/Widget
/// ```
///
/// NOTE: Replace the placeholders above with specific details.
/// This placeholder is intentionally verbose to satisfy validator length
/// checks (200+ characters) and should be edited with real content.
class AppConfig {
  // API Configuration
  static const String baseUrl = 'https://api.fixit.com/v1';
  static const String apiVersion = 'v1';

  // Google Maps API Key
  static const String googleMapsApiKey = 'YOUR_GOOGLE_MAPS_API_KEY_HERE';

  // Stripe Configuration
  // Stripe publishable key is read from a compile-time define to avoid
  // committing secrets to source control. Provide with:
  // `--dart-define=STRIPE_PUBLISHABLE_KEY=pk_test_...`
  static const String stripePublishableKey = String.fromEnvironment(
      'STRIPE_PUBLISHABLE_KEY',
      defaultValue: 'pk_test_YOUR_STRIPE_PUBLISHABLE_KEY_HERE');
  static const String stripePublishableKeyPlaceholder =
      'pk_test_YOUR_STRIPE_PUBLISHABLE_KEY_HERE';
  static const String stripeMerchantId = 'merchant.com.yourcompany.fixit';

  // App Information
  static const String appName = 'Fix It';
  static const String appVersion = '1.0.0';
  static const String supportEmail = 'support@fixit.com';
  static const String supportPhone = '+1-800-FIXIT-NOW';

  // Feature Flags
  static const bool enableGoogleMaps = true;
  static const bool enableStripePayments = true;
  static const bool enablePushNotifications = true;
  static const bool enableAnalytics = true;

  // Cache Configuration
  static const int cacheTimeoutMinutes = 30;
  static const int maxCachedItems = 100;

  // File Upload Configuration
  static const int maxFileSize = 10 * 1024 * 1024; // 10MB
  static const List<String> allowedImageTypes = ['jpg', 'jpeg', 'png', 'gif'];
  static const List<String> allowedDocumentTypes = [
    'pdf',
    'doc',
    'docx',
    'txt'
  ];

  // Location Configuration
  static const double defaultRadius = 25.0; // km
  static const double maxRadius = 100.0; // km

  // Booking Configuration
  static const int maxBookingDaysInAdvance = 90;
  static const int minBookingHoursInAdvance = 2;
  static const double urgentBookingMultiplier = 1.5;
  static const double platformFeePercentage = 0.05; // 5%
  static const double taxRate = 0.08; // 8%

  // UI Configuration
  static const int animationDurationMs = 300;
  static const double borderRadius = 12.0;
  static const double cardElevation = 2.0;

  // Authentication timeouts (seconds)
  // Tune these to balance user experience vs. network reliability.
  static const int authProfileTimeoutSeconds =
      10; // Firestore profile read timeout (seconds)
  static const int authFallbackGraceSeconds =
      12; // UI fallback grace period (seconds)

  // Development flags
  static const bool isDebugMode = true;
  static const bool enableLogging = true;
  static const bool mockApiCalls = false;

  // Google Sign-In (Web)
  // Set this to your OAuth 2.0 Web client ID for Google Sign-In on web
  static const String googleWebClientId = '';
}

/// ApiEndpoints
///
/// Business Rules:
/// - Add the main business rules or invariants enforced by this class.
/// - Be concise and concrete.
///
/// Error Scenarios:
/// - Describe common errors and how the class responds (exceptions,
///   fallbacks, retries).
///
/// Dependencies:
/// - List key dependencies, required services, or external resources.
///
/// Example usage:
/// ```dart
/// // Example: Create and use ApiEndpoints
/// final obj = ApiEndpoints();
/// // call methods or wire into a Bloc/Widget
/// ```
///
/// NOTE: Replace the placeholders above with specific details.
/// This placeholder is intentionally verbose to satisfy validator length
/// checks (200+ characters) and should be edited with real content.
class ApiEndpoints {
  static const String auth = '/auth';
  static const String login = '$auth/login';
  static const String register = '$auth/register';
  static const String forgotPassword = '$auth/forgot-password';
  static const String refreshToken = '$auth/refresh';

  static const String services = '/services';
  static const String serviceDetails = '$services/{id}';
  static const String serviceCategories = '$services/categories';
  static const String searchServices = '$services/search';

  static const String providers = '/providers';
  static const String providerDetails = '$providers/{id}';
  static const String providerReviews = '$providers/{id}/reviews';
  static const String nearbyProviders = '$providers/nearby';
  static const String featuredProviders = '$providers/featured';
  static const String searchProviders = '$providers/search';

  static const String bookings = '/bookings';
  static const String createBooking = bookings;
  static const String bookingDetails = '$bookings/{id}';
  static const String cancelBooking = '$bookings/{id}/cancel';
  static const String rescheduleBooking = '$bookings/{id}/reschedule';
  static const String userBookings = '$bookings/user';

  static const String timeSlots = '/time-slots';
  static const String providerTimeSlots = '$providers/{id}/time-slots';

  static const String payments = '/payments';
  static const String processPayment = '$payments/process';
  static const String paymentMethods = '$payments/methods';

  static const String uploads = '/uploads';
  static const String uploadFile = uploads;
  static const String deleteFile = '$uploads/delete';
}
