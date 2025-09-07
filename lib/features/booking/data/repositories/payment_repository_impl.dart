import 'package:dartz/dartz.dart';
import 'package:fix_it/core/error/failures.dart';
import 'package:fix_it/core/network/network_info.dart';
import 'package:fix_it/features/booking/data/datasources/payment_local_data_source.dart';
import 'package:fix_it/features/booking/data/datasources/payment_remote_data_source.dart';
import 'package:fix_it/features/booking/domain/entities/payment_method_entity.dart';
import 'package:fix_it/features/booking/domain/repositories/payment_repository.dart';

class PaymentRepositoryImpl implements PaymentRepository {
  final PaymentRemoteDataSource remoteDataSource;
  final PaymentLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  PaymentRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<PaymentMethodEntity>>> getPaymentMethods() async {
    if (await networkInfo.isConnected) {
      try {
        final paymentMethods = await remoteDataSource.getPaymentMethods();
        await localDataSource.cachePaymentMethods(paymentMethods);
        return Right(paymentMethods);
      } catch (e) {
        return Left(ServerFailure(e.toString()));
      }
    } else {
      try {
        final paymentMethods = await localDataSource.getCachedPaymentMethods();
        return Right(paymentMethods);
      } catch (e) {
        return Left(CacheFailure('No cached payment methods available'));
      }
    }
  }

  @override
  Future<Either<Failure, bool>> processPayment({
    required String bookingId,
    required String paymentMethodId,
    required double amount,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await remoteDataSource.processPayment(
          bookingId: bookingId,
          paymentMethodId: paymentMethodId,
          amount: amount,
        );
        return Right(result);
      } catch (e) {
        return Left(ServerFailure(e.toString()));
      }
    } else {
      return Left(NetworkFailure('No internet connection'));
    }
  }

  @override
  Future<Either<Failure, bool>> addPaymentMethod({
    required String type,
    required String cardNumber,
    required String expiryDate,
    required String cvv,
    required String cardholderName,
    bool isDefault = false,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await remoteDataSource.addPaymentMethod(
          type: type,
          cardNumber: cardNumber,
          expiryDate: expiryDate,
          cvv: cvv,
          cardholderName: cardholderName,
          isDefault: isDefault,
        );

        if (result) {
          // Refresh the cached payment methods
          final paymentMethods = await remoteDataSource.getPaymentMethods();
          await localDataSource.cachePaymentMethods(paymentMethods);
        }

        return Right(result);
      } catch (e) {
        return Left(ServerFailure(e.toString()));
      }
    } else {
      return Left(NetworkFailure('No internet connection'));
    }
  }

  @override
  Future<Either<Failure, bool>> deletePaymentMethod(String paymentMethodId) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await remoteDataSource.deletePaymentMethod(paymentMethodId);

        if (result) {
          // Refresh the cached payment methods
          final paymentMethods = await remoteDataSource.getPaymentMethods();
          await localDataSource.cachePaymentMethods(paymentMethods);
        }

        return Right(result);
      } catch (e) {
        return Left(ServerFailure(e.toString()));
      }
    } else {
      return Left(NetworkFailure('No internet connection'));
    }
  }

  @override
  Future<Either<Failure, bool>> setDefaultPaymentMethod(String paymentMethodId) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await remoteDataSource.setDefaultPaymentMethod(paymentMethodId);

        if (result) {
          // Refresh the cached payment methods
          final paymentMethods = await remoteDataSource.getPaymentMethods();
          await localDataSource.cachePaymentMethods(paymentMethods);
        }

        return Right(result);
      } catch (e) {
        return Left(ServerFailure(e.toString()));
      }
    } else {
      return Left(NetworkFailure('No internet connection'));
    }
  }
}
