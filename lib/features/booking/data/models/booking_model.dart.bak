import 'package:json_annotation/json_annotation.dart';

import '../../domain/entities/booking_entity.dart';

part 'booking_model.g.dart';

@JsonSerializable()
class BookingModel extends BookingEntity {
  const BookingModel({
    required super.id,
    required super.userId,
    required super.providerId,
    required super.serviceId,
    required super.serviceName,
    required super.providerName,
    required super.providerImage,
    required super.scheduledDate,
    required super.timeSlot,
    required super.address,
    required super.latitude,
    required super.longitude,
    required super.totalAmount,
    required super.servicePrice,
    required super.taxes,
    required super.platformFee,
    required super.status,
    required super.paymentStatus,
    super.notes,
    super.cancellationReason,
    required super.createdAt,
    required super.updatedAt,
    required super.attachments,
    required super.isUrgent,
    required super.estimatedDuration,
  });

  factory BookingModel.fromJson(Map<String, dynamic> json) =>
      _$BookingModelFromJson(json);

  Map<String, dynamic> toJson() => _$BookingModelToJson(this);

  factory BookingModel.fromEntity(BookingEntity entity) {
    return BookingModel(
      id: entity.id,
      userId: entity.userId,
      providerId: entity.providerId,
      serviceId: entity.serviceId,
      serviceName: entity.serviceName,
      providerName: entity.providerName,
      providerImage: entity.providerImage,
      scheduledDate: entity.scheduledDate,
      timeSlot: entity.timeSlot,
      address: entity.address,
      latitude: entity.latitude,
      longitude: entity.longitude,
      totalAmount: entity.totalAmount,
      servicePrice: entity.servicePrice,
      taxes: entity.taxes,
      platformFee: entity.platformFee,
      status: entity.status,
      paymentStatus: entity.paymentStatus,
      notes: entity.notes,
      cancellationReason: entity.cancellationReason,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
      attachments: entity.attachments,
      isUrgent: entity.isUrgent,
      estimatedDuration: entity.estimatedDuration,
    );
  }
}
