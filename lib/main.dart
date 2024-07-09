import 'package:clinic/generated/codegen_loader.g.dart';
import 'package:clinic/widgets/network_observer.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:fl_query/fl_query.dart';
import 'package:fl_query_connectivity_plus_adapter/fl_query_connectivity_plus_adapter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'router.dart';
import 'services/kv.dart';
import 'services/theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await EasyLocalization.ensureInitialized();
  await KV.initialize();
  await QueryClient.initialize(
    cachePrefix: 'clinic_fl_query',
    connectivity: FlQueryConnectivityPlusAdapter(
      pollingDuration: const Duration(seconds: 5),
    ),
  );

  runApp(
    ProviderScope(
      child: EasyLocalization(
        supportedLocales: const [Locale('en'), Locale('id')],
        path: 'assets/translations',
        useOnlyLangCode: true,
        fallbackLocale: const Locale('en'),
        assetLoader: const CodegenLoader(),
        child: QueryClientProvider(
          child: const ClinicAI(),
        ),
      ),
    ),
  );
}

class ClinicAI extends HookConsumerWidget {
  const ClinicAI({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDarkMode = useDarkMode().state;
    final router = ref.watch(routerProvider);

    SystemChrome.setSystemUIOverlayStyle(
      isDarkMode ? SystemUiOverlayStyle.light : SystemUiOverlayStyle.dark,
    );

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
