import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'contact_support_event.dart';
part 'contact_support_state.dart';

class ContactSupportBloc extends Bloc<ContactSupportEvent, ContactSupportState> {
  ContactSupportBloc() : super(ContactSupportInitial()) {
    on<SendMessageEvent>(_onSendMessage);
  }

  void _onSendMessage(
    SendMessageEvent event,
    Emitter<ContactSupportState> emit,
  ) async {
    emit(SendingMessage());

    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 2));

      // In a real app, you would call a use case here
      // final result = await sendMessageUseCase(
      //   name: event.name,
      //   email: event.email,
      //   category: event.category,
      //   subject: event.subject,
      //   message: event.message,
      // );

      // For now, we'll just simulate a successful response
      emit(MessageSentSuccess());
    } catch (e) {
      emit(MessageSentFailure(e.toString()));
    }
  }
}
