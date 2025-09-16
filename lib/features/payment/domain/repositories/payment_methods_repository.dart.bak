// ignore_for_file: unintended_html_in_doc_comment

import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/payment_method_entity.dart';

/// Repository interface for payment methods operations.
/// 
/// This interface defines the contract for payment methods data operations
/// without specifying how the data is retrieved or stored. The actual
/// implementation will be in the data layer.
abstract class PaymentMethodsRepository {
  /// Retrieves all payment methods for a specific user.
  /// 
  /// [userId] - The ID of the user whose payment methods to retrieve
  /// 
  /// Returns:
  /// - Right(List<PaymentMethodEntity>) on success
  /// - Left(Failure) on error
  Future<Either<Failure, List<PaymentMethodEntity>>> getPaymentMethods(String userId);

  /// Adds a new payment method for a user.
  /// 
  /// [paymentMethod] - The payment method entity to add
  /// 
  /// Returns:
  /// - Right(PaymentMethodEntity) on success with the created payment method
  /// - Left(Failure) on error
  Future<Either<Failure, PaymentMethodEntity>> addPaymentMethod(PaymentMethodEntity paymentMethod);

  /// Updates an existing payment method.
  /// 
  /// [paymentMethod] - The payment method entity with updated information
  /// 
  /// Returns:
  /// - Right(PaymentMethodEntity) on success with the updated payment method
  /// - Left(Failure) on error
  Future<Either<Failure, PaymentMethodEntity>> updatePaymentMethod(PaymentMethodEntity paymentMethod);

  /// Deletes a payment method.
  /// 
  /// [paymentMethodId] - The ID of the payment method to delete
  /// 
  /// Returns:
  /// - Right(void) on success
  /// - Left(Failure) on error
  Future<Either<Failure, void>> deletePaymentMethod(String paymentMethodId);

  /// Sets a payment method as the default for a user.
  /// 
  /// [userId] - The ID of the user
  /// [paymentMethodId] - The ID of the payment method to set as default
  /// 
  /// Returns:
  /// - Right(void) on success
  /// - Left(Failure) on error
  Future<Either<Failure, void>> setDefaultPaymentMethod(String userId, String paymentMethodId);

  /// Gets the default payment method for a user.
  /// 
  /// [userId] - The ID of the user
  /// 
  /// Returns:
  /// - Right(PaymentMethodEntity?) on success (null if no default set)
  /// - Left(Failure) on error
  Future<Either<Failure, PaymentMethodEntity?>> getDefaultPaymentMethod(String userId);

  /// Validates a payment method (e.g., verifies card details with payment gateway).
  /// 
  /// [paymentMethodId] - The ID of the payment method to validate
  /// 
  /// Returns:
  /// - Right(bool) on success indicating if valid
  /// - Left(Failure) on error
  Future<Either<Failure, bool>> validatePaymentMethod(String paymentMethodId);
}
