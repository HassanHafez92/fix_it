part of 'payment_bloc.dart';

abstract class PaymentEvent extends Equatable {
  const PaymentEvent();

  @override
  List<Object> get props => [];
}

class LoadPaymentMethodsEvent extends PaymentEvent {
  const LoadPaymentMethodsEvent();
}

class ProcessPaymentEvent extends PaymentEvent {
  final String bookingId;
  final String paymentMethodId;
  final double amount;

  const ProcessPaymentEvent({
    required this.bookingId,
    required this.paymentMethodId,
    required this.amount,
  });

  @override
  List<Object> get props => [bookingId, paymentMethodId, amount];
}
