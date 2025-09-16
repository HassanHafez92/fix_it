import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'user_type_selection_event.dart';
part 'user_type_selection_state.dart';

class UserTypeSelectionBloc extends Bloc<UserTypeSelectionEvent, UserTypeSelectionState> {
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

    emit(UserTypeSelectedState(userType: event.userType));
  }
}
