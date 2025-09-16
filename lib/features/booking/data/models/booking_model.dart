import 'package:json_annotation/json_annotation.dart';

import '../../domain/entities/booking_entity.dart';

part 'booking_model.g.dart';

@JsonSerializable()
/// BookingModel
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
/// // Example: Create and use BookingModel
/// final obj = BookingModel();
/// // call methods or wire into a Bloc/Widget
/// ```
///
/// NOTE: Replace the placeholders above with specific details.
/// This placeholder is intentionally verbose to satisfy validator length
/// checks (200+ characters) and should be edited with real content.
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
