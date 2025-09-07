import 'package:dartz/dartz.dart';
import 'package:fix_it/core/error/failures.dart';
import 'package:fix_it/features/booking/domain/entities/payment_method_entity.dart';

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
