import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/booking_entity.dart';
import '../../domain/entities/time_slot_entity.dart';
import '../../domain/usecases/create_booking_usecase.dart';
import '../../domain/usecases/get_available_time_slots_usecase.dart';

part 'create_booking_event.dart';
part 'create_booking_state.dart';

class CreateBookingBloc extends Bloc<CreateBookingEvent, CreateBookingState> {
  final CreateBookingUseCase createBooking;
  final GetAvailableTimeSlotsUseCase getAvailableTimeSlots;

  CreateBookingBloc({
    required this.createBooking,
    required this.getAvailableTimeSlots,
  }) : super(CreateBookingInitial()) {
    on<GetAvailableTimeSlotsEvent>(_onGetAvailableTimeSlots);
    on<CreateBookingSubmittedEvent>(_onCreateBooking);
    on<ResetCreateBookingEvent>(_onResetCreateBooking);
  }

  Future<void> _onGetAvailableTimeSlots(
    GetAvailableTimeSlotsEvent event,
    Emitter<CreateBookingState> emit,
  ) async {
    emit(TimeSlotsLoading());
    final result = await getAvailableTimeSlots(GetAvailableTimeSlotsParams(
      providerId: event.providerId,
      date: event.date,
    ));
    result.fold(
      (failure) => emit(TimeSlotsError(failure.message)),
      (timeSlots) => emit(TimeSlotsLoaded(timeSlots)),
    );
  }

  Future<void> _onCreateBooking(
    CreateBookingSubmittedEvent event,
    Emitter<CreateBookingState> emit,
  ) async {
    emit(BookingCreating());
    final result = await createBooking(CreateBookingParams(
      providerId: event.providerId,
      serviceId: event.serviceId,
      scheduledDate: event.scheduledDate,
      timeSlot: event.timeSlot,
      address: event.address,
      latitude: event.latitude,
      longitude: event.longitude,
      notes: event.notes,
      attachments: event.attachments,
      isUrgent: event.isUrgent,
    ));
    result.fold(
      (failure) => emit(BookingCreationError(failure.message)),
      (booking) => emit(BookingCreated(booking)),
    );
  }

  Future<void> _onResetCreateBooking(
    ResetCreateBookingEvent event,
    Emitter<CreateBookingState> emit,
  ) async {
    emit(CreateBookingInitial());
  }
}
