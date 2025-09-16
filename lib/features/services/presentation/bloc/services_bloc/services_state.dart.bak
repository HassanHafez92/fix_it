part of 'services_bloc.dart';

abstract class ServicesState extends Equatable {
  const ServicesState();

  @override
  List<Object> get props => [];
}

class ServicesInitial extends ServicesState {}

class ServicesLoading extends ServicesState {}

class ServicesLoaded extends ServicesState {
  final List<Map<String, dynamic>> services;
  final List<String> categories;
  final List<Map<String, dynamic>> filteredServices;
  final String? selectedCategory;
  final String searchQuery;

  const ServicesLoaded({
    required this.services,
    required this.categories,
    required this.filteredServices,
    this.selectedCategory,
    required this.searchQuery,
  });

  ServicesLoaded copyWith({
    List<Map<String, dynamic>>? services,
    List<String>? categories,
    List<Map<String, dynamic>>? filteredServices,
    String? selectedCategory,
    String? searchQuery,
  }) {
    return ServicesLoaded(
      services: services ?? this.services,
      categories: categories ?? this.categories,
      filteredServices: filteredServices ?? this.filteredServices,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }

  @override
  List<Object> get props => [
    services,
    categories,
    filteredServices,
    selectedCategory ?? '',
    searchQuery,
  ];
}

class ServicesError extends ServicesState {
  final String message;

  const ServicesError({required this.message});

  @override
  List<Object> get props => [message];
}
