part of 'provider_details_bloc.dart';

abstract class ProviderDetailsEvent extends Equatable {
  const ProviderDetailsEvent();

  @override
  List<Object?> get props => [];
}

class GetProviderDetailsEvent extends ProviderDetailsEvent {
  final String providerId;

  const GetProviderDetailsEvent({required this.providerId});

  @override
  List<Object?> get props => [providerId];
}

class GetProviderReviewsEvent extends ProviderDetailsEvent {
  final String providerId;

  const GetProviderReviewsEvent({required this.providerId});

  @override
  List<Object?> get props => [providerId];
}
