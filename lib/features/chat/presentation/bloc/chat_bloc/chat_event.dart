part of 'chat_bloc.dart';

abstract class ChatEvent extends Equatable {
  const ChatEvent();

  @override
  List<Object?> get props => [];
}

class LoadChatMessagesEvent extends ChatEvent {
  final String chatId;

  const LoadChatMessagesEvent({required this.chatId});

  @override
  List<Object> get props => [chatId];
}

class SendMessageEvent extends ChatEvent {
  final String chatId;
  final String message;
  final String? attachmentUrl;
  final String? attachmentType;

  const SendMessageEvent({
    required this.chatId,
    required this.message,
    this.attachmentUrl,
    this.attachmentType,
  });

  @override
  List<Object?> get props => [chatId, message, attachmentUrl, attachmentType];
}
