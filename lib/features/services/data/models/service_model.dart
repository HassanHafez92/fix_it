import 'package:json_annotation/json_annotation.dart';

import '../../domain/entities/service_entity.dart';

part 'service_model.g.dart';

@JsonSerializable()
class ServiceModel extends ServiceEntity {
  const ServiceModel({
    required super.id,
    required super.name,
    required super.description,
    required super.category,
    required super.price,
    required super.duration,
    required super.images,
    required super.rating,
    required super.reviewCount,
    required super.isAvailable,
  });

  factory ServiceModel.fromJson(Map<String, dynamic> json) =>
      _$ServiceModelFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$ServiceModelToJson(this);

  factory ServiceModel.fromEntity(ServiceEntity entity) {
    return ServiceModel(
      id: entity.id,
      name: entity.name,
      description: entity.description,
      category: entity.category,
      price: entity.price,
      duration: entity.duration,
      images: entity.images,
      rating: entity.rating,
      reviewCount: entity.reviewCount,
      isAvailable: entity.isAvailable,
    );
  }

  // Added for compatibility with existing code
  String get categoryId => category;
}
