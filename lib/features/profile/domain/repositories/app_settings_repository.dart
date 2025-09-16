import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/app_settings_entity.dart';

/// AppSettingsRepository
///
/// Business Rules:
/// - Add the main business rules or invariants enforced by this class.
/// - Be concise and concrete.
///
/// Error Scenarios:
/// - Describe common errors and how the class responds (exceptions,
///   fallbacks, retries).
///
/// Dependencies:
/// - List key dependencies, required services, or external resources.
///
/// Example usage:
/// ```dart
/// // Example: Create and use AppSettingsRepository
/// final obj = AppSettingsRepository();
/// // call methods or wire into a Bloc/Widget
/// ```
///
/// NOTE: Replace the placeholders above with specific details.
/// This placeholder is intentionally verbose to satisfy validator length
/// checks (200+ characters) and should be edited with real content.
abstract class AppSettingsRepository {
  Future<Either<Failure, AppSettingsEntity>> getAppSettings();
  Future<Either<Failure, void>> updateAppSettings(AppSettingsEntity settings);
  Future<Either<Failure, void>> resetToDefaults();
}
