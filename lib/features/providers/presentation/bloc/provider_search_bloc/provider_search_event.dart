part of 'provider_search_bloc.dart';

abstract class ProviderSearchEvent extends Equatable {
  const ProviderSearchEvent();

  @override
  List<Object> get props => [];
}

class LoadProvidersEvent extends ProviderSearchEvent {
  const LoadProvidersEvent();
}

class SearchProvidersEvent extends ProviderSearchEvent {
  final String query;

  const SearchProvidersEvent({required this.query});

  @override
  List<Object> get props => [query];
}

class FilterProvidersByServiceEvent extends ProviderSearchEvent {
  final String? service;

  const FilterProvidersByServiceEvent({this.service});

  @override
  List<Object> get props => [service ?? ''];
}

class FilterProvidersByLocationEvent extends ProviderSearchEvent {
  final String? location;

  const FilterProvidersByLocationEvent({this.location});

  @override
  List<Object> get props => [location ?? ''];
}

class FilterProvidersByRatingEvent extends ProviderSearchEvent {
  final double minRating;

  const FilterProvidersByRatingEvent({required this.minRating});

  @override
  List<Object> get props => [minRating];
}
