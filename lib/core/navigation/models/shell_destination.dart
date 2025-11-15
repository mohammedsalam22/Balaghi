import 'package:flutter/material.dart';
import 'destination_type.dart';
import '../../../../l10n/app_localizations.dart';

/// Represents a navigation destination in the adaptive shell
class ShellDestination {
  final IconData icon;
  final IconData? selectedIcon;
  final DestinationType label;
  final Widget screen;

  const ShellDestination({
    required this.icon,
    this.selectedIcon,
    required this.label,
    required this.screen,
  });

  /// Get the localized label text
  String getLabelText(AppLocalizations l10n) {
    return label.getLabel(l10n);
  }
}

