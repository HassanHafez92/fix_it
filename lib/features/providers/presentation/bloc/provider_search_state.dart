part of 'provider_search_bloc.dart';

abstract class ProviderSearchState extends Equatable {
  const ProviderSearchState();

  @override
  List<Object?> get props => [];
}

class ProviderSearchInitial extends ProviderSearchState {}

class ProviderSearchLoading extends ProviderSearchState {}

class ProviderSearchLoaded extends ProviderSearchState {
  final List<ProviderEntity> providers;

  const ProviderSearchLoaded(this.providers);

  @override
  List<Object?> get props => [providers];
}

class ProviderSearchError extends ProviderSearchState {
  final String message;

  const ProviderSearchError(this.message);

  @override
  List<Object?> get props => [message];
}
