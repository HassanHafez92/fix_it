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

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
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
          'الإعدادات',
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
                    'حدث خطأ في تحميل الإعدادات',
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
                      'إعادة المحاولة',
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
                    title: 'تفضيلات التطبيق',
                    children: [
                      SettingsSelectionItem(
                        icon: Icons.language,
                        title: 'اللغة',
                        subtitle: _getLanguageDisplayName(settings.language),
                        onTap: () => _showLanguageSelector(context, settings),
                      ),
                      SettingsSelectionItem(
                        icon: Icons.monetization_on,
                        title: 'العملة',
                        subtitle: _getCurrencyDisplayName(settings.currency),
                        onTap: () => _showCurrencySelector(context, settings.currency),
                      ),
                      SettingsSelectionItem(
                        icon: Icons.palette,
                        title: 'المظهر',
                        subtitle: _getThemeDisplayName(settings.theme),
                        onTap: () => _showThemeSelector(context, settings.theme),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // Notifications
                  SettingsSection(
                    title: 'الإشعارات',
                    children: [
                      SettingsSwitchItem(
                        icon: Icons.notifications,
                        title: 'الإشعارات الفورية',
                        subtitle: 'تلقي إشعارات فورية للطلبات والعروض',
                        value: settings.pushNotificationsEnabled,
                        onChanged: (value) {
                          safeAddEvent<SettingsBloc>(
                              context,
                              UpdateSettings(
                                settings.copyWith(pushNotificationsEnabled: value),
                              ));
                        },
                      ),
                      SettingsSwitchItem(
                        icon: Icons.email,
                        title: 'إشعارات البريد الإلكتروني',
                        subtitle: 'تلقي تحديثات عبر البريد الإلكتروني',
                        value: settings.emailNotificationsEnabled,
                        onChanged: (value) {
                          safeAddEvent<SettingsBloc>(
                              context,
                              UpdateSettings(
                                settings.copyWith(emailNotificationsEnabled: value),
                              ));
                        },
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // Privacy & Security
                  SettingsSection(
                    title: 'الخصوصية والأمان',
                    children: [
                      SettingsSwitchItem(
                        icon: Icons.location_on,
                        title: 'خدمات الموقع',
                        subtitle: 'السماح للتطبيق بالوصول لموقعك',
                        value: settings.locationServicesEnabled,
                        onChanged: (value) {
                          safeAddEvent<SettingsBloc>(
                              context,
                              UpdateSettings(
                                settings.copyWith(locationServicesEnabled: value),
                              ));
                        },
                      ),
                      SettingsSwitchItem(
                        icon: Icons.share,
                        title: 'مشاركة البيانات',
                        subtitle: 'مشاركة البيانات لتحسين الخدمة',
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
                    title: 'إعادة تعيين',
                    children: [
                      SettingsSelectionItem(
                        icon: Icons.restore,
                        title: 'إعادة تعيين الإعدادات',
                        subtitle: 'استعادة الإعدادات الافتراضية',
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

  String _getLanguageDisplayName(String language) {
    switch (language) {
      case 'ar':
        return 'العربية';
      case 'en':
        return 'English';
      default:
        return 'العربية';
    }
  }

  String _getCurrencyDisplayName(String currency) {
    switch (currency) {
      case 'SAR':
        return 'ريال سعودي (SAR)';
      case 'USD':
        return 'دولار أمريكي (USD)';
      case 'EUR':
        return 'يورو (EUR)';
      default:
        return 'ريال سعودي (SAR)';
    }
  }

  String _getThemeDisplayName(String theme) {
    switch (theme) {
      case 'light':
        return 'فاتح';
      case 'dark':
        return 'داكن';
      case 'system':
        return 'تلقائي';
      default:
        return 'تلقائي';
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
              'اختر اللغة',
              style: GoogleFonts.cairo(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            _buildLanguageOption(context, 'ar', 'العربية', currentSettings),
            _buildLanguageOption(context, 'en', 'English', currentSettings),
          ],
        ),
      ),
    );
  }

  Widget _buildLanguageOption(BuildContext context, String code, String name, dynamic currentSettings) {
    final current = (currentSettings != null && currentSettings.language != null)
        ? currentSettings.language
        : null;

    return ListTile(
      title: Text(name, style: GoogleFonts.cairo()),
      trailing: code == current ? const Icon(Icons.check, color: Colors.green) : null,
      onTap: () {
        Navigator.pop(context);
        if (code != current) {
          // Use the passed-in settings instance to build the updated settings
          try {
            safeAddEvent<SettingsBloc>(
              context,
              UpdateSettings(currentSettings.copyWith(language: code)),
            );

            // Also inform the global LocaleBloc so the app locale and
            // text direction update immediately.
            final locale = code == 'ar' ? const Locale('ar') : const Locale('en', 'US');
            safeAddEvent<LocaleBloc>(context, ChangeLocaleEvent(locale));
          } catch (_) {
            // If SettingsBloc or LocaleBloc are not available, defer to the next frame
            WidgetsBinding.instance.addPostFrameCallback((_) {
              safeAddEvent<SettingsBloc>(
                context,
                UpdateSettings(currentSettings.copyWith(language: code)),
              );
              final locale = code == 'ar' ? const Locale('ar') : const Locale('en', 'US');
              safeAddEvent<LocaleBloc>(context, ChangeLocaleEvent(locale));
            });
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
        title: Text('إعادة تعيين الإعدادات', style: GoogleFonts.cairo(fontWeight: FontWeight.bold)),
        content: Text(
          'هل أنت متأكد من رغبتك في إعادة تعيين جميع الإعدادات إلى القيم الافتراضية؟',
          style: GoogleFonts.cairo(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('إلغاء', style: GoogleFonts.cairo()),
          ),
          ElevatedButton(
                        onPressed: () {
              Navigator.pop(context);
              safeAddEvent<SettingsBloc>(context, ResetSettings());
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
            child: Text('إعادة تعيين', style: GoogleFonts.cairo(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}