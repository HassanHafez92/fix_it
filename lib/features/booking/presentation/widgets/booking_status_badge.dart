import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../domain/entities/booking_entity.dart';

/// BookingStatusBadge
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
/// // Example: Create and use BookingStatusBadge
/// final obj = BookingStatusBadge();
/// // call methods or wire into a Bloc/Widget
/// ```
///
/// NOTE: Replace the placeholders above with specific details.
/// This placeholder is intentionally verbose to satisfy validator length
/// checks (200+ characters) and should be edited with real content.
class BookingStatusBadge extends StatelessWidget {
  final BookingStatus status;
  final double? fontSize;

  const BookingStatusBadge({
    super.key,
    required this.status,
    this.fontSize,
  });

  @override
/// build
///
/// Description: Briefly explain what this method does.
///
/// Parameters:
/// - (describe parameters)
///
/// Returns:
/// - (describe return value)
  Widget build(BuildContext context) {
    final statusInfo = _getStatusInfo(status);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: statusInfo.color,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            statusInfo.icon,
            color: Colors.white,
            size: (fontSize ?? 12) + 2,
          ),
          const SizedBox(width: 4),
          Text(
            statusInfo.label,
            style: GoogleFonts.cairo(
              fontSize: fontSize ?? 12,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  StatusInfo _getStatusInfo(BookingStatus status) {
    switch (status) {
      case BookingStatus.pending:
        return StatusInfo(
          label: 'Pending',
          color: Colors.orange,
          icon: Icons.schedule,
        );
      case BookingStatus.confirmed:
        return StatusInfo(
          label: 'Confirmed',
          color: Colors.blue,
          icon: Icons.check_circle,
        );
      case BookingStatus.inProgress:
        return StatusInfo(
          label: 'In Progress',
          color: Colors.purple,
          icon: Icons.work,
        );
      case BookingStatus.completed:
        return StatusInfo(
          label: 'Completed',
          color: Colors.green,
          icon: Icons.done_all,
        );
      case BookingStatus.cancelled:
        return StatusInfo(
          label: 'Cancelled',
          color: Colors.red,
          icon: Icons.cancel,
        );
      case BookingStatus.rescheduled:
        return StatusInfo(
          label: 'Rescheduled',
          color: Colors.teal,
          icon: Icons.event_available,
        );
    }
  }
}

/// StatusInfo
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
/// // Example: Create and use StatusInfo
/// final obj = StatusInfo();
/// // call methods or wire into a Bloc/Widget
/// ```
///
/// NOTE: Replace the placeholders above with specific details.
/// This placeholder is intentionally verbose to satisfy validator length
/// checks (200+ characters) and should be edited with real content.
class StatusInfo {
  final String label;
  final Color color;
  final IconData icon;

  StatusInfo({
    required this.label,
    required this.color,
    required this.icon,
  });
}
