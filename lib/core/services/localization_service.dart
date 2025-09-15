/// LocalizationService
///
/// Business Rules:
/// - Add the main business rules or invariants enforced by this class.

import 'package:fix_it/l10n/app_localizations.dart';
/// LocalizationService
///
/// Business rules:
/// - Describe the business rules that this class enforces.
///
/// Dependencies:
/// - List important dependencies or preconditions.
///
/// Error scenarios:
/// - Describe common error conditions and how they are handled.


class LocalizationService {
  static final LocalizationService _instance = LocalizationService._internal();
  factory LocalizationService() => _instance;
  LocalizationService._internal();

  AppLocalizations? _localizations;

  void init(AppLocalizations localizations) {
    _localizations = localizations;
  }

  AppLocalizations get l10n {
    if (_localizations == null) {
      throw Exception("LocalizationService not initialized");
    }
    return _localizations!;
  }
}
