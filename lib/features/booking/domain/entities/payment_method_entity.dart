import 'package:equatable/equatable.dart';

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
