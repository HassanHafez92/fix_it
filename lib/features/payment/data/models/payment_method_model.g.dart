// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payment_method_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PaymentMethodModel _$PaymentMethodModelFromJson(Map<String, dynamic> json) =>
    PaymentMethodModel(
      id: json['id'] as String,
      userId: json['userId'] as String,
      type: $enumDecode(_$PaymentMethodTypeEnumMap, json['type']),
      displayName: json['displayName'] as String,
      lastFourDigits: json['lastFourDigits'] as String,
      cardBrand: json['cardBrand'] as String?,
      expiryMonth: (json['expiryMonth'] as num?)?.toInt(),
      expiryYear: (json['expiryYear'] as num?)?.toInt(),
      isDefault: json['isDefault'] as bool,
      isActive: json['isActive'] as bool,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$PaymentMethodModelToJson(PaymentMethodModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'type': _$PaymentMethodTypeEnumMap[instance.type]!,
      'displayName': instance.displayName,
      'lastFourDigits': instance.lastFourDigits,
      'cardBrand': instance.cardBrand,
      'expiryMonth': instance.expiryMonth,
      'expiryYear': instance.expiryYear,
      'isDefault': instance.isDefault,
      'isActive': instance.isActive,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
    };

const _$PaymentMethodTypeEnumMap = {
  PaymentMethodType.creditCard: 'creditCard',
  PaymentMethodType.debitCard: 'debitCard',
  PaymentMethodType.paypal: 'paypal',
  PaymentMethodType.applePay: 'applePay',
  PaymentMethodType.googlePay: 'googlePay',
  PaymentMethodType.bankTransfer: 'bankTransfer',
  PaymentMethodType.cash: 'cash',
};
