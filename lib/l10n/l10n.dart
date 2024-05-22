import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../drivers/local_storage.dart';
import 'generated/l10n.dart';

part 'l10n.g.dart';

@riverpod
class AppLocale extends _$AppLocale {
  @override
  Locale build() {
    final currentLocale = Locale(
        ref.read(sharedStorageProvider).getString('app_locale') ??
            Intl.getCurrentLocale());

    _loadLocale(currentLocale);

    return currentLocale;
  }

  void setLocale(Locale locale) async {
    assert(locale.languageCode == 'id' || locale.languageCode == 'en');

    _loadLocale(locale);
    await ref
        .read(sharedStorageProvider)
        .setString('app_locale', locale.languageCode);

    state = locale;
  }

  void _loadLocale(Locale locale) async {
    await S.load(locale);
  }
}
