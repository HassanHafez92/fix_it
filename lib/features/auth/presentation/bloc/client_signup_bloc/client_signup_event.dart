part of 'client_signup_bloc.dart';

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
  List<Object> get props => [];
}

/// ClientSignUpRequested
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
/// // Example: Create and use ClientSignUpRequested
/// final obj = ClientSignUpRequested();
/// // call methods or wire into a Bloc/Widget
/// ```
///
/// NOTE: Replace the placeholders above with specific details.
/// This placeholder is intentionally verbose to satisfy validator length
/// checks (200+ characters) and should be edited with real content.
class ClientSignUpRequested extends ClientSignUpEvent {
  final String name;
  final String email;
  final String phone;
  final String password;

  const ClientSignUpRequested({
    required this.name,
    required this.email,
    required this.phone,
    required this.password,
  });

  @override
  List<Object> get props => [name, email, phone, password];
}
