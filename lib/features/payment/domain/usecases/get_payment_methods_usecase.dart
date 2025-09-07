import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/payment_method_entity.dart';
import '../repositories/payment_methods_repository.dart';

/// Use case for retrieving all payment methods for a user.
/// 
/// This use case encapsulates the business logic for getting payment methods,
/// including any validation or business rules that should be applied.
class GetPaymentMethodsUseCase implements UseCase<List<PaymentMethodEntity>, GetPaymentMethodsParams> {
  final PaymentMethodsRepository repository;

  GetPaymentMethodsUseCase(this.repository);

  @override
  Future<Either<Failure, List<PaymentMethodEntity>>> call(GetPaymentMethodsParams params) async {
    // Validate input parameters
    if (params.userId.isEmpty) {
      return Left(ValidationFailure('User ID cannot be empty'));
    }

    // Get payment methods from repository
    final result = await repository.getPaymentMethods(params.userId);

    return result.fold(
      (failure) => Left(failure),
      (paymentMethods) {
        // Apply business logic: sort by default first, then by creation date
        final sortedMethods = List<PaymentMethodEntity>.from(paymentMethods);
        sortedMethods.sort((a, b) {
          // Default payment methods come first
          if (a.isDefault && !b.isDefault) return -1;
          if (!a.isDefault && b.isDefault) return 1;

          // Then sort by creation date (newest first)
          return b.createdAt.compareTo(a.createdAt);
        });

        return Right(sortedMethods);
      },
    );
  }
}

/// Parameters for the GetPaymentMethodsUseCase
class GetPaymentMethodsParams {
  final String userId;

  const GetPaymentMethodsParams({
    required this.userId,
  });
}
