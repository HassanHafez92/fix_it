import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'change_password_event.dart';
part 'change_password_state.dart';

class ChangePasswordBloc extends Bloc<ChangePasswordEvent, ChangePasswordState> {
  ChangePasswordBloc() : super(ChangePasswordInitial()) {
    on<ChangePasswordRequested>(_onChangePasswordRequested);
  }

  void _onChangePasswordRequested(
    ChangePasswordRequested event,
    Emitter<ChangePasswordState> emit,
  ) async {
    emit(ChangePasswordLoading());

    try {
      // Here you would typically call a use case or repository to change the password
      // For now, we'll simulate a successful password change
      await Future.delayed(const Duration(seconds: 1)); // Simulate network call

      // In a real app, you would handle success and failure cases based on the result
      emit(ChangePasswordSuccess());
    } catch (e) {
      emit(ChangePasswordFailure(message: e.toString()));
    }
  }
}
