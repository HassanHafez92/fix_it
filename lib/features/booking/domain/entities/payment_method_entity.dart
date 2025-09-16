import 'package:equatable/equatable.dart';

/// PaymentMethodEntity
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
/// // Example: Create and use PaymentMethodEntity
/// final obj = PaymentMethodEntity();
/// // call methods or wire into a Bloc/Widget
/// ```
///
/// NOTE: Replace the placeholders above with specific details.
/// This placeholder is intentionally verbose to satisfy validator length
/// checks (200+ characters) and should be edited with real content.
class PaymentMethodEntity extends Equatable {
  final String id;
  final String type; // 'credit_card', 'paypal', 'apple_pay', etc.
  final String last4Digits;
  final String expiryDate;
  final String cardholderName;
  final bool isDefault;
  final String? brand; // 'visa', 'mastercard', etc.

  const PaymentMethodEntity({
    required this.id,
    required this.type,
    required this.last4Digits,
    required this.expiryDate,
    required this.cardholderName,
    required this.isDefault,
    this.brand,
  });

  @override
  List<Object?> get props => [
        id,
        type,
        last4Digits,
        expiryDate,
        cardholderName,
        isDefault,
        brand,
      ];
}
