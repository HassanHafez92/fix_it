import 'package:shared_preferences/shared_preferences.dart';

class FavoritesService {
  static const _favoriteServicesKey = 'FAVORITE_SERVICES';

  final SharedPreferences _prefs;

  FavoritesService._(this._prefs);

  static Future<FavoritesService> getInstance() async {
    final prefs = await SharedPreferences.getInstance();
    return FavoritesService._(prefs);
  }

  List<String> _getIds() {
    return _prefs.getStringList(_favoriteServicesKey) ?? <String>[];
  }

  bool isFavorite(String id) {
    final ids = _getIds();
    return ids.contains(id);
  }

  Future<void> toggleFavorite(String id) async {
    final ids = _getIds();
    if (ids.contains(id)) {
      ids.remove(id);
    } else {
      ids.add(id);
    }
    await _prefs.setStringList(_favoriteServicesKey, ids);
  }
}
