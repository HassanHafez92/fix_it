import 'package:dartz/dartz.dart';
import 'package:fix_it/core/error/failures.dart';
import 'package:fix_it/core/usecases/usecase.dart';
import 'package:fix_it/features/chat/domain/entities/chat_entity.dart';
import 'package:fix_it/features/chat/domain/repositories/chat_repository.dart';

class GetChatListUseCase implements UseCase<List<ChatEntity>, NoParams> {
  final ChatRepository repository;

  GetChatListUseCase(this.repository);

  @override
  Future<Either<Failure, List<ChatEntity>>> call(NoParams params) async {
    return await repository.getChatList();
  }
}
