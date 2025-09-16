part of 'search_bloc.dart';

abstract class SearchState extends Equatable {
  const SearchState();

  @override
  List<Object> get props => [];
}

class SearchInitial extends SearchState {}

class SearchQueryUpdated extends SearchState {
  final String query;

  const SearchQueryUpdated(this.query);

  @override
  List<Object> get props => [query];
}

class SearchLoading extends SearchState {}

class SearchResultsLoaded extends SearchState {
  final List services;
  final List providers;

  const SearchResultsLoaded({
    required this.services,
    required this.providers,
  });

  @override
  List<Object> get props => [services, providers];
}

class SearchError extends SearchState {
  final String message;

  const SearchError(this.message);

  @override
  List<Object> get props => [message];
}
