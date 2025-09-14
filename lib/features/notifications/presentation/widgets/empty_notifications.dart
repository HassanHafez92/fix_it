import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fix_it/l10n/app_localizations.dart';
/// EmptyNotifications
///
/// Business rules:
/// - Describe the business rules that this class enforces.
///
/// Dependencies:
/// - List important dependencies or preconditions.
///
/// Error scenarios:
/// - Describe common error conditions and how they are handled.
/// EmptyNotifications
///
/// Business rules:
/// - Describe the business rules that this class enforces.
///
/// Dependencies:
/// - List important dependencies or preconditions.
///
/// Error scenarios:
/// - Describe common error conditions and how they are handled.



class EmptyNotifications extends StatelessWidget {
  final bool hasFilter;
  final VoidCallback? onClearFilter;

  const EmptyNotifications({
    super.key,
    this.hasFilter = false,
    this.onClearFilter,
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
    final l10n = AppLocalizations.of(context)!;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Empty state icon
            Container(
              height: 120,
              width: 120,
              decoration: BoxDecoration(
                color: theme.primaryColor.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                hasFilter ? Icons.filter_list_off : Icons.notifications_none,
                size: 60,
                color: theme.primaryColor.withValues(alpha: 0.6),
              ),
            ),

            const SizedBox(height: 24),

            // Title
            Text(
              hasFilter ? l10n.noMatchingNotifications : l10n.noNotifications,
              style: GoogleFonts.cairo(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF2D3748),
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 12),

            // Subtitle
            Text(
              hasFilter
                  ? l10n.noNotificationsFoundForFilter
                  : l10n.allYourNotificationsWillAppearHere,
              style: GoogleFonts.cairo(
                fontSize: 16,
                color: const Color(0xFF718096),
                height: 1.4,
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 32),

            // Action button
            if (hasFilter && onClearFilter != null)
              ElevatedButton.icon(
                onPressed: onClearFilter,
                icon: const Icon(Icons.clear),
                label: Text(
                  l10n.removeFilter,
                  style: GoogleFonts.cairo(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.primaryColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
              )
            else
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: theme.primaryColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.lightbulb_outline,
                      size: 16,
                      color: theme.primaryColor,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      l10n.notificationsHint,
                      style: GoogleFonts.cairo(
                        fontSize: 12,
                        color: theme.primaryColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}