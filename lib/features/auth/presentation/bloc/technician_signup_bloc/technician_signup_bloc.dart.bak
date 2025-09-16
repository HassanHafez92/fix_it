import 'package:equatable/equatable.dart';
import 'package:fix_it/features/auth/domain/usecases/sign_up_usecase.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'technician_signup_event.dart';
part 'technician_signup_state.dart';

class TechnicianSignUpBloc extends Bloc<TechnicianSignUpEvent, TechnicianSignUpState> {
  final SignUpUseCase signUpUseCase;

  TechnicianSignUpBloc({
    required this.signUpUseCase,
  }) : super(TechnicianSignUpInitial()) {
    on<TechnicianSignUpRequested>(_onTechnicianSignUpRequested);
  }

  void _onTechnicianSignUpRequested(
    TechnicianSignUpRequested event,
    Emitter<TechnicianSignUpState> emit,
  ) async {
    emit(TechnicianSignUpLoading());

    try {
      final result = await signUpUseCase(
        SignUpParams(
          fullName: event.name,
          email: event.email,
          phoneNumber: event.phone,
          password: event.password,
          userType: 'provider',
          profession: event.profession,
        ),
      );

      result.fold(
        (failure) => emit(TechnicianSignUpFailure(failure.message)),
        (user) => emit(TechnicianSignUpSuccess()),
      );
    } catch (e) {
      emit(TechnicianSignUpFailure(e.toString()));
    }
  }
}
