import 'package:fix_it/l10n/app_localizations.dart';

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
