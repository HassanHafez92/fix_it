import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../bloc/settings_bloc.dart';
import '../bloc/settings_state.dart';
import '../bloc/settings_event.dart';
import '../widgets/settings_section.dart';
import '../widgets/settings_switch_item.dart';
import '../widgets/settings_selection_item.dart';
import '../../../../core/utils/bloc_utils.dart';
import '../../../../core/bloc/locale_bloc.dart';

/// SettingsScreen
///
/// Purpose:
/// - Shows the user's application settings (language, currency, theme,
///   notification toggles, privacy options) and allows updating them.
///
/// Business rules:
/// - Settings are read from [SettingsBloc] and updated via events (e.g.,
///   [UpdateSettings]). UI updates optimistically; failures are handled
///   by emitting [SettingsError] in the bloc which shows an error UI.
/// - Language changes are applied immediately via `context.setLocale` when
///   EasyLocalization is available; otherwise the app dispatches
///   [ChangeLocaleEvent] to [LocaleBloc].
///
/// Dependencies:
/// - Requires a provided [SettingsBloc] in the widget tree.
/// - Requires optional [LocaleBloc] for fallback locale persistence.
///
/// Error scenarios:
/// - If loading settings fails the page shows an error message and a
///   retry button that dispatches [LoadSettings].

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  /// build
  ///
  /// Description:
  /// - Builds the settings UI. Subscribes to [SettingsBloc] state changes
  ///   and renders loading, error, or loaded states accordingly.
  ///
  /// Parameters:
  /// - [context]: standard Flutter build context.
  ///
  /// Returns:
  /// - A [Widget] (Scaffold) containing the settings UI.

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

    // Ensure settings are loaded after the first frame so provider is available
    WidgetsBinding.instance.addPostFrameCallback((_) {
      safeAddEvent<SettingsBloc>(context, LoadSettings());
    });

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: theme.primaryColor,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
          ),
        ),
        title: Text(
          tr('settings'),
          style: GoogleFonts.cairo(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
      ),
      body: BlocBuilder<SettingsBloc, SettingsState>(
        builder: (context, state) {
          if (state is SettingsLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is SettingsError) {
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
                    tr('errorLoadingSettings'),
                    style: GoogleFonts.cairo(
                      fontSize: 16,
                      color: const Color(0xFF2D3748),
                    ),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () {
                      safeAddEvent<SettingsBloc>(context, LoadSettings());
                    },
                    child: Text(
                      tr('retry'),
                      style: GoogleFonts.cairo(),
                    ),
                  ),
                ],
              ),
            );
          }

          if (state is SettingsLoaded) {
            final settings = state.settings;

            return SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 16),

                  // App Preferences
                  SettingsSection(
                    title: tr('preferences'),
                    children: [
                      SettingsSelectionItem(
                        icon: Icons.language,
                        title: tr('language'),
                        subtitle:
                            _getLanguageDisplayName(context, settings.language),
                        onTap: () => _showLanguageSelector(context, settings),
                      ),
                      SettingsSelectionItem(
                        icon: Icons.monetization_on,
                        title: tr('currency'),
                        subtitle:
                            _getCurrencyDisplayName(context, settings.currency),
                        onTap: () =>
                            _showCurrencySelector(context, settings.currency),
                      ),
                      SettingsSelectionItem(
                        icon: Icons.palette,
                        title: tr('theme'),
                        subtitle: _getThemeDisplayName(context, settings.theme),
                        onTap: () =>
                            _showThemeSelector(context, settings.theme),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // Notifications
                  SettingsSection(
                    title: tr('notifications'),
                    children: [
                      SettingsSwitchItem(
                        icon: Icons.notifications,
                        title: tr('pushNotifications'),
                        subtitle: tr('pushNotificationsDesc'),
                        value: settings.pushNotificationsEnabled,
                        onChanged: (value) {
                          safeAddEvent<SettingsBloc>(
                              context,
                              UpdateSettings(
                                settings.copyWith(
                                    pushNotificationsEnabled: value),
                              ));
                        },
                      ),
                      SettingsSwitchItem(
                        icon: Icons.email,
                        title: tr('emailNotifications'),
                        subtitle: tr('emailNotificationsDesc'),
                        value: settings.emailNotificationsEnabled,
                        onChanged: (value) {
                          safeAddEvent<SettingsBloc>(
                              context,
                              UpdateSettings(
                                settings.copyWith(
                                    emailNotificationsEnabled: value),
                              ));
                        },
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // Privacy & Security
                  SettingsSection(
                    title: tr('privacyAndSecurity'),
                    children: [
                      SettingsSwitchItem(
                        icon: Icons.location_on,
                        title: tr('locationServices'),
                        subtitle: tr('locationServicesDesc'),
                        value: settings.locationServicesEnabled,
                        onChanged: (value) {
                          safeAddEvent<SettingsBloc>(
                              context,
                              UpdateSettings(
                                settings.copyWith(
                                    locationServicesEnabled: value),
                              ));
                        },
                      ),
                      SettingsSwitchItem(
                        icon: Icons.share,
                        title: tr('dataSharing'),
                        subtitle: tr('dataSharingDesc'),
                        value: settings.dataSharingEnabled,
                        onChanged: (value) {
                          safeAddEvent<SettingsBloc>(
                              context,
                              UpdateSettings(
                                settings.copyWith(dataSharingEnabled: value),
                              ));
                        },
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // Reset Settings
                  SettingsSection(
                    title: tr('reset'),
                    children: [
                      SettingsSelectionItem(
                        icon: Icons.restore,
                        title: tr('resetSettings'),
                        subtitle: tr('resetSettingsDesc'),
                        iconColor: Colors.orange,
                        onTap: () => _showResetDialog(context),
                      ),
                    ],
                  ),

                  const SizedBox(height: 32),
                ],
              ),
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  String _getLanguageDisplayName(BuildContext context, String language) {
    switch (language) {
      case 'ar':
        return tr('arabic');
      case 'en':
        return tr('english');
      default:
        return tr('arabic');
    }
  }

  String _getCurrencyDisplayName(BuildContext context, String currency) {
    switch (currency) {
      case 'SAR':
        return tr('currencySAR');
      case 'USD':
        return tr('currencyUSD');
      default:
        return tr('currencySAR');
    }
  }

  String _getThemeDisplayName(BuildContext context, String theme) {
    switch (theme) {
      case 'light':
        return tr('light');
      case 'dark':
        return tr('dark');
      case 'system':
        return tr('system');
      default:
        return tr('system');
    }
  }

  void _showLanguageSelector(BuildContext context, dynamic currentSettings) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              tr('selectLanguage'),
              style: GoogleFonts.cairo(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            _buildLanguageOption(context, 'ar', tr('arabic'), currentSettings),
            _buildLanguageOption(context, 'en', tr('english'), currentSettings),
          ],
        ),
      ),
    );
  }

  Widget _buildLanguageOption(
      BuildContext context, String code, String name, dynamic currentSettings) {
    final current =
        (currentSettings != null && currentSettings.language != null)
            ? currentSettings.language
            : null;

    return ListTile(
      title: Text(name, style: GoogleFonts.cairo()),
      trailing:
          code == current ? const Icon(Icons.check, color: Colors.green) : null,
      onTap: () {
        Navigator.pop(context);
        if (code != current) {
          // Update settings via SettingsBloc (defensive)
          try {
            safeAddEvent<SettingsBloc>(
              context,
              UpdateSettings(currentSettings.copyWith(language: code)),
            );
          } catch (_) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              safeAddEvent<SettingsBloc>(
                context,
                UpdateSettings(currentSettings.copyWith(language: code)),
              );
            });
          }

          // Set EasyLocalization locale immediately for runtime switch
          try {
            final newLocale =
                code == 'ar' ? const Locale('ar') : const Locale('en', 'US');
            context.setLocale(newLocale);
          } catch (_) {
            // If EasyLocalization isn't available, fall back to LocaleBloc
            final locale =
                code == 'ar' ? const Locale('ar') : const Locale('en', 'US');
            safeAddEvent<LocaleBloc>(context, ChangeLocaleEvent(locale));
          }
        }
      },
    );
  }

  void _showCurrencySelector(BuildContext context, String currentCurrency) {
    // Similar implementation for currency selector
  }

  void _showThemeSelector(BuildContext context, String currentTheme) {
    // Similar implementation for theme selector
  }

  void _showResetDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: Text(tr('resetSettings'),
            style: GoogleFonts.cairo(fontWeight: FontWeight.bold)),
        content: Text(
          tr('resetSettingsConfirm'),
          style: GoogleFonts.cairo(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(tr('cancel'), style: GoogleFonts.cairo()),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              safeAddEvent<SettingsBloc>(context, ResetSettings());
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
            child: Text(tr('reset'),
                style: GoogleFonts.cairo(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
