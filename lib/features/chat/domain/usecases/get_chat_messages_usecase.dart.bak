import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:fix_it/core/error/failures.dart';
import 'package:fix_it/core/usecases/usecase.dart';
import 'package:fix_it/features/chat/domain/entities/message_entity.dart';
import 'package:fix_it/features/chat/domain/repositories/chat_repository.dart';

class GetChatMessagesUseCase implements UseCase<List<MessageEntity>, GetChatMessagesParams> {
  final ChatRepository repository;

  GetChatMessagesUseCase(this.repository);

  @override
  Future<Either<Failure, List<MessageEntity>>> call(GetChatMessagesParams params) async {
    return await repository.getChatMessages(params.chatId);
  }
}

class GetChatMessagesParams extends Equatable {
  final String chatId;

  const GetChatMessagesParams({required this.chatId});

  @override
  List<Object> get props => [chatId];
}
