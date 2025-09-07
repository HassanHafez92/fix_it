import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/user_entity.dart';

part 'user_model.g.dart';

@JsonSerializable()
class UserModel extends UserEntity {
  const UserModel({
    required super.id,
    required super.email,
    required super.fullName,
    super.phoneNumber,
    required super.userType,
    super.profession,
    super.profilePictureUrl,
    super.token,
    required super.createdAt,
    required super.updatedAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => _$UserModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserModelToJson(this);

  factory UserModel.fromEntity(UserEntity entity) {
    return UserModel(
      id: entity.id,
      email: entity.email,
      fullName: entity.fullName,
      phoneNumber: entity.phoneNumber,
      userType: entity.userType,
      profession: entity.profession,
      profilePictureUrl: entity.profilePictureUrl,
      token: entity.token,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }

  UserEntity toEntity() {
    return UserEntity(
      id: id,
      email: email,
      fullName: fullName,
      phoneNumber: phoneNumber,
      userType: userType,
      profession: profession,
      profilePictureUrl: profilePictureUrl,
      token: token,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  @override
  UserModel copyWith({
    String? id,
    String? email,
    String? fullName,
    String? phoneNumber,
    String? userType,
    String? profession,
    String? profilePictureUrl,
    String? token,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return UserModel(
      id: id ?? this.id,
      email: email ?? this.email,
      fullName: fullName ?? this.fullName,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      userType: userType ?? this.userType,
      profession: profession ?? this.profession,
      profilePictureUrl: profilePictureUrl ?? this.profilePictureUrl,
      token: token ?? this.token,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
