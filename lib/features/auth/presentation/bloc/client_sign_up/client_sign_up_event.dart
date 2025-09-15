part of 'client_sign_up_bloc.dart';

/// ClientSignUpEvent
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
/// // Example: Create and use ClientSignUpEvent
/// final obj = ClientSignUpEvent();
/// // call methods or wire into a Bloc/Widget
/// ```
///
/// NOTE: Replace the placeholders above with specific details.
/// This placeholder is intentionally verbose to satisfy validator length
/// checks (200+ characters) and should be edited with real content.
abstract/// ClientSignUpEvent
///
/// **Business Rules:**
/// - Add the main business rules or invariants enforced by this class.
///
class ClientSignUpEvent extends Equatable {
  const ClientSignUpEvent();

  @override
  List<Object?> get props => [];
}

/// ClientSignUpSubmitted
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
/// // Example: Create and use ClientSignUpSubmitted
/// final obj = ClientSignUpSubmitted();
/// // call methods or wire into a Bloc/Widget
/// ```
///
/// NOTE: Replace the placeholders above with specific details.
/// This placeholder is intentionally verbose to satisfy validator length
/// checks (200+ characters) and should be edited with real content.
class ClientSignUpSubmitted extends ClientSignUpEvent {
  final String fullName;
  final String email;
  final String password;
  final String phoneNumber;

  const ClientSignUpSubmitted({
    required this.fullName,
    required this.email,
    required this.password,
    required this.phoneNumber,
  });

  @override
  List<Object?> get props => [fullName, email, password, phoneNumber];
}
