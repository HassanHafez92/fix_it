// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'booking_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BookingModel _$BookingModelFromJson(Map<String, dynamic> json) => BookingModel(
      id: json['id'] as String,
      userId: json['userId'] as String,
      providerId: json['providerId'] as String,
      serviceId: json['serviceId'] as String,
      serviceName: json['serviceName'] as String,
      providerName: json['providerName'] as String,
      providerImage: json['providerImage'] as String,
      scheduledDate: DateTime.parse(json['scheduledDate'] as String),
      timeSlot: json['timeSlot'] as String,
      address: json['address'] as String,
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      totalAmount: (json['totalAmount'] as num).toDouble(),
      servicePrice: (json['servicePrice'] as num).toDouble(),
      taxes: (json['taxes'] as num).toDouble(),
      platformFee: (json['platformFee'] as num).toDouble(),
      status: $enumDecode(_$BookingStatusEnumMap, json['status']),
      paymentStatus: $enumDecode(_$PaymentStatusEnumMap, json['paymentStatus']),
      notes: json['notes'] as String?,
      cancellationReason: json['cancellationReason'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      attachments: (json['attachments'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      isUrgent: json['isUrgent'] as bool,
      estimatedDuration: (json['estimatedDuration'] as num).toInt(),
    );

Map<String, dynamic> _$BookingModelToJson(BookingModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'providerId': instance.providerId,
      'serviceId': instance.serviceId,
      'serviceName': instance.serviceName,
      'providerName': instance.providerName,
      'providerImage': instance.providerImage,
      'scheduledDate': instance.scheduledDate.toIso8601String(),
      'timeSlot': instance.timeSlot,
      'address': instance.address,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'totalAmount': instance.totalAmount,
      'servicePrice': instance.servicePrice,
      'taxes': instance.taxes,
      'platformFee': instance.platformFee,
      'status': _$BookingStatusEnumMap[instance.status]!,
      'paymentStatus': _$PaymentStatusEnumMap[instance.paymentStatus]!,
      'notes': instance.notes,
      'cancellationReason': instance.cancellationReason,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
      'attachments': instance.attachments,
      'isUrgent': instance.isUrgent,
      'estimatedDuration': instance.estimatedDuration,
    };

const _$BookingStatusEnumMap = {
  BookingStatus.pending: 'pending',
  BookingStatus.confirmed: 'confirmed',
  BookingStatus.inProgress: 'inProgress',
  BookingStatus.completed: 'completed',
  BookingStatus.cancelled: 'cancelled',
  BookingStatus.rescheduled: 'rescheduled',
};

const _$PaymentStatusEnumMap = {
  PaymentStatus.pending: 'pending',
  PaymentStatus.paid: 'paid',
  PaymentStatus.failed: 'failed',
  PaymentStatus.refunded: 'refunded',
};
