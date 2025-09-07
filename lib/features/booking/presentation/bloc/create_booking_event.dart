part of 'create_booking_bloc.dart';

abstract class CreateBookingEvent extends Equatable {
  const CreateBookingEvent();

  @override
  List<Object?> get props => [];
}

class GetAvailableTimeSlotsEvent extends CreateBookingEvent {
  final String providerId;
  final DateTime date;

  const GetAvailableTimeSlotsEvent({
    required this.providerId,
    required this.date,
  });

  @override
  List<Object?> get props => [providerId, date];
}

class CreateBookingSubmittedEvent extends CreateBookingEvent {
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

  const CreateBookingSubmittedEvent({
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

class ResetCreateBookingEvent extends CreateBookingEvent {}
