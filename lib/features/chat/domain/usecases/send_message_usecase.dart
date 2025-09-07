import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:fix_it/core/error/failures.dart';
import 'package:fix_it/core/usecases/usecase.dart';
import 'package:fix_it/features/chat/domain/repositories/chat_repository.dart';

class SendMessageUseCase implements UseCase<bool, SendMessageParams> {
  final ChatRepository repository;

  SendMessageUseCase(this.repository);

  @override
  Future<Either<Failure, bool>> call(SendMessageParams params) async {
    return await repository.sendMessage(
      chatId: params.chatId,
      message: params.message,
      attachmentUrl: params.attachmentUrl,
      attachmentType: params.attachmentType,
    );
  }
}

class SendMessageParams extends Equatable {
  final String chatId;
  final String message;
  final String? attachmentUrl;
  final String? attachmentType;

  const SendMessageParams({
    required this.chatId,
    required this.message,
    this.attachmentUrl,
    this.attachmentType,
  });

  @override
  List<Object?> get props => [chatId, message, attachmentUrl, attachmentType];
}
