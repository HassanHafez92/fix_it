part of 'bookings_bloc.dart';

abstract class BookingsEvent extends Equatable {
  const BookingsEvent();

  @override
  List<Object?> get props => [];
}

class GetUserBookingsEvent extends BookingsEvent {}

class GetBookingDetailsEvent extends BookingsEvent {
  final String bookingId;

  const GetBookingDetailsEvent({required this.bookingId});

  @override
  List<Object?> get props => [bookingId];
}

class CancelBookingEvent extends BookingsEvent {
  final String bookingId;
  final String reason;

  const CancelBookingEvent({
    required this.bookingId,
    required this.reason,
  });

  @override
  List<Object?> get props => [bookingId, reason];
}

class FilterBookingsEvent extends BookingsEvent {
  final BookingStatus? status;

  const FilterBookingsEvent({this.status});

  @override
  List<Object?> get props => [status];
}

class ClientConfirmCompletionEvent extends BookingsEvent {
  final String bookingId;

  const ClientConfirmCompletionEvent({required this.bookingId});

  @override
  List<Object?> get props => [bookingId];
}

class RescheduleBookingEvent extends BookingsEvent {
  final String bookingId;
  final DateTime newDate;
  final String newTimeSlot;

  const RescheduleBookingEvent({
    required this.bookingId,
    required this.newDate,
    required this.newTimeSlot,
  });

  @override
  List<Object?> get props => [bookingId, newDate, newTimeSlot];
}
