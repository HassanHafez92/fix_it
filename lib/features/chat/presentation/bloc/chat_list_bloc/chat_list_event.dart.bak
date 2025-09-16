part of 'chat_list_bloc.dart';

abstract class ChatListEvent extends Equatable {
  const ChatListEvent();

  @override
  List<Object> get props => [];
}

class LoadChatListEvent extends ChatListEvent {
  const LoadChatListEvent();
}

class SearchChatListEvent extends ChatListEvent {
  final String query;

  const SearchChatListEvent(this.query);

  @override
  List<Object> get props => [query];
}
