import 'package:equatable/equatable.dart';
import 'package:fix_it/features/chat/domain/entities/message_entity.dart';
import 'package:fix_it/features/chat/domain/usecases/get_chat_messages_usecase.dart';
import 'package:fix_it/features/chat/domain/usecases/send_message_usecase.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'chat_event.dart';
part 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final GetChatMessagesUseCase getChatMessagesUseCase;
  final SendMessageUseCase sendMessageUseCase;

  ChatBloc({
    required this.getChatMessagesUseCase,
    required this.sendMessageUseCase,
  }) : super(ChatInitial()) {
    on<LoadChatMessagesEvent>(_onLoadChatMessages);
    on<SendMessageEvent>(_onSendMessage);
  }

  void _onLoadChatMessages(
    LoadChatMessagesEvent event,
    Emitter<ChatState> emit,
  ) async {
    emit(ChatLoading());

    try {
      final result = await getChatMessagesUseCase(
          GetChatMessagesParams(chatId: event.chatId));

      result.fold(
        (failure) => emit(ChatError(failure.message)),
        (messages) => emit(ChatMessagesLoaded(messages)),
      );
    } catch (e) {
      emit(ChatError(e.toString()));
    }
  }

  void _onSendMessage(
    SendMessageEvent event,
    Emitter<ChatState> emit,
  ) async {
    // If we already have messages, keep them and add sending state
    if (state is ChatMessagesLoaded) {
      final currentMessages = (state as ChatMessagesLoaded).messages;
      emit(ChatMessagesLoaded(currentMessages));
    }

    emit(ChatSending());

    try {
      final result = await sendMessageUseCase(
        SendMessageParams(
          chatId: event.chatId,
          message: event.message,
          attachmentUrl: event.attachmentUrl,
          attachmentType: event.attachmentType,
        ),
      );

      result.fold(
        (failure) => emit(ChatError(failure.message)),
        (success) {
          // Reload messages after sending
          add(LoadChatMessagesEvent(chatId: event.chatId));
        },
      );
    } catch (e) {
      emit(ChatError(e.toString()));
    }
  }
}
