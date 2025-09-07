/// Application-wide constants for the Fix It home services app.
/// 
/// This class contains all constant values used throughout the application,
/// including API configurations, storage keys, UI dimensions, error messages,
/// and validation patterns. All constants are organized by category for easy
/// maintenance and discovery.
/// 
/// Example usage:
/// ```dart
/// String appName = AppConstants.appName;
/// Duration animationDuration = AppConstants.shortAnimationDuration;
/// ```
class AppConstants {
  // Private constructor to prevent instantiation
  AppConstants._();

  // ═══════════════════════════════════════════════════════════════════════════
  // App Information
  // ═══════════════════════════════════════════════════════════════════════════

  /// The display name of the application
  static const String appName = 'Fix It';

  // ═══════════════════════════════════════════════════════════════════════════
  // API Configuration
  // ═══════════════════════════════════════════════════════════════════════════

  /// Base URL for all REST API endpoints
  /// 
  /// Used by [ApiClient] to construct full endpoint URLs for HTTP requests
  /// to the Fix It backend services.
  static const String baseUrl = 'https://api.fixit.com/api/v1';

  /// API version identifier
  /// 
  /// Used for API versioning and backward compatibility management.
  static const String apiVersion = 'v1';

  // ═══════════════════════════════════════════════════════════════════════════
  // Local Storage Keys
  // ═══════════════════════════════════════════════════════════════════════════

  /// Key for storing authentication token in secure storage
  /// 
  /// Used with [FlutterSecureStorage] to persist user authentication tokens
  /// across app sessions.
  static const String authTokenKey = 'auth_token';

  /// Key for storing user data in local storage
  /// 
  /// Used with [SharedPreferences] to cache user profile information
  /// for offline access and quick loading.
  static const String userDataKey = 'user_data';

  /// Key for storing selected language preference
  /// 
  /// Used to persist user's language selection for app localization.
  static const String languageKey = 'language';

  /// Key for storing theme preference
  /// 
  /// Used to persist user's theme selection (light/dark mode).
  static const String themeKey = 'theme';

  /// Key for tracking onboarding completion status
  /// 
  /// Used to determine whether to show the onboarding flow to new users.
  static const String onboardingKey = 'onboarding_completed';

  // ═══════════════════════════════════════════════════════════════════════════
  // Network Timeouts
  // ═══════════════════════════════════════════════════════════════════════════

  /// Timeout duration for establishing HTTP connections (30 seconds)
  /// 
  /// Used by [Dio] client to set the maximum time allowed for establishing
  /// a connection to the server.
  static const int connectionTimeout = 30000; // 30 seconds

  /// Timeout duration for receiving HTTP responses (30 seconds)
  /// 
  /// Used by [Dio] client to set the maximum time allowed for receiving
  /// data from the server after connection is established.
  static const int receiveTimeout = 30000; // 30 seconds

  // ═══════════════════════════════════════════════════════════════════════════
  // Pagination Configuration
  // ═══════════════════════════════════════════════════════════════════════════

  /// Default number of items to load per page
  /// 
  /// Used for paginated lists of services, bookings, reviews, etc.
  /// Balances performance and user experience.
  static const int defaultPageSize = 20;

  // ═══════════════════════════════════════════════════════════════════════════
  // Service Categories
  // ═══════════════════════════════════════════════════════════════════════════

  /// List of available service categories in the Fix It app
  /// 
  /// These categories are used for:
  /// - Service filtering and search
  /// - Provider specialization selection
  /// - Service catalog organization
  /// - Category-based UI navigation
  static const List<String> serviceCategories = [
    'plumbing',        // Plumbing repairs, installations, maintenance
    'electrical',      // Electrical wiring, fixtures, troubleshooting
    'cleaning',        // Home, office, deep cleaning services
    'painting',        // Interior, exterior painting, touch-ups
    'carpentry',       // Furniture assembly, repairs, installations
    'appliance_repair', // Kitchen, laundry, HVAC appliance repairs
    'hvac',           // Heating, ventilation, air conditioning
    'gardening',      // Landscaping, maintenance, plant care
  ];

  // ═══════════════════════════════════════════════════════════════════════════
  // Booking Status Constants
  // ═══════════════════════════════════════════════════════════════════════════

  /// Booking is created but awaiting provider confirmation
  static const String bookingStatusPending = 'pending';

  /// Booking has been confirmed by the provider
  static const String bookingStatusConfirmed = 'confirmed';

  /// Service is currently being performed
  static const String bookingStatusInProgress = 'in_progress';

  /// Service has been completed successfully
  static const String bookingStatusCompleted = 'completed';

  /// Booking has been cancelled by customer or provider
  static const String bookingStatusCancelled = 'cancelled';

  // ═══════════════════════════════════════════════════════════════════════════
  // User Type Constants
  // ═══════════════════════════════════════════════════════════════════════════

  /// User type for customers who book services
  static const String userTypeClient = 'client';

  /// User type for service providers who offer services
  static const String userTypeProvider = 'provider';

  // ═══════════════════════════════════════════════════════════════════════════
  // Payment Method Constants
  // ═══════════════════════════════════════════════════════════════════════════

  /// Cash payment option
  static const String paymentMethodCash = 'cash';

  /// Credit/debit card payment via Stripe
  static const String paymentMethodCard = 'card';

  /// Digital wallet payment option
  static const String paymentMethodWallet = 'wallet';

  // ═══════════════════════════════════════════════════════════════════════════
  // Error Messages (Arabic)
  // ═══════════════════════════════════════════════════════════════════════════

  /// Generic error message for unexpected errors
  /// 
  /// Displayed when an unhandled exception occurs or when the specific
  /// error type cannot be determined.
  static const String genericErrorMessage = 'حدث خطأ غير متوقع. يرجى المحاولة مرة أخرى.';

  /// Error message for network connectivity issues
  /// 
  /// Displayed when the device has no internet connection or cannot
  /// reach the server.
  static const String networkErrorMessage = 'لا يوجد اتصال بالإنترنت. يرجى التحقق من الاتصال والمحاولة مرة أخرى.';

  /// Error message for server-side errors (5xx HTTP status codes)
  /// 
  /// Displayed when the server encounters an internal error.
  static const String serverErrorMessage = 'خطأ في الخادم. يرجى المحاولة لاحقاً.';

  /// Error message for authentication/authorization failures
  /// 
  /// Displayed when the user's session has expired or authentication
  /// credentials are invalid.
  static const String authErrorMessage = 'انتهت صلاحية الجلسة. يرجى تسجيل الدخول مرة أخرى.';

  // ═══════════════════════════════════════════════════════════════════════════
  // Success Messages (Arabic)
  // ═══════════════════════════════════════════════════════════════════════════

  /// Success message for user sign-in
  static const String signInSuccessMessage = 'تم تسجيل الدخول بنجاح';

  /// Success message for user account creation
  static const String signUpSuccessMessage = 'تم إنشاء الحساب بنجاح';

  /// Success message for booking creation
  static const String bookingCreatedMessage = 'تم إنشاء الحجز بنجاح';

  /// Success message for profile updates
  static const String profileUpdatedMessage = 'تم تحديث الملف الشخصي بنجاح';

  // ═══════════════════════════════════════════════════════════════════════════
  // Validation Messages (Arabic)
  // ═══════════════════════════════════════════════════════════════════════════

  /// Validation error for invalid email format
  static const String emailValidationMessage = 'يرجى إدخال بريد إلكتروني صحيح';

  /// Validation error for weak passwords
  /// 
  /// Displayed when password doesn't meet minimum security requirements.
  static const String passwordValidationMessage = 'كلمة المرور يجب أن تكون 8 أحرف على الأقل';

  /// Validation error for empty name fields
  static const String nameValidationMessage = 'يرجى إدخال الاسم';

  /// Validation error for invalid phone number format
  static const String phoneValidationMessage = 'يرجى إدخال رقم هاتف صحيح';

  // ═══════════════════════════════════════════════════════════════════════════
  // Regular Expression Patterns
  // ═══════════════════════════════════════════════════════════════════════════

  /// Regular expression pattern for email validation
  /// 
  /// Validates email format according to RFC 5322 standard.
  /// Supports most common email formats including:
  /// - user@domain.com
  /// - user.name@domain.co.uk
  /// - user+tag@domain.org
  static const String emailPattern = r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';

  /// Regular expression pattern for phone number validation
  /// 
  /// Accepts phone numbers with 10-15 digits (international format).
  /// Examples: 1234567890, 123456789012345
  static const String phonePattern = r'^[0-9]{10,15}$';

  // ═══════════════════════════════════════════════════════════════════════════
  // Animation Durations
  // ═══════════════════════════════════════════════════════════════════════════

  /// Short animation duration for quick transitions
  /// 
  /// Used for:
  /// - Button press animations
  /// - Small UI element transitions
  /// - Quick fade in/out effects
  static const Duration shortAnimationDuration = Duration(milliseconds: 200);

  /// Medium animation duration for standard transitions
  /// 
  /// Used for:
  /// - Page transitions
  /// - Modal dialog animations
  /// - Card flip animations
  static const Duration mediumAnimationDuration = Duration(milliseconds: 300);

  /// Long animation duration for complex transitions
  /// 
  /// Used for:
  /// - Full-screen transitions
  /// - Complex layout changes
  /// - Loading animations
  static const Duration longAnimationDuration = Duration(milliseconds: 500);

  // ═══════════════════════════════════════════════════════════════════════════
  // UI Layout Constants
  // ═══════════════════════════════════════════════════════════════════════════

  /// Standard padding value used throughout the app
  /// 
  /// Applied to:
  /// - Screen margins
  /// - Card content padding
  /// - Form field spacing
  static const double defaultPadding = 16.0;

  /// Large padding for sections requiring more spacing
  /// 
  /// Applied to:
  /// - Section headers
  /// - Important content blocks
  /// - Top-level containers
  static const double largePadding = 24.0;

  /// Small padding for compact layouts
  /// 
  /// Applied to:
  /// - List item internal spacing
  /// - Chip margins
  /// - Compact UI elements
  static const double smallPadding = 8.0;

  /// Default border radius for rounded UI elements
  /// 
  /// Applied to:
  /// - Buttons
  /// - Cards
  /// - Input fields
  /// - Modal dialogs
  static const double defaultBorderRadius = 12.0;

  /// Standard elevation for cards and floating elements
  /// 
  /// Provides subtle shadow depth for Material Design components.
  /// Used for cards, FABs, and elevated buttons.
  static const double cardElevation = 2.0;

  // ═══════════════════════════════════════════════════════════════════════════
  // Asset Paths
  // ═══════════════════════════════════════════════════════════════════════════

  /// Path to the application logo image
  /// 
  /// Used in splash screen, app bar, and branding elements.
  static const String logoPath = 'assets/images/logo.png';

  /// Path to the welcome screen illustration
  /// 
  /// Displayed on the welcome/onboarding screen.
  static const String welcomeImagePath = 'assets/images/welcome.png';

  /// Path to placeholder image for missing content
  /// 
  /// Used when profile pictures, service images, or other content
  /// fails to load or is not available.
  static const String placeholderImagePath = 'assets/images/placeholder.png';
}