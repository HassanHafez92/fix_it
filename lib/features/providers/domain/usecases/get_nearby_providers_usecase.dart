import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/provider_entity.dart';
import '../repositories/provider_repository.dart';

class GetNearbyProvidersUseCase implements UseCase<List<ProviderEntity>, GetNearbyProvidersParams> {
  final ProviderRepository repository;

  GetNearbyProvidersUseCase(this.repository);

  @override
  Future<Either<Failure, List<ProviderEntity>>> call(GetNearbyProvidersParams params) async {
    return await repository.getNearbyProviders(
      latitude: params.latitude,
      longitude: params.longitude,
      radius: params.radius,
    );
  }
}

class GetNearbyProvidersParams extends Equatable {
  final double latitude;
  final double longitude;
  final double radius;

  const GetNearbyProvidersParams({
    required this.latitude,
    required this.longitude,
    this.radius = 10.0,
  });

  @override
  List<Object?> get props => [latitude, longitude, radius];
}
