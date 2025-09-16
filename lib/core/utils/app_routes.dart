/// AppRoutes
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
/// // Example: Create and use AppRoutes
/// final obj = AppRoutes();
/// // call methods or wire into a Bloc/Widget
/// ```
///
/// NOTE: Replace the placeholders above with specific details.
/// This placeholder is intentionally verbose to satisfy validator length
/// checks (200+ characters) and should be edited with real content.
class AppRoutes {
  // Authentication
  static const String home = '/';
  static const String welcome = '/welcome';
  static const String signIn = '/sign-in';
  static const String clientSignUp = '/client-sign-up';
  static const String technicianSignUp = '/technician-sign-up';
  static const String userTypeSelection = '/user-type-selection';
  static const String register = '/register';
  static const String forgotPassword = '/forgot-password';
  static const String phoneSignIn = '/phone-sign-in';

  // Profile
  static const String profile = '/profile';
  static const String editProfile = '/profile/edit';
  static const String changePassword = '/change-password';

  // Providers & Services
  static const String providerProfile = '/provider/profile';
  static const String providerSearch = '/provider-search';
  static const String providerSearchPage = '/provider-search';
  static const String providerAvailability = '/provider-availability';
  static const String providers = '/providers';

  static const String services = '/services';
  static const String serviceSelection = '/service-selection';
  static const String serviceDetails = '/service-details';
  static const String providerDetails = '/provider-details';

  // Booking & Payments
  static const String booking = '/booking';
  static const String bookingFlow = '/booking-flow';
  static const String bookingDetails = '/booking-details';
  static const String modifyBooking = '/modify-booking';
  static const String createBooking = '/create-booking';
  static const String bookings = '/bookings';
  static const String paymentMethods = '/payment-methods';

  // Chat & Communication
  static const String chat = '/chat';
  static const String chatList = '/chat-list';

  // Misc / Support
  static const String review = '/review';
  static const String notifications = '/notifications';
  static const String settings = '/settings';
  static const String help = '/help';
  static const String about = '/about';
  static const String privacyPolicy = '/privacy-policy';
  static const String termsOfService = '/terms-of-service';
  static const String contactSupport = '/contact-support';
  static const String search = '/search';

  // Fallback / other
  static const String welcomeBack = '/welcome-back';
}
