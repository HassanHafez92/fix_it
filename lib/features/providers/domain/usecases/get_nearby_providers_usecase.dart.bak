import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/provider_entity.dart';
import '../repositories/provider_repository.dart';

/// GetNearbyProvidersUseCase
///
/// Usecase to fetch providers within a geographic radius.
///
/// Business Rules:
///  - Uses latitude/longitude and an optional radius (km) to query nearby providers.
class GetNearbyProvidersUseCase
    implements UseCase<List<ProviderEntity>, GetNearbyProvidersParams> {
  final ProviderRepository repository;

  GetNearbyProvidersUseCase(this.repository);

  @override
  Future<Either<Failure, List<ProviderEntity>>> call(
      GetNearbyProvidersParams params) async {
    return await repository.getNearbyProviders(
      latitude: params.latitude,
      longitude: params.longitude,
      radius: params.radius,
    );
  }
}

/// GetNearbyProvidersParams
///
/// Params for [GetNearbyProvidersUseCase].
///
/// Parameter details:
///  - latitude (required): center latitude for the search.
///  - longitude (required): center longitude for the search.
///  - radius: search radius in kilometers (defaults to 10.0).
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
