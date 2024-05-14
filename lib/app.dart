import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'constants/theme.dart';
import 'features/theme/data/theme_mode_repo.dart';
import 'routing/app_router.dart';

class MainApp extends ConsumerWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final goRouter = ref.watch(goRouterProvider);
    final themeMode = ref.watch(themeModeProvider).mode;

    return MaterialApp.router(
      routerConfig: goRouter,
      title: 'Clinic',
      debugShowCheckedModeBanner: false,
      theme: MaterialTheme(Theme.of(context).textTheme).light(),
      darkTheme: MaterialTheme(Theme.of(context).textTheme).dark(),
      themeMode: themeMode,
    );
  }
}
