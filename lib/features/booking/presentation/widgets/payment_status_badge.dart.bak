import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../domain/entities/booking_entity.dart';

class PaymentStatusBadge extends StatelessWidget {
  final PaymentStatus status;
  final double? fontSize;

  const PaymentStatusBadge({
    super.key,
    required this.status,
    this.fontSize,
  });

  @override
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

  PaymentStatusInfo _getStatusInfo(PaymentStatus status) {
    switch (status) {
      case PaymentStatus.pending:
        return PaymentStatusInfo(
          label: 'Payment Pending',
          color: Colors.orange,
          icon: Icons.pending,
        );
      case PaymentStatus.paid:
        return PaymentStatusInfo(
          label: 'Paid',
          color: Colors.green,
          icon: Icons.paid,
        );
      case PaymentStatus.failed:
        return PaymentStatusInfo(
          label: 'Payment Failed',
          color: Colors.red,
          icon: Icons.error,
        );
      case PaymentStatus.refunded:
        return PaymentStatusInfo(
          label: 'Refunded',
          color: Colors.blue,
          icon: Icons.money_off,
        );
    }
  }
}

class PaymentStatusInfo {
  final String label;
  final Color color;
  final IconData icon;

  PaymentStatusInfo({
    required this.label,
    required this.color,
    required this.icon,
  });
}
