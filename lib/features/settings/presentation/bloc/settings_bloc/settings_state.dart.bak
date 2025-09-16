part of 'settings_bloc.dart';

abstract class SettingsState extends Equatable {
  const SettingsState();

  @override
  List<Object> get props => [];
}

class SettingsInitial extends SettingsState {}

class SettingsLoading extends SettingsState {}

class SettingsLoaded extends SettingsState {
  final Map<String, dynamic> settings;

  const SettingsLoaded({required this.settings});

  @override
  List<Object> get props => [settings];
}

class SettingsUpdating extends SettingsState {
  final Map<String, dynamic> settings;

  const SettingsUpdating({required this.settings});

  @override
  List<Object> get props => [settings];
}

class SettingsUpdated extends SettingsState {}

class SettingsError extends SettingsState {
  final String message;

  const SettingsError({required this.message});

  @override
  List<Object> get props => [message];
}

class SettingsLanguageChanged extends SettingsState {
  final Locale locale;
  final bool isRTL;

  const SettingsLanguageChanged({required this.locale, this.isRTL = false});

  @override
  List<Object> get props => [locale, isRTL];
}
