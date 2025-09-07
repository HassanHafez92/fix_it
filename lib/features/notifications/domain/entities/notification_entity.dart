import 'package:equatable/equatable.dart';

class NotificationEntity extends Equatable {
  final String id;
  final String userId;
  final String title;
  final String body;
  final NotificationType type;
  final DateTime timestamp;
  final bool isRead;
  final Map<String, dynamic>? targetData;
  final String? imageUrl;

  const NotificationEntity({
    required this.id,
    required this.userId,
    required this.title,
    required this.body,
    required this.type,
    required this.timestamp,
    this.isRead = false,
    this.targetData,
    this.imageUrl,
  });

  NotificationEntity copyWith({
    String? id,
    String? userId,
    String? title,
    String? body,
    NotificationType? type,
    DateTime? timestamp,
    bool? isRead,
    Map<String, dynamic>? targetData,
    String? imageUrl,
  }) {
    return NotificationEntity(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      title: title ?? this.title,
      body: body ?? this.body,
      type: type ?? this.type,
      timestamp: timestamp ?? this.timestamp,
      isRead: isRead ?? this.isRead,
      targetData: targetData ?? this.targetData,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }

  @override
  List<Object?> get props => [
        id,
        userId,
        title,
        body,
        type,
        timestamp,
        isRead,
        targetData,
        imageUrl,
      ];
}

enum NotificationType {
  bookingConfirmation,
  bookingCancelled,
  bookingCompleted,
  paymentSuccess,
  paymentFailed,
  specialOffer,
  appUpdate,
  reviewRequest,
  bookingReminder,
  providerAssigned,
  general,
}

extension NotificationTypeExtension on NotificationType {
  String get displayName {
    switch (this) {
      case NotificationType.bookingConfirmation:
        return 'تأكيد الحجز';
      case NotificationType.bookingCancelled:
        return 'إلغاء الحجز';
      case NotificationType.bookingCompleted:
        return 'اكتمال الخدمة';
      case NotificationType.paymentSuccess:
        return 'نجح الدفع';
      case NotificationType.paymentFailed:
        return 'فشل الدفع';
      case NotificationType.specialOffer:
        return 'عرض خاص';
      case NotificationType.appUpdate:
        return 'تحديث التطبيق';
      case NotificationType.reviewRequest:
        return 'طلب تقييم';
      case NotificationType.bookingReminder:
        return 'تذكير الموعد';
      case NotificationType.providerAssigned:
        return 'تعيين فني';
      case NotificationType.general:
        return 'عام';
    }
  }

  String get iconName {
    switch (this) {
      case NotificationType.bookingConfirmation:
        return 'check_circle';
      case NotificationType.bookingCancelled:
        return 'cancel';
      case NotificationType.bookingCompleted:
        return 'task_alt';
      case NotificationType.paymentSuccess:
        return 'payment';
      case NotificationType.paymentFailed:
        return 'error';
      case NotificationType.specialOffer:
        return 'local_offer';
      case NotificationType.appUpdate:
        return 'system_update';
      case NotificationType.reviewRequest:
        return 'star';
      case NotificationType.bookingReminder:
        return 'schedule';
      case NotificationType.providerAssigned:
        return 'engineering';
      case NotificationType.general:
        return 'notifications';
    }
  }
}