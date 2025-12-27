import 'package:flutter/material.dart';
import '../../../../l10n/app_localizations.dart';

class ValidationUtils {
  static String? emailValidator(String? value, AppLocalizations? l10n) {
    if (value == null || value.trim().isEmpty) {
      return l10n?.emailRequired ?? 'Email is required';
    }
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    if (!emailRegex.hasMatch(value.trim())) {
      return l10n?.emailInvalid ?? 'Please enter a valid email address';
    }
    return null;
  }

  static String? passwordValidator(String? value, AppLocalizations? l10n) {
    if (value == null || value.isEmpty) {
      return l10n?.passwordRequired ?? 'Password is required';
    }
    return null;
  }
}
