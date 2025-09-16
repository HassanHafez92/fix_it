import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/booking_entity.dart';
import '../repositories/booking_repository.dart';

class ClientConfirmCompletionUseCase
    implements UseCase<BookingEntity, ClientConfirmCompletionParams> {
  final BookingRepository repository;

  ClientConfirmCompletionUseCase(this.repository);

  @override
  Future<Either<Failure, BookingEntity>> call(
      ClientConfirmCompletionParams params) async {
    return await repository.clientConfirmCompletion(
      bookingId: params.bookingId,
    );
  }
}

class ClientConfirmCompletionParams extends Equatable {
  final String bookingId;

  const ClientConfirmCompletionParams({required this.bookingId});

  @override
  List<Object?> get props => [bookingId];
}
