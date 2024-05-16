import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../theme/theme.dart';

part 'startup.g.dart';

@Riverpod(keepAlive: true)
Future<void> startup(StartupRef ref) async {
  // await for all initialization code to be complete before returning
  ref.onDispose(() {
    // ensure we invalidate all the providers we depend on
    ref.invalidate(appThemeProvider);
  });

  await ref.watch(appThemeProvider.future);
}
