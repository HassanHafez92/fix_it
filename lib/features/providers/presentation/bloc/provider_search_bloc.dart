import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/provider_entity.dart';
import '../../domain/usecases/search_providers_usecase.dart';
import '../../domain/usecases/get_nearby_providers_usecase.dart';
import '../../domain/usecases/get_featured_providers_usecase.dart';
import '../../../../core/usecases/usecase.dart';

part 'provider_search_event.dart';
part 'provider_search_state.dart';

class ProviderSearchBloc
    extends Bloc<ProviderSearchEvent, ProviderSearchState> {
  final SearchProvidersUseCase searchProviders;
  final GetNearbyProvidersUseCase getNearbyProviders;
  final GetFeaturedProvidersUseCase getFeaturedProviders;

  ProviderSearchBloc({
    required this.searchProviders,
    required this.getNearbyProviders,
    required this.getFeaturedProviders,
  }) : super(ProviderSearchInitial()) {
    on<SearchProvidersEvent>(_onSearchProviders);
    on<GetNearbyProvidersEvent>(_onGetNearbyProviders);
    on<GetFeaturedProvidersEvent>(_onGetFeaturedProviders);
    on<ClearSearchEvent>(_onClearSearch);
  }

  Future<void> _onSearchProviders(
    SearchProvidersEvent event,
    Emitter<ProviderSearchState> emit,
  ) async {
    emit(ProviderSearchLoading());
    final result = await searchProviders(SearchProvidersParams(
      query: event.query,
      serviceCategory: event.serviceCategory,
      latitude: event.latitude,
      longitude: event.longitude,
      radius: event.radius,
      minRating: event.minRating,
      maxPrice: event.maxPrice,
      sort: event.sort,
    ));
    result.fold(
      (failure) => emit(ProviderSearchError(failure.message)),
      (providers) => emit(ProviderSearchLoaded(providers)),
    );
  }

  Future<void> _onGetNearbyProviders(
    GetNearbyProvidersEvent event,
    Emitter<ProviderSearchState> emit,
  ) async {
    emit(ProviderSearchLoading());
    final result = await getNearbyProviders(GetNearbyProvidersParams(
      latitude: event.latitude,
      longitude: event.longitude,
      radius: event.radius,
    ));
    result.fold(
      (failure) => emit(ProviderSearchError(failure.message)),
      (providers) => emit(ProviderSearchLoaded(providers)),
    );
  }

  Future<void> _onGetFeaturedProviders(
    GetFeaturedProvidersEvent event,
    Emitter<ProviderSearchState> emit,
  ) async {
    emit(ProviderSearchLoading());
    final result = await getFeaturedProviders(NoParamsImpl());
    result.fold(
      (failure) => emit(ProviderSearchError(failure.message)),
      (providers) => emit(ProviderSearchLoaded(providers)),
    );
  }

  Future<void> _onClearSearch(
    ClearSearchEvent event,
    Emitter<ProviderSearchState> emit,
  ) async {
    emit(ProviderSearchInitial());
  }
}
