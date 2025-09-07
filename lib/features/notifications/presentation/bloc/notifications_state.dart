import 'package:equatable/equatable.dart';
import '../../domain/entities/notification_entity.dart';

abstract class NotificationsState extends Equatable {
  const NotificationsState();

  @override
  List<Object> get props => [];
}

class NotificationsInitial extends NotificationsState {}

class NotificationsLoading extends NotificationsState {}

class NotificationsLoaded extends NotificationsState {
  final List<NotificationEntity> notifications;
  final int unreadCount;

  const NotificationsLoaded({
    required this.notifications,
    this.unreadCount = 0,
  });

  @override
  List<Object> get props => [notifications, unreadCount];

  NotificationsLoaded copyWith({
    List<NotificationEntity>? notifications,
    int? unreadCount,
  }) {
    return NotificationsLoaded(
      notifications: notifications ?? this.notifications,
      unreadCount: unreadCount ?? this.unreadCount,
    );
  }
}

class NotificationsError extends NotificationsState {
  final String message;

  const NotificationsError(this.message);

  @override
  List<Object> get props => [message];
}

class NotificationMarkedAsRead extends NotificationsState {
  final List<NotificationEntity> notifications;
  final int unreadCount;

  const NotificationMarkedAsRead({
    required this.notifications,
    required this.unreadCount,
  });

  @override
  List<Object> get props => [notifications, unreadCount];
}

class NotificationDeleted extends NotificationsState {
  final List<NotificationEntity> notifications;
  final int unreadCount;

  const NotificationDeleted({
    required this.notifications,
    required this.unreadCount,
  });

  @override
  List<Object> get props => [notifications, unreadCount];
}