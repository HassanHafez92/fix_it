import 'package:flutter/material.dart';
import 'package:fix_it/l10n/app_localizations.dart';

class TermsOfServiceScreen extends StatelessWidget {
  const TermsOfServiceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.termsOfService),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Text(
            // Placeholder text; replace with real terms content
            'Terms of Service\n\nThis is a placeholder for the Terms of Service. Replace with the real terms or load from assets.',
            style: const TextStyle(fontSize: 16, height: 1.5),
          ),
        ),
      ),
    );
  }
}
