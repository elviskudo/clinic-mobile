import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:native_toast/native_toast.dart';

import '../l10n/generated/l10n.dart';
import '../theme/theme.dart';
import 'l10n/l10n.dart';
import 'router.dart';
import 'di/locator.dart';

final messengerKey = GlobalKey<ScaffoldMessengerState>();

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (ctx) => locator<AppTheme>()),
        ChangeNotifierProvider(create: (ctx) => locator<AppL10n>()),
        StreamProvider<ConnectivityResult>(
          create: (ctx) => locator<Connectivity>().onConnectivityChanged,
          initialData: ConnectivityResult.mobile,
        )
      ],
      builder: (context, child) => MaterialApp.router(
        title: 'Clinic',
        debugShowCheckedModeBanner: false,
        routerConfig: goRouter,
        scaffoldMessengerKey: messengerKey,
        theme: MaterialTheme(Theme.of(context).textTheme).light(),
        darkTheme: MaterialTheme(Theme.of(context).textTheme).dark(),
        themeMode: context.watch<AppTheme>().mode,
        localizationsDelegates: const [
          S.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: S.delegate.supportedLocales,
        locale: context.watch<AppL10n>().locale,
        builder: (context, child) {
          final state = context.watch<ConnectivityResult>();

          if (state != ConnectivityResult.mobile &&
              state != ConnectivityResult.wifi) {
            NativeToast().makeText(
              message: S.of(context).offline,
              duration: NativeToast.shortLength,
            );
          }
          return child!;
        },
      ),
    );
  }
}
