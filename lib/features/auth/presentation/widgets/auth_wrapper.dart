import 'dart:async';
import 'package:fix_it/core/services/auth_service.dart';
import '../../../../app_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:fix_it/core/di/injection_container.dart' as di;
import 'package:fix_it/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:fix_it/features/auth/presentation/pages/welcome_screen.dart';
import 'package:fix_it/features/home/presentation/pages/main_dashboard.dart';

/// AuthWrapper handles authentication state management and navigation
///
/// Business Rules:
///  - Acts as the app's top-level auth gate: it checks authentication on
///    startup and routes to the dashboard or welcome screen accordingly.
///  - Implements a small fallback grace period: if authentication remains
///    unresolved the UI falls back to the `WelcomeScreen` to avoid blocking
///    the user on app startup.
///  - Any auth-related errors should fall back to unauthenticated/welcome
///    flows so the app remains usable in degraded environments.
///
/// This widget serves as the root authentication state manager that:
/// - Checks authentication status on app start
/// - Routes to appropriate screens based on auth state
/// - Provides authentication bloc to the widget tree
class AuthWrapper extends StatefulWidget {
  const AuthWrapper({super.key});

  @override
  State<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  // Grace period before forcing a fallback UI when auth is still loading
  static final Duration _gracePeriod =
      Duration(seconds: AppConfig.authFallbackGraceSeconds);
  Timer? _fallbackTimer;

  @override

  /// initState
  ///
  /// Initialize short-lived resources used by this widget. Avoid heavy IO
  /// here; the [AuthBloc] performs network/database work. Starts the
  /// fallback timer when the widget is inserted in the tree.
  @override
/// initState
///
/// Description: Briefly explain what this method does.
///
/// Parameters:
/// - (describe parameters)
///
/// Returns:
/// - (describe return value)
  void initState() {
    super.initState();
  }

  @override

  /// dispose
  ///
  /// Description:
  /// - Cancels any active fallback timer and disposes of local resources.
  /// - Does not close the [AuthBloc] since it is provided higher in the tree
  ///   and managed by the DI container.
  ///
  /// Parameters: None.
  ///
  /// Returns: void.
  void dispose() {
    _fallbackTimer?.cancel();
    super.dispose();
  }

  void _startFallbackTimer(BuildContext context) {
    _fallbackTimer?.cancel();
    _fallbackTimer = Timer(_gracePeriod, () {
      final authState = context.read<AuthBloc>().state;
      if (authState is AuthInitial || authState is AuthLoading) {
        // If still loading after the grace period, show a brief snackbar
        // to inform the user and navigate to WelcomeScreen as a fallback.
        // ignore: avoid_print
        print('AuthWrapper: fallback timer fired (state=$authState)');
        if (mounted) {
          // Try to show a SnackBar if possible
          try {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text(
                    'Unable to complete automatic sign-in. Showing welcome screen.'),
                duration: Duration(seconds: 3),
              ),
            );
          } catch (_) {
            // Fall back silently if no ScaffoldMessenger is available.
          }

          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (_) => const WelcomeScreen()),
            (route) => false,
          );
        }
      }
    });
  }

  @override

  /// build
  ///
  /// Description:
  /// - Builds the authentication wrapper UI and provides an [AuthBloc]
  ///   to its subtree. The widget listens to [AuthState] and routes to
  ///   the appropriate screen (authenticated dashboard, welcome screen,
  ///   or a loading UI while authentication is in progress).
  ///
  /// Parameters:
  /// - [context]: Build context provided by Flutter framework.
  ///
  /// Returns:
  /// - A [Widget] that acts as the top-level authentication router.
  Widget build(BuildContext context) {
    return BlocProvider<AuthBloc>(
      create: (context) {
        try {
          final bloc = di.sl<AuthBloc>();
          bloc.add(AppStartedEvent());
          return bloc;
        } catch (e) {
          // Return a default bloc that will show the welcome screen
          return AuthBloc(authService: di.sl<AuthService>())
            ..add(AppStartedEvent());
        }
      },
      child: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          // Debug: print auth state changes to help diagnose startup hangs
          // ignore: avoid_print
          print('AuthWrapper: current auth state -> $state');

          // Start or cancel fallback timer depending on auth state
          if (state is AuthInitial || state is AuthLoading) {
            _startFallbackTimer(context);
          } else {
            _fallbackTimer?.cancel();
          }

          // Handle any unexpected states
          if (state is! AuthInitial &&
              state is! AuthLoading &&
              state is! AuthAuthenticated &&
              state is! AuthUnauthenticated &&
              state is! AuthError) {
            return const WelcomeScreen();
          }

          // Show loading screen while checking authentication
          if (state is AuthInitial || state is AuthLoading) {
            return Scaffold(
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const CircularProgressIndicator(),
                    const SizedBox(height: 16),
                    Text(
                      'Loading... (state: ${state.runtimeType})',
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          // Handle navigation based on auth state
          if (state is AuthAuthenticated) {
            // User is authenticated, show main dashboard
            return const MainDashboard();
          } else if (state is AuthUnauthenticated) {
            // User is not authenticated, show welcome screen
            return const WelcomeScreen();
          } else if (state is AuthError) {
            // Show welcome screen on error
            return const WelcomeScreen();
          } else {
            // Default case, show welcome screen
            return const WelcomeScreen();
          }
        },
      ),
    );
  }
}
