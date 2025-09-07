part of 'contact_support_bloc.dart';

abstract class ContactSupportState extends Equatable {
  const ContactSupportState();

  @override
  List<Object> get props => [];
}

class ContactSupportInitial extends ContactSupportState {}

class SendingMessage extends ContactSupportState {}

class MessageSentSuccess extends ContactSupportState {}

class MessageSentFailure extends ContactSupportState {
  final String message;

  const MessageSentFailure(this.message);

  @override
  List<Object> get props => [message];
}
