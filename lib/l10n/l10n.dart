import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'generated/l10n.dart';

@Injectable()
@lazySingleton
class AppL10n with ChangeNotifier {
  late Locale _locale;
  final SharedPreferences _prefs;

  AppL10n({required SharedPreferences prefs}) : _prefs = prefs {
    final storedLocale =
        Locale(_prefs.getString('app_locale') ?? Intl.getCurrentLocale());

    _load(storedLocale);
    _locale = storedLocale;
  }

  Locale get locale => _locale;

  void set(Locale locale) async {
    assert(locale.languageCode == 'id' || locale.languageCode == 'en');

    _load(locale);
    await _prefs.setString('app_locale', locale.languageCode);

    _locale = locale;
    notifyListeners();
  }

  void _load(Locale locale) async {
    await S.load(locale);
  }
}
