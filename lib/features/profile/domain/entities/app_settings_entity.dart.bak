import 'dart:convert';
import 'package:equatable/equatable.dart';

class AppSettingsEntity extends Equatable {
  final String language;
  final String currency;
  final bool pushNotificationsEnabled;
  final bool emailNotificationsEnabled;
  final bool locationServicesEnabled;
  final bool dataSharingEnabled;
  final String theme; // 'light', 'dark', 'system'

  const AppSettingsEntity({
    this.language = 'ar',
    this.currency = 'SAR',
    this.pushNotificationsEnabled = true,
    this.emailNotificationsEnabled = true,
    this.locationServicesEnabled = true,
    this.dataSharingEnabled = false,
    this.theme = 'system',
  });

  AppSettingsEntity copyWith({
    String? language,
    String? currency,
    bool? pushNotificationsEnabled,
    bool? emailNotificationsEnabled,
    bool? locationServicesEnabled,
    bool? dataSharingEnabled,
    String? theme,
  }) {
    return AppSettingsEntity(
      language: language ?? this.language,
      currency: currency ?? this.currency,
      pushNotificationsEnabled: pushNotificationsEnabled ?? this.pushNotificationsEnabled,
      emailNotificationsEnabled: emailNotificationsEnabled ?? this.emailNotificationsEnabled,
      locationServicesEnabled: locationServicesEnabled ?? this.locationServicesEnabled,
      dataSharingEnabled: dataSharingEnabled ?? this.dataSharingEnabled,
      theme: theme ?? this.theme,
    );
  }

  @override
  List<Object> get props => [
        language,
        currency,
        pushNotificationsEnabled,
        emailNotificationsEnabled,
        locationServicesEnabled,
        dataSharingEnabled,
        theme,
      ];

  /// Converts the entity to a JSON string
  String toJson() {
    return '{"language":"$language","currency":"$currency","pushNotificationsEnabled":$pushNotificationsEnabled,"emailNotificationsEnabled":$emailNotificationsEnabled,"locationServicesEnabled":$locationServicesEnabled,"dataSharingEnabled":$dataSharingEnabled,"theme":"$theme"}';
  }

  /// Creates an entity from a JSON string
  factory AppSettingsEntity.fromJson(String jsonString) {
    try {
      final Map<String, dynamic> json = jsonString.isNotEmpty 
          ? Map<String, dynamic>.from(jsonDecode(jsonString)) 
          : <String, dynamic>{};
      
      return AppSettingsEntity(
        language: json['language'] ?? 'ar',
        currency: json['currency'] ?? 'SAR',
        pushNotificationsEnabled: json['pushNotificationsEnabled'] ?? true,
        emailNotificationsEnabled: json['emailNotificationsEnabled'] ?? true,
        locationServicesEnabled: json['locationServicesEnabled'] ?? true,
        dataSharingEnabled: json['dataSharingEnabled'] ?? false,
        theme: json['theme'] ?? 'system',
      );
    } catch (e) {
      // Return default settings if JSON parsing fails
      return const AppSettingsEntity();
    }
  }
}