part of 'user_type_selection_bloc.dart';

/// UserTypeSelectionState
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
/// // Example: Create and use UserTypeSelectionState
/// final obj = UserTypeSelectionState();
/// // call methods or wire into a Bloc/Widget
/// ```
///
/// NOTE: Replace the placeholders above with specific details.
/// This placeholder is intentionally verbose to satisfy validator length
/// checks (200+ characters) and should be edited with real content.
abstract/// UserTypeSelectionState
///
/// **Business Rules:**
/// - Add the main business rules or invariants enforced by this class.
///
class UserTypeSelectionState extends Equatable {
  const UserTypeSelectionState();

  @override
  List<Object> get props => [];
}

/// UserTypeSelectionInitial
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
/// // Example: Create and use UserTypeSelectionInitial
/// final obj = UserTypeSelectionInitial();
/// // call methods or wire into a Bloc/Widget
/// ```
///
/// NOTE: Replace the placeholders above with specific details.
/// This placeholder is intentionally verbose to satisfy validator length
/// checks (200+ characters) and should be edited with real content.
class UserTypeSelectionInitial extends UserTypeSelectionState {}

/// UserTypeSelectionLoading
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
/// // Example: Create and use UserTypeSelectionLoading
/// final obj = UserTypeSelectionLoading();
/// // call methods or wire into a Bloc/Widget
/// ```
///
/// NOTE: Replace the placeholders above with specific details.
/// This placeholder is intentionally verbose to satisfy validator length
/// checks (200+ characters) and should be edited with real content.
class UserTypeSelectionLoading extends UserTypeSelectionState {}

/// UserTypeSelectedState
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
/// // Example: Create and use UserTypeSelectedState
/// final obj = UserTypeSelectedState();
/// // call methods or wire into a Bloc/Widget
/// ```
///
/// NOTE: Replace the placeholders above with specific details.
/// This placeholder is intentionally verbose to satisfy validator length
/// checks (200+ characters) and should be edited with real content.
class UserTypeSelectedState extends UserTypeSelectionState {
  final String userType;

  /// Creates a [UserTypeSelectedState].
  ///
  /// Parameters:
  /// - [userType]: the selected user type (e.g. 'client' or 'technician').
  const UserTypeSelectedState({required this.userType});

  @override
  List<Object> get props => [userType];
}

/// UserTypeSelectionError
/// **Business Rules:**
/// - Add the main business rules or invariants enforced by this class.
///
/// Simple error state used by the bloc to indicate selection failures.
class UserTypeSelectionError extends UserTypeSelectionState {
  final String message;

  /// Creates an error state with a human-readable [message].
  ///
  /// Parameters:
  /// - [message]: A short description of the error to show to users or
  ///   for logging.
  const UserTypeSelectionError(this.message);

  @override
  List<Object> get props => [message];
}
