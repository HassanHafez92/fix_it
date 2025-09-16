import 'package:equatable/equatable.dart';

/// ProviderEntity
///
/// Represents a provider (service professional) in the domain layer.
///
/// Business Rules:
///  - Instances are immutable value objects used across usecases and presentation.
///  - Distance and ETA are optional and only set by proximity/search flows.
class ProviderEntity extends Equatable {
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
  final double? distanceKm; // optional from proximity search
  final int? etaMinutes; // optional estimate

  const ProviderEntity({
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
    this.etaMinutes,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        email,
        phone,
        profileImage,
        bio,
        rating,
        reviewCount,
        services,
        location,
        latitude,
        longitude,
        isVerified,
        isAvailable,
        experienceYears,
        hourlyRate,
        workingHours,
        joinedDate,
        distanceKm,
        etaMinutes,
      ];
}
