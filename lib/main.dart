import 'package:clinic/generated/codegen_loader.g.dart';
import 'package:clinic/widgets/network_observer.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:fl_query/fl_query.dart';
import 'package:fl_query_connectivity_plus_adapter/fl_query_connectivity_plus_adapter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'constants/theme.dart';
import 'hooks/use_dark_mode.dart';
import 'router.dart';
import 'services/kv.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await EasyLocalization.ensureInitialized();
  await KV.initialize();
  await QueryClient.initialize(
    cachePrefix: 'clinic_fl_query',
    connectivity: FlQueryConnectivityPlusAdapter(
      pollingDuration: const Duration(seconds: 10),
    ),
  );

  runApp(
    ProviderScope(
      child: EasyLocalization(
        supportedLocales: const [Locale('en'), Locale('id')],
        path: 'assets/translations',
        fallbackLocale: const Locale('en'),
        useOnlyLangCode: true,
        assetLoader: const CodegenLoader(),
        child: QueryClientProvider(
          child: const ClinicApp(),
        ),
      ),
    ),
  );
}

class ClinicApp extends HookConsumerWidget {
  const ClinicApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDarkMode = useDarkMode().state;

    SystemChrome.setSystemUIOverlayStyle(
      isDarkMode ? SystemUiOverlayStyle.light : SystemUiOverlayStyle.dark,
    );

    final router = ref.watch(routerProvider);

    return MaterialApp.router(
      title: 'Clinic',
      debugShowCheckedModeBanner: false,
      routerConfig: router,
      theme: MaterialTheme(Theme.of(context).textTheme).light(),
      darkTheme: MaterialTheme(Theme.of(context).textTheme).dark(),
      themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light,
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      builder: (context, child) => NetworkObserver(child: child!),
    );
  }
}
