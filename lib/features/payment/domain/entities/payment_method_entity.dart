import 'package:equatable/equatable.dart';

/// Entity representing a payment method in the domain layer.
/// 
/// This entity encapsulates all the business logic properties
/// of a payment method without any dependencies on external frameworks.
class PaymentMethodEntity extends Equatable {
  /// Unique identifier for the payment method
  final String id;

  /// The user ID this payment method belongs to
  final String userId;

  /// Type of payment method (credit_card, paypal, apple_pay, etc.)
  final PaymentMethodType type;

  /// Display name for the payment method (e.g., "Visa ending in 1234")
  final String displayName;

  /// Last 4 digits of card number (for cards) or identifier for other methods
  final String lastFourDigits;

  /// Card brand (for credit cards: visa, mastercard, amex, etc.)
  final String? cardBrand;

  /// Expiry month (for credit cards)
  final int? expiryMonth;

  /// Expiry year (for credit cards)
  final int? expiryYear;

  /// Whether this is the default payment method for the user
  final bool isDefault;

  /// Whether the payment method is currently active/valid
  final bool isActive;

  /// Timestamp when the payment method was added
  final DateTime createdAt;

  /// Timestamp when the payment method was last updated
  final DateTime updatedAt;

  const PaymentMethodEntity({
    required this.id,
    required this.userId,
    required this.type,
    required this.displayName,
    required this.lastFourDigits,
    this.cardBrand,
    this.expiryMonth,
    this.expiryYear,
    required this.isDefault,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Creates a copy of this entity with updated values
  PaymentMethodEntity copyWith({
    String? id,
    String? userId,
    PaymentMethodType? type,
    String? displayName,
    String? lastFourDigits,
    String? cardBrand,
    int? expiryMonth,
    int? expiryYear,
    bool? isDefault,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return PaymentMethodEntity(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      type: type ?? this.type,
      displayName: displayName ?? this.displayName,
      lastFourDigits: lastFourDigits ?? this.lastFourDigits,
      cardBrand: cardBrand ?? this.cardBrand,
      expiryMonth: expiryMonth ?? this.expiryMonth,
      expiryYear: expiryYear ?? this.expiryYear,
      isDefault: isDefault ?? this.isDefault,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  /// Checks if the payment method is expired (for credit cards)
  bool get isExpired {
    if (expiryMonth == null || expiryYear == null) return false;

    final now = DateTime.now();
    final expiry = DateTime(expiryYear!, expiryMonth!);
    return now.isAfter(expiry);
  }

  /// Gets a formatted expiry date string (MM/YY)
  String? get formattedExpiryDate {
    if (expiryMonth == null || expiryYear == null) return null;
    return '${expiryMonth!.toString().padLeft(2, '0')}/${expiryYear!.toString().substring(2)}';
  }

  @override
  List<Object?> get props => [
        id,
        userId,
        type,
        displayName,
        lastFourDigits,
        cardBrand,
        expiryMonth,
        expiryYear,
        isDefault,
        isActive,
        createdAt,
        updatedAt,
      ];
}

/// Enum for different types of payment methods
enum PaymentMethodType {
  creditCard,
  debitCard,
  paypal,
  applePay,
  googlePay,
  bankTransfer,
  cash;

  /// Converts enum to string for API/storage
  String get value {
    switch (this) {
      case PaymentMethodType.creditCard:
        return 'credit_card';
      case PaymentMethodType.debitCard:
        return 'debit_card';
      case PaymentMethodType.paypal:
        return 'paypal';
      case PaymentMethodType.applePay:
        return 'apple_pay';
      case PaymentMethodType.googlePay:
        return 'google_pay';
      case PaymentMethodType.bankTransfer:
        return 'bank_transfer';
      case PaymentMethodType.cash:
        return 'cash';
    }
  }

  /// Creates enum from string value
  static PaymentMethodType fromString(String value) {
    switch (value.toLowerCase()) {
      case 'credit_card':
        return PaymentMethodType.creditCard;
      case 'debit_card':
        return PaymentMethodType.debitCard;
      case 'paypal':
        return PaymentMethodType.paypal;
      case 'apple_pay':
        return PaymentMethodType.applePay;
      case 'google_pay':
        return PaymentMethodType.googlePay;
      case 'bank_transfer':
        return PaymentMethodType.bankTransfer;
      case 'cash':
        return PaymentMethodType.cash;
      default:
        throw ArgumentError('Unknown payment method type: $value');
    }
  }

  /// Gets display name for the payment method type
  String get displayName {
    switch (this) {
      case PaymentMethodType.creditCard:
        return 'Credit Card';
      case PaymentMethodType.debitCard:
        return 'Debit Card';
      case PaymentMethodType.paypal:
        return 'PayPal';
      case PaymentMethodType.applePay:
        return 'Apple Pay';
      case PaymentMethodType.googlePay:
        return 'Google Pay';
      case PaymentMethodType.bankTransfer:
        return 'Bank Transfer';
      case PaymentMethodType.cash:
        return 'Cash';
    }
  }
}
