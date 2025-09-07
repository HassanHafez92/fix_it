import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/booking_entity.dart';
import '../repositories/booking_repository.dart';

class CreateBookingUseCase implements UseCase<BookingEntity, CreateBookingParams> {
  final BookingRepository repository;

  CreateBookingUseCase(this.repository);

  @override
  Future<Either<Failure, BookingEntity>> call(CreateBookingParams params) async {
    return await repository.createBooking(
      providerId: params.providerId,
      serviceId: params.serviceId,
      scheduledDate: params.scheduledDate,
      timeSlot: params.timeSlot,
      address: params.address,
      latitude: params.latitude,
      longitude: params.longitude,
      notes: params.notes,
      attachments: params.attachments,
      isUrgent: params.isUrgent,
    );
  }
}

class CreateBookingParams extends Equatable {
  final String providerId;
  final String serviceId;
  final DateTime scheduledDate;
  final String timeSlot;
  final String address;
  final double latitude;
  final double longitude;
  final String? notes;
  final List<String>? attachments;
  final bool isUrgent;

  const CreateBookingParams({
    required this.providerId,
    required this.serviceId,
    required this.scheduledDate,
    required this.timeSlot,
    required this.address,
    required this.latitude,
    required this.longitude,
    this.notes,
    this.attachments,
    this.isUrgent = false,
  });

  @override
  List<Object?> get props => [
        providerId,
        serviceId,
        scheduledDate,
        timeSlot,
        address,
        latitude,
        longitude,
        notes,
        attachments,
        isUrgent,
      ];
}
