import 'package:fl_query/fl_query.dart';
import 'package:fl_query_hooks/fl_query_hooks.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';

import '../../../../constants/sizes.dart';
import '../../../../di/locator.dart';
import '../../../../widgets/scaffold_busy.dart';
import '../../data/auth_repo.dart';
import '../../models/profile/profile.dart';

class AuthGuard extends HookWidget {
  const AuthGuard({super.key});

  @override
  Widget build(BuildContext context) {
    final query = useQuery<Profile?, dynamic>(
      'profile',
      () => locator.get<AuthRepository>().getCurrentProfile(),
      onData: (profile) {
        if (profile == null) {
          context.go('/onboarding');
        } else if (!(profile.isVerified)) {
          context.go('/auth/verification');
          locator.get<AuthRepository>().resendOtp();
        } else {
          context.go('/app/home');
        }
      },
    );

    if (query.isLoading) return const ScaffoldBusy();
    if (query.hasError) return _AuthGuardError(query: query);

    return const SizedBox.shrink();
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
