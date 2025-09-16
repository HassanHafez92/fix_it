import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/payment_methods_repository.dart';

/// Use case for deleting a payment method.
/// 
/// This use case encapsulates the business logic for deleting payment methods,
/// including validation and business rules.
class DeletePaymentMethodUseCase implements UseCase<void, DeletePaymentMethodParams> {
  final PaymentMethodsRepository repository;

  DeletePaymentMethodUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(DeletePaymentMethodParams params) async {
    // Validate input parameters
    if (params.paymentMethodId.isEmpty) {
      return Left(ValidationFailure('Payment method ID cannot be empty'));
    }

    // Business rule: Check if this is the user's only payment method
    if (params.userId.isNotEmpty) {
      final paymentMethodsResult = await repository.getPaymentMethods(params.userId);

      final paymentMethods = paymentMethodsResult.fold(
        (failure) => <dynamic>[], // If we can't get payment methods, proceed with deletion
        (methods) => methods,
      );

      // If this is the only payment method and forceDelete is false, prevent deletion
      if (paymentMethods.length == 1 && !params.forceDelete) {
        return Left(BusinessLogicFailure(
          'Cannot delete the only payment method. Please add another payment method first.',
        ));
      }
    }

    // Delete payment method through repository
    return await repository.deletePaymentMethod(params.paymentMethodId);
  }
}

/// Parameters for the DeletePaymentMethodUseCase
class DeletePaymentMethodParams {
  final String paymentMethodId;
  final String userId;
  final bool forceDelete;

  const DeletePaymentMethodParams({
    required this.paymentMethodId,
    required this.userId,
    this.forceDelete = false,
  });
}
