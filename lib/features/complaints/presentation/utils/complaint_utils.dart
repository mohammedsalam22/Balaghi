import 'package:flutter/material.dart';
import '../../../../l10n/app_localizations.dart';

class ComplaintUtils {
  static Color getStatusColor(int status) {
    switch (status) {
      case 0:
        return Colors.blue;
      case 1:
        return Colors.orange;
      case 2:
        return Colors.green;
      case 3:
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  static String getStatusText(AppLocalizations l10n, int status) {
    switch (status) {
      case 0:
        return l10n.statusNew;
      case 1:
        return l10n.statusInProgress;
      case 2:
        return l10n.statusDone;
      case 3:
        return l10n.statusRejected;
      default:
        return '';
    }
  }

  static IconData getStatusIcon(int status) {
    switch (status) {
      case 0:
        return Icons.new_releases;
      case 1:
        return Icons.hourglass_empty;
      case 2:
        return Icons.check_circle;
      case 3:
        return Icons.cancel;
      default:
        return Icons.help_outline;
    }
  }
}
