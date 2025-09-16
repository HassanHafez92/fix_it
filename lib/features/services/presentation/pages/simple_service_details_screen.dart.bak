import 'package:flutter/material.dart';
import 'package:fix_it/l10n/app_localizations.dart';
import 'package:google_fonts/google_fonts.dart';

/// Simplified Service Details Screen that avoids potential errors
class SimpleServiceDetailsScreen extends StatelessWidget {
  final String serviceId;

  const SimpleServiceDetailsScreen({super.key, required this.serviceId});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Service Details',
          style: GoogleFonts.cairo(
            color: theme.primaryColor,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.build_circle, size: 64, color: theme.primaryColor),
            SizedBox(height: 16),
            Text(
              'Service ID: $serviceId',
              style: GoogleFonts.cairo(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.grey[800],
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Service details would be loaded here',
              style: TextStyle(color: Colors.grey),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(AppLocalizations.of(context)!.close),
            ),
          ],
        ),
      ),
    );
  }
}
