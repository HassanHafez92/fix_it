import 'package:equatable/equatable.dart';
import 'package:fix_it/features/booking/domain/entities/payment_method_entity.dart';
import 'package:fix_it/features/booking/domain/usecases/get_payment_methods_usecase.dart';
import 'package:fix_it/features/booking/domain/usecases/process_payment_usecase.dart';
import 'package:fix_it/core/usecases/usecase.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'payment_event.dart';
part 'payment_state.dart';

class PaymentBloc extends Bloc<PaymentEvent, PaymentState> {
  final GetPaymentMethodsUseCase getPaymentMethodsUseCase;
  final ProcessPaymentUseCase processPaymentUseCase;

  PaymentBloc({
    required this.getPaymentMethodsUseCase,
    required this.processPaymentUseCase,
  }) : super(PaymentInitial()) {
    on<LoadPaymentMethodsEvent>(_onLoadPaymentMethods);
    on<ProcessPaymentEvent>(_onProcessPayment);
  }

  void _onLoadPaymentMethods(
    LoadPaymentMethodsEvent event,
    Emitter<PaymentState> emit,
  ) async {
    emit(PaymentMethodsLoading());

    try {
      final result = await getPaymentMethodsUseCase(NoParamsImpl());

      result.fold(
        (failure) => emit(PaymentMethodsError(failure.message)),
        (paymentMethods) => emit(PaymentMethodsLoaded(paymentMethods)),
      );
    } catch (e) {
      emit(PaymentMethodsError(e.toString()));
    }
  }

  void _onProcessPayment(
    ProcessPaymentEvent event,
    Emitter<PaymentState> emit,
  ) async {
    emit(PaymentProcessing());

    try {
      final result = await processPaymentUseCase(
        ProcessPaymentParams(
          bookingId: event.bookingId,
          paymentMethodId: event.paymentMethodId,
          amount: event.amount,
        ),
      );

      result.fold(
        (failure) => emit(PaymentError(failure.message)),
        (success) => emit(PaymentSuccess()),
      );
    } catch (e) {
      emit(PaymentError(e.toString()));
    }
  }
}
