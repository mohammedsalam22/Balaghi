import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalizationService extends ValueNotifier<Locale> {
  static const String _languageKey = 'language_code';
  final SharedPreferences _prefs;
  bool _isInitialized = false;

  LocalizationService(this._prefs) : super(const Locale('ar')); // Default to Arabic

  /// Initialize and load language from SharedPreferences
  Future<void> init() async {
    if (_isInitialized) return;
    try {
      final languageCode = _prefs.getString(_languageKey);
      if (languageCode != null && (languageCode == 'ar' || languageCode == 'en')) {
        value = Locale(languageCode);
      } else {
        // Default to Arabic or system locale
        value = const Locale('ar');
      }
      _isInitialized = true;
    } catch (e) {
      // If loading fails, use default
      value = const Locale('ar');
      _isInitialized = true;
    }
  }

  Future<void> setLanguage(Locale locale) async {
    try {
      value = locale;
      await _prefs.setString(_languageKey, locale.languageCode);
    } catch (e) {
      // If saving fails, at least update the value for current session
      value = locale;
    }
  }

  String getLanguageLabel(Locale locale) {
    switch (locale.languageCode) {
      case 'ar':
        return 'العربية';
      case 'en':
        return 'English';
      default:
        return 'العربية';
    }
  }

  List<Locale> get supportedLocales => const [
        Locale('ar'),
        Locale('en'),
      ];
}

