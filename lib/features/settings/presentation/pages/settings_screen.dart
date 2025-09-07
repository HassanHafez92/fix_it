import 'package:fix_it/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fix_it/core/theme/app_theme.dart';
import 'package:fix_it/core/utils/app_routes.dart';
import 'package:fix_it/core/bloc/locale_bloc.dart';
import 'package:fix_it/core/widgets/directionality_wrapper.dart';
import 'package:fix_it/features/settings/presentation/bloc/settings_bloc/settings_bloc.dart';
import 'package:fix_it/core/utils/bloc_utils.dart';

class AppSettingsScreen extends StatefulWidget {
  const AppSettingsScreen({super.key});

  @override
  State<AppSettingsScreen> createState() => _AppSettingsScreenState();
}

class _AppSettingsScreenState extends State<AppSettingsScreen> {
  @override
  void initState() {
    super.initState();
    // Defer loading settings until the first frame so ancestor providers
    // (registered by routes or parent widgets) are available in the context.
    WidgetsBinding.instance.addPostFrameCallback((_) {
  _safeAddEvent(context, LoadSettingsEvent());
    });
  }

  void _safeAddEvent(BuildContext context, SettingsEvent event) {
    // Use the repository-wide safeAddEvent helper which safely defers
    // dispatches when the provider is not yet available in the widget tree.
    try {
      safeAddEvent<SettingsBloc>(context, event);
    } catch (e) {
      // Provider not available or other runtime error; log only to avoid
      // calling ScaffoldMessenger with a context that may not include a Scaffold.
      // ignore: avoid_print
      print('SettingsBloc not available when trying to add event: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return DirectionalityWrapper(
      child: Scaffold(
        appBar: AppBar(
          title: Text(AppLocalizations.of(context)!.settings),
        ),
        body: BlocListener<SettingsBloc, SettingsState>(
          listener: (context, state) {
            if (state is SettingsUpdated) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                      AppLocalizations.of(context)!.settingsUpdatedSuccess),
                  backgroundColor: Colors.green,
                ),
              );
            } else if (state is SettingsLanguageChanged) {
              // Update the app locale when language changes
              safeAddEvent<LocaleBloc>(context, ChangeLocaleEvent(state.locale));
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                      AppLocalizations.of(context)!.languageChangedSuccess),
                  backgroundColor: Colors.green,
                ),
              );
            } else if (state is SettingsError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                      '${AppLocalizations.of(context)!.somethingWentWrong}: ${state.message}'),
                  backgroundColor: Colors.red,
                ),
              );
            }
          },
          child: BlocBuilder<SettingsBloc, SettingsState>(
            builder: (context, state) {
              if (state is SettingsLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is SettingsLoaded) {
                return _buildSettingsContent(context, state.settings);
              } else if (state is SettingsUpdating) {
                return _buildSettingsContent(context, state.settings,
                    isLoading: true);
              } else if (state is SettingsError) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '${AppLocalizations.of(context)!.somethingWentWrong}: ${state.message}',
                        style: const TextStyle(color: Colors.red),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () {
                          _safeAddEvent(context, LoadSettingsEvent());
                        },
                        child: Text(AppLocalizations.of(context)!.tryAgain),
                      ),
                    ],
                  ),
                );
              }
              return Center(
                  child:
                      Text(AppLocalizations.of(context)!.somethingWentWrong));
            },
          ),
        ),
      ),
    );
  }

  Widget _buildSettingsContent(
    BuildContext context,
    dynamic settings, {
    bool isLoading = false,
  }) {
    // Ensure settings is a Map for safe lookups. The bloc currently emits a Map<String, dynamic>.
    final Map<String, dynamic> s =
        (settings is Map<String, dynamic>) ? settings : <String, dynamic>{};

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Notifications settings
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppLocalizations.of(context)!.notifications,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Push notifications toggle
                  _buildSwitchTile(
                    title: AppLocalizations.of(context)!.pushNotifications,
                    subtitle:
                        AppLocalizations.of(context)!.pushNotificationsDesc,
                    value: (s['pushNotifications'] as bool?) ?? true,
                    onChanged: (value) {
                      _safeAddEvent(context,
                          UpdatePushNotificationsEvent(enabled: value));
                    },
                    isLoading: isLoading,
                  ),

                  const SizedBox(height: 8),

                  // Email notifications toggle
                  _buildSwitchTile(
                    title: AppLocalizations.of(context)!.emailNotifications,
                    subtitle:
                        AppLocalizations.of(context)!.emailNotificationsDesc,
                    value: (s['emailNotifications'] as bool?) ?? true,
                    onChanged: (value) {
                      _safeAddEvent(
                          context, UpdateEmailNotificationsEvent(enabled: value));
                    },
                    isLoading: isLoading,
                  ),

                  const SizedBox(height: 8),

                  // Booking reminders toggle
                  _buildSwitchTile(
                    title: AppLocalizations.of(context)!.bookingReminders,
                    subtitle:
                        AppLocalizations.of(context)!.bookingRemindersDesc,
                    value: (s['bookingReminders'] as bool?) ?? true,
                    onChanged: (value) {
                      _safeAddEvent(context,
                          UpdateBookingRemindersEvent(enabled: value));
                    },
                    isLoading: isLoading,
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Privacy settings
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppLocalizations.of(context)!.privacy,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Location services toggle
                  _buildSwitchTile(
                    title: AppLocalizations.of(context)!.locationServices,
                    subtitle:
                        AppLocalizations.of(context)!.locationServicesDesc,
                    value: (s['locationServices'] as bool?) ?? false,
                    onChanged: (value) {
                      _safeAddEvent(context,
                          UpdateLocationServicesEvent(enabled: value));
                    },
                    isLoading: isLoading,
                  ),

                  const SizedBox(height: 8),

                  // Data sharing toggle
                  _buildSwitchTile(
                    title: AppLocalizations.of(context)!.dataSharing,
                    subtitle: AppLocalizations.of(context)!.dataSharingDesc,
                    value: (s['dataSharing'] as bool?) ?? false,
                    onChanged: (value) {
                      _safeAddEvent(context,
                          UpdateDataSharingEvent(enabled: value));
                    },
                    isLoading: isLoading,
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // App preferences
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppLocalizations.of(context)!.preferences,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Language selection
                  ListTile(
                    title: Text(AppLocalizations.of(context)!.language),
                    subtitle: Text((s['language'] as String?) ?? 'English'),
                    trailing: const Icon(Icons.chevron_right),
          onTap: isLoading
            ? null
            : () {
              _showLanguageSelectionDialog(context,
                (s['language'] as String?) ?? 'English');
              },
                  ),

                  const Divider(height: 1),

                  // Currency selection
                  ListTile(
                    title: Text(AppLocalizations.of(context)!.currency),
                    subtitle: Text((s['currency'] as String?) ?? 'USD'),
                    trailing: const Icon(Icons.chevron_right),
          onTap: isLoading
            ? null
            : () {
              _showCurrencySelectionDialog(
                context, (s['currency'] as String?) ?? 'USD');
              },
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // About section
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.info),
                  title: Text(AppLocalizations.of(context)!.about),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    Navigator.pushNamed(context, AppRoutes.about);
                  },
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.help),
                  title: Text(AppLocalizations.of(context)!.helpSupport),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    Navigator.pushNamed(context, AppRoutes.help);
                  },
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.description),
                  title: Text(AppLocalizations.of(context)!.termsOfService),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    // Navigate to terms of service screen (not implemented yet)
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(AppLocalizations.of(context)!.comingSoon),
                      ),
                    );
                  },
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.privacy_tip),
                  title: Text(AppLocalizations.of(context)!.privacyPolicy),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    // Navigate to privacy policy screen (not implemented yet)
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(AppLocalizations.of(context)!.comingSoon),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSwitchTile({
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
    bool isLoading = false,
  }) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 8),
        Switch(
          value: value,
          onChanged: isLoading ? null : onChanged,
          activeColor: AppTheme.primaryColor,
        ),
      ],
    );
  }

  void _showLanguageSelectionDialog(
    BuildContext context,
    String currentLanguage,
  ) {
    final languages = [
      AppLocalizations.of(context)!.english,
      AppLocalizations.of(context)!.arabic,
      AppLocalizations.of(context)!.spanish,
      AppLocalizations.of(context)!.french,
      AppLocalizations.of(context)!.german,
    ];

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppLocalizations.of(context)!.selectLanguage),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: languages.length,
            itemBuilder: (context, index) {
              final language = languages[index];
              final isSelected = language == currentLanguage;

              return ListTile(
                title: Text(language),
                trailing: isSelected
                    ? Icon(
                        Icons.check,
                        color: AppTheme.primaryColor,
                      )
                    : null,
                onTap: () {
                  Navigator.pop(context);
                  _safeAddEvent(context,
                      UpdateLanguageEvent(language: language));
                },
              );
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text(AppLocalizations.of(context)!.cancel),
          ),
        ],
      ),
    );
  }

  void _showCurrencySelectionDialog(
    BuildContext context,
    String currentCurrency,
  ) {
    final currencies = ['USD', 'EUR', 'GBP', 'JPY', 'SAR', 'AED'];

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppLocalizations.of(context)!.selectCurrency),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: currencies.length,
            itemBuilder: (context, index) {
              final currency = currencies[index];
              final isSelected = currency == currentCurrency;

              return ListTile(
                title: Text(currency),
                trailing: isSelected
                    ? Icon(
                        Icons.check,
                        color: AppTheme.primaryColor,
                      )
                    : null,
                onTap: () {
                  Navigator.pop(context);
                  _safeAddEvent(context, UpdateCurrencyEvent(currency: currency));
                },
              );
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text(AppLocalizations.of(context)!.cancel),
          ),
        ],
      ),
    );
  }
}
