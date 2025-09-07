import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'provider_availability_event.dart';
part 'provider_availability_state.dart';

class ProviderAvailabilityBloc extends Bloc<ProviderAvailabilityEvent, ProviderAvailabilityState> {
  ProviderAvailabilityBloc() : super(ProviderAvailabilityInitial()) {
    on<LoadProviderAvailabilityEvent>(_onLoadProviderAvailability);
    on<BookTimeSlotEvent>(_onBookTimeSlot);
  }

  void _onLoadProviderAvailability(
    LoadProviderAvailabilityEvent event,
    Emitter<ProviderAvailabilityState> emit,
  ) async {
    emit(ProviderAvailabilityLoading());
    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 1));

      // Mock availability data
      final now = DateTime.now();
      final availability = <DateTime, List<TimeOfDay>>{};

      // Add availability for the next 7 days
      for (int i = 0; i < 7; i++) {
        final date = DateTime(now.year, now.month, now.day + i);
        final slots = <TimeOfDay>[];

        // Add time slots from 9 AM to 5 PM
        for (int hour = 9; hour < 17; hour++) {
          slots.add(TimeOfDay(hour: hour, minute: 0));
          if (hour < 16) {
            slots.add(TimeOfDay(hour: hour, minute: 30));
          }
        }

        availability[date] = slots;
      }

      // Mock booked slots
      final bookedSlots = <DateTime>[];

      // Add some booked slots for tomorrow
      final tomorrow = DateTime(now.year, now.month, now.day + 1);
      bookedSlots.add(DateTime(tomorrow.year, tomorrow.month, tomorrow.day, 10, 0));
      bookedSlots.add(DateTime(tomorrow.year, tomorrow.month, tomorrow.day, 11, 30));
      bookedSlots.add(DateTime(tomorrow.year, tomorrow.month, tomorrow.day, 14, 0));

      // Add some booked slots for the day after tomorrow
      final dayAfter = DateTime(now.year, now.month, now.day + 2);
      bookedSlots.add(DateTime(dayAfter.year, dayAfter.month, dayAfter.day, 9, 30));
      bookedSlots.add(DateTime(dayAfter.year, dayAfter.month, dayAfter.day, 13, 0));
      bookedSlots.add(DateTime(dayAfter.year, dayAfter.month, dayAfter.day, 15, 30));

      emit(ProviderAvailabilityLoaded(
        providerName: 'John Smith',
        providerRating: 4.8,
        providerTotalRatings: 124,
        availability: availability,
        bookedSlots: bookedSlots,
        selectedDate: now,
      ));
    } catch (e) {
      emit(ProviderAvailabilityError(message: e.toString()));
    }
  }

  void _onBookTimeSlot(
    BookTimeSlotEvent event,
    Emitter<ProviderAvailabilityState> emit,
  ) async {
    if (state is ProviderAvailabilityLoaded) {
      final currentState = state as ProviderAvailabilityLoaded;

      emit(ProviderAvailabilityLoading());
      try {
        // Simulate API call
        await Future.delayed(const Duration(seconds: 1));

        // Add the booked slot to the list
        final updatedBookedSlots = List<DateTime>.from(currentState.bookedSlots);
        updatedBookedSlots.add(event.dateTime);

        emit(currentState.copyWith(
          bookedSlots: updatedBookedSlots,
        ));

        emit(BookingRequested());
      } catch (e) {
        emit(ProviderAvailabilityError(message: e.toString()));
        emit(currentState);
      }
    }
  }
}
