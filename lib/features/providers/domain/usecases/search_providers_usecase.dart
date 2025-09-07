import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/provider_entity.dart';
import '../repositories/provider_repository.dart';

class SearchProvidersUseCase
    implements UseCase<List<ProviderEntity>, SearchProvidersParams> {
  final ProviderRepository repository;

  SearchProvidersUseCase(this.repository);

  @override
  Future<Either<Failure, List<ProviderEntity>>> call(
      SearchProvidersParams params) async {
    return await repository.searchProviders(
      query: params.query,
      serviceCategory: params.serviceCategory,
      latitude: params.latitude,
      longitude: params.longitude,
      radius: params.radius,
      minRating: params.minRating,
      availableAt: params.availableAt,
      maxPrice: params.maxPrice,
      sort: params.sort,
    );
  }
}

class SearchProvidersParams extends Equatable {
  final String? query;
  final String? serviceCategory;
  final double? latitude;
  final double? longitude;
  final double? radius;
  final double? minRating;
  final DateTime? availableAt;
  final double? maxPrice;
  final String? sort;

  const SearchProvidersParams({
    this.query,
    this.serviceCategory,
    this.latitude,
    this.longitude,
    this.radius,
    this.minRating,
    this.availableAt,
    this.maxPrice,
    this.sort,
  });

  @override
  List<Object?> get props => [
        query,
        serviceCategory,
        latitude,
        longitude,
        radius,
        minRating,
        availableAt,
        maxPrice,
        sort
      ];
}
