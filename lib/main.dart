import 'package:easy_localization/easy_localization.dart';
import 'package:fl_query/fl_query.dart';
import 'package:fl_query_connectivity_plus_adapter/fl_query_connectivity_plus_adapter.dart';
import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:state_beacon/state_beacon.dart';
import 'package:toastification/toastification.dart';

import 'app_router.dart';
import 'services/isar.dart';
import 'services/theme.dart';
import 'ui/network_observer.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await EasyLocalization.ensureInitialized();
  final isarStore = await openIsar();

  await QueryClient.initialize(
    cachePrefix: 'clinic_fl_query',
    connectivity: FlQueryConnectivityPlusAdapter(
      pollingDuration: const Duration(seconds: 5),
    ),
  );

  runApp(
    EasyLocalization(
      path: 'i18n',
      supportedLocales: const [
        Locale('id'),
        Locale('en'),
      ],
      fallbackLocale: const Locale('id'),
      useOnlyLangCode: true,
      child: LiteRefScope(
        overrides: {
          isar.overrideWith((ctx) => isarStore),
        },
        child: QueryClientProvider(
          refreshOnMount: false,
          child: const ClinicAI(),
        ),
      ),
    ),
  );
}

class ClinicAI extends StatelessWidget {
  const ClinicAI({super.key});

  @override
  Widget build(BuildContext context) {
    final light = MaterialTheme(Theme.of(context).textTheme).light();
    final dark = MaterialTheme(Theme.of(context).textTheme).dark();

    final themeMode = theme$.select(context, (t) => t.theme);

    return SkeletonizerConfig(
      data: SkeletonizerConfigData(
        effect: ShimmerEffect(
          baseColor: themeMode == ThemeMode.dark
              ? dark.colorScheme.outlineVariant
              : light.colorScheme.outlineVariant,
        ),
      ),
      child: ToastificationWrapper(
        child: MaterialApp.router(
          routerConfig: router.read(context).config(),
          title: 'Clinic AI',
          debugShowCheckedModeBanner: false,
          theme: light,
          darkTheme: dark,
          themeMode: themeMode,
          localizationsDelegates: context.localizationDelegates,
          supportedLocales: context.supportedLocales,
          locale: context.locale,
          builder: (context, child) {
            return ToastificationConfigProvider(
              config: const ToastificationConfig(
                alignment: Alignment.bottomCenter,
                animationDuration: Duration(milliseconds: 500),
              ),
              child: NetworkObserver(child: child!),
            );
          },
        ),
      ),
    );
  }
}
