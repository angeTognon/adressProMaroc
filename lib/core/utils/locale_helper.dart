import 'package:flutter/material.dart';
import '../locale/app_localizations.dart';

class LocaleHelper {
  static String t(BuildContext context, String key) {
    final localizations = AppLocalizations.of(context);
    return localizations?.translate(key) ?? key;
  }

  static bool isRTL(BuildContext context) {
    final locale = Localizations.localeOf(context);
    return locale.languageCode == 'ar';
  }

  static bool isArabic(BuildContext context) {
    final locale = Localizations.localeOf(context);
    return locale.languageCode == 'ar';
  }

  static bool isDarija(BuildContext context) {
    final locale = Localizations.localeOf(context);
    return locale.languageCode == 'fr' && locale.countryCode == 'MA';
  }
}

