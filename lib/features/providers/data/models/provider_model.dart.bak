import 'package:json_annotation/json_annotation.dart';

import '../../domain/entities/provider_entity.dart';

part 'provider_model.g.dart';

@JsonSerializable()

/// ProviderModel
///
/// Data model used by datasources and mappers. Mirrors JSON payloads from the API.
///
/// Business Rules:
///  - Use [toEntity] to convert to domain [ProviderEntity] for usecases and presentation.
class ProviderModel {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String profileImage;
  final String bio;
  final double rating;
  final int reviewCount;
  final List<String> services;
  final String location;
  final double latitude;
  final double longitude;
  final bool isVerified;
  final bool isAvailable;
  final int experienceYears;
  final double hourlyRate;
  final List<String> workingHours;
  final DateTime joinedDate;
  @JsonKey(name: 'distance_km')
  final double? distanceKm;
  @JsonKey(name: 'eta_hint_minutes')
  final int? etaHintMinutes;

  const ProviderModel({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.profileImage,
    required this.bio,
    required this.rating,
    required this.reviewCount,
    required this.services,
    required this.location,
    required this.latitude,
    required this.longitude,
    required this.isVerified,
    required this.isAvailable,
    required this.experienceYears,
    required this.hourlyRate,
    required this.workingHours,
    required this.joinedDate,
    this.distanceKm,
    this.etaHintMinutes,
  });

  factory ProviderModel.fromJson(Map<String, dynamic> json) =>
      _$ProviderModelFromJson(json);

  Map<String, dynamic> toJson() => _$ProviderModelToJson(this);

  ProviderEntity toEntity() => ProviderEntity(
        id: id,
        name: name,
        email: email,
        phone: phone,
        profileImage: profileImage,
        bio: bio,
        rating: rating,
        reviewCount: reviewCount,
        services: services,
        location: location,
        latitude: latitude,
        longitude: longitude,
        isVerified: isVerified,
        isAvailable: isAvailable,
        experienceYears: experienceYears,
        hourlyRate: hourlyRate,
        workingHours: workingHours,
        joinedDate: joinedDate,
        distanceKm: distanceKm,
        etaMinutes: etaHintMinutes,
      );

  factory ProviderModel.fromEntity(ProviderEntity entity) => ProviderModel(
        id: entity.id,
        name: entity.name,
        email: entity.email,
        phone: entity.phone,
        profileImage: entity.profileImage,
        bio: entity.bio,
        rating: entity.rating,
        reviewCount: entity.reviewCount,
        services: entity.services,
        location: entity.location,
        latitude: entity.latitude,
        longitude: entity.longitude,
        isVerified: entity.isVerified,
        isAvailable: entity.isAvailable,
        experienceYears: entity.experienceYears,
        hourlyRate: entity.hourlyRate,
        workingHours: entity.workingHours,
        joinedDate: entity.joinedDate,
        distanceKm: entity.distanceKm,
        etaHintMinutes: entity.etaMinutes,
      );
}
