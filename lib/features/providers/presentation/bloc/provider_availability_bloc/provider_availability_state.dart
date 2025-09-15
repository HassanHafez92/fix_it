part of 'provider_availability_bloc.dart';

abstract class ProviderAvailabilityState extends Equatable {
  const ProviderAvailabilityState();

  @override
  List<Object?> get props => [];
}

class ProviderAvailabilityInitial extends ProviderAvailabilityState {}

class ProviderAvailabilityLoading extends ProviderAvailabilityState {}

/// BookingRequested
///
/// Transient state emitted when a booking request has been successfully sent.
class BookingRequested extends ProviderAvailabilityState {
  const BookingRequested();

  @override
  List<Object?> get props => [];
}

/// ProviderAvailabilityLoaded
///
/// Contains provider availability and booking state.
class ProviderAvailabilityLoaded extends ProviderAvailabilityState {
  final String providerName;
  final double? providerRating;
  final int? providerTotalRatings;
  final Map<DateTime, List<TimeOfDay>> availability;
  final List<DateTime> bookedSlots;
  final DateTime? selectedDate;

  const ProviderAvailabilityLoaded({
    required this.providerName,
    this.providerRating,
    this.providerTotalRatings,
    required this.availability,
    required this.bookedSlots,
    this.selectedDate,
  });

  ProviderAvailabilityLoaded copyWith({
    String? providerName,
    double? providerRating,
    int? providerTotalRatings,
    Map<DateTime, List<TimeOfDay>>? availability,
    List<DateTime>? bookedSlots,
    DateTime? selectedDate,
  }) {
    return ProviderAvailabilityLoaded(
      providerName: providerName ?? this.providerName,
      providerRating: providerRating ?? this.providerRating,
      providerTotalRatings: providerTotalRatings ?? this.providerTotalRatings,
      availability: availability ?? this.availability,
      bookedSlots: bookedSlots ?? this.bookedSlots,
      selectedDate: selectedDate ?? this.selectedDate,
    );
  }

  @override
  List<Object?> get props => [
        providerName,
        providerRating,
        providerTotalRatings,
        availability,
        bookedSlots,
        selectedDate
      ];
}

class ProviderAvailabilityError extends ProviderAvailabilityState {
  final String message;

  const ProviderAvailabilityError({required this.message});

  @override
  List<Object?> get props => [message];
}
