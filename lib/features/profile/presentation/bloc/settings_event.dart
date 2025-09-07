import 'package:equatable/equatable.dart';
import '../../domain/entities/app_settings_entity.dart';

abstract class SettingsEvent extends Equatable {
  const SettingsEvent();

  @override
  List<Object> get props => [];
}

class LoadSettings extends SettingsEvent {}

class UpdateSettings extends SettingsEvent {
  final AppSettingsEntity settings;

  const UpdateSettings(this.settings);

  @override
  List<Object> get props => [settings];
}

class ResetSettings extends SettingsEvent {}