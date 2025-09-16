part of 'service_details_bloc.dart';

abstract class ServiceDetailsState extends Equatable {
  const ServiceDetailsState();

  @override
  List<Object?> get props => [];
}

class ServiceDetailsInitial extends ServiceDetailsState {}

class ServiceDetailsLoading extends ServiceDetailsState {}

class ServiceDetailsLoaded extends ServiceDetailsState {
  final ServiceEntity service;

  const ServiceDetailsLoaded(this.service);

  @override
  List<Object?> get props => [service];
}

class ServiceDetailsError extends ServiceDetailsState {
  final String message;

  const ServiceDetailsError(this.message);

  @override
  List<Object?> get props => [message];
}
