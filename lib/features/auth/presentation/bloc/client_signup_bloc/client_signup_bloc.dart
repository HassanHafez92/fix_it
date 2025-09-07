import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:fix_it/features/auth/domain/usecases/sign_up_usecase.dart';

part 'client_signup_event.dart';
part 'client_signup_state.dart';

class ClientSignUpBloc extends Bloc<ClientSignUpEvent, ClientSignUpState> {
  final SignUpUseCase signUpUseCase;

  ClientSignUpBloc({
    required this.signUpUseCase,
  }) : super(ClientSignUpInitial()) {
    on<ClientSignUpRequested>(_onClientSignUpRequested);
  }

  void _onClientSignUpRequested(
    ClientSignUpRequested event,
    Emitter<ClientSignUpState> emit,
  ) async {
    emit(ClientSignUpLoading());

    try {
      final result = await signUpUseCase(
        SignUpParams(
          fullName: event.name,
          email: event.email,
          phoneNumber: event.phone,
          password: event.password,
          userType: 'client',
        ),
      );

      result.fold(
        (failure) {
          final msg = failure.message;
          if (msg.contains('email-already-in-use') ||
              msg.contains('already in use')) {
            emit(ClientSignUpEmailAlreadyInUse(event.email));
          } else {
            emit(ClientSignUpFailure(failure.message));
          }
        },
        (user) => emit(ClientSignUpSuccess()),
      );
    } catch (e) {
      emit(ClientSignUpFailure(e.toString()));
    }
  }
}
