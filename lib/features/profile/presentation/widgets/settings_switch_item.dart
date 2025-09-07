import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';


class SettingsSwitchItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final bool value;
  final Function(bool) onChanged;
  final Color? iconColor;

  const SettingsSwitchItem({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Container(
            height: 44,
            width: 44,
            decoration: BoxDecoration(
              color: (iconColor ?? theme.primaryColor).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              color: iconColor ?? theme.primaryColor,
              size: 20,
            ),
          ),

          const SizedBox(width: 16),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.cairo(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF2D3748),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: GoogleFonts.cairo(
                    fontSize: 13,
                    color: const Color(0xFF718096),
                  ),
                ),
              ],
            ),
          ),

          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: theme.primaryColor,
          ),
        ],
      ),
    );
  }
}