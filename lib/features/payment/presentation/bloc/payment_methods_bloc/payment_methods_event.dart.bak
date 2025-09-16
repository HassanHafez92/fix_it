part of 'payment_methods_bloc.dart';

abstract class PaymentMethodsEvent extends Equatable {
  const PaymentMethodsEvent();

  @override
  List<Object> get props => [];
}

class LoadPaymentMethodsEvent extends PaymentMethodsEvent {
  const LoadPaymentMethodsEvent();
}

class AddPaymentMethodEvent extends PaymentMethodsEvent {
  final String type;
  final Map<String, dynamic> details;

  const AddPaymentMethodEvent({
    required this.type,
    required this.details,
  });

  @override
  List<Object> get props => [type, details];
}

class DeletePaymentMethodEvent extends PaymentMethodsEvent {
  final String paymentMethodId;

  const DeletePaymentMethodEvent({
    required this.paymentMethodId,
  });

  @override
  List<Object> get props => [paymentMethodId];
}

class SetDefaultPaymentMethodEvent extends PaymentMethodsEvent {
  final String paymentMethodId;

  const SetDefaultPaymentMethodEvent({
    required this.paymentMethodId,
  });

  @override
  List<Object> get props => [paymentMethodId];
}
