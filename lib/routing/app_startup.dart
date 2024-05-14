import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../features/theme/data/theme_mode_repo.dart';

part 'app_startup.g.dart';

@Riverpod(keepAlive: true)
Future<void> appStartup(AppStartupRef ref) async {
  // await for all initialization code to be complete before returning

  ref.onDispose(() {
    // ensure dependent providers are disposed as well
  });

  ref.read(themeModeProvider);
}
