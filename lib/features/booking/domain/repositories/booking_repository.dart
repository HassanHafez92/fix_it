import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/booking_entity.dart';
import '../entities/time_slot_entity.dart';

/// BookingRepository
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
/// // Example: Create and use BookingRepository
/// final obj = BookingRepository();
/// // call methods or wire into a Bloc/Widget
/// ```
///
/// NOTE: Replace the placeholders above with specific details.
/// This placeholder is intentionally verbose to satisfy validator length
/// checks (200+ characters) and should be edited with real content.
abstract class BookingRepository {
  Future<Either<Failure, List<TimeSlotEntity>>> getAvailableTimeSlots({
    required String providerId,
    required DateTime date,
  });
  Future<Either<Failure, BookingEntity>> createBooking({
    required String providerId,
    required String serviceId,
    required DateTime scheduledDate,
    required String timeSlot,
    required String address,
    required double latitude,
    required double longitude,
    String? notes,
    List<String>? attachments,
    bool isUrgent = false,
  });
  Future<Either<Failure, List<BookingEntity>>> getUserBookings();
  Future<Either<Failure, BookingEntity>> getBookingDetails(String bookingId);
  Future<Either<Failure, BookingEntity>> updateBookingStatus({
    required String bookingId,
    required BookingStatus status,
    String? reason,
  });
  Future<Either<Failure, BookingEntity>> rescheduleBooking({
    required String bookingId,
    required DateTime newDate,
    required String newTimeSlot,
    String? address,
    String? notes,
  });
  Future<Either<Failure, void>> cancelBooking({
    required String bookingId,
    required String reason,
  });
  Future<Either<Failure, void>> processPayment({
    required String bookingId,
    required String paymentMethodId,
  });

  /// Cash-only MVP: client confirms completion to finalize payment status
  Future<Either<Failure, BookingEntity>> clientConfirmCompletion({
    required String bookingId,
  });
}
