import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fix_it/l10n/app_localizations.dart';
/// HelpSearchBar
///
/// Business rules:
/// - Describe the business rules that this class enforces.
///
/// Dependencies:
/// - List important dependencies or preconditions.
///
/// Error scenarios:
/// - Describe common error conditions and how they are handled.
/// HelpSearchBar
///
/// Business rules:
/// - Describe the business rules that this class enforces.
///
/// Dependencies:
/// - List important dependencies or preconditions.
///
/// Error scenarios:
/// - Describe common error conditions and how they are handled.



class HelpSearchBar extends StatelessWidget {
  final TextEditingController controller;
  final Function(String) onChanged;
  final VoidCallback onClear;

  const HelpSearchBar({
    super.key,
    required this.controller,
    required this.onChanged,
    required this.onClear,
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
    final l10n = AppLocalizations.of(context)!;
    return TextField(
      controller: controller,
      onChanged: onChanged,
      textDirection: TextDirection.rtl,
      decoration: InputDecoration(
        hintText: l10n.searchFaqHint,
        hintStyle: GoogleFonts.cairo(
          color: const Color(0xFF718096),
        ),
        prefixIcon: const Icon(
          Icons.search,
          color: Color(0xFF718096),
        ),
        suffixIcon: controller.text.isNotEmpty
            ? IconButton(
                onPressed: onClear,
                icon: const Icon(
                  Icons.clear,
                  color:  Color(0xFF718096),
                ),
              )
            : null,
        border: InputBorder.none,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
      ),
      style: GoogleFonts.cairo(
        fontSize: 16,
        color: const Color(0xFF2D3748),
      ),
    );
  }
}