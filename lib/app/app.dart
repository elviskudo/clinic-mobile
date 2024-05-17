import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../l10n/l10n.dart';
import '../theme/theme.dart';
import 'router/router.dart';

class MainApp extends ConsumerWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final routerConfig = ref.watch(routerProvider);
    final themeMode = ref.watch(appThemeProvider);
    final locale = ref.watch(appLocaleProvider);

    return MaterialApp.router(
      routerConfig: routerConfig,
      title: 'Clinic',
      restorationScopeId: 'app',
      theme: MaterialTheme(Theme.of(context).textTheme).light(),
      darkTheme: MaterialTheme(Theme.of(context).textTheme).dark(),
      themeMode: themeMode,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: locale,
      debugShowCheckedModeBanner: false,
    );
  }
}
