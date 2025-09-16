part of 'provider_search_bloc.dart';

abstract class ProviderSearchEvent extends Equatable {
  const ProviderSearchEvent();

  @override
  List<Object?> get props => [];
}

class SearchProvidersEvent extends ProviderSearchEvent {
  final String? query;
  final String? serviceCategory;
  final double? latitude;
  final double? longitude;
  final double? radius;
  final double? minRating;
  final double? maxPrice;
  final String? sort;

  const SearchProvidersEvent({
    this.query,
    this.serviceCategory,
    this.latitude,
    this.longitude,
    this.radius,
    this.minRating,
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
        maxPrice,
        sort
      ];
}

class GetNearbyProvidersEvent extends ProviderSearchEvent {
  final double latitude;
  final double longitude;
  final double radius;

  const GetNearbyProvidersEvent({
    required this.latitude,
    required this.longitude,
    this.radius = 10.0,
  });

  @override
  List<Object?> get props => [latitude, longitude, radius];
}

class GetFeaturedProvidersEvent extends ProviderSearchEvent {}

class ClearSearchEvent extends ProviderSearchEvent {}
