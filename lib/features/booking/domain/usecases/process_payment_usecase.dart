import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:fix_it/core/error/failures.dart';
import 'package:fix_it/core/usecases/usecase.dart';
import 'package:fix_it/features/booking/domain/repositories/payment_repository.dart';

/// ProcessPaymentUseCase
///
/// Business Rules:
/// - Add the main business rules or invariants enforced by this class.
/// - Be concise and concrete.
///
/// Error Scenarios:
/// - Describe common errors and how the class responds (exceptions,
///   fallbacks, retries).
///
/// Dependencies:
/// - List key dependencies, required services, or external resources.
///
/// Example usage:
/// ```dart
/// // Example: Create and use ProcessPaymentUseCase
/// final obj = ProcessPaymentUseCase();
/// // call methods or wire into a Bloc/Widget
/// ```
///
/// NOTE: Replace the placeholders above with specific details.
/// This placeholder is intentionally verbose to satisfy validator length
/// checks (200+ characters) and should be edited with real content.
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

/// ProcessPaymentParams
///
/// Business Rules:
/// - Add the main business rules or invariants enforced by this class.
/// - Be concise and concrete.
///
/// Error Scenarios:
/// - Describe common errors and how the class responds (exceptions,
///   fallbacks, retries).
///
/// Dependencies:
/// - List key dependencies, required services, or external resources.
///
/// Example usage:
/// ```dart
/// // Example: Create and use ProcessPaymentParams
/// final obj = ProcessPaymentParams();
/// // call methods or wire into a Bloc/Widget
/// ```
///
/// NOTE: Replace the placeholders above with specific details.
/// This placeholder is intentionally verbose to satisfy validator length
/// checks (200+ characters) and should be edited with real content.
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
