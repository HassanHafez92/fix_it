part of 'provider_search_bloc.dart';

/// ProviderSearchState
///
/// States emitted by [ProviderSearchBloc].
abstract class ProviderSearchState extends Equatable {
  const ProviderSearchState();

  @override
  List<Object> get props => [];
}

/// ProviderSearchInitial
class ProviderSearchInitial extends ProviderSearchState {}

/// ProviderSearchLoading
class ProviderSearchLoading extends ProviderSearchState {}

/// ProviderSearchLoaded
///
/// Contains the loaded providers and current filter state.
class ProviderSearchLoaded extends ProviderSearchState {
  final List<Map<String, dynamic>> providers;
  final List<Map<String, dynamic>> filteredProviders;
  final List<String> services;
  final List<String> locations;
  final String? selectedService;
  final String? selectedLocation;
  final double minRating;
  final String searchQuery;

  const ProviderSearchLoaded({
    required this.providers,
    required this.filteredProviders,
    required this.services,
    required this.locations,
    this.selectedService,
    this.selectedLocation,
    required this.minRating,
    required this.searchQuery,
  });

  ProviderSearchLoaded copyWith({
    List<Map<String, dynamic>>? providers,
    List<Map<String, dynamic>>? filteredProviders,
    List<String>? services,
    List<String>? locations,
    String? selectedService,
    String? selectedLocation,
    double? minRating,
    String? searchQuery,
  }) {
    return ProviderSearchLoaded(
      providers: providers ?? this.providers,
      filteredProviders: filteredProviders ?? this.filteredProviders,
      services: services ?? this.services,
      locations: locations ?? this.locations,
      selectedService: selectedService ?? this.selectedService,
      selectedLocation: selectedLocation ?? this.selectedLocation,
      minRating: minRating ?? this.minRating,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }

  @override
  List<Object> get props => [
        providers,
        filteredProviders,
        services,
        locations,
        selectedService ?? '',
        selectedLocation ?? '',
        minRating,
        searchQuery,
      ];
}

/// ProviderSearchError
class ProviderSearchError extends ProviderSearchState {
  final String message;

  const ProviderSearchError({required this.message});

  @override
  List<Object> get props => [message];
}
