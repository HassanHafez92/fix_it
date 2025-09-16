// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:fix_it/core/utils/app_routes.dart';
import 'package:fix_it/l10n/app_localizations.dart';
import 'package:fix_it/core/bloc/locale_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fix_it/core/di/injection_container.dart' as di;
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../profile/presentation/bloc/user_profile_bloc/user_profile_bloc.dart';
import '../../../settings/presentation/bloc/settings_bloc/settings_bloc.dart';
import '../../../../core/bloc/theme_cubit.dart';
import 'package:fix_it/core/utils/bloc_utils.dart';

/// Profile tab of the main dashboard
///
/// Provides user account management:
/// - User profile information
/// - Settings and preferences
/// - Help and support access
/// - Account actions (logout, etc.)
class DashboardProfileTab extends StatefulWidget {
  const DashboardProfileTab({super.key});

  @override
  State<DashboardProfileTab> createState() => _DashboardProfileTabState();
}

class _DashboardProfileTabState extends State<DashboardProfileTab> {
  bool _didInit = false;

  // DI fallback helpers
  UserProfileBloc _getUserProfileBloc(BuildContext ctx) {
    try {
      return ctx.read<UserProfileBloc>();
    } catch (_) {
      return di.sl<UserProfileBloc>();
    }
  }

  @override
/// initState
///
/// Description: Briefly explain what this method does.
///
/// Parameters:
/// - (describe parameters)
///
/// Returns:
/// - (describe return value)
  void initState() {
    super.initState();
    // Do not access InheritedWidgets/Providers here. Dispatch bloc events
    // in didChangeDependencies so the providers higher in the tree are available.
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_didInit) {
      _didInit = true;
  // Providers are available now; dispatch initial load events.
  safeAddEvent<UserProfileBloc>(context, LoadUserProfileEvent());
  safeAddEvent<SettingsBloc>(context, LoadSettingsEvent());
    }
  }

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

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: _buildAppBar(context, theme),
      body: RefreshIndicator(
        onRefresh: _onRefresh,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildProfileHeader(context, theme),
              const SizedBox(height: 24),
              _buildQuickStats(context, theme),
              const SizedBox(height: 24),
              _buildAccountSection(context, theme),
              const SizedBox(height: 24),
              _buildPreferencesSection(context, theme),
              const SizedBox(height: 24),
              _buildSupportSection(context, theme),
              const SizedBox(height: 24),
              _buildAppSection(context, theme),
              const SizedBox(height: 80), // Space for bottom navigation
            ],
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context, ThemeData theme) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      title: Text(
        AppLocalizations.of(context)!.profileTitle,
        style: GoogleFonts.cairo(
          color: theme.primaryColor,
          fontWeight: FontWeight.bold,
          fontSize: 20,
        ),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.bug_report, color: Colors.redAccent),
          onPressed: () async {
            // Debug: print LocaleBloc instances from DI and context and saved prefs
            final localContext = context;
            try {
              final diLocale = di.sl<LocaleBloc>().state.locale;
              final contextLocale =
                  localContext.read<LocaleBloc>().state.locale;
              final prefs = await SharedPreferences.getInstance();
              final prefsLocale = prefs.getString('locale');
              // ignore: avoid_print
              print('DEBUG: di LocaleBloc state -> $diLocale');
              // ignore: avoid_print
              print('DEBUG: context LocaleBloc state -> $contextLocale');
              // ignore: avoid_print
              print('DEBUG: prefs locale -> $prefsLocale');
            } catch (e) {
              // ignore: avoid_print
              print('DEBUG: error reading debug info: $e');
            }
          },
        ),
        IconButton(
          icon: Icon(Icons.edit, color: theme.primaryColor),
          onPressed: () {
            Navigator.pushNamed(context, AppRoutes.editProfile);
          },
        ),
        PopupMenuButton<String>(
          onSelected: (value) {
            switch (value) {
              case 'settings':
                Navigator.pushNamed(context, AppRoutes.settings);
                break;
              case 'help':
                Navigator.pushNamed(context, AppRoutes.help);
                break;
              case 'logout':
                _showLogoutDialog(context);
                break;
            }
          },
          itemBuilder: (context) => [
            PopupMenuItem(
              value: 'settings',
              child: Row(
                children: [
                  const Icon(Icons.settings),
                  const SizedBox(width: 8),
                  Text(AppLocalizations.of(context)!.settings),
                ],
              ),
            ),
            PopupMenuItem(
              value: 'help',
              child: Row(
                children: [
                  const Icon(Icons.help),
                  const SizedBox(width: 8),
                  Text(AppLocalizations.of(context)!.helpSupport),
                ],
              ),
            ),
            PopupMenuItem(
              value: 'logout',
              child: Row(
                children: [
                  const Icon(Icons.logout, color: Colors.red),
                  const SizedBox(width: 8),
                  Text(AppLocalizations.of(context)!.logoutTitle, style: const TextStyle(color: Colors.red)),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildProfileHeader(BuildContext context, ThemeData theme) {
    return BlocBuilder<UserProfileBloc, UserProfileState>(
      bloc: _getUserProfileBloc(context),
      builder: (context, state) {
        if (state is UserProfileLoading) {
          return Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: const Center(child: CircularProgressIndicator()),
          );
        } else if (state is UserProfileError) {
          return Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              children: [
                Icon(Icons.error_outline, color: Colors.red[400], size: 36),
                const SizedBox(height: 8),
                Text('Error loading profile',
                    style: GoogleFonts.cairo(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Text(state.message, style: GoogleFonts.cairo()),
              ],
            ),
          );
        } else if (state is UserProfileLoaded) {
          final user = state.userProfile;
          final userName = user['fullName'] as String? ?? 'User';
          final userEmail = user['email'] as String? ?? '';
          final userPhone = user['phoneNumber'] as String? ?? '';
          final userType = (user['userType'] as String?) == 'client'
              ? 'Client'
              : 'Service Provider';

          return Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              children: [
                Stack(
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundColor: theme.primaryColor.withOpacity(0.1),
                      child: Text(
                        userName.isNotEmpty ? userName[0].toUpperCase() : 'U',
                        style: GoogleFonts.cairo(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: theme.primaryColor,
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: theme.primaryColor,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.camera_alt,
                          color: Colors.white,
                          size: 16,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  userName,
                  style: GoogleFonts.cairo(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[800],
                  ),
                  textAlign: TextAlign.center,
                ),
                if (userType.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: theme.primaryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      userType,
                      style: GoogleFonts.cairo(
                        fontSize: 12,
                        color: theme.primaryColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
                const SizedBox(height: 16),
                if (userEmail.isNotEmpty) ...[
                  Row(
                    children: [
                      Icon(Icons.email, color: Colors.grey[600], size: 16),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          userEmail,
                          style: GoogleFonts.cairo(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
                if (userPhone.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.phone, color: Colors.grey[600], size: 16),
                      const SizedBox(width: 8),
                      Text(
                        userPhone,
                        style: GoogleFonts.cairo(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          );
        }

  // Fallback to auth bloc if user profile bloc hasn't emitted anything yet
  return BlocBuilder<AuthBloc, AuthState>(
          builder: (context, authState) {
            String userName = 'User';
            // Note: email/phone shown below if available from profile state
            String userType = '';

            if (authState is AuthAuthenticated) {
              userName = authState.user.fullName;
              userType = authState.user.userType == 'client'
                  ? 'Client'
                  : 'Service Provider';
            }

            return Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Stack(
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundColor: theme.primaryColor.withOpacity(0.1),
                        child: Text(
                          userName.isNotEmpty ? userName[0].toUpperCase() : 'U',
                          style: GoogleFonts.cairo(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: theme.primaryColor,
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: theme.primaryColor,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.camera_alt,
                            color: Colors.white,
                            size: 16,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    userName,
                    style: GoogleFonts.cairo(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[800],
                    ),
                    textAlign: TextAlign.center,
                  ),
                  if (userType.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(
                        color: theme.primaryColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        userType,
                        style: GoogleFonts.cairo(
                          fontSize: 12,
                          color: theme.primaryColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildQuickStats(BuildContext context, ThemeData theme) {
    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            title: 'Bookings',
            value: '12',
            icon: Icons.calendar_today,
            color: Colors.blue,
            onTap: () {
              // Navigate to bookings tab
            },
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildStatCard(
            title: 'Reviews',
            value: '4.8',
            icon: Icons.star,
            color: Colors.orange,
            onTap: () {
              // Navigate to reviews
            },
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
    VoidCallback? onTap,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: onTap,
          child: Column(
            children: [
              Icon(icon, color: color, size: 28),
              const SizedBox(height: 8),
              Text(
                value,
                style: GoogleFonts.cairo(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
              Text(
                title,
                style: GoogleFonts.cairo(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAccountSection(BuildContext context, ThemeData theme) {
    return _buildSection(
      title: 'Account',
      children: [
        _buildMenuItem(
          icon: Icons.person,
          title: 'Edit Profile',
          subtitle: 'Update your personal information',
          onTap: () {
            Navigator.pushNamed(context, AppRoutes.editProfile);
          },
        ),
        _buildMenuItem(
          icon: Icons.lock,
          title: 'Change Password',
          subtitle: 'Update your account password',
          onTap: () {
            Navigator.pushNamed(context, AppRoutes.changePassword);
          },
        ),
        _buildMenuItem(
          icon: Icons.search,
          title: 'Browse Providers',
          subtitle: 'Find nearby technicians and services',
          onTap: () {
            Navigator.pushNamed(context, AppRoutes.providerSearchPage);
          },
        ),
        _buildMenuItem(
          icon: Icons.payment,
          title: 'Payment Methods',
          subtitle: 'Manage your payment options',
          onTap: () {
            Navigator.pushNamed(context, AppRoutes.paymentMethods);
          },
        ),
        _buildMenuItem(
          icon: Icons.chat_bubble_outline,
          title: 'Chat',
          subtitle: 'View your conversations',
          onTap: () {
            Navigator.pushNamed(context, AppRoutes.chatList);
          },
        ),
      ],
    );
  }

  Widget _buildPreferencesSection(BuildContext context, ThemeData theme) {
    return _buildSection(
      title: AppLocalizations.of(context)!.preferences,
      children: [
        _buildMenuItem(
          icon: Icons.notifications,
          title: 'Notifications',
          subtitle: 'Manage notification settings',
          onTap: () {
            Navigator.pushNamed(context, AppRoutes.notifications);
          },
          trailing: Switch(
            value: true,
            onChanged: (value) {
              // Handle notification toggle
            },
            activeColor: theme.primaryColor,
          ),
        ),
        

        _buildMenuItem(
          icon: Icons.settings,
          title: AppLocalizations.of(context)!.settings,
          subtitle: 'Manage app settings',
          onTap: () {
            Navigator.pushNamed(context, AppRoutes.settings);
          },
        ),
        _buildMenuItem(
          icon: Icons.dark_mode,
          title: 'Dark Mode',
          subtitle: 'Toggle dark theme',
          onTap: () {
            // No-op: toggle handled by the switch
          },
          trailing: Builder(builder: (context) {
            final mode = di.sl<ThemeCubit>().state;
            final isDark = mode == ThemeMode.dark ||
                (mode == ThemeMode.system &&
                    MediaQuery.of(context).platformBrightness ==
                        Brightness.dark);

            return Switch(
              value: isDark,
              onChanged: (value) {
                // Update ThemeCubit which is registered in DI and provided at app root
                context.read<ThemeCubit>().toggle(value);
              },
              activeColor: theme.primaryColor,
            );
          }),
        ),
      ],
    );
  }

  Widget _buildSupportSection(BuildContext context, ThemeData theme) {
    return _buildSection(
      title: AppLocalizations.of(context)!.helpSupport,
      children: [
        _buildMenuItem(
          icon: Icons.help,
          title: 'Help Center',
          subtitle: 'Get help and support',
          onTap: () {
            Navigator.pushNamed(context, AppRoutes.help);
          },
        ),
        _buildMenuItem(
          icon: Icons.contact_support,
          title: 'Contact Us',
          subtitle: 'Get in touch with our team',
          onTap: () {
            Navigator.pushNamed(context, AppRoutes.contactSupport);
          },
        ),
        _buildMenuItem(
          icon: Icons.star_rate,
          title: 'Rate App',
          subtitle: 'Rate us on the app store',
          onTap: () {
            _showRateAppDialog(context);
          },
        ),
      ],
    );
  }

  Widget _buildAppSection(BuildContext context, ThemeData theme) {
    return _buildSection(
      title: AppLocalizations.of(context)!.appTitle,
      children: [
        _buildMenuItem(
          icon: Icons.info,
          title: AppLocalizations.of(context)!.about,
          subtitle: 'Learn more about Fix It',
          onTap: () {
            Navigator.pushNamed(context, AppRoutes.about);
          },
        ),
        _buildMenuItem(
          icon: Icons.privacy_tip,
          title: AppLocalizations.of(context)!.privacyPolicy,
          subtitle: 'Read our privacy policy',
          onTap: () {
            Navigator.pushNamed(context, AppRoutes.privacyPolicy);
          },
        ),
        _buildMenuItem(
          icon: Icons.description,
          title: AppLocalizations.of(context)!.termsOfService,
          subtitle: 'Read our terms of service',
          onTap: () {
            Navigator.pushNamed(context, AppRoutes.termsOfService);
          },
        ),
        _buildMenuItem(
          icon: Icons.logout,
          title: 'Logout',
          subtitle: 'Sign out of your account',
          onTap: () {
            _showLogoutDialog(context);
          },
          titleColor: Colors.red,
          iconColor: Colors.red,
        ),
      ],
    );
  }

  Widget _buildSection({
    required String title,
    required List<Widget> children,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: GoogleFonts.cairo(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.grey[800],
          ),
        ),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            children: children,
          ),
        ),
      ],
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    Widget? trailing,
    Color? titleColor,
    Color? iconColor,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: (iconColor ?? Colors.grey[600])!.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  icon,
                  color: iconColor ?? Colors.grey[600],
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
                        color: titleColor ?? Colors.grey[800],
                      ),
                    ),
                    Text(
                      subtitle,
                      style: GoogleFonts.cairo(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              trailing ?? Icon(Icons.chevron_right, color: Colors.grey[400]),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _onRefresh() async {
    // Refresh user profile and settings
  safeAddEvent<UserProfileBloc>(context, LoadUserProfileEvent());
  safeAddEvent<SettingsBloc>(context, LoadSettingsEvent());
  }

  void _showLogoutDialog(BuildContext context) {
    final parentContext = context;
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(
          'Logout',
          style: GoogleFonts.cairo(fontWeight: FontWeight.bold),
        ),
        content: Text(
          'Are you sure you want to logout?',
          style: GoogleFonts.cairo(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
              TextButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              safeAddEvent<AuthBloc>(parentContext, SignOutEvent());
            },
            child: Text(AppLocalizations.of(context)!.logoutTitle, style: const TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  

  void _showRateAppDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Rate Fix It',
          style: GoogleFonts.cairo(fontWeight: FontWeight.bold),
        ),
        content: Text(
          'If you enjoy using Fix It, would you mind taking a moment to rate it? Thanks for your support!',
          style: GoogleFonts.cairo(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Not Now'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              // Open app store for rating
            },
            child: const Text('Rate Now'),
          ),
        ],
      ),
    );
  }
}
