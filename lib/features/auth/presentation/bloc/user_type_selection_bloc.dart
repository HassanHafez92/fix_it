import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fix_it/core/services/localization_service.dart';
import 'user_type_selection_event.dart';
import 'user_type_selection_state.dart';
/// UserTypeSelectionBloc
///
/// Business rules:
/// - Describe the business rules that this class enforces.
///
/// Dependencies:
/// - List important dependencies or preconditions.
///
/// Error scenarios:
/// - Describe common error conditions and how they are handled.


class UserTypeSelectionBloc
    extends Bloc<UserTypeSelectionEvent, UserTypeSelectionState> {
  UserTypeSelectionBloc() : super(UserTypeSelectionInitial()) {
    on<UserTypeSelected>(_onUserTypeSelected);
    on<UserTypeSelectionReset>(_onUserTypeSelectionReset);
  }

  void _onUserTypeSelected(
    UserTypeSelected event,
    Emitter<UserTypeSelectionState> emit,
  ) async {
    emit(UserTypeSelectionLoading());

    try {
      // Validate user type
      if (event.userType != 'client' && event.userType != 'provider') {
        emit(
            UserTypeSelectionError(LocalizationService().l10n.invalidUserType));
        return;
      }

      // Simulate brief processing
      await Future.delayed(const Duration(milliseconds: 300));

      emit(UserTypeSelectionSelected(event.userType));
    } catch (e) {
      emit(UserTypeSelectionError(
          LocalizationService().l10n.errorSelectingUserType(e.toString())));
    }
  }

  void _onUserTypeSelectionReset(
    UserTypeSelectionReset event,
    Emitter<UserTypeSelectionState> emit,
  ) {
    emit(UserTypeSelectionInitial());
  }
}
