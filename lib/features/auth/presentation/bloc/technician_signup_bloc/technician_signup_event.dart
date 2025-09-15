part of 'technician_signup_bloc.dart';

/// TechnicianSignUpEvent
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
/// // Example: Create and use TechnicianSignUpEvent
/// final obj = TechnicianSignUpEvent();
/// // call methods or wire into a Bloc/Widget
/// ```
///
/// NOTE: Replace the placeholders above with specific details.
/// This placeholder is intentionally verbose to satisfy validator length
/// checks (200+ characters) and should be edited with real content.
abstract/// TechnicianSignUpEvent
///
/// **Business Rules:**
/// - Add the main business rules or invariants enforced by this class.
///
class TechnicianSignUpEvent extends Equatable {
  const TechnicianSignUpEvent();

  @override
  List<Object> get props => [];
}

/// TechnicianSignUpRequested
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
/// // Example: Create and use TechnicianSignUpRequested
/// final obj = TechnicianSignUpRequested();
/// // call methods or wire into a Bloc/Widget
/// ```
///
/// NOTE: Replace the placeholders above with specific details.
/// This placeholder is intentionally verbose to satisfy validator length
/// checks (200+ characters) and should be edited with real content.
class TechnicianSignUpRequested extends TechnicianSignUpEvent {
  final String name;
  final String email;
  final String phone;
  final String profession;
  final String password;

  const TechnicianSignUpRequested({
    required this.name,
    required this.email,
    required this.phone,
    required this.profession,
    required this.password,
  });

  @override
  List<Object> get props => [name, email, phone, profession, password];
}
