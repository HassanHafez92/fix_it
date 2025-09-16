import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/booking_entity.dart';
import '../repositories/booking_repository.dart';

class GetBookingDetailsUseCase
    implements UseCase<BookingEntity, GetBookingDetailsParams> {
  final BookingRepository repository;

  GetBookingDetailsUseCase(this.repository);

  @override
  Future<Either<Failure, BookingEntity>> call(
      GetBookingDetailsParams params) async {
    return await repository.getBookingDetails(params.bookingId);
  }
}

class GetBookingDetailsParams extends Equatable {
  final String bookingId;

  const GetBookingDetailsParams({required this.bookingId});

  @override
  List<Object?> get props => [bookingId];
}
