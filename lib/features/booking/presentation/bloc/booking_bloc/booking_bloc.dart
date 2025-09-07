
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';

part 'booking_event.dart';
part 'booking_state.dart';

class BookingBloc extends Bloc<BookingEvent, BookingState> {
  BookingBloc() : super(BookingInitial()) {
    on<StartBookingEvent>(_onStartBooking);
    on<SelectServiceEvent>(_onSelectService);
    on<SelectProviderEvent>(_onSelectProvider);
    on<SelectDateEvent>(_onSelectDate);
    on<SelectTimeEvent>(_onSelectTime);
    on<SelectDateTimeEvent>(_onSelectDateTime);
    on<UpdateAddressEvent>(_onUpdateAddress);
    on<UpdateCityEvent>(_onUpdateCity);
    on<UpdatePostalCodeEvent>(_onUpdatePostalCode);
    on<UpdateNotesEvent>(_onUpdateNotes);
    on<SelectPaymentMethodEvent>(_onSelectPaymentMethod);
    on<ConfirmBookingEvent>(_onConfirmBooking);
    on<LoadServicesEvent>(_onLoadServices);
    on<LoadProvidersEvent>(_onLoadProviders);
  }

  void _onStartBooking(StartBookingEvent event, Emitter<BookingState> emit) {
    emit(BookingInitial(
      providerId: event.providerId,
      serviceId: event.serviceId,
    ));

    // Load services if no service is pre-selected
    if (event.serviceId == null) {
      add(LoadServicesEvent());
    }
  }

  void _onSelectService(SelectServiceEvent event, Emitter<BookingState> emit) {
    if (state is BookingInitial || state is BookingServiceSelection) {
      emit(BookingServiceSelection(
        service: event.service,
        providerId: state is BookingInitial ? (state as BookingInitial).providerId : null,
      ));

      // Load providers for the selected service
      add(LoadProvidersEvent(serviceId: event.service.id));
    }
  }

  void _onSelectProvider(SelectProviderEvent event, Emitter<BookingState> emit) {
    if (state is BookingServiceSelection) {
      emit(BookingProviderSelection(
        service: (state as BookingServiceSelection).service,
        provider: event.provider,
      ));
    }
  }

  void _onSelectDate(SelectDateEvent event, Emitter<BookingState> emit) {
    if (state is BookingProviderSelection) {
      final currentState = state as BookingProviderSelection;
      emit(BookingDateTimeSelection(
        service: currentState.service,
        provider: currentState.provider,
        selectedDate: event.date,
        selectedTime: currentState.selectedTime,
      ));
    } else if (state is BookingDateTimeSelection) {
      final currentState = state as BookingDateTimeSelection;
      emit(BookingDateTimeSelection(
        service: currentState.service,
        provider: currentState.provider,
        selectedDate: event.date,
        selectedTime: currentState.selectedTime,
      ));
    }
  }

  void _onSelectTime(SelectTimeEvent event, Emitter<BookingState> emit) {
    if (state is BookingProviderSelection) {
      final currentState = state as BookingProviderSelection;
      emit(BookingDateTimeSelection(
        service: currentState.service,
        provider: currentState.provider,
        selectedDate: currentState.selectedDate,
        selectedTime: event.time,
      ));
    } else if (state is BookingDateTimeSelection) {
      final currentState = state as BookingDateTimeSelection;
      emit(BookingDateTimeSelection(
        service: currentState.service,
        provider: currentState.provider,
        selectedDate: currentState.selectedDate,
        selectedTime: event.time,
      ));
    }
  }

  void _onSelectDateTime(SelectDateTimeEvent event, Emitter<BookingState> emit) {
    if (state is BookingDateTimeSelection) {
      final currentState = state as BookingDateTimeSelection;
      emit(BookingAddressSelection(
        service: currentState.service,
        provider: currentState.provider,
        dateTime: event.dateTime,
      ));
    }
  }

  void _onUpdateAddress(UpdateAddressEvent event, Emitter<BookingState> emit) {
    if (state is BookingAddressSelection) {
      final currentState = state as BookingAddressSelection;
      emit(BookingAddressSelection(
        service: currentState.service,
        provider: currentState.provider,
        dateTime: currentState.dateTime,
        address: event.address,
        city: currentState.city,
        postalCode: currentState.postalCode,
        notes: currentState.notes,
      ));
    } else if (state is BookingPaymentSelection) {
      final currentState = state as BookingPaymentSelection;
      emit(BookingPaymentSelection(
        service: currentState.service,
        provider: currentState.provider,
        dateTime: currentState.dateTime,
        address: event.address,
        city: currentState.city,
        postalCode: currentState.postalCode,
        notes: currentState.notes,
        paymentMethods: currentState.paymentMethods,
        selectedPaymentMethod: currentState.selectedPaymentMethod,
      ));
    } else if (state is BookingSummary) {
      final currentState = state as BookingSummary;
      emit(BookingSummary(
        service: currentState.service,
        provider: currentState.provider,
        dateTime: currentState.dateTime,
        address: event.address,
        city: currentState.city,
        postalCode: currentState.postalCode,
        notes: currentState.notes,
        paymentMethods: currentState.paymentMethods,
        selectedPaymentMethod: currentState.selectedPaymentMethod,
      ));
    }
  }

  void _onUpdateCity(UpdateCityEvent event, Emitter<BookingState> emit) {
    if (state is BookingAddressSelection) {
      final currentState = state as BookingAddressSelection;
      emit(BookingAddressSelection(
        service: currentState.service,
        provider: currentState.provider,
        dateTime: currentState.dateTime,
        address: currentState.address,
        city: event.city,
        postalCode: currentState.postalCode,
        notes: currentState.notes,
      ));
    } else if (state is BookingPaymentSelection) {
      final currentState = state as BookingPaymentSelection;
      emit(BookingPaymentSelection(
        service: currentState.service,
        provider: currentState.provider,
        dateTime: currentState.dateTime,
        address: currentState.address,
        city: event.city,
        postalCode: currentState.postalCode,
        notes: currentState.notes,
        paymentMethods: currentState.paymentMethods,
        selectedPaymentMethod: currentState.selectedPaymentMethod,
      ));
    } else if (state is BookingSummary) {
      final currentState = state as BookingSummary;
      emit(BookingSummary(
        service: currentState.service,
        provider: currentState.provider,
        dateTime: currentState.dateTime,
        address: currentState.address,
        city: event.city,
        postalCode: currentState.postalCode,
        notes: currentState.notes,
        paymentMethods: currentState.paymentMethods,
        selectedPaymentMethod: currentState.selectedPaymentMethod,
      ));
    }
  }

  void _onUpdatePostalCode(UpdatePostalCodeEvent event, Emitter<BookingState> emit) {
    if (state is BookingAddressSelection) {
      final currentState = state as BookingAddressSelection;
      emit(BookingAddressSelection(
        service: currentState.service,
        provider: currentState.provider,
        dateTime: currentState.dateTime,
        address: currentState.address,
        city: currentState.city,
        postalCode: event.postalCode,
        notes: currentState.notes,
      ));
    } else if (state is BookingPaymentSelection) {
      final currentState = state as BookingPaymentSelection;
      emit(BookingPaymentSelection(
        service: currentState.service,
        provider: currentState.provider,
        dateTime: currentState.dateTime,
        address: currentState.address,
        city: currentState.city,
        postalCode: event.postalCode,
        notes: currentState.notes,
        paymentMethods: currentState.paymentMethods,
        selectedPaymentMethod: currentState.selectedPaymentMethod,
      ));
    } else if (state is BookingSummary) {
      final currentState = state as BookingSummary;
      emit(BookingSummary(
        service: currentState.service,
        provider: currentState.provider,
        dateTime: currentState.dateTime,
        address: currentState.address,
        city: currentState.city,
        postalCode: event.postalCode,
        notes: currentState.notes,
        paymentMethods: currentState.paymentMethods,
        selectedPaymentMethod: currentState.selectedPaymentMethod,
      ));
    }
  }

  void _onUpdateNotes(UpdateNotesEvent event, Emitter<BookingState> emit) {
    if (state is BookingAddressSelection) {
      final currentState = state as BookingAddressSelection;
      emit(BookingAddressSelection(
        service: currentState.service,
        provider: currentState.provider,
        dateTime: currentState.dateTime,
        address: currentState.address,
        city: currentState.city,
        postalCode: currentState.postalCode,
        notes: event.notes,
      ));
    } else if (state is BookingPaymentSelection) {
      final currentState = state as BookingPaymentSelection;
      emit(BookingPaymentSelection(
        service: currentState.service,
        provider: currentState.provider,
        dateTime: currentState.dateTime,
        address: currentState.address,
        city: currentState.city,
        postalCode: currentState.postalCode,
        notes: event.notes,
        paymentMethods: currentState.paymentMethods,
        selectedPaymentMethod: currentState.selectedPaymentMethod,
      ));
    } else if (state is BookingSummary) {
      final currentState = state as BookingSummary;
      emit(BookingSummary(
        service: currentState.service,
        provider: currentState.provider,
        dateTime: currentState.dateTime,
        address: currentState.address,
        city: currentState.city,
        postalCode: currentState.postalCode,
        notes: event.notes,
        paymentMethods: currentState.paymentMethods,
        selectedPaymentMethod: currentState.selectedPaymentMethod,
      ));
    }
  }

  void _onSelectPaymentMethod(SelectPaymentMethodEvent event, Emitter<BookingState> emit) {
    if (state is BookingAddressSelection) {
      final currentState = state as BookingAddressSelection;
      emit(BookingPaymentSelection(
        service: currentState.service,
        provider: currentState.provider,
        dateTime: currentState.dateTime,
        address: currentState.address,
        city: currentState.city,
        postalCode: currentState.postalCode,
        notes: currentState.notes,
        selectedPaymentMethod: event.paymentMethod,
      ));
    } else if (state is BookingPaymentSelection) {
      final currentState = state as BookingPaymentSelection;
      emit(BookingPaymentSelection(
        service: currentState.service,
        provider: currentState.provider,
        dateTime: currentState.dateTime,
        address: currentState.address,
        city: currentState.city,
        postalCode: currentState.postalCode,
        notes: currentState.notes,
        paymentMethods: currentState.paymentMethods,
        selectedPaymentMethod: event.paymentMethod,
      ));
    } else if (state is BookingSummary) {
      final currentState = state as BookingSummary;
      emit(BookingSummary(
        service: currentState.service,
        provider: currentState.provider,
        dateTime: currentState.dateTime,
        address: currentState.address,
        city: currentState.city,
        postalCode: currentState.postalCode,
        notes: currentState.notes,
        paymentMethods: currentState.paymentMethods,
        selectedPaymentMethod: event.paymentMethod,
      ));
    }
  }

  void _onConfirmBooking(ConfirmBookingEvent event, Emitter<BookingState> emit) {
    if (state is BookingSummary) {
      emit(BookingLoading());

      // Here you would typically make an API call to create the booking
      // For now, we'll just simulate a successful booking
      Future.delayed(const Duration(seconds: 2), () {
        emit(BookingSuccess(
          bookingId: 'booking_${DateTime.now().millisecondsSinceEpoch}',
        ));
      });
    }
  }

  void _onLoadServices(LoadServicesEvent event, Emitter<BookingState> emit) {
    emit(BookingLoading());

    // Here you would typically make an API call to load services
    // For now, we'll just simulate loading services
    Future.delayed(const Duration(seconds: 1), () {
      if (state is BookingInitial) {
        final currentState = state as BookingInitial;
        emit(BookingServiceSelection(
          service: null,
          providerId: currentState.providerId,
        ));
      } else if (state is BookingServiceSelection) {
        final currentState = state as BookingServiceSelection;
        emit(BookingServiceSelection(
          service: currentState.service,
          providerId: currentState.providerId,
        ));
      }
    });
  }

  void _onLoadProviders(LoadProvidersEvent event, Emitter<BookingState> emit) {
    emit(BookingLoading());

    // Here you would typically make an API call to load providers
    // For now, we'll just simulate loading providers
    Future.delayed(const Duration(seconds: 1), () {
      if (state is BookingServiceSelection) {
        final currentState = state as BookingServiceSelection;
        emit(BookingServiceSelection(
          service: currentState.service,
          providerId: currentState.providerId,
        ));
      } else if (state is BookingProviderSelection) {
        final currentState = state as BookingProviderSelection;
        emit(BookingProviderSelection(
          service: currentState.service,
          provider: currentState.provider,
        ));
      }
    });
  }
}
