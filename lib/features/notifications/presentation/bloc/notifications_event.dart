import 'package:equatable/equatable.dart';

abstract class NotificationsEvent extends Equatable {
  const NotificationsEvent();

  @override
  List<Object> get props => [];
}

class LoadNotifications extends NotificationsEvent {}

class MarkNotificationAsRead extends NotificationsEvent {
  final String notificationId;

  const MarkNotificationAsRead(this.notificationId);

  @override
  List<Object> get props => [notificationId];
}

class MarkAllAsRead extends NotificationsEvent {}

class DeleteNotification extends NotificationsEvent {
  final String notificationId;

  const DeleteNotification(this.notificationId);

  @override
  List<Object> get props => [notificationId];
}

class DeleteAllNotifications extends NotificationsEvent {}

class RefreshNotifications extends NotificationsEvent {}