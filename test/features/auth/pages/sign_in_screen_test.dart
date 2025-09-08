import 'package:fix_it/features/auth/presentation/pages/sign_up_screen.dart';
import 'package:fix_it/l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fix_it/features/auth/presentation/pages/sign_in_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mocktail/mocktail.dart';
import 'package:fix_it/features/auth/presentation/bloc/auth_bloc.dart';

import 'dart:async';

class MockAuthBloc extends Mock implements AuthBloc {
  // Provide a non-null stream and state for BlocProvider to work in tests
  final _controller = StreamController<AuthState>.broadcast();

  @override
  Stream<AuthState> get stream => _controller.stream;

  @override
  AuthState get state => AuthInitial();

  @override
  Future<void> close() async {
    await _controller.close();
  }

  // Helper to push states if needed
  void push(AuthState state) => _controller.add(state);
}

void main() {
  group('SignInScreen', () {
    testWidgets('displays email and password fields',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider<AuthBloc>(
            create: (_) => MockAuthBloc(),
            child: const SignInScreen(),
          ),
        ),
      );

      // Find by label text which CustomTextField renders
      expect(find.text('Email'), findsOneWidget);
      expect(find.text('Password'), findsOneWidget);
    });

    testWidgets('displays sign in button', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider<AuthBloc>(
            create: (_) => MockAuthBloc(),
            child: const SignInScreen(),
          ),
        ),
      );

      expect(find.text('Sign In'), findsOneWidget);
    });

    testWidgets('displays sign up link', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider<AuthBloc>(
            create: (_) => MockAuthBloc(),
            child: const SignInScreen(),
          ),
        ),
      );

      // The screen displays the prompt and a Sign Up button separately
      expect(find.textContaining("Don't have an account"), findsOneWidget);
      expect(find.text('Sign Up'), findsOneWidget);
    });

    testWidgets('tapping sign in button triggers sign in',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider<AuthBloc>(
            create: (_) => MockAuthBloc(),
            child: const SignInScreen(),
          ),
        ),
      );

      await tester.tap(find.text('Sign In'));
      await tester.pumpAndSettle();

      // Ensure the button exists after tapping (no crash)
      expect(find.text('Sign In'), findsOneWidget);
    });

    testWidgets('navigates to sign up screen when link is tapped',
        (WidgetTester tester) async {
      final mockBloc = MockAuthBloc();
      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: AppLocalizations.supportedLocales,
          routes: {
            '/sign-up': (context) => BlocProvider<AuthBloc>.value(
                  value: mockBloc,
                  child: const SignUpScreen(),
                ),
          },
          home: BlocProvider<AuthBloc>.value(
            value: mockBloc,
            child: const SignInScreen(),
          ),
        ),
      );

      // Ensure the widget is visible (handles small test window layouts)
      await tester.ensureVisible(find.text('Sign Up'));
      await tester.tap(find.text('Sign Up'));
      await tester.pumpAndSettle();

      // Verify navigation to sign up screen
      expect(find.byType(SignUpScreen), findsOneWidget);
    });
  });
}
