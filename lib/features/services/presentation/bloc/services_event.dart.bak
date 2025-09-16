part of 'services_bloc.dart';

abstract class ServicesEvent extends Equatable {
  const ServicesEvent();

  @override
  List<Object?> get props => [];
}

class GetServicesEvent extends ServicesEvent {
  const GetServicesEvent();

  @override
  List<Object?> get props => [];
}

class GetServicesByCategoryEvent extends ServicesEvent {
  final String categoryId;

  const GetServicesByCategoryEvent({required this.categoryId});

  @override
  List<Object?> get props => [categoryId];
}

class SearchServicesEvent extends ServicesEvent {
  final String query;

  const SearchServicesEvent({required this.query});

  @override
  List<Object?> get props => [query];
}

class GetCategoriesEvent extends ServicesEvent {}

class LoadServicesEvent extends ServicesEvent {}
