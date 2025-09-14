import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'settings_event.dart';
part 'settings_state.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  SettingsBloc() : super(SettingsInitial()) {
    on<LoadSettingsEvent>(_onLoadSettings);
    on<UpdatePushNotificationsEvent>(_onUpdatePushNotifications);
    on<UpdateEmailNotificationsEvent>(_onUpdateEmailNotifications);
    on<UpdateBookingRemindersEvent>(_onUpdateBookingReminders);
    on<UpdateLocationServicesEvent>(_onUpdateLocationServices);
    on<UpdateDataSharingEvent>(_onUpdateDataSharing);
    on<UpdateLanguageEvent>(_onUpdateLanguage);
    on<UpdateCurrencyEvent>(_onUpdateCurrency);
  }

  void _onLoadSettings(
    LoadSettingsEvent event,
    Emitter<SettingsState> emit,
  ) async {
    emit(SettingsLoading());
    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 1));

      // Read saved locale from preferences so we don't overwrite a
      // user-selected language when reloading settings.
      final prefs = await SharedPreferences.getInstance();
      String languageDisplay = 'English';
      final savedLocale = prefs.getString('locale');
      if (savedLocale != null) {
        final parts = savedLocale.split('_');
        final code = parts.isNotEmpty ? parts[0] : savedLocale;
        switch (code) {
          case 'ar':
            languageDisplay = 'Arabic';
            break;
          default:
            languageDisplay = 'English';
            break;
        }
      }

      // Mock settings data
      final settings = {
        'pushNotifications': true,
        'emailNotifications': true,
        'bookingReminders': true,
        'locationServices': true,
        'dataSharing': false,
        'language': languageDisplay,
        'currency': 'USD',
      };

      emit(SettingsLoaded(settings: settings));
    } catch (e) {
      emit(SettingsError(message: e.toString()));
    }
  }

  void _onUpdatePushNotifications(
    UpdatePushNotificationsEvent event,
    Emitter<SettingsState> emit,
  ) async {
    if (state is SettingsLoaded) {
      final currentState = state as SettingsLoaded;

      emit(SettingsUpdating(settings: currentState.settings));
      try {
        // Simulate API call
        await Future.delayed(const Duration(milliseconds: 500));

        // Update settings
        final updatedSettings =
            Map<String, dynamic>.from(currentState.settings);
        updatedSettings['pushNotifications'] = event.enabled;

        emit(SettingsLoaded(settings: updatedSettings));
        emit(SettingsUpdated());
      } catch (e) {
        emit(SettingsError(message: e.toString()));
        emit(currentState);
      }
    }
  }

  void _onUpdateEmailNotifications(
    UpdateEmailNotificationsEvent event,
    Emitter<SettingsState> emit,
  ) async {
    if (state is SettingsLoaded) {
      final currentState = state as SettingsLoaded;

      emit(SettingsUpdating(settings: currentState.settings));
      try {
        // Simulate API call
        await Future.delayed(const Duration(milliseconds: 500));

        // Update settings
        final updatedSettings =
            Map<String, dynamic>.from(currentState.settings);
        updatedSettings['emailNotifications'] = event.enabled;

        emit(SettingsLoaded(settings: updatedSettings));
        emit(SettingsUpdated());
      } catch (e) {
        emit(SettingsError(message: e.toString()));
        emit(currentState);
      }
    }
  }

  void _onUpdateBookingReminders(
    UpdateBookingRemindersEvent event,
    Emitter<SettingsState> emit,
  ) async {
    if (state is SettingsLoaded) {
      final currentState = state as SettingsLoaded;

      emit(SettingsUpdating(settings: currentState.settings));
      try {
        // Simulate API call
        await Future.delayed(const Duration(milliseconds: 500));

        // Update settings
        final updatedSettings =
            Map<String, dynamic>.from(currentState.settings);
        updatedSettings['bookingReminders'] = event.enabled;

        emit(SettingsLoaded(settings: updatedSettings));
        emit(SettingsUpdated());
      } catch (e) {
        emit(SettingsError(message: e.toString()));
        emit(currentState);
      }
    }
  }

  void _onUpdateLocationServices(
    UpdateLocationServicesEvent event,
    Emitter<SettingsState> emit,
  ) async {
    if (state is SettingsLoaded) {
      final currentState = state as SettingsLoaded;

      emit(SettingsUpdating(settings: currentState.settings));
      try {
        // Simulate API call
        await Future.delayed(const Duration(milliseconds: 500));

        // Update settings
        final updatedSettings =
            Map<String, dynamic>.from(currentState.settings);
        updatedSettings['locationServices'] = event.enabled;

        emit(SettingsLoaded(settings: updatedSettings));
        emit(SettingsUpdated());
      } catch (e) {
        emit(SettingsError(message: e.toString()));
        emit(currentState);
      }
    }
  }

  void _onUpdateDataSharing(
    UpdateDataSharingEvent event,
    Emitter<SettingsState> emit,
  ) async {
    if (state is SettingsLoaded) {
      final currentState = state as SettingsLoaded;

      emit(SettingsUpdating(settings: currentState.settings));
      try {
        // Simulate API call
        await Future.delayed(const Duration(milliseconds: 500));

        // Update settings
        final updatedSettings =
            Map<String, dynamic>.from(currentState.settings);
        updatedSettings['dataSharing'] = event.enabled;

        emit(SettingsLoaded(settings: updatedSettings));
        emit(SettingsUpdated());
      } catch (e) {
        emit(SettingsError(message: e.toString()));
        emit(currentState);
      }
    }
  }

  void _onUpdateLanguage(
    UpdateLanguageEvent event,
    Emitter<SettingsState> emit,
  ) async {
    if (state is SettingsLoaded) {
      final currentState = state as SettingsLoaded;

      emit(SettingsUpdating(settings: currentState.settings));
      try {
        // Simulate API call
        await Future.delayed(const Duration(milliseconds: 500));

        // Update settings
        final updatedSettings =
            Map<String, dynamic>.from(currentState.settings);
        updatedSettings['language'] = event.language;

        // Convert language string to Locale and update app locale
        Locale newLocale;
        bool isRTL = false;
        switch (event.language.toLowerCase()) {
          case 'arabic':
            newLocale = const Locale('ar');
            isRTL = true; // Set RTL for Arabic
            break;
          case 'english':
          default:
            newLocale = const Locale('en', 'US');
            break;
        }

        // Update the app locale by getting LocaleBloc from the service locator
        // This will be handled by the context that has access to LocaleBloc
        // We'll emit a special state that includes the locale information
        emit(SettingsLoaded(settings: updatedSettings));
        emit(SettingsLanguageChanged(locale: newLocale, isRTL: isRTL));
      } catch (e) {
        emit(SettingsError(message: e.toString()));
        emit(currentState);
      }
    }
  }

  void _onUpdateCurrency(
    UpdateCurrencyEvent event,
    Emitter<SettingsState> emit,
  ) async {
    if (state is SettingsLoaded) {
      final currentState = state as SettingsLoaded;

      emit(SettingsUpdating(settings: currentState.settings));
      try {
        // Simulate API call
        await Future.delayed(const Duration(milliseconds: 500));

        // Update settings
        final updatedSettings =
            Map<String, dynamic>.from(currentState.settings);
        updatedSettings['currency'] = event.currency;

        emit(SettingsLoaded(settings: updatedSettings));
        emit(SettingsUpdated());
      } catch (e) {
        emit(SettingsError(message: e.toString()));
        emit(currentState);
      }
    }
  }
}
