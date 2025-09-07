import 'package:flutter_bloc/flutter_bloc.dart';
import 'user_type_selection_event.dart';
import 'user_type_selection_state.dart';

class UserTypeSelectionBloc extends Bloc<UserTypeSelectionEvent, UserTypeSelectionState> {
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
        emit(const UserTypeSelectionError('نوع المستخدم غير صحيح'));
        return;
      }

      // Simulate brief processing
      await Future.delayed(const Duration(milliseconds: 300));

      emit(UserTypeSelectionSelected(event.userType));
    } catch (e) {
      emit(UserTypeSelectionError('حدث خطأ أثناء اختيار نوع المستخدم: ${e.toString()}'));
    }
  }

  void _onUserTypeSelectionReset(
    UserTypeSelectionReset event,
    Emitter<UserTypeSelectionState> emit,
  ) {
    emit(UserTypeSelectionInitial());
  }
}