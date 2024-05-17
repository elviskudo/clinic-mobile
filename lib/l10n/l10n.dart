import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../drivers/local_storage.dart';

part 'l10n.g.dart';

@riverpod
class AppLocale extends _$AppLocale {
  @override
  Locale build() {
    final lang = ref.watch(sharedStorageProvider).getString('app_locale') ??
        lookupAppLocalizations(
          basicLocaleListResolution(
            [WidgetsBinding.instance.platformDispatcher.locale],
            AppLocalizations.supportedLocales,
          ),
        ).localeName;

    return Locale(lang);
  }

  void setLocale(Locale locale) async {
    assert(locale.languageCode == 'id' || locale.languageCode == 'en');
    await ref
        .read(sharedStorageProvider)
        .setString('app_locale', locale.languageCode);
    state = locale;
  }
}
