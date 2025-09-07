part of 'provider_availability_bloc.dart';

abstract class ProviderAvailabilityEvent extends Equatable {
  const ProviderAvailabilityEvent();

  @override
  List<Object> get props => [];
}

class LoadProviderAvailabilityEvent extends ProviderAvailabilityEvent {
  final String providerId;

  const LoadProviderAvailabilityEvent({
    required this.providerId,
  });

  @override
  List<Object> get props => [providerId];
}

class BookTimeSlotEvent extends ProviderAvailabilityEvent {
  final String providerId;
  final DateTime dateTime;

  const BookTimeSlotEvent({
    required this.providerId,
    required this.dateTime,
  });

  @override
  List<Object> get props => [providerId, dateTime];
}
