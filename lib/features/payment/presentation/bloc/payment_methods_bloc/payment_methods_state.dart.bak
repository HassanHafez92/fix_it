part of 'payment_methods_bloc.dart';

abstract class PaymentMethodsState extends Equatable {
  const PaymentMethodsState();

  @override
  List<Object> get props => [];
}

class PaymentMethodsInitial extends PaymentMethodsState {}

class PaymentMethodsLoading extends PaymentMethodsState {}

class PaymentMethodsLoaded extends PaymentMethodsState {
  final List<Map<String, dynamic>> paymentMethods;
  final Map<String, dynamic> defaultPaymentMethod;

  const PaymentMethodsLoaded({
    required this.paymentMethods,
    required this.defaultPaymentMethod,
  });

  @override
  List<Object> get props => [paymentMethods, defaultPaymentMethod];
}

class PaymentMethodsError extends PaymentMethodsState {
  final String message;

  const PaymentMethodsError({required this.message});

  @override
  List<Object> get props => [message];
}

class PaymentMethodDeleted extends PaymentMethodsState {}

class DefaultPaymentMethodUpdated extends PaymentMethodsState {}
