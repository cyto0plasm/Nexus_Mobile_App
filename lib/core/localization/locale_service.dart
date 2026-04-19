import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocaleService {
  static const _key = 'app_locale';
  static const _firstOpenKey = 'first_open_done';

  /// Call once at app startup.
  /// - First open → detect phone language, save it, return it
  /// - Returning user → return their saved preference
  static Future<Locale> resolveLocale() async {
    final prefs = await SharedPreferences.getInstance();
    final isFirstOpen = !(prefs.getBool(_firstOpenKey) ?? false);

    if (isFirstOpen) {
      await prefs.setBool(_firstOpenKey, true);

      // Get phone's system language
      final systemLocale = WidgetsBinding.instance.platformDispatcher.locale;
      final code = systemLocale.languageCode;

      // Only use it if we actually support that language
      final supported = ['en', 'ar'];
      final resolved = supported.contains(code) ? code : 'en';

      await prefs.setString(_key, resolved);
      return Locale(resolved);
    }

    final saved = prefs.getString(_key) ?? 'en';
    return Locale(saved);
  }
}