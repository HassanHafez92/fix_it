import 'package:equatable/equatable.dart';

class UserProfileEntity extends Equatable {
  final String id;
  final String fullName;
  final String email;
  final String? phoneNumber;
  final String? profilePictureUrl;
  final String? bio;
  final List<String> paymentMethods;
  final DateTime createdAt;
  final DateTime updatedAt;

  const UserProfileEntity({
    required this.id,
    required this.fullName,
    required this.email,
    this.phoneNumber,
    this.profilePictureUrl,
    this.bio,
    this.paymentMethods = const [],
    required this.createdAt,
    required this.updatedAt,
  });

  UserProfileEntity copyWith({
    String? id,
    String? fullName,
    String? email,
    String? phoneNumber,
    String? profilePictureUrl,
    String? bio,
    List<String>? paymentMethods,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return UserProfileEntity(
      id: id ?? this.id,
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      profilePictureUrl: profilePictureUrl ?? this.profilePictureUrl,
      bio: bio ?? this.bio,
      paymentMethods: paymentMethods ?? this.paymentMethods,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [
        id,
        fullName,
        email,
        phoneNumber,
        profilePictureUrl,
        bio,
        paymentMethods,
        createdAt,
        updatedAt,
      ];
}