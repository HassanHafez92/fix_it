part of 'services_bloc.dart';

abstract class ServicesState extends Equatable {
  const ServicesState();

  @override
  List<Object?> get props => [];
}

class ServicesInitial extends ServicesState {}

class ServicesLoading extends ServicesState {}

class ServicesLoaded extends ServicesState {
  final List<ServiceEntity> services;
  final List<String> categories;

  const ServicesLoaded(this.services, {this.categories = const []});

  @override
  List<Object?> get props => [services, categories];

  ServicesLoaded copyWith({
    List<ServiceEntity>? services,
    List<String>? categories,
  }) {
    return ServicesLoaded(
      services ?? this.services,
      categories: categories ?? this.categories,
    );
  }
}



class ServicesError extends ServicesState {
  final String message;

  const ServicesError(this.message);

  @override
  List<Object?> get props => [message];
}

class CategoriesLoading extends ServicesState {}

class CategoriesLoaded extends ServicesState {
  final List<CategoryEntity> categories;

  const CategoriesLoaded(this.categories);

  @override
  List<Object?> get props => [categories];
}

class CategoriesError extends ServicesState {
  final String message;

  const CategoriesError(this.message);

  @override
  List<Object?> get props => [message];
}
