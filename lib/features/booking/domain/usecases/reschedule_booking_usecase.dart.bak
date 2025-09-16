import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/booking_entity.dart';
import '../repositories/booking_repository.dart';

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
