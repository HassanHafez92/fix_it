import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'payment_methods_event.dart';
part 'payment_methods_state.dart';

class PaymentMethodsBloc extends Bloc<PaymentMethodsEvent, PaymentMethodsState> {
  PaymentMethodsBloc() : super(PaymentMethodsInitial()) {
    on<LoadPaymentMethodsEvent>(_onLoadPaymentMethods);
    on<AddPaymentMethodEvent>(_onAddPaymentMethod);
    on<DeletePaymentMethodEvent>(_onDeletePaymentMethod);
    on<SetDefaultPaymentMethodEvent>(_onSetDefaultPaymentMethod);
  }

  void _onLoadPaymentMethods(
    LoadPaymentMethodsEvent event,
    Emitter<PaymentMethodsState> emit,
  ) async {
    emit(PaymentMethodsLoading());
    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 1));

      // Mock payment methods data
      final paymentMethods = [
        {
          'id': '1',
          'type': 'credit_card',
          'last4': '1234',
          'expiryDate': '12/25',
          'cardholderName': 'John Doe',
          'isDefault': true,
        },
        {
          'id': '2',
          'type': 'paypal',
          'email': 'john.doe@example.com',
          'isDefault': false,
        },
      ];

      final defaultPaymentMethod = paymentMethods.firstWhere(
        (method) => method['isDefault'] == true,
        orElse: () => paymentMethods.first,
      );

      emit(PaymentMethodsLoaded(
        paymentMethods: paymentMethods,
        defaultPaymentMethod: defaultPaymentMethod,
      ));
    } catch (e) {
      emit(PaymentMethodsError(message: e.toString()));
    }
  }

  void _onAddPaymentMethod(
    AddPaymentMethodEvent event,
    Emitter<PaymentMethodsState> emit,
  ) async {
    if (state is PaymentMethodsLoaded) {
      final currentState = state as PaymentMethodsLoaded;

      emit(PaymentMethodsLoading());
      try {
        // Simulate API call
        await Future.delayed(const Duration(seconds: 1));

        // Create new payment method
        final newPaymentMethod = {
          'id': DateTime.now().millisecondsSinceEpoch.toString(),
          'type': event.type,
          ...event.details,
          'isDefault': currentState.paymentMethods.isEmpty,
        };

        final updatedPaymentMethods = [...currentState.paymentMethods, newPaymentMethod];

        final defaultPaymentMethod = updatedPaymentMethods.firstWhere(
          (method) => method['isDefault'] == true,
          orElse: () => updatedPaymentMethods.first,
        );

        emit(PaymentMethodsLoaded(
          paymentMethods: updatedPaymentMethods,
          defaultPaymentMethod: defaultPaymentMethod,
        ));
      } catch (e) {
        emit(PaymentMethodsError(message: e.toString()));
        emit(currentState);
      }
    }
  }

  void _onDeletePaymentMethod(
    DeletePaymentMethodEvent event,
    Emitter<PaymentMethodsState> emit,
  ) async {
    if (state is PaymentMethodsLoaded) {
      final currentState = state as PaymentMethodsLoaded;

      emit(PaymentMethodsLoading());
      try {
        // Simulate API call
        await Future.delayed(const Duration(seconds: 1));

        final updatedPaymentMethods = currentState.paymentMethods
            .where((method) => method['id'] != event.paymentMethodId)
            .toList();

        dynamic defaultPaymentMethod;

        if (currentState.defaultPaymentMethod['id'] == event.paymentMethodId) {
          // If we deleted the default, make the first one the new default
          if (updatedPaymentMethods.isNotEmpty) {
            defaultPaymentMethod = updatedPaymentMethods.first;
            // Update the isDefault flag
            defaultPaymentMethod['isDefault'] = true;
          }
        } else {
          defaultPaymentMethod = currentState.defaultPaymentMethod;
        }

        emit(PaymentMethodsLoaded(
          paymentMethods: updatedPaymentMethods,
          defaultPaymentMethod: defaultPaymentMethod,
        ));

        emit(PaymentMethodDeleted());
      } catch (e) {
        emit(PaymentMethodsError(message: e.toString()));
        emit(currentState);
      }
    }
  }

  void _onSetDefaultPaymentMethod(
    SetDefaultPaymentMethodEvent event,
    Emitter<PaymentMethodsState> emit,
  ) async {
    if (state is PaymentMethodsLoaded) {
      final currentState = state as PaymentMethodsLoaded;

      emit(PaymentMethodsLoading());
      try {
        // Simulate API call
        await Future.delayed(const Duration(seconds: 1));

        final updatedPaymentMethods = currentState.paymentMethods.map((method) {
          return {
            ...method,
            'isDefault': method['id'] == event.paymentMethodId,
          };
        }).toList();

        final defaultPaymentMethod = updatedPaymentMethods.firstWhere(
          (method) => method['id'] == event.paymentMethodId,
        );

        emit(PaymentMethodsLoaded(
          paymentMethods: updatedPaymentMethods,
          defaultPaymentMethod: defaultPaymentMethod,
        ));

        emit(DefaultPaymentMethodUpdated());
      } catch (e) {
        emit(PaymentMethodsError(message: e.toString()));
        emit(currentState);
      }
    }
  }
}
