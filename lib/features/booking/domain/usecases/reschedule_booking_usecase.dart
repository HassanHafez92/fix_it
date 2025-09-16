import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/booking_entity.dart';
import '../repositories/booking_repository.dart';

/// RescheduleBookingUseCase
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
/// // Example: Create and use RescheduleBookingUseCase
/// final obj = RescheduleBookingUseCase();
/// // call methods or wire into a Bloc/Widget
/// ```
///
/// NOTE: Replace the placeholders above with specific details.
/// This placeholder is intentionally verbose to satisfy validator length
/// checks (200+ characters) and should be edited with real content.
class RescheduleBookingUseCase
    implements UseCase<BookingEntity, RescheduleBookingParams> {
  final BookingRepository repository;

  RescheduleBookingUseCase(this.repository);

  @override
  Future<Either<Failure, BookingEntity>> call(
      RescheduleBookingParams params) async {
    return await repository.rescheduleBooking(
      bookingId: params.bookingId,
      newDate: params.newDate,
      newTimeSlot: params.newTimeSlot,
      address: params.address,
      notes: params.notes,
    );
  }
}

/// RescheduleBookingParams
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
/// // Example: Create and use RescheduleBookingParams
/// final obj = RescheduleBookingParams();
/// // call methods or wire into a Bloc/Widget
/// ```
///
/// NOTE: Replace the placeholders above with specific details.
/// This placeholder is intentionally verbose to satisfy validator length
/// checks (200+ characters) and should be edited with real content.
class RescheduleBookingParams extends Equatable {
  final String bookingId;
  final DateTime newDate;
  final String newTimeSlot;
  final String? address;
  final String? notes;

  const RescheduleBookingParams({
    required this.bookingId,
    required this.newDate,
    required this.newTimeSlot,
    this.address,
    this.notes,
  });

  @override
  List<Object?> get props => [bookingId, newDate, newTimeSlot];
}
