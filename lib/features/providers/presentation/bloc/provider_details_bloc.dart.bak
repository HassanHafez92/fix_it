import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/provider_entity.dart';
import '../../domain/entities/review_entity.dart';
import '../../domain/usecases/get_provider_details_usecase.dart';
import '../../domain/usecases/get_provider_reviews_usecase.dart';

part 'provider_details_event.dart';
part 'provider_details_state.dart';

class ProviderDetailsBloc
    extends Bloc<ProviderDetailsEvent, ProviderDetailsState> {
  final GetProviderDetailsUseCase getProviderDetails;
  final GetProviderReviewsUseCase getProviderReviews;

  ProviderDetailsBloc({
    required this.getProviderDetails,
    required this.getProviderReviews,
  }) : super(ProviderDetailsInitial()) {
    on<GetProviderDetailsEvent>(_onGetProviderDetails);
    on<GetProviderReviewsEvent>(_onGetProviderReviews);
  }

  Future<void> _onGetProviderDetails(
    GetProviderDetailsEvent event,
    Emitter<ProviderDetailsState> emit,
  ) async {
    emit(ProviderDetailsLoading());
    final result = await getProviderDetails(
      GetProviderDetailsParams(providerId: event.providerId),
    );
    result.fold(
      (failure) => emit(ProviderDetailsError(failure.message)),
      (provider) => emit(ProviderDetailsLoaded(provider)),
    );
  }

  Future<void> _onGetProviderReviews(
    GetProviderReviewsEvent event,
    Emitter<ProviderDetailsState> emit,
  ) async {
    if (state is ProviderDetailsLoaded) {
      final currentState = state as ProviderDetailsLoaded;
      emit(
          ProviderDetailsLoaded(currentState.provider, isLoadingReviews: true));

      final result = await getProviderReviews(
        GetProviderReviewsParams(providerId: event.providerId),
      );
      result.fold(
        (failure) => emit(ProviderDetailsLoaded(
          currentState.provider,
          reviewsError: failure.message,
        )),
        (reviews) => emit(ProviderDetailsLoaded(
          currentState.provider,
          reviews: reviews,
        )),
      );
    }
  }
}
