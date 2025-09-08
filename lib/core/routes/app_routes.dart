import 'package:fix_it/features/notifications/presentation/bloc/notifications_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// Import commonly used screens so routes return concrete pages instead of a
// placeholder that prints "Arguments: none".
import 'package:fix_it/core/di/injection_container.dart' as di;
import 'package:fix_it/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:fix_it/features/auth/presentation/pages/welcome_screen.dart';
import 'package:fix_it/features/auth/presentation/pages/sign_in_screen.dart';
import 'package:fix_it/features/auth/presentation/pages/sign_up_screen.dart';
import 'package:fix_it/features/auth/presentation/pages/forgot_password_screen.dart';
import 'package:fix_it/features/auth/presentation/pages/phone_sign_in_screen.dart';
import 'package:fix_it/features/auth/presentation/pages/user_type_selection_screen.dart';
import 'package:fix_it/features/home/presentation/pages/main_dashboard.dart';
import 'package:fix_it/features/booking/presentation/pages/create_booking_screen.dart';
import 'package:fix_it/features/booking/presentation/pages/bookings_screen.dart';
import 'package:fix_it/features/booking/presentation/pages/booking_details_screen.dart';
import 'package:fix_it/features/booking/presentation/pages/modify_booking_screen.dart';
import 'package:fix_it/features/providers/presentation/pages/provider_details_screen.dart';
import 'package:fix_it/features/services/presentation/pages/service_details_screen.dart';
// Profile & misc pages
import 'package:fix_it/features/profile/presentation/pages/profile_screen.dart';
import 'package:fix_it/features/profile/presentation/pages/edit_profile_screen.dart';
import 'package:fix_it/features/profile/presentation/pages/change_password_screen.dart';
import 'package:fix_it/features/profile/presentation/bloc/user_profile_bloc/user_profile_bloc.dart';
import 'package:fix_it/features/profile/presentation/bloc/change_password_bloc/change_password_bloc.dart';
import 'package:fix_it/features/payment/presentation/pages/payment_methods_screen.dart';
import 'package:fix_it/features/payment/presentation/bloc/payment_methods_bloc/payment_methods_bloc.dart';
import 'package:fix_it/features/notifications/presentation/pages/notifications_screen.dart';
// profile-level settings screen import removed; use app-level settings screen instead
// App-level settings pages and bloc
import 'package:fix_it/features/settings/presentation/pages/settings_screen.dart'
    as app_settings_pages;
import 'package:fix_it/features/settings/presentation/bloc/settings_bloc/settings_bloc.dart'
    as app_settings_bloc;
import 'package:fix_it/features/help_support/presentation/pages/help_screen.dart';
import 'package:fix_it/features/help_support/presentation/pages/about_screen.dart';
import 'package:fix_it/features/help_support/presentation/bloc/about_bloc/about_bloc.dart';
import 'package:fix_it/features/help_support/presentation/pages/privacy_policy_screen.dart';
import 'package:fix_it/features/help_support/presentation/pages/terms_of_service_screen.dart';
import 'package:fix_it/features/help_support/presentation/pages/contact_support_screen.dart';

/// AppRoutes: small, incremental route helper improvements.
/// - Keeps route name/arguments preserved on created routes
/// - Provides a small typed-args helper for safe casting
class AppRoutes {
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    final name = settings.name ?? 'unknown';

    // Map known route names to their concrete pages. Leave an informative
    // fallback for truly unknown routes.
    switch (name) {
      case '/':
      case '/welcome':
        return _buildRoute(settings, (context) => const WelcomeScreen());
      case '/sign-in':
        return _buildRoute(
            settings,
            (context) => BlocProvider<AuthBloc>(
                  create: (context) => di.sl<AuthBloc>(),
                  child: const SignInScreen(),
                ));
      case '/sign_in':
        return _buildRoute(
            settings,
            (context) => BlocProvider<AuthBloc>(
                  create: (context) => di.sl<AuthBloc>(),
                  child: const SignInScreen(),
                ));
      case '/sign-up':
      case '/client-sign-up':
      case '/technician-sign-up':
        return _buildRoute(
            settings,
            (context) => BlocProvider<AuthBloc>(
                  create: (context) => di.sl<AuthBloc>(),
                  child: const SignUpScreen(),
                ));
      case '/user-type-selection':
        return _buildRoute(
            settings, (context) => const UserTypeSelectionScreen());
      case '/forgot_password':
      case '/forgot-password':
        return _buildRoute(
            settings,
            (context) => BlocProvider<AuthBloc>(
                  create: (context) => di.sl<AuthBloc>(),
                  child: const ForgotPasswordScreen(),
                ));
      case '/phone_sign_in':
      case '/phone-sign-in':
        return _buildRoute(
            settings,
            (context) => BlocProvider<AuthBloc>(
                  create: (context) => di.sl<AuthBloc>(),
                  child: const PhoneSignInScreen(),
                ));
      case '/dashboard':
      case '/home':
        return _buildRoute(settings, (context) => const MainDashboard());
      case '/create-booking':
      case '/booking-flow':
        return _buildRoute(settings, (context) => const CreateBookingScreen());
      // Profile & settings
      case '/profile':
        return _buildRoute(settings, (context) => const ProfileScreen());
      case '/profile/edit':
        // Provide a fresh UserProfileBloc instance for the edit screen via DI.
        final editBloc = di.sl<UserProfileBloc>();
        return _buildRoute(
            settings,
            (context) => BlocProvider<UserProfileBloc>(
                  create: (context) => editBloc,
                  child: EditProfileScreen(bloc: editBloc),
                ));
      case '/change-password':
        // ChangePasswordBloc is lightweight and not registered in DI; provide a fresh instance.
        return _buildRoute(
            settings,
            (context) => BlocProvider<ChangePasswordBloc>(
                  create: (context) => ChangePasswordBloc(),
                  child: const ChangePasswordScreen(),
                ));
      case '/payment-methods':
        return _buildRoute(
            settings,
            (context) => BlocProvider<PaymentMethodsBloc>(
                  create: (context) => di.sl<PaymentMethodsBloc>(),
                  child: const PaymentMethodsScreen(),
                ));
      case '/notifications':
        return _buildRoute(
            settings,
            (context) => BlocProvider<NotificationsBloc>(
                  create: (context) => di.sl<NotificationsBloc>(),
                  child: const NotificationsScreen(),
                ));
      case '/settings':
        // Provide the app-level SettingsBloc so AppSettingsScreen can access it
        return _buildRoute(
            settings,
            (context) => BlocProvider<app_settings_bloc.SettingsBloc>(
                  create: (context) => di.sl<app_settings_bloc.SettingsBloc>(),
                  child: const app_settings_pages.AppSettingsScreen(),
                ));
      case '/help':
        return _buildRoute(settings, (context) => const HelpScreen());
      case '/about':
        return _buildRoute(
            settings,
            (context) => BlocProvider<AboutBloc>(
                  create: (context) => AboutBloc()..add(LoadAboutInfoEvent()),
                  child: const AboutScreen(),
                ));
      case '/privacy-policy':
        return _buildRoute(settings, (context) => const PrivacyPolicyScreen());
      case '/terms-of-service':
        return _buildRoute(settings, (context) => const TermsOfServiceScreen());
      case '/contact-support':
        return _buildRoute(settings, (context) => const ContactSupportScreen());
      case '/bookings':
        return _buildRoute(settings, (context) => const BookingsScreen());
      case '/booking-details':
        final args = argsAs<Map<String, dynamic>>(settings);
        final bookingId = args != null && args['bookingId'] is String
            ? args['bookingId'] as String
            : null;
        if (bookingId == null) {
          return _buildRoute(
              settings,
              (context) => Scaffold(
                    appBar: AppBar(title: const Text('Booking')),
                    body: const Center(child: Text('Missing bookingId')),
                  ));
        }
        return _buildRoute(
            settings, (context) => BookingDetailsScreen(bookingId: bookingId));
      case '/provider-details':
      case '/provider/profile':
        final pArgs = argsAs<Map<String, dynamic>>(settings);
        final providerId = pArgs != null && pArgs['providerId'] is String
            ? pArgs['providerId'] as String
            : null;
        if (providerId == null) {
          return _buildRoute(
              settings,
              (context) => Scaffold(
                    appBar: AppBar(title: const Text('Provider')),
                    body: const Center(child: Text('Missing providerId')),
                  ));
        }
        return _buildRoute(settings,
            (context) => ProviderDetailsScreen(providerId: providerId));
      case '/service-details':
        final sArgs = argsAs<Map<String, dynamic>>(settings);
        final serviceId = sArgs != null && sArgs['serviceId'] is String
            ? sArgs['serviceId'] as String
            : null;
        if (serviceId == null) {
          return _buildRoute(
              settings,
              (context) => Scaffold(
                    appBar: AppBar(title: const Text('Service')),
                    body: const Center(child: Text('Missing serviceId')),
                  ));
        }
        return _buildRoute(
            settings, (context) => ServiceDetailsScreen(serviceId: serviceId));
      case '/modify-booking':
        final mArgs = argsAs<Map<String, dynamic>>(settings);
        final bookingId = mArgs != null && mArgs['bookingId'] is String
            ? mArgs['bookingId'] as String
            : null;
        if (bookingId == null) {
          return _buildRoute(
              settings,
              (context) => Scaffold(
                    appBar: AppBar(title: const Text('Modify Booking')),
                    body: const Center(child: Text('Missing bookingId')),
                  ));
        }
        return _buildRoute(
            settings, (context) => ModifyBookingScreen(bookingId: bookingId));
      default:
        // Fallback: avoid displaying raw `arguments` to users. Log for debugging
        // and show a friendly 'route not found' screen instead.
        final args = settings.arguments;
        // Keep a debug log so developers can inspect unexpected args during testing.
        // This is intentionally not shown in the UI to avoid leaking internal data.
        // ignore: avoid_print
        debugPrint('Unknown route "$name" called with arguments: $args');

        return _buildRoute(settings, (context) {
          return Scaffold(
            appBar: AppBar(title: Text('Route: $name')),
            body: Center(
              child: Text(
                'No page found for this route',
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
          );
        });
    }
  }

  // Helper that preserves the incoming RouteSettings on the created route.
  static MaterialPageRoute _buildRoute(
      RouteSettings settings, WidgetBuilder builder) {
    return MaterialPageRoute(settings: settings, builder: builder);
  }

  // Small typed args extractor: returns null if the arguments are absent or
  // not of the requested type T.
  static T? argsAs<T>(RouteSettings settings) {
    if (settings.arguments == null) return null;
    if (settings.arguments is T) return settings.arguments as T;
    return null;
  }
}
// class _BookingSuccessScreen extends StatelessWidget {
//   final String bookingId;

//   const _BookingSuccessScreen({required this.bookingId});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             const Icon(
//               Icons.check_circle,
//               size: 100,
//               color: Colors.green,
//             ),
//             const SizedBox(height: 20),
//             const Text(
//               'Booking Successful!',
//               style: TextStyle(
//                 fontSize: 24,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//             const SizedBox(height: 10),
//             Text('Booking ID: $bookingId'),
//             const SizedBox(height: 30),
//             ElevatedButton(
//               onPressed: () {
//                 Navigator.pushNamedAndRemoveUntil(
//                   context,
//                   AppRoutes.bookings,
//                   (route) => false,
//                 );
//               },
//               child: const Text('View My Bookings'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
