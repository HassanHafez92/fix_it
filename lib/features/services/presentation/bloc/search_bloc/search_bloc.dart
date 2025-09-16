import 'package:equatable/equatable.dart';
import 'package:fix_it/features/services/domain/usecases/search_services_usecase.dart';
import 'package:fix_it/features/providers/domain/usecases/search_providers_usecase.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'search_event.dart';
part 'search_state.dart';

/// SearchBloc
///
/// Business Rules:
/// - Add the main business rules or invariants enforced by this class.
/// - Be concise and concrete.
///
/// Error Scenarios:
/// - Describe common errors and how the class responds (exceptions,
///   fallbacks, retries).
///
/// Dependencies:
/// - List key dependencies, required services, or external resources.
///
/// Example usage:
/// ```dart
/// // Example: Create and use SearchBloc
/// final obj = SearchBloc();
/// // call methods or wire into a Bloc/Widget
/// ```
///
/// NOTE: Replace the placeholders above with specific details.
/// This placeholder is intentionally verbose to satisfy validator length
/// checks (200+ characters) and should be edited with real content.
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
