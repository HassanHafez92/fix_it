part of 'contact_support_bloc.dart';

abstract class ContactSupportEvent extends Equatable {
  const ContactSupportEvent();

  @override
  List<Object> get props => [];
}

class SendMessageEvent extends ContactSupportEvent {
  final String name;
  final String email;
  final String category;
  final String subject;
  final String message;

  const SendMessageEvent({
    required this.name,
    required this.email,
    required this.category,
    required this.subject,
    required this.message,
  });

  @override
  List<Object> get props => [name, email, category, subject, message];
}
