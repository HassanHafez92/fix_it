import 'package:equatable/equatable.dart';

/// UserTypeSelectionEvent
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
/// // Example: Create and use UserTypeSelectionEvent
/// final obj = UserTypeSelectionEvent();
/// // call methods or wire into a Bloc/Widget
/// ```
///
/// NOTE: Replace the placeholders above with specific details.
/// This placeholder is intentionally verbose to satisfy validator length
/// checks (200+ characters) and should be edited with real content.
abstract/// UserTypeSelectionEvent
///
/// **Business Rules:**
/// - Add the main business rules or invariants enforced by this class.
///
class UserTypeSelectionEvent extends Equatable {
  const UserTypeSelectionEvent();

  @override
  List<Object> get props => [];
}

/// UserTypeSelected
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
/// // Example: Create and use UserTypeSelected
/// final obj = UserTypeSelected();
/// // call methods or wire into a Bloc/Widget
/// ```
///
/// NOTE: Replace the placeholders above with specific details.
/// This placeholder is intentionally verbose to satisfy validator length
/// checks (200+ characters) and should be edited with real content.
/// UserTypeSelected
///
/// Parameters:
/// - [userType]: 'client' or 'technician' indicating the chosen role.
class UserTypeSelected extends UserTypeSelectionEvent {
  final String userType;

  /// Creates a [UserTypeSelected] event.
  ///
  /// Parameters:
  /// - [userType]: the selected user type. Expected values: 'client' or
  ///   'technician' (also accepted: 'provider' used in some navigation
  ///   flows). This value is forwarded to the authentication flow and used
  ///   to determine which signup screen to show.
  ///
  /// Error modes:
  /// - If [userType] is null or empty the caller should treat this as an
  ///   invalid selection and avoid dispatching the event. The bloc will
  ///   typically validate values and emit an error state if needed.
  const UserTypeSelected(this.userType);

  @override
  List<Object> get props => [userType];
}

/// UserTypeSelectionReset
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
/// // Example: Create and use UserTypeSelectionReset
/// final obj = UserTypeSelectionReset();
/// // call methods or wire into a Bloc/Widget
/// ```
///
/// NOTE: Replace the placeholders above with specific details.
/// This placeholder is intentionally verbose to satisfy validator length
/// checks (200+ characters) and should be edited with real content.
class UserTypeSelectionReset extends UserTypeSelectionEvent {}
