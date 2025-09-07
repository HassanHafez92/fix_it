import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ProviderServicesCard extends StatelessWidget {
  final List<String> services;

  const ProviderServicesCard({super.key, required this.services});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Services Offered',
              style: GoogleFonts.cairo(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.grey[800],
              ),
            ),
            const SizedBox(height: 16),
            if (services.isEmpty)
              Center(
                child: Text(
                  'No services available',
                  style: GoogleFonts.cairo(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
              )
            else
              ...services.map((service) => _buildServiceItem(service)),
          ],
        ),
      ),
    );
  }

  Widget _buildServiceItem(String service) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Expanded(
            child: Text(
              service,
              style: GoogleFonts.cairo(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.grey[800],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
