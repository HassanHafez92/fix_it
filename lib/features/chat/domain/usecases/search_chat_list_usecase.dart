import 'package:dartz/dartz.dart';
import 'package:fix_it/core/error/failures.dart';
import 'package:fix_it/core/usecases/usecase.dart';
import 'package:fix_it/features/chat/domain/entities/chat_entity.dart';
import 'package:fix_it/features/chat/domain/repositories/chat_repository.dart';

class SearchChatListUseCase implements UseCase<List<ChatEntity>, String> {
  final ChatRepository repository;

  SearchChatListUseCase(this.repository);

  @override
  Future<Either<Failure, List<ChatEntity>>> call(String params) async {
    return await repository.searchChatList(params);
  }
}
