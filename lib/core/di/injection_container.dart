import 'package:dio/dio.dart';
import 'package:fix_it/core/constants/app_constants.dart';
// App-level settings bloc (used by Settings screen)
import 'package:fix_it/features/settings/presentation/bloc/settings_bloc/settings_bloc.dart'
  as app_settings_bloc;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:fix_it/core/services/notification_service.dart';
import 'package:fix_it/app_config.dart';
import 'package:fix_it/core/bloc/locale_bloc.dart';
import 'package:fix_it/core/bloc/theme_cubit.dart';

// Core modules
import 'package:fix_it/core/network/api_client.dart';
import 'package:fix_it/core/network/network_info.dart';
import 'package:fix_it/core/services/payment_service.dart';
import 'package:fix_it/core/services/location_service.dart';
import 'package:fix_it/core/services/file_upload_service.dart';
import 'package:fix_it/core/services/auth_service.dart';
import 'package:fix_it/core/services/auth_service_impl.dart';
import 'package:fix_it/core/services/text_direction_service.dart';

// Notifications data/repository
import 'package:fix_it/features/notifications/data/datasources/notification_remote_data_source.dart';
import 'package:fix_it/features/notifications/data/datasources/notification_local_data_source.dart';
import 'package:fix_it/features/notifications/data/repositories/notification_repository_impl.dart';
import 'package:fix_it/features/notifications/domain/repositories/notification_repository.dart';

// Profile data/repository
import 'package:fix_it/features/profile/data/datasources/profile_remote_data_source.dart';
import 'package:fix_it/features/profile/data/datasources/profile_local_data_source.dart';
import 'package:fix_it/features/profile/data/repositories/user_profile_repository_impl.dart';
import 'package:fix_it/features/profile/domain/repositories/user_profile_repository.dart';
import 'package:fix_it/features/profile/domain/usecases/get_user_profile_usecase.dart';
import 'package:fix_it/features/profile/domain/usecases/update_user_profile_usecase.dart';
import 'package:fix_it/features/profile/domain/usecases/change_password_usecase.dart';
import 'package:fix_it/features/profile/presentation/bloc/user_profile_bloc/user_profile_bloc.dart';

// Dependency injection container: registers app services, repositories,
// usecases and blocs. Keep imports grouped by external packages, features,
// and core modules for readability.

// Features
import 'package:fix_it/features/auth/data/datasources/auth_local_data_source.dart';
import 'package:fix_it/features/auth/data/datasources/auth_firebase_data_source.dart';
import 'package:fix_it/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:fix_it/features/auth/domain/repositories/auth_repository.dart';
import 'package:fix_it/features/auth/domain/usecases/sign_in_usecase.dart';
import 'package:fix_it/features/auth/domain/usecases/sign_up_usecase.dart';
import 'package:fix_it/features/auth/domain/usecases/sign_out_usecase.dart';
import 'package:fix_it/features/auth/domain/usecases/get_current_user_usecase.dart';
import 'package:fix_it/features/auth/domain/usecases/forgot_password_usecase.dart';
import 'package:fix_it/features/auth/domain/usecases/client_sign_up_usecase.dart';
import 'package:fix_it/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:fix_it/features/auth/presentation/bloc/client_sign_up/client_sign_up_bloc.dart';

// Services Feature
import 'package:fix_it/features/services/data/datasources/service_remote_data_source.dart';
import 'package:fix_it/features/services/data/datasources/service_local_data_source.dart';
import 'package:fix_it/features/services/data/repositories/service_repository_impl.dart';
import 'package:fix_it/features/services/domain/repositories/service_repository.dart';
import 'package:fix_it/features/services/domain/usecases/get_services_usecase.dart';
import 'package:fix_it/features/services/domain/usecases/get_service_details_usecase.dart';
import 'package:fix_it/features/services/domain/usecases/get_services_by_category_usecase.dart';
import 'package:fix_it/features/services/domain/usecases/search_services_usecase.dart';
import 'package:fix_it/features/services/domain/usecases/get_categories_usecase.dart';
import 'package:fix_it/features/services/presentation/bloc/services_bloc.dart';
import 'package:fix_it/features/services/presentation/bloc/service_details_bloc.dart';

// Providers Feature
import 'package:fix_it/features/providers/data/datasources/provider_remote_data_source.dart';
import 'package:fix_it/features/providers/data/datasources/provider_local_data_source.dart';
import 'package:fix_it/features/providers/data/repositories/provider_repository_impl.dart';
import 'package:fix_it/features/providers/domain/repositories/provider_repository.dart';
import 'package:fix_it/features/providers/domain/usecases/search_providers_usecase.dart';
import 'package:fix_it/features/providers/domain/usecases/get_provider_details_usecase.dart';
import 'package:fix_it/features/providers/domain/usecases/get_provider_reviews_usecase.dart';
import 'package:fix_it/features/providers/domain/usecases/submit_provider_review_usecase.dart';
import 'package:fix_it/features/providers/domain/usecases/get_nearby_providers_usecase.dart';
import 'package:fix_it/features/providers/domain/usecases/get_featured_providers_usecase.dart';
import 'package:fix_it/features/providers/presentation/bloc/provider_search_bloc.dart';
import 'package:fix_it/features/providers/presentation/bloc/provider_details_bloc.dart';

// Booking Feature
import 'package:fix_it/features/booking/data/datasources/booking_remote_data_source.dart';
import 'package:fix_it/features/booking/data/datasources/booking_local_data_source.dart';
import 'package:fix_it/features/booking/data/repositories/booking_repository_impl.dart';
import 'package:fix_it/features/booking/domain/repositories/booking_repository.dart';
import 'package:fix_it/features/booking/domain/usecases/create_booking_usecase.dart';
import 'package:fix_it/features/booking/domain/usecases/get_available_time_slots_usecase.dart';
import 'package:fix_it/features/booking/domain/usecases/get_user_bookings_usecase.dart';
import 'package:fix_it/features/booking/domain/usecases/get_booking_details_usecase.dart';
import 'package:fix_it/features/booking/domain/usecases/client_confirm_completion_usecase.dart';
import 'package:fix_it/features/booking/domain/usecases/cancel_booking_usecase.dart';
import 'package:fix_it/features/booking/domain/usecases/reschedule_booking_usecase.dart';
import 'package:fix_it/features/booking/presentation/bloc/create_booking_bloc.dart';
import 'package:fix_it/features/booking/presentation/bloc/bookings_bloc.dart';

// Payment Feature
import 'package:fix_it/features/booking/data/datasources/payment_remote_data_source.dart';
import 'package:fix_it/features/booking/data/datasources/payment_local_data_source.dart';
import 'package:fix_it/features/booking/data/repositories/payment_repository_impl.dart';
import 'package:fix_it/features/booking/domain/repositories/payment_repository.dart';
import 'package:fix_it/features/booking/domain/usecases/get_payment_methods_usecase.dart';
import 'package:fix_it/features/booking/domain/usecases/process_payment_usecase.dart';
import 'package:fix_it/features/booking/presentation/bloc/payment_bloc/payment_bloc.dart';
// Payment feature: payment methods bloc
import 'package:fix_it/features/payment/presentation/bloc/payment_methods_bloc/payment_methods_bloc.dart';

// Chat Feature
import 'package:fix_it/features/chat/data/datasources/chat_remote_data_source.dart';
import 'package:fix_it/features/chat/data/datasources/chat_local_data_source.dart';
import 'package:fix_it/features/chat/data/repositories/chat_repository_impl.dart';
import 'package:fix_it/features/chat/domain/repositories/chat_repository.dart';
import 'package:fix_it/features/chat/domain/usecases/get_chat_list_usecase.dart';
import 'package:fix_it/features/chat/domain/usecases/get_chat_messages_usecase.dart';
import 'package:fix_it/features/chat/domain/usecases/send_message_usecase.dart';
import 'package:fix_it/features/chat/domain/usecases/search_chat_list_usecase.dart';
import 'package:fix_it/features/chat/presentation/bloc/chat_list_bloc/chat_list_bloc.dart';
import 'package:fix_it/features/chat/presentation/bloc/chat_bloc/chat_bloc.dart';

// Notifications Feature
import 'package:fix_it/features/notifications/presentation/bloc/notifications_bloc.dart';
import 'package:fix_it/features/notifications/domain/usecases/get_notifications_usecase.dart';
import 'package:fix_it/features/notifications/domain/usecases/mark_notification_read_usecase.dart';
import 'package:fix_it/features/notifications/domain/usecases/get_unread_count_usecase.dart';
import 'package:fix_it/features/notifications/domain/usecases/mark_all_as_read_usecase.dart';
import 'package:fix_it/features/notifications/domain/usecases/delete_notification_usecase.dart';
import 'package:fix_it/features/notifications/domain/usecases/delete_all_notifications_usecase.dart';

// Settings Feature
import 'package:fix_it/features/profile/domain/repositories/app_settings_repository.dart';
import 'package:fix_it/features/profile/data/repositories/app_settings_repository_impl.dart';
import 'package:fix_it/features/profile/data/datasources/app_settings_remote_data_source.dart';
import 'package:fix_it/features/profile/data/datasources/app_settings_local_data_source.dart';
import 'package:fix_it/features/profile/domain/usecases/get_app_settings_usecase.dart';
import 'package:fix_it/features/profile/domain/usecases/update_app_settings_usecase.dart';
// Notification mocks removed. The real NotificationRemoteDataSource,
// NotificationRepository and NotificationService are registered below.

// Removed unused mock user profile repository; profile feature is
// served by a simplified in-feature bloc implementation.
// Removed: _MockUserProfileRepository is not referenced by the
// simplified DI setup and thus removed to avoid unused-declaration
// analyzer errors.

// GetIt service locator
final sl = GetIt.instance;

Future<void> init() async {
  // External
  final sharedPreferences = await SharedPreferences.getInstance();
  const secureStorage = FlutterSecureStorage();
  final dio = Dio(
    BaseOptions(
      baseUrl: AppConstants.baseUrl,
      connectTimeout:
          const Duration(milliseconds: AppConstants.connectionTimeout),
      receiveTimeout: const Duration(milliseconds: AppConstants.receiveTimeout),
      headers: {
        'Content-Type': 'application/json',
        'X-App-Version': AppConfig.appVersion,
      },
    ),
  );

  sl.registerLazySingleton(() => sharedPreferences);
  sl.registerLazySingleton(() => secureStorage);
  // Attach interceptor to include Firebase ID token on requests
  dio.interceptors.add(
    InterceptorsWrapper(
      onRequest: (options, handler) async {
        try {
          final auth = FirebaseAuth.instance;
          final user = auth.currentUser;
          if (user != null) {
            final idToken = await user.getIdToken();
            if (idToken != null) {
              options.headers['Authorization'] = 'Bearer $idToken';
            }
          }
        } catch (_) {
          // Silently continue without token
        }
        handler.next(options);
      },
      onError: (DioException err, handler) async {
        // If unauthorized, try to refresh the ID token once and retry
        if (err.response?.statusCode == 401) {
          try {
            final auth = FirebaseAuth.instance;
            final user = auth.currentUser;
            if (user != null) {
              final refreshed = await user.getIdToken(true);
              if (refreshed != null) {
                final requestOptions = err.requestOptions;
                requestOptions.headers['Authorization'] = 'Bearer $refreshed';
                final clone = await dio.fetch(requestOptions);
                return handler.resolve(clone);
              }
            }
          } catch (_) {}
        }
        handler.next(err);
      },
    ),
  );

  sl.registerLazySingleton(() => dio);

  // Firebase
  sl.registerLazySingleton(() => FirebaseAuth.instance);
  sl.registerLazySingleton(() => FirebaseFirestore.instance);

  // Firebase Messaging and NotificationService
  sl.registerLazySingleton<FirebaseMessaging>(() => FirebaseMessaging.instance);
  sl.registerLazySingleton<NotificationService>(() => NotificationService(
        messaging: sl<FirebaseMessaging>(),
        auth: sl<FirebaseAuth>(),
        firestore: sl<FirebaseFirestore>(),
      ));

  // Core
  sl.registerLazySingleton<ApiClient>(() => ApiClient(sl<Dio>()));
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl());

  // Core Services
  // PaymentService: register the implementation but keep initialization
  // guarded by AppConfig. The implementation itself checks AppConfig.enableStripePayments
  // to avoid runtime failures when Stripe keys are absent in dev environments.
  sl.registerLazySingleton<PaymentService>(
      () => PaymentServiceImpl(dio: sl<Dio>()));
  sl.registerLazySingleton<LocationService>(() => LocationServiceImpl());
  sl.registerLazySingleton<FileUploadService>(() => FileUploadServiceImpl());
  sl.registerLazySingleton<AuthService>(() => AuthServiceImpl());
  sl.registerLazySingleton<TextDirectionService>(() => TextDirectionService());

  // Features
  _initAuth();
  // Enable core features
  _initServices();
  _initProviders();
  _initBookings();
  // Payments are cash-only in MVP; keep DI available but unused in UI
  _initPayment();
  _initChat();
  _initNotifications();
  _initProfile();
  _initLocale();
  _initSettings();
}

void _initAuth() {
  // Data sources
  sl.registerLazySingleton<AuthFirebaseDataSource>(
    () => AuthFirebaseDataSourceImpl(
      auth: sl<FirebaseAuth>(),
      firestore: sl<FirebaseFirestore>(),
    ),
  );
  sl.registerLazySingleton<AuthLocalDataSource>(
    () => AuthLocalDataSourceImpl(
      secureStorage: sl<FlutterSecureStorage>(),
      sharedPreferences: sl<SharedPreferences>(),
    ),
  );

  // Repository
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      firebaseDataSource: sl<AuthFirebaseDataSource>(),
      localDataSource: sl<AuthLocalDataSource>(),
      networkInfo: sl<NetworkInfo>(),
      authService: sl<AuthService>(),
    ),
  );

  // Use cases
  sl.registerLazySingleton(() => SignInUseCase(sl<AuthRepository>()));
  sl.registerLazySingleton(() => SignUpUseCase(sl<AuthRepository>()));
  sl.registerLazySingleton(() => SignOutUseCase(sl<AuthRepository>()));
  sl.registerLazySingleton(() => GetCurrentUserUseCase(sl<AuthRepository>()));
  sl.registerLazySingleton(() => ForgotPasswordUseCase(sl<AuthRepository>()));
  sl.registerLazySingleton(
      () => ClientSignUpUseCase(repository: sl<AuthRepository>()));

  // Blocs
  sl.registerFactory(() => AuthBloc(
        authService: sl<AuthService>(),
      ));
  sl.registerFactory(() => ClientSignUpBloc(
        clientSignUpUseCase: sl<ClientSignUpUseCase>(),
      ));
}

void _initServices() {
  // Data sources
  sl.registerLazySingleton<ServiceRemoteDataSource>(
    () => ServiceRemoteDataSourceImpl(apiClient: sl<ApiClient>()),
  );
  sl.registerLazySingleton<ServiceLocalDataSource>(
    () =>
        ServiceLocalDataSourceImpl(sharedPreferences: sl<SharedPreferences>()),
  );

  // Repository
  sl.registerLazySingleton<ServiceRepository>(
    () => ServiceRepositoryImpl(
      remoteDataSource: sl<ServiceRemoteDataSource>(),
      localDataSource: sl<ServiceLocalDataSource>(),
      networkInfo: sl<NetworkInfo>(),
    ),
  );

  // Use cases
  sl.registerLazySingleton(() => GetServicesUseCase(sl<ServiceRepository>()));
  sl.registerLazySingleton(
      () => GetServiceDetailsUseCase(sl<ServiceRepository>()));
  sl.registerLazySingleton(
      () => GetServicesByCategoryUseCase(sl<ServiceRepository>()));
  sl.registerLazySingleton(
      () => SearchServicesUseCase(sl<ServiceRepository>()));
  sl.registerLazySingleton(() => GetCategoriesUseCase(sl<ServiceRepository>()));

  // Blocs
  sl.registerFactory(() => ServicesBloc(
        getServices: sl<GetServicesUseCase>(),
        getServicesByCategory: sl<GetServicesByCategoryUseCase>(),
        searchServices: sl<SearchServicesUseCase>(),
        getCategories: sl<GetCategoriesUseCase>(),
      ));
  sl.registerFactory(() => ServiceDetailsBloc(
        getServiceDetails: sl<GetServiceDetailsUseCase>(),
      ));
}

// ignore: unused_element
void _initProviders() {
  // Data sources
  sl.registerLazySingleton<ProviderRemoteDataSource>(
    () => ProviderRemoteDataSourceImpl(apiClient: sl<ApiClient>()),
  );
  sl.registerLazySingleton<ProviderLocalDataSource>(
    () =>
        ProviderLocalDataSourceImpl(sharedPreferences: sl<SharedPreferences>()),
  );

  // Repository
  sl.registerLazySingleton<ProviderRepository>(
    () => ProviderRepositoryImpl(
      remoteDataSource: sl<ProviderRemoteDataSource>(),
      localDataSource: sl<ProviderLocalDataSource>(),
      networkInfo: sl<NetworkInfo>(),
    ),
  );

  // Use cases
  sl.registerLazySingleton(
      () => SearchProvidersUseCase(sl<ProviderRepository>()));
  sl.registerLazySingleton(
      () => GetProviderDetailsUseCase(sl<ProviderRepository>()));
  sl.registerLazySingleton(
      () => GetProviderReviewsUseCase(sl<ProviderRepository>()));
  sl.registerLazySingleton(
      () => SubmitProviderReviewUseCase(sl<ProviderRepository>()));
  sl.registerLazySingleton(
      () => GetNearbyProvidersUseCase(sl<ProviderRepository>()));
  sl.registerLazySingleton(
      () => GetFeaturedProvidersUseCase(sl<ProviderRepository>()));

  // Blocs
  sl.registerFactory(() => ProviderSearchBloc(
        searchProviders: sl<SearchProvidersUseCase>(),
        getNearbyProviders: sl<GetNearbyProvidersUseCase>(),
        getFeaturedProviders: sl<GetFeaturedProvidersUseCase>(),
      ));
  sl.registerFactory(() => ProviderDetailsBloc(
        getProviderDetails: sl<GetProviderDetailsUseCase>(),
        getProviderReviews: sl<GetProviderReviewsUseCase>(),
      ));
}

// ignore: unused_element
void _initChat() {
  // Data sources
  sl.registerLazySingleton<ChatRemoteDataSource>(
    () => ChatRemoteDataSourceImpl(),
  );
  sl.registerLazySingleton<ChatLocalDataSource>(
    () => ChatLocalDataSourceImpl(),
  );

  // Repository
  sl.registerLazySingleton<ChatRepository>(
    () => ChatRepositoryImpl(
      remoteDataSource: sl<ChatRemoteDataSource>(),
      localDataSource: sl<ChatLocalDataSource>(),
      networkInfo: sl<NetworkInfo>(),
    ),
  );

  // Use cases
  sl.registerLazySingleton(() => GetChatListUseCase(sl<ChatRepository>()));
  sl.registerLazySingleton(() => SearchChatListUseCase(sl<ChatRepository>()));
  sl.registerLazySingleton(() => GetChatMessagesUseCase(sl<ChatRepository>()));
  sl.registerLazySingleton(() => SendMessageUseCase(sl<ChatRepository>()));

  // Blocs
  sl.registerFactory(() => ChatListBloc(
        getChatListUseCase: sl<GetChatListUseCase>(),
        searchChatListUseCase: sl<SearchChatListUseCase>(),
      ));
  sl.registerFactory(() => ChatBloc(
        getChatMessagesUseCase: sl<GetChatMessagesUseCase>(),
        sendMessageUseCase: sl<SendMessageUseCase>(),
      ));
}

// ignore: unused_element
void _initPayment() {
  // Data sources
  sl.registerLazySingleton<PaymentRemoteDataSource>(
    () => PaymentRemoteDataSourceImpl(apiClient: sl<ApiClient>()),
  );
  sl.registerLazySingleton<PaymentLocalDataSource>(
    () => PaymentLocalDataSourceImpl(),
  );

  // Repository
  sl.registerLazySingleton<PaymentRepository>(
    () => PaymentRepositoryImpl(
      remoteDataSource: sl<PaymentRemoteDataSource>(),
      localDataSource: sl<PaymentLocalDataSource>(),
      networkInfo: sl<NetworkInfo>(),
    ),
  );

  // Use cases
  sl.registerLazySingleton(
      () => GetPaymentMethodsUseCase(sl<PaymentRepository>()));
  sl.registerLazySingleton(
      () => ProcessPaymentUseCase(sl<PaymentRepository>()));

  // Blocs
  sl.registerFactory(() => PaymentBloc(
        getPaymentMethodsUseCase: sl<GetPaymentMethodsUseCase>(),
        processPaymentUseCase: sl<ProcessPaymentUseCase>(),
      ));
  // Payment methods (UI) bloc
  sl.registerFactory<PaymentMethodsBloc>(() => PaymentMethodsBloc());
}

void _initNotifications() {
  // Data sources
  sl.registerLazySingleton<NotificationRemoteDataSource>(
    () => NotificationRemoteDataSourceImpl(firestore: sl<FirebaseFirestore>()),
  );
  sl.registerLazySingleton<NotificationLocalDataSource>(
    () => NotificationLocalDataSourceImpl(
        sharedPreferences: sl<SharedPreferences>()),
  );

  // Repository
  sl.registerLazySingleton<NotificationRepository>(
    () => NotificationRepositoryImpl(
      remoteDataSource: sl<NotificationRemoteDataSource>(),
      localDataSource: sl<NotificationLocalDataSource>(),
      networkInfo: sl<NetworkInfo>(),
    ),
  );

  // Use cases
  sl.registerLazySingleton(
      () => GetNotificationsUseCase(sl<NotificationRepository>()));
  sl.registerLazySingleton(
      () => MarkNotificationAsReadUseCase(sl<NotificationRepository>()));
  sl.registerLazySingleton(
      () => GetUnreadCountUseCase(sl<NotificationRepository>()));
  sl.registerLazySingleton(
      () => MarkAllAsReadUseCase(sl<NotificationRepository>()));
  sl.registerLazySingleton(
      () => DeleteNotificationUseCase(sl<NotificationRepository>()));
  sl.registerLazySingleton(
      () => DeleteAllNotificationsUseCase(sl<NotificationRepository>()));

  // Blocs
  sl.registerFactory<NotificationsBloc>(() => NotificationsBloc(
        getNotifications: sl<GetNotificationsUseCase>(),
        markAsRead: sl<MarkNotificationAsReadUseCase>(),
        getUnreadCount: sl<GetUnreadCountUseCase>(),
        markAllAsRead: sl<MarkAllAsReadUseCase>(),
        deleteNotification: sl<DeleteNotificationUseCase>(),
        deleteAllNotifications: sl<DeleteAllNotificationsUseCase>(),
        getCurrentUser: sl<GetCurrentUserUseCase>(),
      ));
}

void _initLocale() {
  // Register LocaleBloc as lazy singleton so the same instance is used
  // across the app (main and widgets) and saved locale is loaded once.
  sl.registerLazySingleton<LocaleBloc>(() => LocaleBloc());
  // Register an alias for LocaleBloc as localBloc to maintain compatibility
  sl.registerLazySingleton<LocaleBloc>(() => sl<LocaleBloc>(), instanceName: 'localBloc');
  // Theme cubit controls app ThemeMode
  sl.registerLazySingleton<ThemeCubit>(
      () => ThemeCubit(sl<SharedPreferences>()));
}

void _initSettings() {
  // Register data sources
  sl.registerLazySingleton<AppSettingsRemoteDataSource>(() => AppSettingsRemoteDataSourceImpl());
  sl.registerLazySingleton<AppSettingsLocalDataSource>(() => AppSettingsLocalDataSourceImpl(
    sharedPreferences: sl(),
  ));
  
  // Register repository
  sl.registerLazySingleton<AppSettingsRepository>(() => AppSettingsRepositoryImpl(
    remoteDataSource: sl(),
    localDataSource: sl(),
    networkInfo: sl(),
  ));
  
  // Register use cases
  sl.registerLazySingleton(() => GetAppSettingsUseCase(sl()));
  sl.registerLazySingleton(() => UpdateAppSettingsUseCase(sl()));
  
  // Register SettingsBloc as a factory so a new instance is created each time
  // The app-level SettingsBloc has a parameterless constructor, so register accordingly.
  sl.registerFactory<app_settings_bloc.SettingsBloc>(
      () => app_settings_bloc.SettingsBloc());
}

void _initProfile() {
  // Profile feature - register data sources, repository, usecases, and bloc
  sl.registerLazySingleton<ProfileRemoteDataSource>(
    () => ProfileRemoteDataSourceImpl(),
  );

  sl.registerLazySingleton<ProfileLocalDataSource>(
    () => ProfileLocalDataSourceImpl(),
  );

  sl.registerLazySingleton<UserProfileRepository>(
    () => UserProfileRepositoryImpl(
      remoteDataSource: sl<ProfileRemoteDataSource>(),
      localDataSource: sl<ProfileLocalDataSource>(),
    ),
  );

  // Use cases
  sl.registerLazySingleton(
      () => GetUserProfileUseCase(sl<UserProfileRepository>()));
  sl.registerLazySingleton(
      () => UpdateUserProfileUseCase(sl<UserProfileRepository>()));
  sl.registerLazySingleton(
      () => ChangePasswordUseCase(sl<UserProfileRepository>()));

  // Blocs - register UserProfileBloc with domain usecases
  sl.registerFactory<UserProfileBloc>(() => UserProfileBloc(
        getCurrentUser: sl<GetCurrentUserUseCase>(),
        getUserProfile: sl<GetUserProfileUseCase>(),
        updateUserProfile: sl<UpdateUserProfileUseCase>(),
        changePassword: sl<ChangePasswordUseCase>(),
      ));
}

void _initBookings() {
  // Data sources
  sl.registerLazySingleton<BookingRemoteDataSource>(
    () =>
        BookingRemoteDataSourceImpl(apiClient: sl<ApiClient>(), dio: sl<Dio>()),
  );
  sl.registerLazySingleton<BookingLocalDataSource>(
    () =>
        BookingLocalDataSourceImpl(sharedPreferences: sl<SharedPreferences>()),
  );

  // Repository
  sl.registerLazySingleton<BookingRepository>(
    () => BookingRepositoryImpl(
      remoteDataSource: sl<BookingRemoteDataSource>(),
      localDataSource: sl<BookingLocalDataSource>(),
      networkInfo: sl<NetworkInfo>(),
    ),
  );

  // Use cases
  sl.registerLazySingleton(() => CreateBookingUseCase(sl<BookingRepository>()));
  sl.registerLazySingleton(
      () => GetAvailableTimeSlotsUseCase(sl<BookingRepository>()));
  sl.registerLazySingleton(
      () => GetUserBookingsUseCase(sl<BookingRepository>()));
  sl.registerLazySingleton(
      () => GetBookingDetailsUseCase(sl<BookingRepository>()));
  sl.registerLazySingleton(() => CancelBookingUseCase(sl<BookingRepository>()));
  sl.registerLazySingleton(
      () => RescheduleBookingUseCase(sl<BookingRepository>()));
  sl.registerLazySingleton(
      // NOTE: `ClientConfirmCompletionUseCase` was moved to its own file
      // (`booking/domain/usecases/client_confirm_completion_usecase.dart`) to
      // keep booking-related usecases separated for clarity.
      () => ClientConfirmCompletionUseCase(sl<BookingRepository>()));

  // Blocs
  sl.registerFactory(() => CreateBookingBloc(
        createBooking: sl<CreateBookingUseCase>(),
        getAvailableTimeSlots: sl<GetAvailableTimeSlotsUseCase>(),
      ));
  sl.registerFactory(() => BookingsBloc(
        getUserBookings: sl<GetUserBookingsUseCase>(),
        getBookingDetails: sl<GetBookingDetailsUseCase>(),
        cancelBooking: sl<CancelBookingUseCase>(),
        clientConfirmCompletion: sl<ClientConfirmCompletionUseCase>(),
        rescheduleBooking: sl<RescheduleBookingUseCase>(),
      ));
}
