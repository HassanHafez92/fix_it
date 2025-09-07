import 'package:flutter/material.dart';

/// A service to manage text direction throughout the app
/// This ensures consistent RTL/LTR behavior across all screens
class TextDirectionService {
  static final TextDirectionService _instance = TextDirectionService._internal();

  factory TextDirectionService() {
    return _instance;
  }

  TextDirectionService._internal();

  TextDirection _textDirection = TextDirection.ltr;

  /// Get the current text direction
  TextDirection get textDirection => _textDirection;

  /// Set the text direction based on locale
  void setTextDirection(Locale locale) {
    _textDirection = locale.languageCode == 'ar' 
        ? TextDirection.rtl 
        : TextDirection.ltr;
  }

  /// Check if current text direction is RTL
  bool get isRTL => _textDirection == TextDirection.rtl;
}
