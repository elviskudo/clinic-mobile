import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../constants/sizes.dart';
import '../../features/auth/auth.dart';

part 'startup.g.dart';

@Riverpod(keepAlive: true)
Future<void> startup(StartupRef ref) async {
  // await for all initialization code to be complete before returning
  ref.onDispose(() {
    // ensure we invalidate all the providers we depend on
    ref.invalidate(isAuthenticatedProvider);
  });

  await ref.watch(isAuthenticatedProvider.future);
}

class AppStartupWidget extends ConsumerWidget {
  const AppStartupWidget({super.key, required this.onLoaded});

  final WidgetBuilder onLoaded;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(startupProvider);

    return state.when(
      data: (_) => onLoaded(context),
      loading: () => const AppStartupLoadingWidget(),
      error: (e, st) => AppStartupErrorWidget(
        message: e.toString(),
        onRetry: () {
          ref.invalidate(startupProvider);
        },
      ),
    );
  }
}

class AppStartupLoadingWidget extends StatelessWidget {
  const AppStartupLoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}

class AppStartupErrorWidget extends StatelessWidget {
  const AppStartupErrorWidget({
    super.key,
    required this.message,
    required this.onRetry,
  });

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              message,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            gapH16,
            OutlinedButton(
              onPressed: onRetry,
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }
}
