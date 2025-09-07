import 'package:equatable/equatable.dart';

enum BookingStatus {
  pending,
  confirmed,
  inProgress,
  completed,
  cancelled,
  rescheduled,
}

enum PaymentStatus {
  pending,
  paid,
  failed,
  refunded,
}

class BookingEntity extends Equatable {
  final String id;
  final String userId;
  final String providerId;
  final String serviceId;
  final String serviceName;
  final String providerName;
  final String providerImage;
  final DateTime scheduledDate;
  final String timeSlot;
  final String address;
  final double latitude;
  final double longitude;
  final double totalAmount;
  final double servicePrice;
  final double taxes;
  final double platformFee;
  final BookingStatus status;
  final PaymentStatus paymentStatus;
  final String? notes;
  final String? cancellationReason;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<String> attachments;
  final bool isUrgent;
  final int estimatedDuration;

  const BookingEntity({
    required this.id,
    required this.userId,
    required this.providerId,
    required this.serviceId,
    required this.serviceName,
    required this.providerName,
    required this.providerImage,
    required this.scheduledDate,
    required this.timeSlot,
    required this.address,
    required this.latitude,
    required this.longitude,
    required this.totalAmount,
    required this.servicePrice,
    required this.taxes,
    required this.platformFee,
    required this.status,
    required this.paymentStatus,
    this.notes,
    this.cancellationReason,
    required this.createdAt,
    required this.updatedAt,
    required this.attachments,
    required this.isUrgent,
    required this.estimatedDuration,
  });

  @override
  List<Object?> get props => [
        id,
        userId,
        providerId,
        serviceId,
        serviceName,
        providerName,
        providerImage,
        scheduledDate,
        timeSlot,
        address,
        latitude,
        longitude,
        totalAmount,
        servicePrice,
        taxes,
        platformFee,
        status,
        paymentStatus,
        notes,
        cancellationReason,
        createdAt,
        updatedAt,
        attachments,
        isUrgent,
        estimatedDuration,
      ];
}
