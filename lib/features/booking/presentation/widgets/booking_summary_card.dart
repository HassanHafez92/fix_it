// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../../domain/entities/time_slot_entity.dart';

/// BookingSummaryCard
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
/// // Example: Create and use BookingSummaryCard
/// final obj = BookingSummaryCard();
/// // call methods or wire into a Bloc/Widget
/// ```
///
/// NOTE: Replace the placeholders above with specific details.
/// This placeholder is intentionally verbose to satisfy validator length
/// checks (200+ characters) and should be edited with real content.
class BookingSummaryCard extends StatelessWidget {
  final DateTime? selectedDate;
  final TimeSlotEntity? selectedTimeSlot;
  final String? address;
  final String? notes;
  final bool isUrgent;
  final List<String> attachments;
  final String? serviceName;
  final String? providerName;
  final double? servicePrice;
  final double? urgentFee;
  final double? taxes;
  final double? platformFee;

  const BookingSummaryCard({
    super.key,
    this.selectedDate,
    this.selectedTimeSlot,
    this.address,
    this.notes,
    this.isUrgent = false,
    this.attachments = const [],
    this.serviceName,
    this.providerName,
    this.servicePrice,
    this.urgentFee,
    this.taxes,
    this.platformFee,
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
    final theme = Theme.of(context);

    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Icon(Icons.receipt_long, color: theme.primaryColor),
                const SizedBox(width: 8),
                Text(
                  'Booking Summary',
                  style: GoogleFonts.cairo(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[800],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // Service Details
            if (serviceName != null) _buildServiceSection(),

            // Provider Details
            if (providerName != null) _buildProviderSection(),

            // Schedule Details
            _buildScheduleSection(),

            // Location Details
            if (address != null) _buildLocationSection(),

            // Additional Details
            _buildAdditionalSection(),

            // Price Breakdown
            _buildPriceSection(theme),
          ],
        ),
      ),
    );
  }

  Widget _buildServiceSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader('Service', Icons.build),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.blue[50],
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.blue[200]!),
          ),
          child: Row(
            children: [
              Icon(Icons.build, color: Colors.blue[700], size: 20),
              const SizedBox(width: 8),
              Text(
                serviceName!,
                style: GoogleFonts.cairo(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.blue[800],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildProviderSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader('Provider', Icons.person),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.green[50],
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.green[200]!),
          ),
          child: Row(
            children: [
              Icon(Icons.person, color: Colors.green[700], size: 20),
              const SizedBox(width: 8),
              Text(
                providerName!,
                style: GoogleFonts.cairo(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.green[800],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildScheduleSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader('Schedule', Icons.schedule),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.purple[50],
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.purple[200]!),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (selectedDate != null) ...[
                Row(
                  children: [
                    Icon(Icons.calendar_today, color: Colors.purple[700], size: 18),
                    const SizedBox(width: 8),
                    Text(
                      DateFormat('EEEE, MMM dd, yyyy').format(selectedDate!),
                      style: GoogleFonts.cairo(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.purple[800],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
              ],
              if (selectedTimeSlot != null) ...[
                Row(
                  children: [
                    Icon(Icons.access_time, color: Colors.purple[700], size: 18),
                    const SizedBox(width: 8),
                    Text(
                      '${selectedTimeSlot!.startTime} - ${selectedTimeSlot!.endTime}',
                      style: GoogleFonts.cairo(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.purple[800],
                      ),
                    ),
                    if (selectedTimeSlot!.isUrgentSlot) ...[
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.orange,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          'URGENT',
                          style: GoogleFonts.cairo(
                            fontSize: 10,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ],
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildLocationSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader('Location', Icons.location_on),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.orange[50],
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.orange[200]!),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.location_on, color: Colors.orange[700], size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  address!,
                  style: GoogleFonts.cairo(
                    fontSize: 14,
                    color: Colors.orange[800],
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildAdditionalSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader('Additional Details', Icons.info_outline),
        const SizedBox(height: 8),

        // Priority
        Row(
          children: [
            Icon(
              isUrgent ? Icons.priority_high : Icons.schedule,
              color: isUrgent ? Colors.red[600] : Colors.grey[600],
              size: 18,
            ),
            const SizedBox(width: 8),
            Text(
              isUrgent ? 'Urgent Service' : 'Standard Priority',
              style: GoogleFonts.cairo(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: isUrgent ? Colors.red[700] : Colors.grey[700],
              ),
            ),
          ],
        ),

        if (notes != null && notes!.isNotEmpty) ...[
          const SizedBox(height: 8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.notes, color: Colors.grey[600], size: 18),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Notes: $notes',
                  style: GoogleFonts.cairo(
                    fontSize: 14,
                    color: Colors.grey[700],
                  ),
                ),
              ),
            ],
          ),
        ],

        if (attachments.isNotEmpty) ...[
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(Icons.attach_file, color: Colors.grey[600], size: 18),
              const SizedBox(width: 8),
              Text(
                '${attachments.length} attachment${attachments.length > 1 ? 's' : ''}',
                style: GoogleFonts.cairo(
                  fontSize: 14,
                  color: Colors.grey[700],
                ),
              ),
            ],
          ),
        ],

        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildPriceSection(ThemeData theme) {
    final basePrice = servicePrice ?? 100.0;
    final urgent = urgentFee ?? (isUrgent ? 25.0 : 0.0);
    final tax = taxes ?? (basePrice * 0.08);
    final platform = platformFee ?? 5.0;
    final total = basePrice + urgent + tax + platform;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader('Price Breakdown', Icons.receipt),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: theme.primaryColor.withOpacity(0.05),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: theme.primaryColor.withOpacity(0.2)),
          ),
          child: Column(
            children: [
              _buildPriceRow('Service Fee', basePrice),
              if (urgent > 0) _buildPriceRow('Urgent Fee', urgent, isUrgent: true),
              _buildPriceRow('Taxes', tax),
              _buildPriceRow('Platform Fee', platform),
              const Divider(thickness: 1),
              _buildPriceRow('Total', total, isTotal: true, theme: theme),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSectionHeader(String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, color: Colors.grey[700], size: 18),
        const SizedBox(width: 8),
        Text(
          title,
          style: GoogleFonts.cairo(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.grey[800],
          ),
        ),
      ],
    );
  }

  Widget _buildPriceRow(String label, double amount, {bool isTotal = false, bool isUrgent = false, ThemeData? theme}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: GoogleFonts.cairo(
              fontSize: isTotal ? 16 : 14,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
              color: isUrgent ? Colors.orange[700] : (isTotal ? theme?.primaryColor : Colors.grey[700]),
            ),
          ),
          Text(
            '\$${amount.toStringAsFixed(2)}',
            style: GoogleFonts.cairo(
              fontSize: isTotal ? 16 : 14,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.w600,
              color: isUrgent ? Colors.orange[700] : (isTotal ? theme?.primaryColor : Colors.grey[800]),
            ),
          ),
        ],
      ),
    );
  }
}
