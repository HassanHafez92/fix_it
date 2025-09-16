import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/payment_methods_repository.dart';

/// Use case for setting a default payment method.
/// 
/// This use case encapsulates the business logic for setting a payment method
/// as the default, including validation and business rules.
class SetDefaultPaymentMethodUseCase implements UseCase<void, SetDefaultPaymentMethodParams> {
  final PaymentMethodsRepository repository;

  SetDefaultPaymentMethodUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(SetDefaultPaymentMethodParams params) async {
    // Validate input parameters
    if (params.userId.isEmpty) {
      return Left(ValidationFailure('User ID cannot be empty'));
    }

    if (params.paymentMethodId.isEmpty) {
      return Left(ValidationFailure('Payment method ID cannot be empty'));
    }

    // Business rule: Verify that the payment method belongs to the user
    final userPaymentMethodsResult = await repository.getPaymentMethods(params.userId);

    return userPaymentMethodsResult.fold(
      (failure) => Left(failure),
      (paymentMethods) async {
        // Check if the payment method exists and belongs to the user
        final paymentMethodExists = paymentMethods.any(
          (method) => method.id == params.paymentMethodId && method.userId == params.userId,
        );

        if (!paymentMethodExists) {
          return Left(BusinessLogicFailure(
            'Payment method does not exist or does not belong to the user',
          ));
        }

        // Check if the payment method is active
        final paymentMethod = paymentMethods.firstWhere(
          (method) => method.id == params.paymentMethodId,
        );

        if (!paymentMethod.isActive) {
          return Left(BusinessLogicFailure(
            'Cannot set an inactive payment method as default',
          ));
        }

        // Check if the payment method is expired (for cards)
        if (paymentMethod.isExpired) {
          return Left(BusinessLogicFailure(
            'Cannot set an expired payment method as default',
          ));
        }

        // Set as default through repository
        return await repository.setDefaultPaymentMethod(params.userId, params.paymentMethodId);
      },
    );
  }
}

/// Parameters for the SetDefaultPaymentMethodUseCase
class SetDefaultPaymentMethodParams {
  final String userId;
  final String paymentMethodId;

  const SetDefaultPaymentMethodParams({
    required this.userId,
    required this.paymentMethodId,
  });
}
