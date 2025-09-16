import 'package:equatable/equatable.dart';
import 'package:fix_it/features/services/domain/usecases/search_services_usecase.dart';
import 'package:fix_it/features/providers/domain/usecases/search_providers_usecase.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'search_event.dart';
part 'search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final SearchServicesUseCase searchServicesUseCase;
  final SearchProvidersUseCase searchProvidersUseCase;

  SearchBloc({
    required this.searchServicesUseCase,
    required this.searchProvidersUseCase,
  }) : super(SearchInitial()) {
    on<SearchQueryChangedEvent>(_onSearchQueryChanged);
    on<PerformSearchEvent>(_onPerformSearch);
    on<ClearSearchEvent>(_onClearSearch);
  }

  void _onSearchQueryChanged(
    SearchQueryChangedEvent event,
    Emitter<SearchState> emit,
  ) {
    // We could implement auto-suggestions here
    // For now, we'll just update the state with the query
    emit(SearchQueryUpdated(event.query));
  }

  void _onPerformSearch(
    PerformSearchEvent event,
    Emitter<SearchState> emit,
  ) async {
    emit(SearchLoading());

    try {
      final servicesResult = await searchServicesUseCase(SearchServicesParams(query: event.query));
      final providersResult = await searchProvidersUseCase(SearchProvidersParams(query: event.query));

      servicesResult.fold(
        (failure) => emit(SearchError(failure.message)),
        (services) {
          providersResult.fold(
            (failure) => emit(SearchError(failure.message)),
            (providers) {
              emit(SearchResultsLoaded(services: services, providers: providers));
            },
          );
        },
      );
    } catch (e) {
      emit(SearchError(e.toString()));
    }
  }

  void _onClearSearch(
    ClearSearchEvent event,
    Emitter<SearchState> emit,
  ) {
    emit(SearchInitial());
  }
}
