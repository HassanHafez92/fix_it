part of 'provider_details_bloc.dart';

abstract class ProviderDetailsEvent extends Equatable {
  const ProviderDetailsEvent();

  @override
  List<Object> get props => [];
}

class LoadProviderDetailsEvent extends ProviderDetailsEvent {
  final String providerId;

  const LoadProviderDetailsEvent({
    required this.providerId,
  });

  @override
  List<Object> get props => [providerId];
}

class LoadProviderReviewsEvent extends ProviderDetailsEvent {
  const LoadProviderReviewsEvent();
}

class LoadProviderServicesEvent extends ProviderDetailsEvent {
  const LoadProviderServicesEvent();
}

class LoadProviderAvailabilityEvent extends ProviderDetailsEvent {
  const LoadProviderAvailabilityEvent();
}
