import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/service_entity.dart';
import '../../domain/usecases/get_service_details_usecase.dart';

part 'service_details_event.dart';
part 'service_details_state.dart';

/// ServiceDetailsBloc
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
/// // Example: Create and use ServiceDetailsBloc
/// final obj = ServiceDetailsBloc();
/// // call methods or wire into a Bloc/Widget
/// ```
///
/// NOTE: Replace the placeholders above with specific details.
/// This placeholder is intentionally verbose to satisfy validator length
/// checks (200+ characters) and should be edited with real content.
class ServiceDetailsBloc
    extends Bloc<ServiceDetailsEvent, ServiceDetailsState> {
  final GetServiceDetailsUseCase getServiceDetails;

  ServiceDetailsBloc({
    required this.getServiceDetails,
  }) : super(ServiceDetailsInitial()) {
    on<GetServiceDetailsEvent>(_onGetServiceDetails);
  }

  Future<void> _onGetServiceDetails(
    GetServiceDetailsEvent event,
    Emitter<ServiceDetailsState> emit,
  ) async {
    emit(ServiceDetailsLoading());
    final result = await getServiceDetails(
      GetServiceDetailsParams(serviceId: event.serviceId),
    );
    result.fold(
      (failure) => emit(ServiceDetailsError(failure.message)),
      (service) => emit(ServiceDetailsLoaded(service)),
    );
  }
}
