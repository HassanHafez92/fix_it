import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fix_it/core/utils/bloc_utils.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:intl/intl.dart';

import 'package:fix_it/core/utils/app_routes.dart';
import '../bloc/notifications_bloc.dart';
import '../bloc/notifications_event.dart';
import '../bloc/notifications_state.dart';
import '../widgets/notification_card.dart';
import '../widgets/notification_filter_chips.dart';
import '../widgets/empty_notifications.dart';
import '../../domain/entities/notification_entity.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  NotificationType? selectedFilter;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      safeAddEvent<NotificationsBloc>(context, LoadNotifications());
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: theme.primaryColor,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
          ),
        ),
        title: Text(
          'الإشعارات',
          style: GoogleFonts.cairo(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        actions: [
          BlocBuilder<NotificationsBloc, NotificationsState>(
            builder: (context, state) {
              if (state is NotificationsLoaded &&
                  state.notifications.isNotEmpty) {
                return PopupMenuButton<String>(
                  icon: const Icon(Icons.more_vert, color: Colors.white),
                  onSelected: (value) {
                    switch (value) {
                        case 'mark_all_read':
                        safeAddEvent<NotificationsBloc>(context, MarkAllAsRead());
                        break;
                      case 'delete_all':
                        _showDeleteAllDialog(context);
                        break;
                    }
                  },
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      value: 'mark_all_read',
                      child: Row(
                        children: [
                          const Icon(Icons.mark_email_read, size: 20),
                          const SizedBox(width: 8),
                          Text('تحديد الكل كمقروء', style: GoogleFonts.cairo()),
                        ],
                      ),
                    ),
                    PopupMenuItem(
                      value: 'delete_all',
                      child: Row(
                        children: [
                          const Icon(Icons.delete_sweep,
                              size: 20, color: Colors.red),
                          const SizedBox(width: 8),
                          Text(
                            'حذف جميع الإشعارات',
                            style: GoogleFonts.cairo(color: Colors.red),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ],
      ),
      body: BlocBuilder<NotificationsBloc, NotificationsState>(
        builder: (context, state) {
          if (state is NotificationsLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is NotificationsError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.error_outline,
                    size: 64,
                    color: Colors.red,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'حدث خطأ في تحميل الإشعارات',
                    style: GoogleFonts.cairo(
                      fontSize: 16,
                      color: const Color(0xFF2D3748),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    state.message,
                    style: GoogleFonts.cairo(
                      fontSize: 14,
                      color: const Color(0xFF718096),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () {
                      safeAddEvent<NotificationsBloc>(context, LoadNotifications());
                    },
                    child: Text(
                      'إعادة المحاولة',
                      style: GoogleFonts.cairo(),
                    ),
                  ),
                ],
              ),
            );
          }

          if (state is NotificationsLoaded) {
            final notifications = _filterNotifications(state.notifications);

            if (notifications.isEmpty) {
              return EmptyNotifications(
                hasFilter: selectedFilter != null,
                onClearFilter: () {
                  setState(() {
                    selectedFilter = null;
                  });
                },
              );
            }

            return Column(
              children: [
                // Filter Chips
                NotificationFilterChips(
                  selectedFilter: selectedFilter,
                  onFilterChanged: (filter) {
                    setState(() {
                      selectedFilter = filter;
                    });
                  },
                  notificationCounts:
                      _getNotificationCounts(state.notifications),
                ),

                // Notifications List
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: () async {
                      safeAddEvent<NotificationsBloc>(context, LoadNotifications());
                    },
                    child: ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: notifications.length,
                      itemBuilder: (context, index) {
                        final notification = notifications[index];
                        return NotificationCard(
                          notification: notification,
                          onTap: () =>
                              _handleNotificationTap(context, notification),
                          onDelete: () =>
                              _showDeleteDialog(context, notification),
                        );
                      },
                    ),
                  ),
                ),
              ],
            );
          }

          return const EmptyNotifications();
        },
      ),
    );
  }

  List<NotificationEntity> _filterNotifications(
      List<NotificationEntity> notifications) {
    if (selectedFilter == null) {
      return notifications;
    }
    return notifications.where((n) => n.type == selectedFilter).toList();
  }

  Map<NotificationType, int> _getNotificationCounts(
      List<NotificationEntity> notifications) {
    final counts = <NotificationType, int>{};
    for (final notification in notifications) {
      counts[notification.type] = (counts[notification.type] ?? 0) + 1;
    }
    return counts;
  }

  void _handleNotificationTap(
      BuildContext context, NotificationEntity notification) {
    // Mark as read if not already read
    if (!notification.isRead) {
      safeAddEvent<NotificationsBloc>(context, MarkNotificationAsRead(notification.id));
    }

    // Navigate based on notification type and target data
    if (notification.targetData != null) {
      final targetData = notification.targetData!;

      switch (notification.type) {
        case NotificationType.bookingConfirmation:
        case NotificationType.bookingCancelled:
        case NotificationType.bookingCompleted:
        case NotificationType.bookingReminder:
          if (targetData.containsKey('bookingId')) {
            Navigator.pushNamed(
              context,
              AppRoutes.bookingDetails,
              arguments: {'bookingId': targetData['bookingId']},
            );
          }
          break;
        case NotificationType.specialOffer:
          if (targetData.containsKey('serviceId')) {
            Navigator.pushNamed(
              context,
              AppRoutes.serviceDetails,
              arguments: {'serviceId': targetData['serviceId']},
            );
          }
          break;
        case NotificationType.providerAssigned:
          if (targetData.containsKey('providerId')) {
            Navigator.pushNamed(
              context,
              AppRoutes.providerDetails,
              arguments: {'providerId': targetData['providerId']},
            );
          }
          break;
        default:
          // Show notification details dialog
          _showNotificationDetails(context, notification);
      }
    } else {
      _showNotificationDetails(context, notification);
    }
  }

  void _showNotificationDetails(
      BuildContext context, NotificationEntity notification) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: Text(
          notification.title,
          style: GoogleFonts.cairo(fontWeight: FontWeight.bold),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              notification.body,
              style: GoogleFonts.cairo(),
            ),
            const SizedBox(height: 16),
            Text(
              DateFormat('dd/MM/yyyy - hh:mm a', 'ar')
                  .format(notification.timestamp),
              style: GoogleFonts.cairo(
                fontSize: 12,
                color: const Color(0xFF718096),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('إغلاق', style: GoogleFonts.cairo()),
          ),
        ],
      ),
    );
  }

  void _showDeleteDialog(
      BuildContext context, NotificationEntity notification) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: Text('حذف الإشعار',
            style: GoogleFonts.cairo(fontWeight: FontWeight.bold)),
        content: Text(
          'هل أنت متأكد من رغبتك في حذف هذا الإشعار؟',
          style: GoogleFonts.cairo(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('إلغاء', style: GoogleFonts.cairo()),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              safeAddEvent<NotificationsBloc>(context, DeleteNotification(notification.id));
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: Text('حذف', style: GoogleFonts.cairo(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _showDeleteAllDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: Text('حذف جميع الإشعارات',
            style: GoogleFonts.cairo(fontWeight: FontWeight.bold)),
        content: Text(
          'هل أنت متأكد من رغبتك في حذف جميع الإشعارات؟ لا يمكن التراجع عن هذا الإجراء.',
          style: GoogleFonts.cairo(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('إلغاء', style: GoogleFonts.cairo()),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              safeAddEvent<NotificationsBloc>(context, DeleteAllNotifications());
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child:
                Text('حذف الكل', style: GoogleFonts.cairo(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
