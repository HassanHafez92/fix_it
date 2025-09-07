import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/error/failures.dart';
import '../../../domain/entities/user_entity.dart';
import '../../../domain/usecases/technician_sign_up_usecase.dart';

part 'technician_sign_up_state.dart';
part 'technician_sign_up_event.dart';

class TechnicianSignUpBloc extends Bloc<TechnicianSignUpEvent, TechnicianSignUpState> {
  final TechnicianSignUpUseCase technicianSignUpUseCase;

  TechnicianSignUpBloc({required this.technicianSignUpUseCase}) : super(TechnicianSignUpInitial()) {
    on<TechnicianSignUpSubmitted>(_onTechnicianSignUpSubmitted);
  }

  Future<void> _onTechnicianSignUpSubmitted(
    TechnicianSignUpSubmitted event,
    Emitter<TechnicianSignUpState> emit,
  ) async {
    emit(TechnicianSignUpLoading());

    try {
      final user = await technicianSignUpUseCase(
        TechnicianSignUpParams(
          fullName: event.fullName,
          email: event.email,
          password: event.password,
          phoneNumber: event.phoneNumber,
          profession: event.profession,
        ),
      );

      emit(TechnicianSignUpSuccess(user));
    } on Failure catch (e) {
      emit(TechnicianSignUpError(e.message));
    } catch (e) {
      emit(TechnicianSignUpError('An unexpected error occurred: $e'));
    }
  }
}
