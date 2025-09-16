part of 'services_bloc.dart';

abstract class ServicesEvent extends Equatable {
  const ServicesEvent();

  @override
  List<Object> get props => [];
}

class LoadServicesEvent extends ServicesEvent {
  const LoadServicesEvent();
}

class SearchServicesEvent extends ServicesEvent {
  final String query;

  const SearchServicesEvent({required this.query});

  @override
  List<Object> get props => [query];
}

class FilterServicesByCategoryEvent extends ServicesEvent {
  final String? category;

  const FilterServicesByCategoryEvent({this.category});

  @override
  List<Object> get props => [category ?? ''];
}

class ApplyServiceFiltersEvent extends ServicesEvent {
  final String? category;
  final Map<String, bool> filters;

  const ApplyServiceFiltersEvent({this.category, required this.filters});

  @override
  List<Object> get props => [category ?? '', filters.toString()];
}
