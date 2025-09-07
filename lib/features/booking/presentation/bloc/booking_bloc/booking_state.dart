part of 'booking_bloc.dart';

abstract class BookingState extends Equatable {
  const BookingState();

  @override
  List<Object?> get props => [];
}

class BookingInitial extends BookingState {
  final String? providerId;
  final String? serviceId;

  const BookingInitial({
    this.providerId,
    this.serviceId,
  });

  @override
  List<Object?> get props => [providerId, serviceId];
}

class BookingServiceSelection extends BookingState {
  final dynamic service;
  final String? providerId;
  final List<dynamic> services;

  const BookingServiceSelection({
    required this.service,
    this.providerId,
    this.services = const [],
  });

  @override
  List<Object?> get props => [service, providerId, services];
}

class BookingProviderSelection extends BookingState {
  final dynamic service;
  final dynamic provider;
  final List<dynamic> providers;
  final DateTime? selectedDate;
  final TimeOfDay? selectedTime;

  const BookingProviderSelection({
    required this.service,
    required this.provider,
    this.providers = const [],
    this.selectedDate,
    this.selectedTime,
  });

  @override
  List<Object?> get props => [service, provider, providers, selectedDate, selectedTime];
}

class BookingDateTimeSelection extends BookingState {
  final dynamic service;
  final dynamic provider;
  final DateTime? selectedDate;
  final TimeOfDay? selectedTime;

  const BookingDateTimeSelection({
    required this.service,
    required this.provider,
    this.selectedDate,
    this.selectedTime,
  });

  @override
  List<Object?> get props => [service, provider, selectedDate, selectedTime];
}

class BookingAddressSelection extends BookingState {
  final dynamic service;
  final dynamic provider;
  final DateTime dateTime;
  final String address;
  final String city;
  final String postalCode;
  final String notes;

  const BookingAddressSelection({
    required this.service,
    required this.provider,
    required this.dateTime,
    this.address = '',
    this.city = '',
    this.postalCode = '',
    this.notes = '',
  });

  @override
  List<Object?> get props => [
    service,
    provider,
    dateTime,
    address,
    city,
    postalCode,
    notes,
  ];
}

class BookingPaymentSelection extends BookingState {
  final dynamic service;
  final dynamic provider;
  final DateTime dateTime;
  final String address;
  final String city;
  final String postalCode;
  final String notes;
  final List<dynamic> paymentMethods;
  final dynamic selectedPaymentMethod;

  const BookingPaymentSelection({
    required this.service,
    required this.provider,
    required this.dateTime,
    required this.address,
    required this.city,
    required this.postalCode,
    required this.notes,
    this.paymentMethods = const [],
    this.selectedPaymentMethod,
  });

  @override
  List<Object?> get props => [
    service,
    provider,
    dateTime,
    address,
    city,
    postalCode,
    notes,
    paymentMethods,
    selectedPaymentMethod,
  ];
}

class BookingSummary extends BookingState {
  final dynamic service;
  final dynamic provider;
  final DateTime dateTime;
  final String address;
  final String city;
  final String postalCode;
  final String notes;
  final List<dynamic> paymentMethods;
  final dynamic selectedPaymentMethod;

  const BookingSummary({
    required this.service,
    required this.provider,
    required this.dateTime,
    required this.address,
    required this.city,
    required this.postalCode,
    required this.notes,
    required this.paymentMethods,
    required this.selectedPaymentMethod,
  });

  @override
  List<Object?> get props => [
    service,
    provider,
    dateTime,
    address,
    city,
    postalCode,
    notes,
    paymentMethods,
    selectedPaymentMethod,
  ];
}

class BookingLoading extends BookingState {}

class BookingSuccess extends BookingState {
  final String bookingId;

  const BookingSuccess({required this.bookingId});

  @override
  List<Object?> get props => [bookingId];
}

class BookingFailure extends BookingState {
  final String message;

  const BookingFailure(this.message);

  @override
  List<Object?> get props => [message];
}
