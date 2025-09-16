import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:fix_it/core/utils/app_routes.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:fix_it/core/widgets/directionality_wrapper.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import 'package:fix_it/core/utils/bloc_utils.dart';
import '../bloc/user_profile_bloc/user_profile_bloc.dart';
import '../widgets/profile_header.dart';
import '../../domain/entities/user_profile_entity.dart';
import '../widgets/profile_menu_item.dart';
/// ProfileScreen
///
/// Business rules:
/// - Describe the business rules that this class enforces.
///
/// Dependencies:
/// - List important dependencies or preconditions.
///
/// Error scenarios:
/// - Describe common error conditions and how they are handled.
/// ProfileScreen
///
/// Business rules:
/// - Describe the business rules that this class enforces.
///
/// Dependencies:
/// - List important dependencies or preconditions.
///
/// Error scenarios:
/// - Describe common error conditions and how they are handled.



class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});
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
/// build
///
/// Description: Briefly explain what this method does.
///
/// Parameters:
/// - (describe parameters)
///
/// Returns:
/// - (describe return value)
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return DirectionalityWrapper(
      child: Scaffold(
        backgroundColor: Colors.grey[50],
        appBar: AppBar(
          backgroundColor: theme.primaryColor,
          elevation: 0,
          title: Text(
            tr('profileTitle'),
            style: GoogleFonts.cairo(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          centerTitle: true,
          actions: [
            IconButton(
              onPressed: () {
                Navigator.pushNamed(context, AppRoutes.settings);
              },
              icon: const Icon(
                Icons.settings,
                color: Colors.white,
              ),
            ),
          ],
        ),
        body: BlocBuilder<UserProfileBloc, UserProfileState>(
          builder: (context, state) {
            if (state is UserProfileLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is UserProfileError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      size: 64,
                      color: Colors.red,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      tr('errorLoadingData'),
                      style: GoogleFonts.cairo(
                        fontSize: 16,
                        color: const Color(0xFF2D3748),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      state.message,
                      style: GoogleFonts.cairo(
                        fontSize: 14,
                        color: const Color(0xFF718096),
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: () {
                        // use safeAddEvent to avoid ProviderNotFound when context
                        // inside error widget may not have the bloc available
                        safeAddEvent<UserProfileBloc>(
                            context, const LoadUserProfileEvent());
                      },
                      child: Text(
                        tr('tryAgain'),
                        style: GoogleFonts.cairo(),
                      ),
                    ),
                  ],
                ),
              );
            }

            return SingleChildScrollView(
              child: Column(
                children: [
                  // Profile Header
                  if (state is UserProfileLoaded)
                    ProfileHeader(profile: _mapToEntity(state.userProfile)),

                  const SizedBox(height: 24),

                  // Menu Items
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        ProfileMenuItem(
                          icon: Icons.person_outline,
                          title: tr('editProfile'),
                          subtitle: tr('profileUpdateSubtitle'),
                          onTap: () {
                            Navigator.pushNamed(context, AppRoutes.editProfile);
                          },
                        ),
                        const Divider(height: 1),
                        ProfileMenuItem(
                          icon: Icons.lock_outline,
                          title: tr('changePassword'),
                          subtitle: tr('changePasswordSubtitle'),
                          onTap: () {
                            Navigator.pushNamed(
                                context, AppRoutes.changePassword);
                          },
                        ),
                        const Divider(height: 1),
                        ProfileMenuItem(
                          icon: Icons.payment,
                          title: tr('paymentMethods'),
                          subtitle: tr('managePaymentSubtitle'),
                          onTap: () {
                            Navigator.pushNamed(
                                context, AppRoutes.paymentMethods);
                          },
                        ),
                        const Divider(height: 1),
                        ProfileMenuItem(
                          icon: Icons.history,
                          title: tr('bookings'),
                          subtitle: tr('viewBookingsSubtitle'),
                          onTap: () {
                            Navigator.pushNamed(context, AppRoutes.bookings);
                          },
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Settings & Support
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        ProfileMenuItem(
                          icon: Icons.notifications_outlined,
                          title: tr('notifications'),
                          subtitle: tr('notificationsSubtitle'),
                          onTap: () {
                            Navigator.pushNamed(
                                context, AppRoutes.notifications);
                          },
                        ),
                        const Divider(height: 1),
                        ProfileMenuItem(
                          icon: Icons.help_outline,
                          title: tr('helpSupport'),
                          subtitle: tr('helpSupportSubtitle'),
                          onTap: () {
                            Navigator.pushNamed(context, AppRoutes.help);
                          },
                        ),
                        const Divider(height: 1),
                        ProfileMenuItem(
                          icon: Icons.info_outline,
                          title: tr('about'),
                          subtitle: tr('aboutSubtitle'),
                          onTap: () {
                            Navigator.pushNamed(context, AppRoutes.about);
                          },
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Logout
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: ProfileMenuItem(
                      icon: Icons.logout,
                      title: tr('logoutTitle'),
                      subtitle: tr('logoutSubtitle'),
                      iconColor: Colors.red,
                      titleColor: Colors.red,
                      onTap: () => _showLogoutDialog(context),
                    ),
                  ),

                  const SizedBox(height: 32),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    final parentContext = context;
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        title: Text(
          tr('logoutTitle'),
          style: GoogleFonts.cairo(
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Text(
          tr('logoutConfirm'),
          style: GoogleFonts.cairo(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              tr('cancel'),
              style: GoogleFonts.cairo(
                color: const Color(0xFF718096),
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              // Use the parent context (the one that contains the providers)
              safeAddEvent<AuthBloc>(parentContext, SignOutEvent());
              Navigator.pushNamedAndRemoveUntil(
                parentContext,
                AppRoutes.welcome,
                (route) => false,
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: Text(
              tr('logoutTitle'),
              style: GoogleFonts.cairo(
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

UserProfileEntity _mapToEntity(Map<String, dynamic> m) {
  return UserProfileEntity(
    id: m['id'] as String? ?? 'unknown',
    fullName: m['fullName'] as String? ?? 'User',
    email: m['email'] as String? ?? '',
    phoneNumber: m['phoneNumber'] as String?,
    profilePictureUrl: m['profilePictureUrl'] as String?,
    bio: m['bio'] as String?,
    paymentMethods: (m['paymentMethods'] as List<dynamic>?)
            ?.map((e) => e.toString())
            .toList() ??
        [],
    createdAt: m['createdAt'] is DateTime
        ? m['createdAt'] as DateTime
        : DateTime.now(),
    updatedAt: m['updatedAt'] is DateTime
        ? m['updatedAt'] as DateTime
        : DateTime.now(),
  );
}
