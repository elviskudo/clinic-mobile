import 'package:clinic/constants/sizes.dart';
import 'package:clinic/features/auth/auth.dart';
import 'package:clinic/widgets/scaffold_busy.dart';
import 'package:fl_query/fl_query.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class StartupObserver extends HookConsumerWidget {
  const StartupObserver({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final query = useAccountQuery(
      context,
      ref,
      onData: (profile) {
        if (profile != null) {
          profile.isVerified
              ? context.go('/home')
              : context.go('/verification');
        } else {
          context.go('/onboarding');
        }
      },
    );

    if (query.isLoading) return const ScaffoldBusy();
    if (query.hasError && query.error?.response?.statusCode == 500) {
      return _AuthGuardError(query: query);
    }

    return const Scaffold();
  }
}

class _AuthGuardError extends StatelessWidget {
  const _AuthGuardError({required this.query});

  final Query<Account?, dynamic> query;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('${query.error}'),
            gapH8,
            OutlinedButton(
              onPressed: () {
                query.refresh();
              },
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }
}
