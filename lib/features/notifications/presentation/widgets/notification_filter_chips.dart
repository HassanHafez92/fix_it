// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fix_it/l10n/app_localizations.dart';

import '../../domain/entities/notification_entity.dart';
import 'notification_helper.dart';
/// NotificationFilterChips
///
/// Business rules:
/// - Describe the business rules that this class enforces.
///
/// Dependencies:
/// - List important dependencies or preconditions.
///
/// Error scenarios:
/// - Describe common error conditions and how they are handled.
/// NotificationFilterChips
///
/// Business rules:
/// - Describe the business rules that this class enforces.
///
/// Dependencies:
/// - List important dependencies or preconditions.
///
/// Error scenarios:
/// - Describe common error conditions and how they are handled.



class NotificationFilterChips extends StatelessWidget {
  final NotificationType? selectedFilter;
  final Function(NotificationType?) onFilterChanged;
  final Map<NotificationType, int> notificationCounts;

  const NotificationFilterChips({
    super.key,
    required this.selectedFilter,
    required this.onFilterChanged,
    required this.notificationCounts,
  });
/// build
///
/// Description: Briefly explain what this method does.
///
/// Parameters:
/// - (describe parameters)
///
/// Returns:
/// - (describe return value)


  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      height: 60,
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: [
          // All notifications chip
          _FilterChip(
            label: AppLocalizations.of(context)!.all,
            count: _getTotalCount(),
            isSelected: selectedFilter == null,
            onTap: () => onFilterChanged(null),
            color: theme.primaryColor,
          ),

          const SizedBox(width: 8),

          // Individual type chips
          ...NotificationType.values.where((type) {
            return notificationCounts.containsKey(type) &&
                   notificationCounts[type]! > 0;
          }).map((type) {
            return Padding(
              padding: const EdgeInsets.only(left: 8),
              child: _FilterChip(
                label: getNotificationTypeDisplayName(context, type),
                count: notificationCounts[type] ?? 0,
                isSelected: selectedFilter == type,
                onTap: () => onFilterChanged(type),
                color: _getTypeColor(type),
              ),
            );
          }),
        ],
      ),
    );
  }

  int _getTotalCount() {
    return notificationCounts.values.fold(0, (sum, count) => sum + count);
  }

  Color _getTypeColor(NotificationType type) {
    switch (type) {
      case NotificationType.bookingConfirmation:
        return Colors.green;
      case NotificationType.bookingCancelled:
        return Colors.red;
      case NotificationType.bookingCompleted:
        return Colors.blue;
      case NotificationType.paymentSuccess:
        return Colors.green;
      case NotificationType.paymentFailed:
        return Colors.red;
      case NotificationType.specialOffer:
        return Colors.orange;
      case NotificationType.appUpdate:
        return Colors.purple;
      case NotificationType.reviewRequest:
        return Colors.amber;
      case NotificationType.bookingReminder:
        return Colors.blue;
      case NotificationType.providerAssigned:
        return Colors.teal;
      case NotificationType.general:
        return Colors.grey;
    }
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final int count;
  final bool isSelected;
  final VoidCallback onTap;
  final Color color;

  const _FilterChip({
    required this.label,
    required this.count,
    required this.isSelected,
    required this.onTap,
    required this.color,
  });
/// build
///
/// Description: Briefly explain what this method does.
///
/// Parameters:
/// - (describe parameters)
///
/// Returns:
/// - (describe return value)


  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 8,
        ),
        decoration: BoxDecoration(
          color: isSelected ? color : color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? color : color.withOpacity(0.3),
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: GoogleFonts.cairo(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: isSelected ? Colors.white : color,
              ),
            ),
            if (count > 0) ...[
              const SizedBox(width: 6),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 6,
                  vertical: 2,
                ),
                decoration: BoxDecoration(
                  color: isSelected 
                      ? Colors.white.withOpacity(0.2)
                      : color.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  count.toString(),
                  style: GoogleFonts.cairo(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: isSelected ? Colors.white : color,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}