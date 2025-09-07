import 'package:json_annotation/json_annotation.dart';
import 'package:fix_it/features/booking/domain/entities/payment_method_entity.dart';

part 'payment_method_model.g.dart';

@JsonSerializable()
class PaymentMethodModel extends PaymentMethodEntity {
  const PaymentMethodModel({
    required super.id,
    required super.type,
    required super.last4Digits,
    required super.expiryDate,
    required super.cardholderName,
    required super.isDefault,
    super.brand,
  });

  factory PaymentMethodModel.fromJson(Map<String, dynamic> json) =>
      _$PaymentMethodModelFromJson(json);

  Map<String, dynamic> toJson() => _$PaymentMethodModelToJson(this);

  factory PaymentMethodModel.fromEntity(PaymentMethodEntity entity) {
    return PaymentMethodModel(
      id: entity.id,
      type: entity.type,
      last4Digits: entity.last4Digits,
      expiryDate: entity.expiryDate,
      cardholderName: entity.cardholderName,
      isDefault: entity.isDefault,
      brand: entity.brand,
    );
  }
}
