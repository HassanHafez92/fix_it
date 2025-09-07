part of 'provider_details_bloc.dart';

abstract class ProviderDetailsState extends Equatable {
  const ProviderDetailsState();

  @override
  List<Object> get props => [];
}

class ProviderDetailsInitial extends ProviderDetailsState {}

class ProviderDetailsLoading extends ProviderDetailsState {}

class ProviderDetailsLoaded extends ProviderDetailsState {
  final Map<String, dynamic> provider;
  final List<Map<String, dynamic>> reviews;
  final List<Map<String, dynamic>> services;
  final Map<DateTime, List<TimeOfDay>> availability;

  const ProviderDetailsLoaded({
    required this.provider,
    this.reviews = const [],
    this.services = const [],
    this.availability = const {},
  });

  ProviderDetailsLoaded copyWith({
    Map<String, dynamic>? provider,
    List<Map<String, dynamic>>? reviews,
    List<Map<String, dynamic>>? services,
    Map<DateTime, List<TimeOfDay>>? availability,
  }) {
    return ProviderDetailsLoaded(
      provider: provider ?? this.provider,
      reviews: reviews ?? this.reviews,
      services: services ?? this.services,
      availability: availability ?? this.availability,
    );
  }

  @override
  List<Object> get props => [provider, reviews, services, availability];
}

class ProviderDetailsError extends ProviderDetailsState {
  final String message;

  const ProviderDetailsError({required this.message});

  @override
  List<Object> get props => [message];
}
