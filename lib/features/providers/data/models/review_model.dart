import 'package:json_annotation/json_annotation.dart';

import '../../domain/entities/review_entity.dart';

part 'review_model.g.dart';

@JsonSerializable()
class ReviewModel extends ReviewEntity {
  const ReviewModel({
    required super.id,
    required super.providerId,
    required super.userId,
    required super.userName,
    required super.userImage,
    required super.rating,
    required super.comment,
    required super.createdAt,
    required super.images,
  });

  factory ReviewModel.fromJson(Map<String, dynamic> json) =>
      _$ReviewModelFromJson(json);

  Map<String, dynamic> toJson() => _$ReviewModelToJson(this);

  factory ReviewModel.fromEntity(ReviewEntity entity) {
    return ReviewModel(
      id: entity.id,
      providerId: entity.providerId,
      userId: entity.userId,
      userName: entity.userName,
      userImage: entity.userImage,
      rating: entity.rating,
      comment: entity.comment,
      createdAt: entity.createdAt,
      images: entity.images,
    );
  }
}
