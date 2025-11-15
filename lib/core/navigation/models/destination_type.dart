import '../../../../l10n/app_localizations.dart';

/// Enum representing different navigation destination types
/// Used for localization and type-safe navigation
enum DestinationType {
  home,
  reports,
  status,
  settings,
}

extension DestinationTypeExtension on DestinationType {
  /// Get localized label for the destination
  String getLabel(AppLocalizations l10n) {
    switch (this) {
      case DestinationType.home:
        return l10n.home;
      case DestinationType.reports:
        return l10n.reports;
      case DestinationType.status:
        return l10n.status;
      case DestinationType.settings:
        return l10n.settings;
    }
  }
}

