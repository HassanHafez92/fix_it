// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/constants/app_constants.dart';
import 'package:fix_it/core/utils/app_routes.dart';
import '../widgets/custom_button.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // ignore: unused_local_variable
    final size = MediaQuery.of(context).size;
    final theme = Theme.of(context);

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
                        'Your trusted partner for home\nmaintenance and repair services',
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
                            text: 'إنشاء حساب جديد',
                            onPressed: () {
                              Navigator.pushNamed(
                                  context, AppRoutes.userTypeSelection);
                            },
                            backgroundColor: Colors.white,
                            textColor: theme.primaryColor,
                          ),
                          const SizedBox(height: 16),
                          CustomButton(
                            text: 'تسجيل الدخول',
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
                              'By continuing, you agree to our ',
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
                                'Terms of Service',
                                style: GoogleFonts.cairo(
                                  fontSize: 12,
                                  color: Colors.white,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ),
                            Text(
                              ' and ',
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
                                'Privacy Policy',
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
