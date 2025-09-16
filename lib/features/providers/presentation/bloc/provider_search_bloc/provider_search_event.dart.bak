part of 'provider_search_bloc.dart';

/// ProviderSearchEvent
///
/// Base class for search-related events.
abstract class ProviderSearchEvent extends Equatable {
  const ProviderSearchEvent();

  @override
  List<Object> get props => [];
}

/// LoadProvidersEvent
///
/// Instructs the bloc to load the initial list of providers (e.g., for discovery).
class LoadProvidersEvent extends ProviderSearchEvent {
  const LoadProvidersEvent();
}

/// SearchProvidersEvent
///
/// Event used to run a free-text search.
class SearchProvidersEvent extends ProviderSearchEvent {
  final String query;

  const SearchProvidersEvent({required this.query});

  @override
  List<Object> get props => [query];
}

/// FilterProvidersByServiceEvent
///
/// Event to filter providers by a chosen service category.
class FilterProvidersByServiceEvent extends ProviderSearchEvent {
  final String? service;

  const FilterProvidersByServiceEvent({this.service});

  @override
  List<Object> get props => [service ?? ''];
}

/// FilterProvidersByLocationEvent
///
/// Event to filter providers by location.
class FilterProvidersByLocationEvent extends ProviderSearchEvent {
  final String? location;

  const FilterProvidersByLocationEvent({this.location});

  @override
  List<Object> get props => [location ?? ''];
}

/// FilterProvidersByRatingEvent
///
/// Event to filter providers by minimum rating threshold.
class FilterProvidersByRatingEvent extends ProviderSearchEvent {
  final double minRating;

  const FilterProvidersByRatingEvent({required this.minRating});

  @override
  List<Object> get props => [minRating];
}
