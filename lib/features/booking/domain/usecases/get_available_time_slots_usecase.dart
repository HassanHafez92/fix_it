import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/time_slot_entity.dart';
import '../repositories/booking_repository.dart';

class GetAvailableTimeSlotsUseCase implements UseCase<List<TimeSlotEntity>, GetAvailableTimeSlotsParams> {
  final BookingRepository repository;

  GetAvailableTimeSlotsUseCase(this.repository);

  @override
  Future<Either<Failure, List<TimeSlotEntity>>> call(GetAvailableTimeSlotsParams params) async {
    return await repository.getAvailableTimeSlots(
      providerId: params.providerId,
      date: params.date,
    );
  }
}

class GetAvailableTimeSlotsParams extends Equatable {
  final String providerId;
  final DateTime date;

  const GetAvailableTimeSlotsParams({
    required this.providerId,
    required this.date,
  });

  @override
  List<Object?> get props => [providerId, date];
}
