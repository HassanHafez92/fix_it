import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:fix_it/core/utils/app_routes.dart';

class UserTypeSelectionScreen extends StatelessWidget {
  const UserTypeSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Back button
              Align(
                alignment: Alignment.centerLeft,
                child: IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: Icon(
                    Icons.arrow_back_ios,
                    color: theme.primaryColor,
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Logo and title
              Column(
                children: [
                  Container(
                    height: 80,
                    width: 80,
                    decoration: BoxDecoration(
                      color: theme.primaryColor,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Icon(
                      Icons.build_circle,
                      color: Colors.white,
                      size: 40,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Join Fix It',
                    style: GoogleFonts.cairo(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF2D3748),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Choose your account type to continue',
                    style: GoogleFonts.cairo(
                      fontSize: 16,
                      color: const Color(0xFF718096),
                    ),
                  ),
                ],
              ),

              const Spacer(),

              // User type cards
              Column(
                children: [
                  _UserTypeCard(
                    icon: Icons.person,
                    title: 'Client',
                    description: 'I need maintenance and repair services',
                    onTap: () => _navigateToSignUp(context, 'client'),
                    color: Colors.blue,
                  ),
                  const SizedBox(height: 16),
                  _UserTypeCard(
                    icon: Icons.engineering,
                    title: 'Specialized Technician',
                    description: 'I provide maintenance and repair services',
                    onTap: () => _navigateToSignUp(context, 'provider'),
                    color: Colors.green,
                  ),
                ],
              ),

              const Spacer(),

              // Login link
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Already have an account?',
                    style: GoogleFonts.cairo(
                      fontSize: 14,
                      color: const Color(0xFF718096),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.pushReplacementNamed(
                      context,
                      AppRoutes.signIn,
                    ),
                    child: Text(
                      'Sign In',
                      style: GoogleFonts.cairo(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: theme.primaryColor,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  void _navigateToSignUp(BuildContext context, String userType) {
    if (userType == 'client') {
      Navigator.pushNamed(
        context,
        AppRoutes.clientSignUp,
      );
    } else {
      Navigator.pushNamed(
        context,
        AppRoutes.technicianSignUp,
      );
    }
  }
}

class _UserTypeCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final VoidCallback onTap;
  final Color color;

  const _UserTypeCard({
    required this.icon,
    required this.title,
    required this.description,
    required this.onTap,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              Container(
                height: 60,
                width: 60,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  size: 30,
                  color: color,
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
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF2D3748),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      description,
                      style: GoogleFonts.cairo(
                        fontSize: 14,
                        color: const Color(0xFF718096),
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                size: 20,
                color: const Color(0xFF718096),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
