import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/service_entity.dart';
import '../../domain/usecases/get_service_details_usecase.dart';

part 'service_details_event.dart';
part 'service_details_state.dart';

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
