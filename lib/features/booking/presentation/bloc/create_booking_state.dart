part of 'create_booking_bloc.dart';

abstract class CreateBookingState extends Equatable {
  const CreateBookingState();

  @override
  List<Object?> get props => [];
}

class CreateBookingInitial extends CreateBookingState {}

class TimeSlotsLoading extends CreateBookingState {}

class TimeSlotsLoaded extends CreateBookingState {
  final List<TimeSlotEntity> timeSlots;

  const TimeSlotsLoaded(this.timeSlots);

  @override
  List<Object?> get props => [timeSlots];
}

class TimeSlotsError extends CreateBookingState {
  final String message;

  const TimeSlotsError(this.message);

  @override
  List<Object?> get props => [message];
}

class BookingCreating extends CreateBookingState {}

class BookingCreated extends CreateBookingState {
  final BookingEntity booking;

  const BookingCreated(this.booking);

  @override
  List<Object?> get props => [booking];
}

class BookingCreationError extends CreateBookingState {
  final String message;

  const BookingCreationError(this.message);

  @override
  List<Object?> get props => [message];
}
