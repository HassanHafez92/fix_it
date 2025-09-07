import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_notifications_usecase.dart';
import '../../domain/usecases/mark_notification_read_usecase.dart';
import '../../domain/usecases/get_unread_count_usecase.dart';
import '../../domain/usecases/mark_all_as_read_usecase.dart';
import '../../domain/usecases/delete_notification_usecase.dart';
import '../../domain/usecases/delete_all_notifications_usecase.dart';
import '../../../auth/domain/usecases/get_current_user_usecase.dart';
import '../../../../core/usecases/usecase.dart' as uc show NoParamsImpl;
import '../../domain/entities/notification_entity.dart';
import 'notifications_event.dart';
import 'notifications_state.dart';

class NotificationsBloc extends Bloc<NotificationsEvent, NotificationsState> {
  final GetNotificationsUseCase getNotifications;
  final MarkNotificationAsReadUseCase markAsRead;
  final GetUnreadCountUseCase getUnreadCount;
  final MarkAllAsReadUseCase markAllAsRead;
  final DeleteNotificationUseCase deleteNotification;
  final DeleteAllNotificationsUseCase deleteAllNotifications;
  final GetCurrentUserUseCase getCurrentUser;

  NotificationsBloc({
    required this.getNotifications,
    required this.markAsRead,
    required this.getUnreadCount,
    required this.markAllAsRead,
    required this.deleteNotification,
    required this.deleteAllNotifications,
    required this.getCurrentUser,
  }) : super(NotificationsInitial()) {
    on<LoadNotifications>(_onLoadNotifications);
    on<MarkNotificationAsRead>(_onMarkNotificationAsRead);
    on<MarkAllAsRead>(_onMarkAllAsRead);
    on<DeleteNotification>(_onDeleteNotification);
    on<DeleteAllNotifications>(_onDeleteAllNotifications);
    on<RefreshNotifications>(_onRefreshNotifications);
  }

  void _onLoadNotifications(
    LoadNotifications event,
    Emitter<NotificationsState> emit,
  ) async {
    emit(NotificationsLoading());

    try {
      // For now, use hardcoded user ID - in real app, get from authenticated user
      const userId = 'current_user_id';

      final notificationsResult = await getNotifications(userId);
      final unreadCountResult = await getUnreadCount(userId);

      notificationsResult.fold(
        (failure) => emit(const NotificationsError('فشل في تحميل الإشعارات')),
        (notifications) {
          unreadCountResult.fold(
            (failure) => emit(NotificationsLoaded(
              notifications: notifications,
              unreadCount: 0,
            )),
            (unreadCount) => emit(NotificationsLoaded(
              notifications: notifications,
              unreadCount: unreadCount,
            )),
          );
        },
      );
    } catch (e) {
      emit(NotificationsError('حدث خطأ غير متوقع: ${e.toString()}'));
    }
  }

  void _onMarkNotificationAsRead(
    MarkNotificationAsRead event,
    Emitter<NotificationsState> emit,
  ) async {
    if (state is NotificationsLoaded) {
      final currentState = state as NotificationsLoaded;

      try {
        final result = await markAsRead(event.notificationId);

        result.fold(
          (failure) => emit(const NotificationsError('فشل في تحديث الإشعار')),
          (_) {
            // Update the notification as read in the list
            final updatedNotifications =
                currentState.notifications.map((notification) {
              if (notification.id == event.notificationId) {
                return notification.copyWith(isRead: true);
              }
              return notification;
            }).toList();

            final newUnreadCount =
                updatedNotifications.where((n) => !n.isRead).length;

            emit(NotificationMarkedAsRead(
              notifications: updatedNotifications,
              unreadCount: newUnreadCount,
            ));
          },
        );
      } catch (e) {
        emit(NotificationsError('حدث خطأ في تحديث الإشعار: ${e.toString()}'));
      }
    }
  }

  void _onMarkAllAsRead(
    MarkAllAsRead event,
    Emitter<NotificationsState> emit,
  ) async {
    if (state is NotificationsLoaded) {
      final currentState = state as NotificationsLoaded;

      try {
        // Mark all notifications as read
        final updatedNotifications =
            currentState.notifications.map((notification) {
          return notification.copyWith(isRead: true);
        }).toList();

        emit(NotificationsLoaded(
          notifications: updatedNotifications,
          unreadCount: 0,
        ));

        // Call usecase to mark all as read in backend
        try {
          final userResult = await getCurrentUser(uc.NoParamsImpl());
          userResult.fold((_) {
            // ignore failure, fall back to current_user_id
            markAllAsRead('current_user_id');
          }, (user) async {
            final userId = user?.id ?? 'current_user_id';
            await markAllAsRead(userId);
          });
        } catch (_) {
          // ignore backend failure for optimistic update - could show error
        }
      } catch (e) {
        emit(NotificationsError('حدث خطأ في تحديث الإشعارات: ${e.toString()}'));
      }
    }
  }

  void _onDeleteNotification(
    DeleteNotification event,
    Emitter<NotificationsState> emit,
  ) async {
    if (state is NotificationsLoaded) {
      final currentState = state as NotificationsLoaded;

      try {
        // Remove notification from list
        final updatedNotifications = currentState.notifications
            .where((notification) => notification.id != event.notificationId)
            .toList();

        final newUnreadCount =
            updatedNotifications.where((n) => !n.isRead).length;

        emit(NotificationDeleted(
          notifications: updatedNotifications,
          unreadCount: newUnreadCount,
        ));

        // Call usecase to delete notification in backend
        try {
          final userResult = await getCurrentUser(uc.NoParamsImpl());
          userResult.fold((_) async {
            await deleteNotification(event.notificationId);
          }, (user) async {
            // deleteNotification only needs notificationId, so call directly
            await deleteNotification(event.notificationId);
          });
        } catch (_) {
          // ignore backend failure for optimistic UI; could notify user
        }
      } catch (e) {
        emit(NotificationsError('حدث خطأ في حذف الإشعار: ${e.toString()}'));
      }
    }
  }

  void _onDeleteAllNotifications(
    DeleteAllNotifications event,
    Emitter<NotificationsState> emit,
  ) async {
    if (state is NotificationsLoaded) {
      try {
        emit(const NotificationsLoaded(
          notifications: [],
          unreadCount: 0,
        ));

        // Call usecase to delete all notifications in backend
        try {
          final userResult = await getCurrentUser(uc.NoParamsImpl());
          userResult.fold((_) async {
            await deleteAllNotifications('current_user_id');
          }, (user) async {
            final userId = user?.id ?? 'current_user_id';
            await deleteAllNotifications(userId);
          });
        } catch (_) {
          // ignore backend failure for optimistic UI
        }
      } catch (e) {
        emit(NotificationsError('حدث خطأ في حذف الإشعارات: ${e.toString()}'));
      }
    }
  }

  void _onRefreshNotifications(
    RefreshNotifications event,
    Emitter<NotificationsState> emit,
  ) async {
    // Reload notifications without showing loading state
    add(LoadNotifications());
  }

  // Helper method to get mock notifications for testing
  // ignore: unused_element
  List<NotificationEntity> _getMockNotifications() {
    final now = DateTime.now();
    return [
      NotificationEntity(
        id: '1',
        userId: 'current_user_id',
        title: 'تم تأكيد حجزك',
        body: 'تم تأكيد طلب الصيانة الخاص بك. سيصل الفني في الموعد المحدد.',
        type: NotificationType.bookingConfirmation,
        timestamp: now.subtract(const Duration(hours: 1)),
        isRead: false,
        targetData: {'bookingId': 'booking_123'},
      ),
      NotificationEntity(
        id: '2',
        userId: 'current_user_id',
        title: 'عرض خاص',
        body: 'خصم 20% على جميع خدمات السباكة لفترة محدودة!',
        type: NotificationType.specialOffer,
        timestamp: now.subtract(const Duration(hours: 3)),
        isRead: true,
        targetData: {'serviceId': 'service_plumbing'},
      ),
      NotificationEntity(
        id: '3',
        userId: 'current_user_id',
        title: 'تذكير بالموعد',
        body: 'موعدك مع الفني غداً في الساعة 10:00 صباحاً',
        type: NotificationType.bookingReminder,
        timestamp: now.subtract(const Duration(days: 1)),
        isRead: false,
        targetData: {'bookingId': 'booking_456'},
      ),
      NotificationEntity(
        id: '4',
        userId: 'current_user_id',
        title: 'تم إكمال الخدمة',
        body: 'تم إنجاز خدمة الكهرباء بنجاح. يرجى تقييم الخدمة.',
        type: NotificationType.bookingCompleted,
        timestamp: now.subtract(const Duration(days: 2)),
        isRead: true,
        targetData: {'bookingId': 'booking_789'},
      ),
    ];
  }
}
