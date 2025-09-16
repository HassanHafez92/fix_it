// ignore_for_file: avoid_print

import 'package:firebase_core/firebase_core.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'dart:ui' as ui;
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/di/injection_container.dart' as di;
import 'core/bloc/locale_bloc.dart';
import 'core/bloc/theme_cubit.dart';
import 'core/routes/app_routes.dart';
import 'core/theme/app_theme.dart';
import 'core/services/location_service.dart';
import 'core/services/payment_service.dart';
import 'core/services/analytics_service.dart';
import 'core/services/notification_service.dart';

import 'app_config.dart';
import 'features/auth/presentation/pages/welcome_screen.dart';
import 'features/auth/presentation/widgets/auth_wrapper.dart';
import 'firebase_options.dart';

// Simple Bloc observer to help debug Bloc events/state changes at runtime
/// SimpleBlocObserver
///
/// Business Rules:
/// - Record Bloc lifecycle events for debugging; avoid logging sensitive data.
/// - Keep observer lightweight to not affect runtime performance.
///
/// Dependencies:
/// - Assumes Blocs are registered and functioning within the app DI.
///
/// Error scenarios:
/// - Observer should not throw; errors are logged and swallowed to not
///   disrupt Bloc processing.

class SimpleBlocObserver extends BlocObserver {
  /// onEvent
  ///
  /// Description: Briefly explain what this method does.
  ///
  /// Parameters:
  /// - (describe parameters)
  ///
  /// Returns:
  /// - (describe return value)

  @override
/// onEvent
///
/// Description: Briefly explain what this method does.
///
/// Parameters:
/// - (describe parameters)
///
/// Returns:
/// - (describe return value)
  void onEvent(Bloc bloc, Object? event) {
    super.onEvent(bloc, event);
    print('BLOC EVENT: ${bloc.runtimeType} -> $event');
  }

  /// onChange
  ///
  /// Description: Briefly explain what this method does.
  ///
  /// Parameters:
  /// - (describe parameters)
  ///
  /// Returns:
  /// - (describe return value)

  @override
/// onChange
///
/// Description: Briefly explain what this method does.
///
/// Parameters:
/// - (describe parameters)
///
/// Returns:
/// - (describe return value)
  void onChange(BlocBase bloc, Change change) {
    super.onChange(bloc, change);
    print('BLOC CHANGE: ${bloc.runtimeType} -> $change');
  }

  /// onTransition
  ///
  /// Description: Briefly explain what this method does.
  ///
  /// Parameters:
  /// - (describe parameters)
  ///
  /// Returns:
  /// - (describe return value)

  @override
/// onTransition
///
/// Description: Briefly explain what this method does.
///
/// Parameters:
/// - (describe parameters)
///
/// Returns:
/// - (describe return value)
  void onTransition(Bloc bloc, Transition transition) {
    super.onTransition(bloc, transition);
    print('BLOC TRANSITION: ${bloc.runtimeType} -> $transition');
  }
}

/// Entry point for the Fix It home services application.
///
/// This function initializes all necessary services, configurations, and
/// dependencies before launching the main application. It ensures that
/// Firebase, dependency injection, location services, and UI preferences
/// are properly set up.
///
/// **Initialization Order:**
/// 1. Flutter widget binding
/// 2. Firebase initialization
/// 3. Dependency injection setup
/// 4. Core services initialization
/// 5. UI configuration (orientation, system UI)
/// 6. App launch
///
/// **Error Handling:**
/// If any critical service fails to initialize, the error is logged
/// but the app continues to launch to prevent complete failure.
///
/// Returns:
/// - A [Future] that completes when the app has finished launching.
Future<void> main() async {
  print('🚀 Starting Fix It app...');
  // Ensure Flutter framework is properly initialized before running async operations
  WidgetsFlutterBinding.ensureInitialized();
  print('✅ Flutter framework initialized');

  // Initialize Firebase with platform-specific configuration
  // This enables authentication, Firestore, storage, and other Firebase services
  try {
    print('🔥 Initializing Firebase...');
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    print('✅ Firebase initialized successfully');
  } catch (e) {
    print('❌ Firebase initialization failed: $e');
  }

  // Set up dependency injection container
  // This registers all repositories, use cases, blocs, and services
  try {
    print('🔧 Setting up dependency injection...');
    await di.init();
    print('✅ Dependency injection setup complete');
  } catch (e) {
    print('❌ Dependency injection setup failed: $e');
  }

  // NOTE: defer heavy, non-critical service initialization until after
  // the first frame is rendered. Running these before the first frame can
  // cause main-thread work that results in skipped frames on app launch.
  // We schedule initialization after runApp (see below).

  // Configure device orientation to portrait only
  // This ensures consistent UI layout across the app
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Configure system UI appearance
  // Sets status bar and navigation bar colors and icon brightness
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: Colors.white,
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
  );

  print('🚀 Launching Fix It app...');
  // Register a simple global Bloc observer to capture events and state changes
  Bloc.observer = SimpleBlocObserver();
  // Initialize EasyLocalization
  await EasyLocalization.ensureInitialized();

  // Launch the main application wrapped with EasyLocalization
  runApp(
    EasyLocalization(
      supportedLocales: const [Locale('en', 'US'), Locale('ar')],
      path: 'assets/translations',
      fallbackLocale: const Locale('en', 'US'),
      assetLoader: RootBundleAssetLoader(),
      saveLocale: false,
      useOnlyLangCode: true,
      startLocale: Locale('en'),
      child: const FixItApp(),
    ),
  );

  // Initialize non-critical services after the first frame to avoid blocking
  // the UI during app startup. This reduces skipped frames on slow devices.
  WidgetsBinding.instance.addPostFrameCallback((_) {
    final servicesStart = DateTime.now();
    _initializeServices().whenComplete(() {
      final servicesMs =
          DateTime.now().difference(servicesStart).inMilliseconds;
      print('🔧 _initializeServices completed (took ${servicesMs}ms)');
    });
  });
}

/// Initializes core services required by the application.
///
/// This function sets up essential services like location access and
/// payment processing. Services are initialized in a try-catch block
/// to prevent app crashes if individual services fail.
///
/// **Services Initialized:**
/// - Location services (with permission requests)
/// - Payment services (currently disabled due to compatibility)
///
/// **Error Handling:**
/// Individual service failures are logged but don't prevent app startup.
/// This ensures the app remains functional even if some services are unavailable.
Future<void> _initializeServices() async {
  print('🔧 Starting service initialization...');
  try {
    // Initialize payment service when enabled via AppConfig. PaymentService
    // itself is a no-op when `enableStripePayments` is false, so this call
    // is safe in dev.
    if (AppConfig.enableStripePayments) {
      try {
        final paymentService = di.sl<PaymentService>();
        await paymentService.initialize();
        print('✅ PaymentService initialized');
      } catch (e) {
        print('❌ PaymentService initialization error: $e');
      }
    }

    // Request location permissions from the user
    // This is required for provider discovery and address-based services
    print('📍 Requesting location permissions...');
    final locationService = di.sl<LocationService>();
    await locationService.requestLocationPermission();
    print('✅ Location permissions requested');

    // Initialize analytics service (lightweight) so hooks are ready
    try {
      await AnalyticsService().init();
      print('✅ AnalyticsService initialized');
    } catch (e) {
      print('⚠️ AnalyticsService init failed: $e');
    }

    // Initialize push notifications (FCM) if enabled in config
    if (AppConfig.enablePushNotifications) {
      try {
        final notificationService = di.sl<NotificationService>();
        await notificationService.init();
        print('✅ NotificationService initialized');
      } catch (e) {
        print('⚠️ NotificationService init failed: $e');
      }
    }

    print('✅ All services initialized successfully');
  } catch (e) {
    // Log initialization errors but continue app startup
    // This prevents complete app failure if a service fails to initialize
    print('❌ Error initializing services: $e');
  }
}

/// Main application widget for the Fix It app.
///
/// This widget sets up the root [MaterialApp] with all necessary configurations
/// including theme, localization, routing, and the initial screen. It serves
/// as the foundation for the entire application.
///
/// **Features Configured:**
/// - Material Design theming (light and dark modes)
/// - Internationalization support (English and Arabic)
/// - Navigation and routing system
/// - System-responsive theme mode
/// - Debug banner removal for production-ready appearance
///
/// **Routing:**
/// Uses [AppRoutes.onGenerateRoute] for centralized route management
/// and starts with [WelcomeScreen] as the initial route.
///
/// Business Rules:
/// - Initializes app-level services and wiring before UI is started.
/// - Preserves hybrid localization wiring: both generated-l10n and
///   easy_localization may be present and must be kept compatible.
///
/// Dependencies:
/// - Relies on DI container initialized in `di.init()` and services
///   registered via the injection container.
///
/// Error scenarios:
/// - Initialization failures are logged but do not abort app startup.

class FixItApp extends StatelessWidget {
  /// Creates the main Fix It application widget.
  const FixItApp({super.key});

  /// build
  ///
  /// Description: Briefly explain what this method does.
  ///
  /// Parameters:
  /// - (describe parameters)
  ///
  /// Returns:
  /// - (describe return value)

  @override
/// build
///
/// Description: Briefly explain what this method does.
///
/// Parameters:
/// - (describe parameters)
///
/// Returns:
/// - (describe return value)
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<LocaleBloc>(
          create: (context) =>
              di.sl<LocaleBloc>()..add(const LoadSavedLocaleEvent()),
        ),
        BlocProvider(
          create: (context) => di.sl<ThemeCubit>(),
        ),
      ],
      child: BlocBuilder<LocaleBloc, LocaleState>(
        builder: (context, localeState) {
          // Debug: log locale state at app root to verify updates
          print('Main: BlocBuilder localeState -> ${localeState.locale}');
          // Check if the locale is Arabic to apply RTL direction
          final isArabic = localeState.locale.languageCode == 'ar';
          // Apply text direction globally based on locale
          final textDirection =
              isArabic ? ui.TextDirection.rtl : ui.TextDirection.ltr;

          return MaterialApp(
            // Application title (used by OS for task switching)
            title: 'Fix It',

            // Remove debug banner for cleaner appearance
            debugShowCheckedModeBanner: false,

            // Theme configuration
            theme: AppTheme.lightTheme, // Light mode theme
            darkTheme: AppTheme.darkTheme, // Dark mode theme
            // ThemeMode driven by ThemeCubit (registered in DI)
            themeMode: context.watch<ThemeCubit>().state,

            // Internationalization delegates
            // Provides localized text for Material Design components
            // using easy_localization for all translations
            localizationsDelegates: [
              ...EasyLocalization.of(context)!.delegates,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],

            // Supported locales for the application
            // Supports multiple languages for international users
            supportedLocales: EasyLocalization.of(context)!.supportedLocales,

            // Use EasyLocalization's locale
            locale: EasyLocalization.of(context)!.locale,

            // Apply text direction based on locale
            localeResolutionCallback: (deviceLocale, supported) {
              if (supported.contains(localeState.locale)) {
                return localeState.locale;
              }
              return deviceLocale ?? const Locale('en');
            },

            // Centralized route generation
            // Handles navigation between different screens in the app
            onGenerateRoute: AppRoutes.onGenerateRoute,

            // Initial screen displayed when the app launches
            // AuthWrapper handles authentication state and navigation
            // Wrap the entire app with Directionality to ensure consistent text direction
            builder: (context, child) {
              return Directionality(
                textDirection: textDirection,
                child: child!,
              );
            },
            home: const AuthWrapper(),
          );
        },
      ),
    );
  }
}
