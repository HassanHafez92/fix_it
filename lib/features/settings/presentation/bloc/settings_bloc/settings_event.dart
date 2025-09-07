part of 'settings_bloc.dart';

abstract class SettingsEvent extends Equatable {
  const SettingsEvent();

  @override
  List<Object> get props => [];
}

class LoadSettingsEvent extends SettingsEvent {
  const LoadSettingsEvent();
}

class UpdatePushNotificationsEvent extends SettingsEvent {
  final bool enabled;

  const UpdatePushNotificationsEvent({required this.enabled});

  @override
  List<Object> get props => [enabled];
}

class UpdateEmailNotificationsEvent extends SettingsEvent {
  final bool enabled;

  const UpdateEmailNotificationsEvent({required this.enabled});

  @override
  List<Object> get props => [enabled];
}

class UpdateBookingRemindersEvent extends SettingsEvent {
  final bool enabled;

  const UpdateBookingRemindersEvent({required this.enabled});

  @override
  List<Object> get props => [enabled];
}

class UpdateLocationServicesEvent extends SettingsEvent {
  final bool enabled;

  const UpdateLocationServicesEvent({required this.enabled});

  @override
  List<Object> get props => [enabled];
}

class UpdateDataSharingEvent extends SettingsEvent {
  final bool enabled;

  const UpdateDataSharingEvent({required this.enabled});

  @override
  List<Object> get props => [enabled];
}

class UpdateLanguageEvent extends SettingsEvent {
  final String language;

  const UpdateLanguageEvent({required this.language});

  @override
  List<Object> get props => [language];
}

class UpdateCurrencyEvent extends SettingsEvent {
  final String currency;

  const UpdateCurrencyEvent({required this.currency});

  @override
  List<Object> get props => [currency];
}
