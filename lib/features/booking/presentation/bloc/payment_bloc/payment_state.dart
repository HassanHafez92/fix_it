part of 'payment_bloc.dart';

abstract class PaymentState extends Equatable {
  const PaymentState();

  @override
  List<Object> get props => [];
}

class PaymentInitial extends PaymentState {}

class PaymentMethodsLoading extends PaymentState {}

class PaymentMethodsLoaded extends PaymentState {
  final List<PaymentMethodEntity> paymentMethods;

  const PaymentMethodsLoaded(this.paymentMethods);

  @override
  List<Object> get props => [paymentMethods];
}

class PaymentMethodsError extends PaymentState {
  final String message;

  const PaymentMethodsError(this.message);

  @override
  List<Object> get props => [message];
}

class PaymentProcessing extends PaymentState {}

class PaymentSuccess extends PaymentState {}

class PaymentError extends PaymentState {
  final String message;

  const PaymentError(this.message);

  @override
  List<Object> get props => [message];
}
