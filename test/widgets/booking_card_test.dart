import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fix_it/features/booking/presentation/widgets/booking_card.dart';
import 'package:fix_it/features/booking/domain/entities/booking_entity.dart';
import 'package:fix_it/core/routes/app_routes.dart' as routes_generator;
import 'package:fix_it/core/utils/app_routes.dart';
import 'package:fix_it/core/di/injection_container.dart' as di;
import 'package:fix_it/features/chat/domain/repositories/chat_repository.dart';
import 'package:mocktail/mocktail.dart';
import 'package:fix_it/l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:dartz/dartz.dart';
import 'package:fix_it/features/booking/domain/usecases/get_booking_details_usecase.dart';
import 'package:fix_it/features/booking/domain/usecases/get_available_time_slots_usecase.dart';
import 'package:fix_it/features/booking/domain/usecases/reschedule_booking_usecase.dart';
import 'package:fix_it/features/booking/domain/entities/time_slot_entity.dart';

class FakeGetBookingDetailsUseCase extends Mock
    implements GetBookingDetailsUseCase {}

class FakeGetAvailableTimeSlotsUseCase extends Mock
    implements GetAvailableTimeSlotsUseCase {}

class FakeRescheduleBookingUseCase extends Mock
    implements RescheduleBookingUseCase {}

class MockChatRepository extends Mock implements ChatRepository {}

void main() {
  setUpAll(() {
    // No fallback values required for these tests
  });
  setUpAll(() {
    // register fallback values for mocktail when() any() usage
    registerFallbackValue(GetBookingDetailsParams(bookingId: 'fallback'));
    registerFallbackValue(
        GetAvailableTimeSlotsParams(providerId: 'p', date: DateTime.now()));
    registerFallbackValue(RescheduleBookingParams(
        bookingId: 'b', newDate: DateTime.now(), newTimeSlot: 't'));
  });

  testWidgets('Modify button navigates to modify screen with bookingId',
      (tester) async {
    // Declare booking first, then register DI fakes and stubs
    final booking1 = BookingEntity(
      id: 'b1',
      userId: 'u1',
      providerId: 'p1',
      serviceId: 's1',
      serviceName: 'Service',
      providerName: 'Provider',
      providerImage: '',
      scheduledDate: DateTime.now(),
      timeSlot: '10:00 - 11:00',
      address: 'Address',
      latitude: 0.0,
      longitude: 0.0,
      totalAmount: 50.0,
      servicePrice: 45.0,
      taxes: 0.0,
      platformFee: 5.0,
      status: BookingStatus.pending,
      paymentStatus: PaymentStatus.pending,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      attachments: [],
      isUrgent: false,
      estimatedDuration: 60,
    );

    final fakeGetDetails = FakeGetBookingDetailsUseCase();
    final fakeGetSlots = FakeGetAvailableTimeSlotsUseCase();
    final fakeReschedule = FakeRescheduleBookingUseCase();

    if (di.sl.isRegistered<GetBookingDetailsUseCase>()) {
      di.sl.unregister<GetBookingDetailsUseCase>();
    }
    if (di.sl.isRegistered<GetAvailableTimeSlotsUseCase>()) {
      di.sl.unregister<GetAvailableTimeSlotsUseCase>();
    }
    if (di.sl.isRegistered<RescheduleBookingUseCase>()) {
      di.sl.unregister<RescheduleBookingUseCase>();
    }

    di.sl.registerSingleton<GetBookingDetailsUseCase>(fakeGetDetails);
    di.sl.registerSingleton<GetAvailableTimeSlotsUseCase>(fakeGetSlots);
    di.sl.registerSingleton<RescheduleBookingUseCase>(fakeReschedule);

    // Stub getDetails to return the booking when called
    when(() => fakeGetDetails(any()))
        .thenAnswer((inv) async => Right(booking1));
    when(() => fakeGetSlots(any()))
        .thenAnswer((inv) async => Right(<TimeSlotEntity>[]));
    when(() => fakeReschedule(any()))
        .thenAnswer((inv) async => Right(booking1));

    await tester.pumpWidget(MaterialApp(
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      // Use a custom onGenerateRoute so /modify-booking works with arguments
      // but intercept /chat to avoid creating the real ChatBloc in tests.
      onGenerateRoute: (settings) {
        if (settings.name == AppRoutes.chat) {
          return MaterialPageRoute(
            builder: (_) =>
                const Scaffold(body: Center(child: Text('chat screen'))),
            settings: settings,
          );
        }
        if (settings.name == AppRoutes.modifyBooking) {
          final args = settings.arguments as Map<String, dynamic>?;
          final bookingId = args != null && args['bookingId'] is String
              ? args['bookingId'] as String
              : 'missing';
          return MaterialPageRoute(
            builder: (_) => Scaffold(
              appBar: AppBar(title: const Text('Modify Booking')),
              body: Center(child: Text('Modify booking: $bookingId')),
            ),
            settings: settings,
          );
        }
        return routes_generator.AppRoutes.onGenerateRoute(settings);
      },
      home: Scaffold(body: BookingCard(booking: booking1)),
    ));

    expect(find.text('Modify'), findsOneWidget);
    await tester.tap(find.text('Modify'));
    await tester.pumpAndSettle();

    // Should navigate to ModifyBookingScreen which shows bookingId
    expect(find.textContaining('Modify booking:'), findsOneWidget);
    expect(find.textContaining('b1'), findsOneWidget);
  });

  testWidgets(
      'Contact bottom sheet -> Message performs createChat and opens chat',
      (tester) async {
    final booking = BookingEntity(
      id: 'b2',
      userId: 'u1',
      providerId: 'p2',
      serviceId: 's1',
      serviceName: 'Service',
      providerName: 'Provider2',
      providerImage: '',
      scheduledDate: DateTime.now(),
      timeSlot: '10:00 - 11:00',
      address: 'Address',
      latitude: 0.0,
      longitude: 0.0,
      totalAmount: 50.0,
      servicePrice: 45.0,
      taxes: 0.0,
      platformFee: 5.0,
      status: BookingStatus.confirmed,
      paymentStatus: PaymentStatus.pending,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      attachments: [],
      isUrgent: false,
      estimatedDuration: 60,
    );

    final mockChatRepo = MockChatRepository();
    when(() => mockChatRepo.createChat(otherUserId: any(named: 'otherUserId')))
        .thenAnswer((_) async => Right('chat_test123'));

    // Register mock in DI (replace existing if present)
    if (di.sl.isRegistered<ChatRepository>()) {
      di.sl.unregister<ChatRepository>();
    }
    di.sl.registerSingleton<ChatRepository>(mockChatRepo);

    await tester.pumpWidget(MaterialApp(
      // Intercept /chat to return a dummy chat screen so the test
      // doesn't require ChatBloc to be registered in DI.
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      onGenerateRoute: (settings) {
        if (settings.name == AppRoutes.chat) {
          return MaterialPageRoute(
            builder: (_) =>
                const Scaffold(body: Center(child: Text('chat screen'))),
            settings: settings,
          );
        }
        if (settings.name == AppRoutes.modifyBooking) {
          final args = settings.arguments as Map<String, dynamic>?;
          final bookingId = args != null && args['bookingId'] is String
              ? args['bookingId'] as String
              : 'missing';
          return MaterialPageRoute(
            builder: (_) => Scaffold(
              appBar: AppBar(title: const Text('Modify Booking')),
              body: Center(child: Text('Modify booking: $bookingId')),
            ),
            settings: settings,
          );
        }
        return routes_generator.AppRoutes.onGenerateRoute(settings);
      },
      home: Scaffold(body: BookingCard(booking: booking)),
    ));

    expect(find.text('Contact Provider'), findsOneWidget);
    await tester.tap(find.text('Contact Provider'));
    await tester.pumpAndSettle();

    // Bottom sheet should show 'Message Provider'
    expect(find.text('Message Provider'), findsOneWidget);
    await tester.tap(find.text('Message Provider'));
    await tester.pumpAndSettle();

    // Should navigate to dummy chat screen
    expect(find.text('chat screen'), findsOneWidget);
  });
}
