import 'package:flutter/material.dart';
import '../../features/home/presentation/pages/home_page.dart';
import '../../features/reports/presentation/pages/reports_page.dart';
import '../../features/status/presentation/pages/status_page.dart';
import '../../features/settings/presentation/pages/settings_page.dart';
import '../../l10n/app_localizations.dart';
import 'adaptive_shell.dart';
import 'models/shell_destination.dart';
import 'models/destination_type.dart';

class MainNavigation extends StatelessWidget {
  const MainNavigation({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return AdaptiveShell(
      title: l10n.complaints, // Home page now shows complaints
      destinations: [
        ShellDestination(
          icon: Icons.home_outlined,
          selectedIcon: Icons.home_rounded,
          label: DestinationType.home,
          screen: const HomePage(),
        ),
        ShellDestination(
          icon: Icons.description_outlined,
          selectedIcon: Icons.description_rounded,
          label: DestinationType.reports,
          screen: const ReportsPage(),
        ),
        ShellDestination(
          icon: Icons.info_outlined,
          selectedIcon: Icons.info_rounded,
          label: DestinationType.status,
          screen: const StatusPage(),
        ),
        ShellDestination(
          icon: Icons.settings_outlined,
          selectedIcon: Icons.settings_rounded,
          label: DestinationType.settings,
          screen: const SettingsPage(),
        ),
      ],
      quickActions: const [],
      actions: const [],
    );
  }
}

