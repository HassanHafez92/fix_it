import 'package:flutter/material.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'provider_details_event.dart';
part 'provider_details_state.dart';

class ProviderDetailsBloc extends Bloc<ProviderDetailsEvent, ProviderDetailsState> {
  ProviderDetailsBloc() : super(ProviderDetailsInitial()) {
    on<LoadProviderDetailsEvent>(_onLoadProviderDetails);
    on<LoadProviderReviewsEvent>(_onLoadProviderReviews);
    on<LoadProviderServicesEvent>(_onLoadProviderServices);
    on<LoadProviderAvailabilityEvent>(_onLoadProviderAvailability);
  }

  void _onLoadProviderDetails(
    LoadProviderDetailsEvent event,
    Emitter<ProviderDetailsState> emit,
  ) async {
    emit(ProviderDetailsLoading());
    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 1));

      // Mock provider data
      final provider = {
        'id': event.providerId,
        'name': 'John Smith',
        'email': 'john.smith@example.com',
        'phone': '+1 (555) 123-4567',
        'profilePictureUrl': '',
        'bio': 'Experienced professional with over 10 years in the industry. Specialized in home repairs and maintenance.',
        'rating': 4.8,
        'totalRatings': 124,
        'totalBookings': 320,
        'yearsOfExperience': 10,
        'isVerified': true,
        'services': ['Plumbing', 'Electrical', 'HVAC'],
        'location': 'New York, NY',
        'joinedDate': DateTime(2018, 5, 15),
      };

      emit(ProviderDetailsLoaded(provider: provider));
    } catch (e) {
      emit(ProviderDetailsError(message: e.toString()));
    }
  }

  void _onLoadProviderReviews(
    LoadProviderReviewsEvent event,
    Emitter<ProviderDetailsState> emit,
  ) async {
    if (state is ProviderDetailsLoaded) {
      final currentState = state as ProviderDetailsLoaded;

      emit(ProviderDetailsLoading());
      try {
        // Simulate API call
        await Future.delayed(const Duration(seconds: 1));

        // Mock reviews data
        final reviews = [
          {
            'id': '1',
            'userName': 'Alice Johnson',
            'userProfilePictureUrl': '',
            'rating': 5,
            'comment': 'John did an excellent job fixing my plumbing issue. Very professional and knowledgeable.',
            'date': DateTime(2023, 10, 15),
          },
          {
            'id': '2',
            'userName': 'Bob Williams',
            'userProfilePictureUrl': '',
            'rating': 4,
            'comment': 'Good service overall. Arrived on time and completed the work as expected.',
            'date': DateTime(2023, 9, 28),
          },
          {
            'id': '3',
            'userName': 'Carol Davis',
            'userProfilePictureUrl': '',
            'rating': 5,
            'comment': 'Highly recommend! Fixed my electrical problem quickly and efficiently.',
            'date': DateTime(2023, 9, 10),
          },
        ];

        emit(currentState.copyWith(reviews: reviews));
      } catch (e) {
        emit(ProviderDetailsError(message: e.toString()));
        emit(currentState);
      }
    }
  }

  void _onLoadProviderServices(
    LoadProviderServicesEvent event,
    Emitter<ProviderDetailsState> emit,
  ) async {
    if (state is ProviderDetailsLoaded) {
      final currentState = state as ProviderDetailsLoaded;

      emit(ProviderDetailsLoading());
      try {
        // Simulate API call
        await Future.delayed(const Duration(seconds: 1));

        // Mock services data
        final services = [
          {
            'id': '1',
            'name': 'Plumbing Repair',
            'description': 'Fix leaks, unclog drains, and repair pipes',
            'price': 80.0,
            'duration': 120,
            'category': 'Plumbing',
          },
          {
            'id': '2',
            'name': 'Electrical Installation',
            'description': 'Install light fixtures, outlets, and switches',
            'price': 100.0,
            'duration': 90,
            'category': 'Electrical',
          },
          {
            'id': '3',
            'name': 'HVAC Maintenance',
            'description': 'Regular maintenance for heating and cooling systems',
            'price': 120.0,
            'duration': 180,
            'category': 'HVAC',
          },
        ];

        emit(currentState.copyWith(services: services));
      } catch (e) {
        emit(ProviderDetailsError(message: e.toString()));
        emit(currentState);
      }
    }
  }

  void _onLoadProviderAvailability(
    LoadProviderAvailabilityEvent event,
    Emitter<ProviderDetailsState> emit,
  ) async {
    if (state is ProviderDetailsLoaded) {
      final currentState = state as ProviderDetailsLoaded;

      emit(ProviderDetailsLoading());
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

        emit(currentState.copyWith(availability: availability));
      } catch (e) {
        emit(ProviderDetailsError(message: e.toString()));
        emit(currentState);
      }
    }
  }
}
