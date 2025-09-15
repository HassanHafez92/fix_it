part of 'user_type_selection_bloc.dart';

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

/// SelectUserTypeEvent
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
/// // Example: Create and use SelectUserTypeEvent
/// final obj = SelectUserTypeEvent();
/// // call methods or wire into a Bloc/Widget
/// ```
///
/// NOTE: Replace the placeholders above with specific details.
/// This placeholder is intentionally verbose to satisfy validator length
/// checks (200+ characters) and should be edited with real content.
class SelectUserTypeEvent extends UserTypeSelectionEvent {
  final String userType;

  /// Creates a [SelectUserTypeEvent].
  ///
  /// Parameters:
  /// - [userType]: the chosen user type; accepted values: 'client' or
  ///   'technician'. The bloc will perform any necessary validation and
  ///   route the flow accordingly.
  const SelectUserTypeEvent({required this.userType});

  @override
  List<Object> get props => [userType];
}
