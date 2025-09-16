import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../domain/entities/provider_entity.dart';

/// ProviderInfoCard
///
/// Displays contact information for a provider (phone, email, location).
/// Used inside provider profile/details screens.
///
/// Business Rules:
/// - All displayed contact fields are read-only.
/// - Expects [ProviderEntity] to contain valid phone/email strings; display
///   falls back to empty values if missing.
class ProviderInfoCard extends StatelessWidget {
  final ProviderEntity provider;

  const ProviderInfoCard({super.key, required this.provider});

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
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              tr('contactInformation'),
              style: GoogleFonts.cairo(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.grey[800],
              ),
            ),
            const SizedBox(height: 16),
            _buildInfoRow(Icons.phone, tr('phone'), provider.phone),
            const SizedBox(height: 12),
            _buildInfoRow(Icons.email, tr('email'), provider.email),
            const SizedBox(height: 12),
            _buildInfoRow(
                Icons.location_on, tr('locationLabel'), provider.location),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 20, color: Colors.grey[600]),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: GoogleFonts.cairo(
                  fontSize: 12,
                  color: Colors.grey[500],
                ),
              ),
              Text(
                value,
                style: GoogleFonts.cairo(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[800],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
