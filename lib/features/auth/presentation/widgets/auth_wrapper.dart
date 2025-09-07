import 'package:fix_it/core/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:fix_it/core/di/injection_container.dart' as di;
import 'package:fix_it/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:fix_it/features/auth/presentation/pages/welcome_screen.dart';
import 'package:fix_it/features/home/presentation/pages/main_dashboard.dart';

/// AuthWrapper handles authentication state management and navigation
///
/// This widget serves as the root authentication state manager that:
/// - Checks authentication status on app start
/// - Routes to appropriate screens based on auth state
/// - Provides authentication bloc to the widget tree
class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AuthBloc>(
      create: (context) {
        try {
          final bloc = di.sl<AuthBloc>();
          bloc.add(AppStartedEvent());
          return bloc;
        } catch (e) {
          // Return a default bloc that will show the welcome screen
          return AuthBloc(authService: di.sl<AuthService>())..add( AppStartedEvent());
        }
      },
      child: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          
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
                      'Loading...',
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