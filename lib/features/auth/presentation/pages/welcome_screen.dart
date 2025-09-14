// ignore_for_file: deprecated_member_use

import 'package:fix_it/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/constants/app_constants.dart';
import 'package:fix_it/core/utils/app_routes.dart';
import '../widgets/custom_button.dart';
/// WelcomeScreen
///
/// Business rules:
/// - Describe the business rules that this class enforces.
///
/// Dependencies:
/// - List important dependencies or preconditions.
///
/// Error scenarios:
/// - Describe common error conditions and how they are handled.
/// WelcomeScreen
///
/// Business rules:
/// - Describe the business rules that this class enforces.
///
/// Dependencies:
/// - List important dependencies or preconditions.
///
/// Error scenarios:
/// - Describe common error conditions and how they are handled.



class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});
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
    // ignore: unused_local_variable
    final size = MediaQuery.of(context).size;
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);
    if (l10n == null) {
      // Return a simple loading indicator if localization is not available
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              theme.primaryColor,
              theme.primaryColor.withOpacity(0.8),
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: MediaQuery.of(context).size.height -
                    MediaQuery.of(context).padding.top -
                    MediaQuery.of(context).padding.bottom,
              ),
              child: IntrinsicHeight(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Column(
                    children: [
                      const SizedBox(height: 40),

                      // Logo and App Name
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 20,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        child: Icon(
                          Icons.build_rounded,
                          size: 60,
                          color: theme.primaryColor,
                        ),
                      ),

                      const SizedBox(height: 24),

                      Text(
                        AppConstants.appName,
                        style: GoogleFonts.cairo(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),

                      const SizedBox(height: 16),

                      Text(
                        l10n.welcomeSlogan,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.cairo(
                          fontSize: 16,
                          color: Colors.white.withOpacity(0.9),
                          height: 1.5,
                        ),
                      ),

                      const Spacer(),

                      // Buttons
                      Column(
                        children: [
                          CustomButton(
                            text: l10n.createNewAccount,
                            onPressed: () {
                              Navigator.pushNamed(
                                  context, AppRoutes.userTypeSelection);
                            },
                            backgroundColor: Colors.white,
                            textColor: theme.primaryColor,
                          ),
                          const SizedBox(height: 16),
                          CustomButton(
                            text: l10n.signIn,
                            onPressed: () {
                              Navigator.pushNamed(context, AppRoutes.signIn);
                            },
                            backgroundColor: Colors.transparent,
                            textColor: Colors.white,
                            borderColor: Colors.white,
                          ),
                        ],
                      ),

                      const SizedBox(height: 32),

                      // Terms and Privacy
                      Flexible(
                        child: Wrap(
                          alignment: WrapAlignment.center,
                          children: [
                            Text(
                              l10n.byContinuingYouAgree,
                              style: GoogleFonts.cairo(
                                fontSize: 12,
                                color: Colors.white.withOpacity(0.8),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                // Navigate to terms
                              },
                              child: Text(
                                l10n.termsOfService,
                                style: GoogleFonts.cairo(
                                  fontSize: 12,
                                  color: Colors.white,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ),
                            Text(
                              l10n.and,
                              style: GoogleFonts.cairo(
                                fontSize: 12,
                                color: Colors.white.withOpacity(0.8),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                // Navigate to privacy policy
                              },
                              child: Text(
                                l10n.privacyPolicy,
                                style: GoogleFonts.cairo(
                                  fontSize: 12,
                                  color: Colors.white,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
