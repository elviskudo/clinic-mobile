import 'package:clinic/constants/sizes.dart';
import 'package:clinic/data/queries/profile.dart';
import 'package:clinic/models/profile/profile.dart';
import 'package:clinic/widgets/scaffold_busy.dart';
import 'package:fl_query/fl_query.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class AuthGuard extends HookConsumerWidget {
  const AuthGuard({super.key, this.child});

  /// This widget will render if [useProfile] query is successful.
  final Widget? child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final query = useProfile(ref);

    if (query.isLoading) return const ScaffoldBusy();
    if (query.hasError && query.error?.response?.statusCode == 500) {
      return _AuthGuardError(query: query);
    }

    return child ?? const SizedBox.shrink();
  }
}

class _AuthGuardError extends StatelessWidget {
  const _AuthGuardError({required this.query});

  final Query<Profile?, dynamic> query;

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
