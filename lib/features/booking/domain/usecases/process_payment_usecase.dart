import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:fix_it/core/error/failures.dart';
import 'package:fix_it/core/usecases/usecase.dart';
import 'package:fix_it/features/booking/domain/repositories/payment_repository.dart';

class ProcessPaymentUseCase implements UseCase<bool, ProcessPaymentParams> {
  final PaymentRepository repository;

  ProcessPaymentUseCase(this.repository);

  @override
  Future<Either<Failure, bool>> call(ProcessPaymentParams params) async {
    return await repository.processPayment(
      bookingId: params.bookingId,
      paymentMethodId: params.paymentMethodId,
      amount: params.amount,
    );
  }
}

class ProcessPaymentParams extends Equatable {
  final String bookingId;
  final String paymentMethodId;
  final double amount;

  const ProcessPaymentParams({
    required this.bookingId,
    required this.paymentMethodId,
    required this.amount,
  });

  @override
  List<Object> get props => [bookingId, paymentMethodId, amount];
}
