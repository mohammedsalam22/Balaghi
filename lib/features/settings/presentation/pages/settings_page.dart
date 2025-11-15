import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/di/injection_container.dart' as di;
import '../../../../core/theme/theme_service.dart';
import '../../../../core/localization/localization_service.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../auth/presentation/cubit/auth/auth_cubit.dart';
import '../../../auth/presentation/cubit/auth/auth_state.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.settings),
        centerTitle: true,
        elevation: 0,
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            const SizedBox(height: 16),
            // Profile Section
            Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    const CircleAvatar(
                      radius: 30,
                      child: Icon(Icons.person, size: 30),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            l10n.user,
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'user@example.com',
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  color: Colors.grey[600],
                                ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.edit_outlined),
                      tooltip: l10n.editProfile,
                      onPressed: () {
                        // Handle edit profile
                      },
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            // Settings Options
            Card(
              elevation: 2,
              child: Column(
                children: [
                  ValueListenableBuilder<ThemeMode>(
                    valueListenable: di.sl<ThemeService>(),
                    builder: (context, themeMode, child) {
                      final themeService = di.sl<ThemeService>();
                      final l10n = AppLocalizations.of(context)!;
                      return ListTile(
                        leading: Icon(
                          themeMode == ThemeMode.dark
                              ? Icons.dark_mode
                              : themeMode == ThemeMode.light
                                  ? Icons.light_mode
                                  : Icons.brightness_auto,
                        ),
                        title: Text(l10n.theme),
                        subtitle: Text(themeService.getThemeModeLabel(themeMode)),
                        trailing: const Icon(Icons.chevron_left),
                        onTap: () {
                          _showThemeDialog(context, themeService);
                        },
                      );
                    },
                  ),
                  const Divider(height: 1),
                  ValueListenableBuilder<Locale>(
                    valueListenable: di.sl<LocalizationService>(),
                    builder: (context, locale, child) {
                      final localizationService = di.sl<LocalizationService>();
                      return ListTile(
                        leading: const Icon(Icons.language_outlined),
                        title: Text(AppLocalizations.of(context)!.language),
                        subtitle: Text(localizationService.getLanguageLabel(locale)),
                        trailing: const Icon(Icons.chevron_left),
                        onTap: () {
                          _showLanguageDialog(context, localizationService);
                        },
                      );
                    },
                  ),
                  const Divider(height: 1),
                  Builder(
                    builder: (context) {
                      final l10n = AppLocalizations.of(context)!;
                      return ListTile(
                        leading: const Icon(Icons.notifications_outlined),
                        title: Text(l10n.notifications),
                        subtitle: Text(l10n.manageNotifications),
                        trailing: const Icon(Icons.chevron_left),
                        onTap: () {
                          // Handle notifications
                        },
                      );
                    },
                  ),
                  const Divider(height: 1),
                  Builder(
                    builder: (context) {
                      final l10n = AppLocalizations.of(context)!;
                      return ListTile(
                        leading: const Icon(Icons.security_outlined),
                        title: Text(l10n.security),
                        subtitle: Text(l10n.securityAndPrivacy),
                        trailing: const Icon(Icons.chevron_left),
                        onTap: () {
                          // Handle security
                        },
                      );
                    },
                  ),
                  const Divider(height: 1),
                  Builder(
                    builder: (context) {
                      final l10n = AppLocalizations.of(context)!;
                      return ListTile(
                        leading: const Icon(Icons.help_outline),
                        title: Text(l10n.help),
                        subtitle: Text(l10n.faqAndSupport),
                        trailing: const Icon(Icons.chevron_left),
                        onTap: () {
                          // Handle help
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            // Logout Button
            BlocListener<AuthCubit, AuthState>(
              listener: (context, state) {
                if (state is AuthUnauthenticated) {
                  // Navigation will be handled by main.dart
                }
              },
              child: Builder(
                builder: (context) {
                  final l10n = AppLocalizations.of(context)!;
                  return Card(
                    elevation: 2,
                    color: Colors.red.shade50,
                    child: ListTile(
                      leading: Icon(Icons.logout, color: Colors.red[700]),
                      title: Text(
                        l10n.logout,
                        style: TextStyle(
                          color: Colors.red[700],
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      onTap: () {
                        _showLogoutDialog(context);
                      },
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  void _showLanguageDialog(BuildContext context, LocalizationService localizationService) {
    final l10n = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return ValueListenableBuilder<Locale>(
          valueListenable: localizationService,
          builder: (context, currentLocale, child) {
            return AlertDialog(
              title: Text(l10n.selectLanguage),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  RadioListTile<Locale>(
                    title: const Text('العربية'),
                    value: const Locale('ar'),
                    groupValue: currentLocale,
                    onChanged: (Locale? value) {
                      if (value != null) {
                        localizationService.setLanguage(value);
                        Navigator.of(dialogContext).pop();
                      }
                    },
                  ),
                  RadioListTile<Locale>(
                    title: const Text('English'),
                    value: const Locale('en'),
                    groupValue: currentLocale,
                    onChanged: (Locale? value) {
                      if (value != null) {
                        localizationService.setLanguage(value);
                        Navigator.of(dialogContext).pop();
                      }
                    },
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(dialogContext).pop();
                  },
                  child: Text(l10n.cancel),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showThemeDialog(BuildContext context, ThemeService themeService) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return ValueListenableBuilder<ThemeMode>(
          valueListenable: themeService,
          builder: (context, currentTheme, child) {
            final l10n = AppLocalizations.of(context)!;
            return AlertDialog(
              title: Text(l10n.selectTheme),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  RadioListTile<ThemeMode>(
                    title: Text(l10n.light),
                    value: ThemeMode.light,
                    groupValue: currentTheme,
                    onChanged: (ThemeMode? value) {
                      if (value != null) {
                        themeService.setThemeMode(value);
                        Navigator.of(dialogContext).pop();
                      }
                    },
                  ),
                  RadioListTile<ThemeMode>(
                    title: Text(l10n.dark),
                    value: ThemeMode.dark,
                    groupValue: currentTheme,
                    onChanged: (ThemeMode? value) {
                      if (value != null) {
                        themeService.setThemeMode(value);
                        Navigator.of(dialogContext).pop();
                      }
                    },
                  ),
                  RadioListTile<ThemeMode>(
                    title: Text(l10n.auto),
                    value: ThemeMode.system,
                    groupValue: currentTheme,
                    onChanged: (ThemeMode? value) {
                      if (value != null) {
                        themeService.setThemeMode(value);
                        Navigator.of(dialogContext).pop();
                      }
                    },
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(dialogContext).pop();
                  },
                  child: Text(l10n.cancel),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showLogoutDialog(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text(l10n.logoutConfirmation),
          content: Text(l10n.logoutMessage),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
              child: Text(l10n.cancel),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
                context.read<AuthCubit>().logout();
              },
              child: Text(
                l10n.logout,
                style: const TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }
}

