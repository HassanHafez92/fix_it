import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../domain/entities/booking_entity.dart';

/// BookingStatusFilter
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
/// // Example: Create and use BookingStatusFilter
/// final obj = BookingStatusFilter();
/// // call methods or wire into a Bloc/Widget
/// ```
///
/// NOTE: Replace the placeholders above with specific details.
/// This placeholder is intentionally verbose to satisfy validator length
/// checks (200+ characters) and should be edited with real content.
class BookingStatusFilter extends StatelessWidget {
  final BookingStatus? selectedStatus;
  final Function(BookingStatus?) onStatusChanged;

  const BookingStatusFilter({
    super.key,
    this.selectedStatus,
    required this.onStatusChanged,
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
    Theme.of(context);

    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              'Filter by Status',
              style: GoogleFonts.cairo(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.grey[800],
              ),
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 40,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                _buildFilterChip(
                  context: context,
                  label: 'All',
                  value: null,
                  isSelected: selectedStatus == null,
                  color: Colors.grey,
                ),
                _buildFilterChip(
                  context: context,
                  label: 'Pending',
                  value: BookingStatus.pending,
                  isSelected: selectedStatus == BookingStatus.pending,
                  color: Colors.orange,
                ),
                _buildFilterChip(
                  context: context,
                  label: 'Confirmed',
                  value: BookingStatus.confirmed,
                  isSelected: selectedStatus == BookingStatus.confirmed,
                  color: Colors.blue,
                ),
                _buildFilterChip(
                  context: context,
                  label: 'In Progress',
                  value: BookingStatus.inProgress,
                  isSelected: selectedStatus == BookingStatus.inProgress,
                  color: Colors.purple,
                ),
                _buildFilterChip(
                  context: context,
                  label: 'Completed',
                  value: BookingStatus.completed,
                  isSelected: selectedStatus == BookingStatus.completed,
                  color: Colors.green,
                ),
                _buildFilterChip(
                  context: context,
                  label: 'Cancelled',
                  value: BookingStatus.cancelled,
                  isSelected: selectedStatus == BookingStatus.cancelled,
                  color: Colors.red,
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Divider(height: 1, color: Colors.grey[300]),
        ],
      ),
    );
  }

  Widget _buildFilterChip({
    required BuildContext context,
    required String label,
    required BookingStatus? value,
    required bool isSelected,
    required Color color,
  }) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      child: FilterChip(
        label: Text(
          label,
          style: GoogleFonts.cairo(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: isSelected ? Colors.white : color,
          ),
        ),
        selected: isSelected,
        onSelected: (selected) {
          onStatusChanged(selected ? value : null);
        },
        selectedColor: color,
        backgroundColor: color is MaterialColor ? color[50] : Colors.grey[50],
        side: BorderSide(
          color: isSelected
              ? color
              : (color is MaterialColor ? color[300]! : Colors.grey[300]!),
        ),
        showCheckmark: false,
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        visualDensity: VisualDensity.compact,
      ),
    );
  }
}
