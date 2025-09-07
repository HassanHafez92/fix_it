// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payment_method_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PaymentMethodModel _$PaymentMethodModelFromJson(Map<String, dynamic> json) =>
    PaymentMethodModel(
      id: json['id'] as String,
      type: json['type'] as String,
      last4Digits: json['last4Digits'] as String,
      expiryDate: json['expiryDate'] as String,
      cardholderName: json['cardholderName'] as String,
      isDefault: json['isDefault'] as bool,
      brand: json['brand'] as String?,
    );

Map<String, dynamic> _$PaymentMethodModelToJson(PaymentMethodModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'type': instance.type,
      'last4Digits': instance.last4Digits,
      'expiryDate': instance.expiryDate,
      'cardholderName': instance.cardholderName,
      'isDefault': instance.isDefault,
      'brand': instance.brand,
    };
