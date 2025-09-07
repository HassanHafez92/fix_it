part of 'bookings_bloc.dart';

abstract class BookingsState extends Equatable {
  const BookingsState();

  @override
  List<Object?> get props => [];
}

class BookingsInitial extends BookingsState {}

class BookingsLoading extends BookingsState {}

class BookingsLoaded extends BookingsState {
  final List<BookingEntity> bookings;

  const BookingsLoaded(this.bookings);

  @override
  List<Object?> get props => [bookings];
}

class BookingsFiltered extends BookingsState {
  final List<BookingEntity> bookings;
  final BookingStatus? filterStatus;

  const BookingsFiltered(this.bookings, this.filterStatus);

  @override
  List<Object?> get props => [bookings, filterStatus];
}

class BookingsError extends BookingsState {
  final String message;

  const BookingsError(this.message);

  @override
  List<Object?> get props => [message];
}

class BookingDetailsLoading extends BookingsState {}

class BookingDetailsLoaded extends BookingsState {
  final BookingEntity booking;

  const BookingDetailsLoaded(this.booking);

  @override
  List<Object?> get props => [booking];
}

class BookingDetailsError extends BookingsState {
  final String message;

  const BookingDetailsError(this.message);

  @override
  List<Object?> get props => [message];
}

class BookingCancelling extends BookingsState {}

class BookingCancelError extends BookingsState {
  final String message;

  const BookingCancelError(this.message);

  @override
  List<Object?> get props => [message];
}

class BookingRescheduling extends BookingsState {}

class BookingRescheduleError extends BookingsState {
  final String message;

  const BookingRescheduleError(this.message);

  @override
  List<Object?> get props => [message];
}
