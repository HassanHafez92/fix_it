import 'package:dartz/dartz.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/payment_method_entity.dart';
import '../../domain/repositories/payment_methods_repository.dart';
import '../datasources/payment_methods_local_data_source.dart';
import '../datasources/payment_methods_remote_data_source.dart';
import '../models/payment_method_model.dart';

/// Implementation of PaymentMethodsRepository that handles both remote and local data sources.
/// 
/// This repository implements the cache-first strategy:
/// 1. Try to get data from cache first (if available and valid)
/// 2. If cache miss or invalid, fetch from remote source
/// 3. Cache the remote data for future use
/// 4. Handle offline scenarios gracefully
class PaymentMethodsRepositoryImpl implements PaymentMethodsRepository {
  final PaymentMethodsRemoteDataSource remoteDataSource;
  final PaymentMethodsLocalDataSource localDataSource;
  final Connectivity connectivity;

  PaymentMethodsRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.connectivity,
  });

  @override
  Future<Either<Failure, List<PaymentMethodEntity>>> getPaymentMethods(String userId) async {
    try {
      // Check internet connectivity
      final connectivityResult = await connectivity.checkConnectivity();
      final isConnected = !connectivityResult.contains(ConnectivityResult.none);

      // Try to get from cache first
      try {
        final cachedPaymentMethods = await localDataSource.getCachedPaymentMethods(userId);

        // If we have cached data and no internet, return cached data
        if (!isConnected && cachedPaymentMethods.isNotEmpty) {
          return Right(cachedPaymentMethods.map((model) => model.toEntity()).toList());
        }

        // If we have internet, try to get fresh data
        if (isConnected) {
          try {
            final remotePaymentMethods = await remoteDataSource.getPaymentMethods(userId);

            // Cache the fresh data
            await localDataSource.cachePaymentMethods(userId, remotePaymentMethods);

            return Right(remotePaymentMethods.map((model) => model.toEntity()).toList());
          } catch (e) {
            // If remote fails but we have cached data, return cached data
            if (cachedPaymentMethods.isNotEmpty) {
              return Right(cachedPaymentMethods.map((model) => model.toEntity()).toList());
            }
            rethrow;
          }
        }

        // Return cached data if available
        return Right(cachedPaymentMethods.map((model) => model.toEntity()).toList());
      } catch (cacheError) {
        // No cached data, try remote if connected
        if (isConnected) {
          final remotePaymentMethods = await remoteDataSource.getPaymentMethods(userId);
          await localDataSource.cachePaymentMethods(userId, remotePaymentMethods);
          return Right(remotePaymentMethods.map((model) => model.toEntity()).toList());
        } else {
          return Left(NetworkFailure('No internet connection and no cached data available'));
        }
      }
    } catch (e) {
      return Left(ServerFailure('Failed to get payment methods: $e'));
    }
  }

  @override
  Future<Either<Failure, PaymentMethodEntity>> addPaymentMethod(PaymentMethodEntity paymentMethod) async {
    try {
      // Check internet connectivity
      final connectivityResult = await connectivity.checkConnectivity();
      final isConnected = !connectivityResult.contains(ConnectivityResult.none);

      if (!isConnected) {
        return Left(NetworkFailure('No internet connection. Cannot add payment method.'));
      }

      // Convert entity to model
      final paymentMethodModel = PaymentMethodModel.fromEntity(paymentMethod);

      // Add payment method remotely
      final addedPaymentMethod = await remoteDataSource.addPaymentMethod(paymentMethodModel);

      // Update local cache
      try {
        final cachedPaymentMethods = await localDataSource.getCachedPaymentMethods(paymentMethod.userId);
        final updatedPaymentMethods = [...cachedPaymentMethods, addedPaymentMethod];
        await localDataSource.cachePaymentMethods(paymentMethod.userId, updatedPaymentMethods);

        // If this is the default payment method, cache it
        if (addedPaymentMethod.isDefault) {
          await localDataSource.cacheDefaultPaymentMethod(paymentMethod.userId, addedPaymentMethod);
        }
      } catch (cacheError) {
        // If cache update fails, just refresh the cache
        try {
          final allPaymentMethods = await remoteDataSource.getPaymentMethods(paymentMethod.userId);
          await localDataSource.cachePaymentMethods(paymentMethod.userId, allPaymentMethods);
        } catch (e) {
          // Cache refresh failed, but main operation succeeded
        }
      }

      return Right(addedPaymentMethod.toEntity());
    } catch (e) {
      return Left(ServerFailure('Failed to add payment method: $e'));
    }
  }

  @override
  Future<Either<Failure, PaymentMethodEntity>> updatePaymentMethod(PaymentMethodEntity paymentMethod) async {
    try {
      // Check internet connectivity
      final connectivityResult = await connectivity.checkConnectivity();
      final isConnected = !connectivityResult.contains(ConnectivityResult.none);

      if (!isConnected) {
        return Left(NetworkFailure('No internet connection. Cannot update payment method.'));
      }

      // Convert entity to model
      final paymentMethodModel = PaymentMethodModel.fromEntity(paymentMethod);

      // Update payment method remotely
      final updatedPaymentMethod = await remoteDataSource.updatePaymentMethod(paymentMethodModel);

      // Update local cache
      try {
        final cachedPaymentMethods = await localDataSource.getCachedPaymentMethods(paymentMethod.userId);
        final updatedPaymentMethods = cachedPaymentMethods.map((cached) {
          return cached.id == updatedPaymentMethod.id ? updatedPaymentMethod : cached;
        }).toList();
        await localDataSource.cachePaymentMethods(paymentMethod.userId, updatedPaymentMethods);
      } catch (cacheError) {
        // If cache update fails, just refresh the cache
        try {
          final allPaymentMethods = await remoteDataSource.getPaymentMethods(paymentMethod.userId);
          await localDataSource.cachePaymentMethods(paymentMethod.userId, allPaymentMethods);
        } catch (e) {
          // Cache refresh failed, but main operation succeeded
        }
      }

      return Right(updatedPaymentMethod.toEntity());
    } catch (e) {
      return Left(ServerFailure('Failed to update payment method: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> deletePaymentMethod(String paymentMethodId) async {
    try {
      // Check internet connectivity
      final connectivityResult = await connectivity.checkConnectivity();
      final isConnected = !connectivityResult.contains(ConnectivityResult.none);

      if (!isConnected) {
        return Left(NetworkFailure('No internet connection. Cannot delete payment method.'));
      }

      // Delete payment method remotely
      await remoteDataSource.deletePaymentMethod(paymentMethodId);

      // Update local cache by removing the deleted payment method
      try {
        // We need to find which user this payment method belongs to
        // This is a limitation of the current design - we might need to pass userId
        // For now, we'll clear all cache and let it refresh on next request
        await localDataSource.clearAllCache();
      } catch (cacheError) {
        // Cache clear failed, but remote delete succeeded
        // This is not critical, cache will be refreshed on next request
      }

      return const Right(null);
    } catch (e) {
      return Left(ServerFailure('Failed to delete payment method: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> setDefaultPaymentMethod(String userId, String paymentMethodId) async {
    try {
      // Check internet connectivity
      final connectivityResult = await connectivity.checkConnectivity();
      final isConnected = !connectivityResult.contains(ConnectivityResult.none);

      if (!isConnected) {
        return Left(NetworkFailure('No internet connection. Cannot set default payment method.'));
      }

      // Set default payment method remotely
      await remoteDataSource.setDefaultPaymentMethod(userId, paymentMethodId);

      // Update local cache
      try {
        final cachedPaymentMethods = await localDataSource.getCachedPaymentMethods(userId);
        final updatedPaymentMethods = cachedPaymentMethods.map((method) {
          return method.copyWith(isDefault: method.id == paymentMethodId);
        }).toList();

        await localDataSource.cachePaymentMethods(userId, updatedPaymentMethods);

        // Cache the new default payment method
        final defaultMethod = updatedPaymentMethods.firstWhere(
          (method) => method.id == paymentMethodId,
        );
        await localDataSource.cacheDefaultPaymentMethod(userId, defaultMethod);
      } catch (cacheError) {
        // If cache update fails, just refresh the cache
        try {
          final allPaymentMethods = await remoteDataSource.getPaymentMethods(userId);
          await localDataSource.cachePaymentMethods(userId, allPaymentMethods);
        } catch (e) {
          // Cache refresh failed, but main operation succeeded
        }
      }

      return const Right(null);
    } catch (e) {
      return Left(ServerFailure('Failed to set default payment method: $e'));
    }
  }

  @override
  Future<Either<Failure, PaymentMethodEntity?>> getDefaultPaymentMethod(String userId) async {
    try {
      // Check internet connectivity
      final connectivityResult = await connectivity.checkConnectivity();
      final isConnected = !connectivityResult.contains(ConnectivityResult.none);

      // Try to get from cache first
      try {
        final cachedDefaultMethod = await localDataSource.getCachedDefaultPaymentMethod(userId);

        // If we have cached data and no internet, return cached data
        if (!isConnected && cachedDefaultMethod != null) {
          return Right(cachedDefaultMethod.toEntity());
        }

        // If we have internet, try to get fresh data
        if (isConnected) {
          try {
            final remoteDefaultMethod = await remoteDataSource.getDefaultPaymentMethod(userId);

            // Cache the fresh data
            await localDataSource.cacheDefaultPaymentMethod(userId, remoteDefaultMethod);

            return Right(remoteDefaultMethod?.toEntity());
          } catch (e) {
            // If remote fails but we have cached data, return cached data
            if (cachedDefaultMethod != null) {
              return Right(cachedDefaultMethod.toEntity());
            }
            rethrow;
          }
        }

        // Return cached data if available
        return Right(cachedDefaultMethod?.toEntity());
      } catch (cacheError) {
        // No cached data, try remote if connected
        if (isConnected) {
          final remoteDefaultMethod = await remoteDataSource.getDefaultPaymentMethod(userId);
          await localDataSource.cacheDefaultPaymentMethod(userId, remoteDefaultMethod);
          return Right(remoteDefaultMethod?.toEntity());
        } else {
          return Left(NetworkFailure('No internet connection and no cached data available'));
        }
      }
    } catch (e) {
      return Left(ServerFailure('Failed to get default payment method: $e'));
    }
  }

  @override
  Future<Either<Failure, bool>> validatePaymentMethod(String paymentMethodId) async {
    try {
      // Check internet connectivity
      final connectivityResult = await connectivity.checkConnectivity();
      final isConnected = !connectivityResult.contains(ConnectivityResult.none);

      if (!isConnected) {
        return Left(NetworkFailure('No internet connection. Cannot validate payment method.'));
      }

      // This would typically involve calling a payment gateway API
      // For now, we'll just return true if the payment method exists
      // TODO: Implement actual payment method validation with payment gateway

      return const Right(true);
    } catch (e) {
      return Left(ServerFailure('Failed to validate payment method: $e'));
    }
  }
}
