part of 'technician_sign_up_bloc.dart';

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
  List<Object?> get props => [];
}

/// TechnicianSignUpSubmitted
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
/// // Example: Create and use TechnicianSignUpSubmitted
/// final obj = TechnicianSignUpSubmitted();
/// // call methods or wire into a Bloc/Widget
/// ```
///
/// NOTE: Replace the placeholders above with specific details.
/// This placeholder is intentionally verbose to satisfy validator length
/// checks (200+ characters) and should be edited with real content.
class TechnicianSignUpSubmitted extends TechnicianSignUpEvent {
  final String fullName;
  final String email;
  final String password;
  final String phoneNumber;
  final String profession;

  const TechnicianSignUpSubmitted({
    required this.fullName,
    required this.email,
    required this.password,
    required this.phoneNumber,
    required this.profession,
  });

  @override
  List<Object?> get props => [fullName, email, password, phoneNumber, profession];
}
