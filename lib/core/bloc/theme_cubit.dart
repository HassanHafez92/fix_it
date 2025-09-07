import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Simple cubit that holds the application's [ThemeMode] and persists the
/// user's preference in [SharedPreferences].
class ThemeCubit extends Cubit<ThemeMode> {
  final SharedPreferences _prefs;
  static const String _prefKey = 'theme_mode';

  ThemeCubit(SharedPreferences prefs)
      : _prefs = prefs,
        super(_loadInitial(prefs));

  static ThemeMode _loadInitial(SharedPreferences prefs) {
    final v = prefs.getString(_prefKey);
    switch (v) {
      case 'light':
        return ThemeMode.light;
      case 'dark':
        return ThemeMode.dark;
      case 'system':
      default:
        return ThemeMode.system;
    }
  }

  Future<void> _save(ThemeMode mode) async {
    final value = mode == ThemeMode.light
        ? 'light'
        : mode == ThemeMode.dark
            ? 'dark'
            : 'system';
    await _prefs.setString(_prefKey, value);
  }

  /// Set explicit light mode
  void setLight() {
    emit(ThemeMode.light);
    _save(ThemeMode.light);
  }

  /// Set explicit dark mode
  void setDark() {
    emit(ThemeMode.dark);
    _save(ThemeMode.dark);
  }

  /// Toggle between light and dark
  void toggle(bool enabled) {
    final next = enabled ? ThemeMode.dark : ThemeMode.light;
    emit(next);
    _save(next);
  }

  /// Reset to system preference
  void setSystem() {
    emit(ThemeMode.system);
    _save(ThemeMode.system);
  }
}
