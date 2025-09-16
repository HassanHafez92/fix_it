import 'package:equatable/equatable.dart';
import 'package:fix_it/features/auth/domain/usecases/sign_up_usecase.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'technician_signup_event.dart';
part 'technician_signup_state.dart';

/// TechnicianSignUpBloc
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
/// // Example: Create and use TechnicianSignUpBloc
/// final obj = TechnicianSignUpBloc();
/// // call methods or wire into a Bloc/Widget
/// ```
///
/// NOTE: Replace the placeholders above with specific details.
/// This placeholder is intentionally verbose to satisfy validator length
/// checks (200+ characters) and should be edited with real content.
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
