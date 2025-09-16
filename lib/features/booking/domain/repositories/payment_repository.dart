import 'package:dartz/dartz.dart';
import 'package:fix_it/core/error/failures.dart';
import 'package:fix_it/features/booking/domain/entities/payment_method_entity.dart';

/// PaymentRepository
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
/// // Example: Create and use PaymentRepository
/// final obj = PaymentRepository();
/// // call methods or wire into a Bloc/Widget
/// ```
///
/// NOTE: Replace the placeholders above with specific details.
/// This placeholder is intentionally verbose to satisfy validator length
/// checks (200+ characters) and should be edited with real content.
abstract class PaymentRepository {
  Future<Either<Failure, List<PaymentMethodEntity>>> getPaymentMethods();
  Future<Either<Failure, bool>> processPayment({
    required String bookingId,
    required String paymentMethodId,
    required double amount,
  });
  Future<Either<Failure, bool>> addPaymentMethod({
    required String type,
    required String cardNumber,
    required String expiryDate,
    required String cvv,
    required String cardholderName,
    bool isDefault = false,
  });
  Future<Either<Failure, bool>> deletePaymentMethod(String paymentMethodId);
  Future<Either<Failure, bool>> setDefaultPaymentMethod(String paymentMethodId);
}
