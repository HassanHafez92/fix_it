import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/booking_entity.dart';
import '../entities/time_slot_entity.dart';

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
