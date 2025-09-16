part of 'provider_details_bloc.dart';

/// ProviderDetailsEvent
///
/// Base class for provider details related events.
abstract class ProviderDetailsEvent extends Equatable {
  const ProviderDetailsEvent();

  @override
  List<Object> get props => [];
}

/// LoadProviderDetailsEvent
///
/// Loads the full provider profile for the given providerId.
class LoadProviderDetailsEvent extends ProviderDetailsEvent {
  final String providerId;

  const LoadProviderDetailsEvent({
    required this.providerId,
  });

  @override
  List<Object> get props => [providerId];
}

/// LoadProviderReviewsEvent
class LoadProviderReviewsEvent extends ProviderDetailsEvent {
  const LoadProviderReviewsEvent();
}

/// LoadProviderServicesEvent
class LoadProviderServicesEvent extends ProviderDetailsEvent {
  const LoadProviderServicesEvent();
}

/// LoadProviderAvailabilityEvent
class LoadProviderAvailabilityEvent extends ProviderDetailsEvent {
  const LoadProviderAvailabilityEvent();
}
