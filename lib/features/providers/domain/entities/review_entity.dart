import 'package:equatable/equatable.dart';

/// ReviewEntity
///
/// Domain model for provider reviews.
///
/// Business Rules:
///  - Reviews are authored by users and attached to a single provider.
class ReviewEntity extends Equatable {
  final String id;
  final String providerId;
  final String userId;
  final String userName;
  final String userImage;
  final double rating;
  final String comment;
  final DateTime createdAt;
  final List<String> images;

  const ReviewEntity({
    required this.id,
    required this.providerId,
    required this.userId,
    required this.userName,
    required this.userImage,
    required this.rating,
    required this.comment,
    required this.createdAt,
    required this.images,
  });

  @override
  List<Object?> get props => [
        id,
        providerId,
        userId,
        userName,
        userImage,
        rating,
        comment,
        createdAt,
        images,
      ];
}
