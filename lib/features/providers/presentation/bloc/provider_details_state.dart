part of 'provider_details_bloc.dart';

abstract class ProviderDetailsState extends Equatable {
  const ProviderDetailsState();

  @override
  List<Object?> get props => [];
}

class ProviderDetailsInitial extends ProviderDetailsState {}

class ProviderDetailsLoading extends ProviderDetailsState {}

class ProviderDetailsLoaded extends ProviderDetailsState {
  final ProviderEntity provider;
  final List<ReviewEntity>? reviews;
  final bool isLoadingReviews;
  final String? reviewsError;

  const ProviderDetailsLoaded(
    this.provider, {
    this.reviews,
    this.isLoadingReviews = false,
    this.reviewsError,
  });

  @override
  List<Object?> get props => [provider, reviews, isLoadingReviews, reviewsError];
}

class ProviderDetailsError extends ProviderDetailsState {
  final String message;

  const ProviderDetailsError(this.message);

  @override
  List<Object?> get props => [message];
}
