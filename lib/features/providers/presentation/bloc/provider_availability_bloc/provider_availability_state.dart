part of 'provider_availability_bloc.dart';

abstract class ProviderAvailabilityState extends Equatable {
  const ProviderAvailabilityState();

  @override
  List<Object> get props => [];
}

class ProviderAvailabilityInitial extends ProviderAvailabilityState {}

class ProviderAvailabilityLoading extends ProviderAvailabilityState {}

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
  List<Object> get props => [providerName, providerRating ?? 0, providerTotalRatings ?? 0, availability, bookedSlots, selectedDate ?? DateTime.now()];
}

class ProviderAvailabilityError extends ProviderAvailabilityState {
  final String message;

  const ProviderAvailabilityError({required this.message});

  @override
  List<Object> get props => [message];
}

class BookingRequested extends ProviderAvailabilityState {}
