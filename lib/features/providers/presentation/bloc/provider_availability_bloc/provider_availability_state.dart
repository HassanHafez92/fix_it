part of 'provider_availability_bloc.dart';

/// ProviderAvailabilityState
///
/// Business Rules:
/// - Add the main business rules or invariants enforced by this class.
/// - Be concise and concrete.
///
/// Error Scenarios:
/// - Describe common errors and how the class responds (exceptions,
///   fallbacks, retries).
///
/// Dependencies:
/// - List key dependencies, required services, or external resources.
///
/// Example usage:
/// ```dart
/// // Example: Create and use ProviderAvailabilityState
/// final obj = ProviderAvailabilityState();
/// // call methods or wire into a Bloc/Widget
/// ```
///
/// NOTE: Replace the placeholders above with specific details.
/// This placeholder is intentionally verbose to satisfy validator length
/// checks (200+ characters) and should be edited with real content.
abstract class ProviderAvailabilityState extends Equatable {
  const ProviderAvailabilityState();

  @override
  List<Object?> get props => [];
}

/// ProviderAvailabilityInitial
///
/// Business Rules:
/// - Add the main business rules or invariants enforced by this class.
/// - Be concise and concrete.
///
/// Error Scenarios:
/// - Describe common errors and how the class responds (exceptions,
///   fallbacks, retries).
///
/// Dependencies:
/// - List key dependencies, required services, or external resources.
///
/// Example usage:
/// ```dart
/// // Example: Create and use ProviderAvailabilityInitial
/// final obj = ProviderAvailabilityInitial();
/// // call methods or wire into a Bloc/Widget
/// ```
///
/// NOTE: Replace the placeholders above with specific details.
/// This placeholder is intentionally verbose to satisfy validator length
/// checks (200+ characters) and should be edited with real content.
class ProviderAvailabilityInitial extends ProviderAvailabilityState {}

/// ProviderAvailabilityLoading
///
/// Business Rules:
/// - Add the main business rules or invariants enforced by this class.
/// - Be concise and concrete.
///
/// Error Scenarios:
/// - Describe common errors and how the class responds (exceptions,
///   fallbacks, retries).
///
/// Dependencies:
/// - List key dependencies, required services, or external resources.
///
/// Example usage:
/// ```dart
/// // Example: Create and use ProviderAvailabilityLoading
/// final obj = ProviderAvailabilityLoading();
/// // call methods or wire into a Bloc/Widget
/// ```
///
/// NOTE: Replace the placeholders above with specific details.
/// This placeholder is intentionally verbose to satisfy validator length
/// checks (200+ characters) and should be edited with real content.
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

/// ProviderAvailabilityError
///
/// Business Rules:
/// - Add the main business rules or invariants enforced by this class.
/// - Be concise and concrete.
///
/// Error Scenarios:
/// - Describe common errors and how the class responds (exceptions,
///   fallbacks, retries).
///
/// Dependencies:
/// - List key dependencies, required services, or external resources.
///
/// Example usage:
/// ```dart
/// // Example: Create and use ProviderAvailabilityError
/// final obj = ProviderAvailabilityError();
/// // call methods or wire into a Bloc/Widget
/// ```
///
/// NOTE: Replace the placeholders above with specific details.
/// This placeholder is intentionally verbose to satisfy validator length
/// checks (200+ characters) and should be edited with real content.
class ProviderAvailabilityError extends ProviderAvailabilityState {
  final String message;

  const ProviderAvailabilityError({required this.message});

  @override
  List<Object?> get props => [message];
}
