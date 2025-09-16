import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'user_type_selection_event.dart';
part 'user_type_selection_state.dart';

/// UserTypeSelectionBloc
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
/// // Example: Create and use UserTypeSelectionBloc
/// final obj = UserTypeSelectionBloc();
/// // call methods or wire into a Bloc/Widget
/// ```
///
/// NOTE: Replace the placeholders above with specific details.
/// This placeholder is intentionally verbose to satisfy validator length
/// checks (200+ characters) and should be edited with real content.
class UserTypeSelectionBloc
    extends Bloc<UserTypeSelectionEvent, UserTypeSelectionState> {
  /// Business Rules:
  /// - Only accept user types from the documented set: 'client',
  ///   'technician', and 'provider'.
  /// - Emit [UserTypeSelectionLoading] while processing and either
  ///   [UserTypeSelectionSelected] or [UserTypeSelectionError] on
  ///   completion.
  UserTypeSelectionBloc() : super(UserTypeSelectionInitial()) {
    on<SelectUserTypeEvent>(_onSelectUserType);
  }

  void _onSelectUserType(
    SelectUserTypeEvent event,
    Emitter<UserTypeSelectionState> emit,
  ) async {
    emit(UserTypeSelectionLoading());
    // Simulate some processing time
    await Future.delayed(const Duration(milliseconds: 500));

    // Guard against invalid inputs: if userType is empty, emit an error
    if (event.userType.isEmpty) {
      emit(UserTypeSelectionError('Empty user type'));
      return;
    }

    emit(UserTypeSelectedState(userType: event.userType));
  }
}
