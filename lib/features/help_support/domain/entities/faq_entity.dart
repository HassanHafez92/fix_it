import 'package:equatable/equatable.dart';

class FAQEntity extends Equatable {
  final String id;
  final String question;
  final String answer;
  final String category;
  final int order;
  final bool isExpanded;

  const FAQEntity({
    required this.id,
    required this.question,
    required this.answer,
    required this.category,
    this.order = 0,
    this.isExpanded = false,
  });

  FAQEntity copyWith({
    String? id,
    String? question,
    String? answer,
    String? category,
    int? order,
    bool? isExpanded,
  }) {
    return FAQEntity(
      id: id ?? this.id,
      question: question ?? this.question,
      answer: answer ?? this.answer,
      category: category ?? this.category,
      order: order ?? this.order,
      isExpanded: isExpanded ?? this.isExpanded,
    );
  }

  @override
  List<Object> get props => [id, question, answer, category, order, isExpanded];
}

class ContactInfoEntity extends Equatable {
  final String id;
  final ContactType type;
  final String value;
  final String description;
  final bool isActive;

  const ContactInfoEntity({
    required this.id,
    required this.type,
    required this.value,
    required this.description,
    this.isActive = true,
  });

  @override
  List<Object> get props => [id, type, value, description, isActive];
}

enum ContactType {
  email,
  phone,
  whatsapp,
  website,
  social,
}

extension ContactTypeExtension on ContactType {
  String get iconName {
    switch (this) {
      case ContactType.email:
        return 'email';
      case ContactType.phone:
        return 'phone';
      case ContactType.whatsapp:
        return 'chat';
      case ContactType.website:
        return 'language';
      case ContactType.social:
        return 'share';
    }
  }
}