part of 'service_details_bloc.dart';

abstract class ServiceDetailsEvent extends Equatable {
  const ServiceDetailsEvent();

  @override
  List<Object?> get props => [];
}

class GetServiceDetailsEvent extends ServiceDetailsEvent {
  final String serviceId;

  const GetServiceDetailsEvent({required this.serviceId});

  @override
  List<Object?> get props => [serviceId];
}
