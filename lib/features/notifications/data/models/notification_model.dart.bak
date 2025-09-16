import '../../domain/entities/notification_entity.dart';
class NotificationModel extends NotificationEntity {
  const NotificationModel({
    required super.id,
    required super.userId,
    required super.title,
    required super.body,
    required super.type,
    required super.timestamp,
    super.isRead = false,
    super.targetData,
    super.imageUrl,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id'] as String,
      userId: json['userId'] as String,
      title: json['title'] as String,
      body: json['body'] as String,
      type: _parseNotificationType(json['type'] as String),
      timestamp: DateTime.parse(json['timestamp'] as String),
      isRead: json['isRead'] as bool? ?? false,
      targetData: json['targetData'] as Map<String, dynamic>?,
      imageUrl: json['imageUrl'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'title': title,
      'body': body,
      'type': type.name,
      'timestamp': timestamp.toIso8601String(),
      'isRead': isRead,
      'targetData': targetData,
      'imageUrl': imageUrl,
    };
  }

  static NotificationType _parseNotificationType(String typeString) {
    switch (typeString) {
      case 'bookingConfirmation':
        return NotificationType.bookingConfirmation;
      case 'bookingCancelled':
        return NotificationType.bookingCancelled;
      case 'bookingCompleted':
        return NotificationType.bookingCompleted;
      case 'paymentSuccess':
        return NotificationType.paymentSuccess;
      case 'paymentFailed':
        return NotificationType.paymentFailed;
      case 'specialOffer':
        return NotificationType.specialOffer;
      case 'appUpdate':
        return NotificationType.appUpdate;
      case 'reviewRequest':
        return NotificationType.reviewRequest;
      case 'bookingReminder':
        return NotificationType.bookingReminder;
      case 'providerAssigned':
        return NotificationType.providerAssigned;
      case 'general':
      default:
        return NotificationType.general;
    }
  }

  factory NotificationModel.fromEntity(NotificationEntity entity) {
    return NotificationModel(
      id: entity.id,
      userId: entity.userId,
      title: entity.title,
      body: entity.body,
      type: entity.type,
      timestamp: entity.timestamp,
      isRead: entity.isRead,
      targetData: entity.targetData,
      imageUrl: entity.imageUrl,
    );
  }

  NotificationEntity toEntity() {
    return NotificationEntity(
      id: id,
      userId: userId,
      title: title,
      body: body,
      type: type,
      timestamp: timestamp,
      isRead: isRead,
      targetData: targetData,
      imageUrl: imageUrl,
    );
  }

  @override
  NotificationModel copyWith({
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
    return NotificationModel(
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
}