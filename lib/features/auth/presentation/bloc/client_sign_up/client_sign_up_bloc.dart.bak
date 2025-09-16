import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/error/failures.dart';
import '../../../domain/entities/user_entity.dart';
import '../../../domain/usecases/client_sign_up_usecase.dart';

part 'client_sign_up_state.dart';
part 'client_sign_up_event.dart';

class ClientSignUpBloc extends Bloc<ClientSignUpEvent, ClientSignUpState> {
  final ClientSignUpUseCase clientSignUpUseCase;

  ClientSignUpBloc({required this.clientSignUpUseCase}) : super(ClientSignUpInitial()) {
    on<ClientSignUpSubmitted>(_onClientSignUpSubmitted);
  }

  Future<void> _onClientSignUpSubmitted(
    ClientSignUpSubmitted event,
    Emitter<ClientSignUpState> emit,
  ) async {
    emit(ClientSignUpLoading());

    try {
      final user = await clientSignUpUseCase(
        ClientSignUpParams(
          fullName: event.fullName,
          email: event.email,
          password: event.password,
          phoneNumber: event.phoneNumber,
        ),
      );

      emit(ClientSignUpSuccess(user));
    } on Failure catch (e) {
      emit(ClientSignUpError(e.message));
    } catch (e) {
      emit(ClientSignUpError('An unexpected error occurred: $e'));
    }
  }
}
