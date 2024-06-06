import 'package:clinic/constants/sizes.dart';
import 'package:clinic/data/queries/profile.dart';
import 'package:clinic/models/profile/profile.dart';
import 'package:clinic/widgets/scaffold_busy.dart';
import 'package:fl_query/fl_query.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';

class AuthGuard extends HookWidget {
  const AuthGuard({super.key});

  @override
  Widget build(BuildContext context) {
    final query = useProfileQuery(
      onData: (profile) {
        if (profile != null) {
          profile.isVerified
              ? context.go('/home')
              : context.go('/verification');
        } else {
          context.go('/onboarding');
        }
      },
      onError: (e) {
        if (e.response?.statusCode == 400) {
          context.go('/verification');
        } else if (e.response?.statusCode == 401) {
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
