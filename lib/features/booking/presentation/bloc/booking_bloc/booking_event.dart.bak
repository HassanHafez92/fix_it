part of 'booking_bloc.dart';

abstract class BookingEvent extends Equatable {
  const BookingEvent();

  @override
  List<Object?> get props => [];
}

class StartBookingEvent extends BookingEvent {
  final String? providerId;
  final String? serviceId;

  const StartBookingEvent({
    this.providerId,
    this.serviceId,
  });

  @override
  List<Object?> get props => [providerId, serviceId];
}

class SelectServiceEvent extends BookingEvent {
  final dynamic service;

  const SelectServiceEvent({required this.service});

  @override
  List<Object> get props => [service];
}

class SelectProviderEvent extends BookingEvent {
  final dynamic provider;

  const SelectProviderEvent({required this.provider});

  @override
  List<Object> get props => [provider];
}

class SelectDateEvent extends BookingEvent {
  final DateTime date;

  const SelectDateEvent({required this.date});

  @override
  List<Object> get props => [date];
}

class SelectTimeEvent extends BookingEvent {
  final TimeOfDay time;

  const SelectTimeEvent({required this.time});

  @override
  List<Object> get props => [time];
}

class SelectDateTimeEvent extends BookingEvent {
  final DateTime dateTime;

  const SelectDateTimeEvent({required this.dateTime});

  @override
  List<Object> get props => [dateTime];
}

class UpdateAddressEvent extends BookingEvent {
  final String address;

  const UpdateAddressEvent({required this.address});

  @override
  List<Object> get props => [address];
}

class UpdateCityEvent extends BookingEvent {
  final String city;

  const UpdateCityEvent({required this.city});

  @override
  List<Object> get props => [city];
}

class UpdatePostalCodeEvent extends BookingEvent {
  final String postalCode;

  const UpdatePostalCodeEvent({required this.postalCode});

  @override
  List<Object> get props => [postalCode];
}

class UpdateNotesEvent extends BookingEvent {
  final String notes;

  const UpdateNotesEvent({required this.notes});

  @override
  List<Object> get props => [notes];
}

class SelectPaymentMethodEvent extends BookingEvent {
  final dynamic paymentMethod;

  const SelectPaymentMethodEvent({required this.paymentMethod});

  @override
  List<Object> get props => [paymentMethod];
}

class ConfirmBookingEvent extends BookingEvent {
  const ConfirmBookingEvent();
}

class LoadServicesEvent extends BookingEvent {
  const LoadServicesEvent();
}

class LoadProvidersEvent extends BookingEvent {
  final String? serviceId;

  const LoadProvidersEvent({this.serviceId});

  @override
  List<Object?> get props => [serviceId];
}
