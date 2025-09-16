// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fix_it/core/services/text_direction_service.dart';

part 'locale_event.dart';
part 'locale_state.dart';

class LocaleBloc extends Bloc<LocaleEvent, LocaleState> {
  LocaleBloc() : super(const LocaleState(Locale('ar'))) {
    on<ChangeLocaleEvent>(_onChangeLocale);
    on<LoadSavedLocaleEvent>(_onLoadSavedLocale);
  }

  void _onChangeLocale(
      ChangeLocaleEvent event, Emitter<LocaleState> emit) async {
    // ignore: duplicate_ignore
    // ignore: avoid_print
    print('LocaleBloc: received ChangeLocaleEvent -> ${event.locale}');
    final prefs = await SharedPreferences.getInstance();
    // Save locale with language code only for Arabic, or languageCode_countryCode for others
    String localeString = event.locale.languageCode;
    if (event.locale.languageCode != 'ar' && event.locale.countryCode != null) {
      localeString += '_${event.locale.countryCode}';
    }
    await prefs.setString('locale', localeString);
    print('LocaleBloc: saved locale $localeString to prefs');
  // Update global text direction service so widgets using
  // DirectionalityWrapper reflect the new locale immediately.
  TextDirectionService().setTextDirection(event.locale);
    emit(LocaleState(event.locale));
  }

  void _onLoadSavedLocale(
      LoadSavedLocaleEvent event, Emitter<LocaleState> emit) async {
    print('LocaleBloc: received LoadSavedLocaleEvent');
    final prefs = await SharedPreferences.getInstance();
    final savedLocale = prefs.getString('locale');

    if (savedLocale != null) {
      final parts = savedLocale.split('_');
      if (parts.length == 1) {
        // Handle language code only (like Arabic)
        emit(LocaleState(Locale(parts[0])));
        return;
      } else if (parts.length == 2) {
        // Handle language code and country code
        emit(LocaleState(Locale(parts[0], parts[1])));
        return;
      }
    }

    // Default to Arabic if no saved locale
    print('LocaleBloc: no saved locale, defaulting to ar');
  final defaultLocale = const Locale('ar');
  TextDirectionService().setTextDirection(defaultLocale);
  emit(LocaleState(defaultLocale));
  }
}