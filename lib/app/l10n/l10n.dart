import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../drivers/local_storage.dart';

part 'l10n.g.dart';

@Riverpod(keepAlive: true)
class AppLocale extends _$AppLocale {
  @override
  FutureOr<Locale> build() {
    return ref.read(sharedStorageProvider.future).then((prefs) {
      final systemLang = lookupAppLocalizations(
        basicLocaleListResolution(
          [WidgetsBinding.instance.platformDispatcher.locale],
          AppLocalizations.supportedLocales,
        ),
      );
      final lang = prefs.getString('app_locale') ?? systemLang.localeName;

      return Locale(lang);
    });
  }

  void setLocale(Locale locale) async {
    assert(locale.languageCode == 'id' || locale.languageCode == 'en');
    await ref
        .read(sharedStorageProvider)
        .requireValue
        .setString('app_locale', locale.languageCode);
    state = AsyncData(locale);
  }
}
