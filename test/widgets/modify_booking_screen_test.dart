import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:dartz/dartz.dart';

import 'package:fix_it/core/di/injection_container.dart' as di;
import 'package:fix_it/features/booking/presentation/pages/modify_booking_screen.dart';
import 'package:fix_it/features/booking/domain/usecases/get_booking_details_usecase.dart';
import 'package:fix_it/features/booking/domain/usecases/get_available_time_slots_usecase.dart';
import 'package:fix_it/features/booking/domain/usecases/reschedule_booking_usecase.dart';
import 'package:fix_it/features/booking/domain/entities/booking_entity.dart';
import 'package:fix_it/features/booking/domain/entities/time_slot_entity.dart';

class FakeGetBookingDetailsUseCase extends Mock
    implements GetBookingDetailsUseCase {}

class FakeGetAvailableTimeSlotsUseCase extends Mock
    implements GetAvailableTimeSlotsUseCase {}

class FakeRescheduleBookingUseCase extends Mock
    implements RescheduleBookingUseCase {}

class GetBookingDetailsParamsFake extends Fake
    implements GetBookingDetailsParams {}

class GetAvailableTimeSlotsParamsFake extends Fake
    implements GetAvailableTimeSlotsParams {}

class RescheduleBookingParamsFake extends Fake
    implements RescheduleBookingParams {}

void main() {
  setUpAll(() {
    registerFallbackValue(GetBookingDetailsParams(bookingId: 'fallback'));
    registerFallbackValue(
        GetAvailableTimeSlotsParams(providerId: 'p', date: DateTime.now()));
    registerFallbackValue(RescheduleBookingParams(
        bookingId: 'b', newDate: DateTime.now(), newTimeSlot: 't'));
  });

  testWidgets('ModifyBookingScreen loads booking details and time slots',
      (tester) async {
    // enlarge the test window so the screen layout won't overflow in tests
    tester.view.physicalSize = const Size(1080, 1920);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });
    final fakeGetDetails = FakeGetBookingDetailsUseCase();
    final fakeGetSlots = FakeGetAvailableTimeSlotsUseCase();
    final fakeReschedule = FakeRescheduleBookingUseCase();

    // ensure DI has our fakes
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

    final booking = BookingEntity(
      id: 'b1',
      userId: 'u1',
      providerId: 'p1',
      serviceId: 's1',
      serviceName: 'MyService',
      providerName: 'Provider A',
      providerImage: '',
      scheduledDate: DateTime.now(),
      timeSlot: '10:00 - 11:00',
      address: 'Some address',
      latitude: 0.0,
      longitude: 0.0,
      totalAmount: 100.0,
      servicePrice: 90.0,
      taxes: 5.0,
      platformFee: 5.0,
      status: BookingStatus.pending,
      paymentStatus: PaymentStatus.pending,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      attachments: [],
      isUrgent: false,
      estimatedDuration: 60,
    );

    final slot = TimeSlotEntity(
      id: 'ts1',
      providerId: 'p1',
      date: DateTime.now(),
      startTime: '10:00',
      endTime: '11:00',
      isAvailable: true,
      price: null,
      isUrgentSlot: false,
    );

    when(() => fakeGetDetails(any())).thenAnswer((_) async => Right(booking));
    when(() => fakeGetSlots(any())).thenAnswer((_) async => Right([slot]));

    await tester
        .pumpWidget(MaterialApp(home: ModifyBookingScreen(bookingId: 'b1')));
    await tester.pumpAndSettle();

    expect(find.text('MyService'), findsOneWidget);
    expect(find.text('Provider A'), findsOneWidget);
    expect(find.textContaining('Address'), findsOneWidget);
  });

  testWidgets('Save changes calls reschedule usecase and pops with success',
      (tester) async {
    // enlarge the test window so the screen layout won't overflow in tests
    tester.view.physicalSize = const Size(1080, 1920);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

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

    final booking = BookingEntity(
      id: 'b2',
      userId: 'u1',
      providerId: 'p2',
      serviceId: 's1',
      serviceName: 'Service',
      providerName: 'ProviderB',
      providerImage: '',
      scheduledDate: DateTime.now(),
      timeSlot: '10:00 - 11:00',
      address: 'Addr',
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

    final slot = TimeSlotEntity(
      id: 'ts2',
      providerId: 'p2',
      date: DateTime.now(),
      startTime: '10:00',
      endTime: '11:00',
      isAvailable: true,
      price: null,
      isUrgentSlot: false,
    );

    when(() => fakeGetDetails(any())).thenAnswer((_) async => Right(booking));
    when(() => fakeGetSlots(any())).thenAnswer((_) async => Right([slot]));
    when(() => fakeReschedule(any())).thenAnswer((_) async => Right(booking));

    await tester
        .pumpWidget(MaterialApp(home: ModifyBookingScreen(bookingId: 'b2')));
    await tester.pumpAndSettle();

    // Tap save
    expect(find.text('Save changes'), findsOneWidget);
    await tester.tap(find.text('Save changes'));
    await tester.pumpAndSettle();

    // The screen should have popped; the title won't be present
    expect(find.text('Modify Booking'), findsNothing);
    verify(() => fakeReschedule(any())).called(1);
  });
}
