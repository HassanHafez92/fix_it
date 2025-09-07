// ignore: depend_on_referenced_packages
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:fix_it/core/usecases/usecase.dart';
import 'package:fix_it/features/chat/domain/entities/chat_entity.dart';
import 'package:fix_it/features/chat/domain/usecases/get_chat_list_usecase.dart';
import 'package:fix_it/features/chat/domain/usecases/search_chat_list_usecase.dart';

part 'chat_list_event.dart';
part 'chat_list_state.dart';

class ChatListBloc extends Bloc<ChatListEvent, ChatListState> {
  final GetChatListUseCase getChatListUseCase;
  final SearchChatListUseCase searchChatListUseCase;

  ChatListBloc({
    required this.getChatListUseCase,
    required this.searchChatListUseCase,
  }) : super(ChatListInitial()) {
    on<LoadChatListEvent>(_onLoadChatList);
    on<SearchChatListEvent>(_onSearchChatList);
  }

  void _onLoadChatList(
    LoadChatListEvent event,
    Emitter<ChatListState> emit,
  ) async {
    emit(ChatListLoading());

    try {
      final result = await getChatListUseCase(const NoParamsImpl());

      result.fold(
        (failure) => emit(ChatListError(failure.message)),
        (chats) => emit(ChatListLoaded(chats)),
      );
    } catch (e) {
      emit(ChatListError(e.toString()));
    }
  }

  void _onSearchChatList(
    SearchChatListEvent event,
    Emitter<ChatListState> emit,
  ) async {
    emit(ChatListLoading());

    try {
      final result = await searchChatListUseCase(event.query);

      result.fold(
        (failure) => emit(ChatListError(failure.message)),
        (chats) => emit(ChatListLoaded(chats)),
      );
    } catch (e) {
      emit(ChatListError(e.toString()));
    }
  }
}
