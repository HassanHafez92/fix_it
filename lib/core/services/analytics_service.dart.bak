import '../../app_config.dart';

class AnalyticsService {
  static final AnalyticsService _instance = AnalyticsService._internal();

  factory AnalyticsService() => _instance;

  AnalyticsService._internal();

  /// Initialize analytics providers here when available.
  Future<void> init() async {
    // No-op for now; the project may wire a concrete analytics implementation later.
  }

  Future<void> logEvent(String name, Map<String, Object?> params) async {
    if (!AppConfig.enableAnalytics) return;
    // Lightweight debug logging so events are visible during development.
    // Replace with a concrete analytics provider (e.g., FirebaseAnalytics) later.
    // ignore: avoid_print
    print('[Analytics] $name -> $params');
  }
}
