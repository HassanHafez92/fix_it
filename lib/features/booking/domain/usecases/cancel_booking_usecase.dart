import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/booking_repository.dart';

class CancelBookingUseCase implements UseCase<void, CancelBookingParams> {
  final BookingRepository repository;

  CancelBookingUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(CancelBookingParams params) async {
    return await repository.cancelBooking(
      bookingId: params.bookingId,
      reason: params.reason,
    );
  }
}

class CancelBookingParams extends Equatable {
  final String bookingId;
  final String reason;

  const CancelBookingParams({
    required this.bookingId,
    required this.reason,
  });

  @override
  List<Object?> get props => [bookingId, reason];
}
