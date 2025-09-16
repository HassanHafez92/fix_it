import 'package:dartz/dartz.dart';
import 'package:fix_it/core/error/failures.dart';
import 'package:fix_it/core/usecases/usecase.dart';
import 'package:fix_it/features/booking/domain/entities/payment_method_entity.dart';
import 'package:fix_it/features/booking/domain/repositories/payment_repository.dart';

class GetPaymentMethodsUseCase implements UseCase<List<PaymentMethodEntity>, NoParams> {
  final PaymentRepository repository;

  GetPaymentMethodsUseCase(this.repository);

  @override
  Future<Either<Failure, List<PaymentMethodEntity>>> call(NoParams params) async {
    return await repository.getPaymentMethods();
  }
}
