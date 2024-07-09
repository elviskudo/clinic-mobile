import 'package:clinic/constants/sizes.dart';
import 'package:clinic/features/auth/auth_dto.dart';
import 'package:clinic/features/auth/auth_repo.dart';
import 'package:clinic/widgets/scaffold_busy.dart';
import 'package:dio/dio.dart';
import 'package:fl_query/fl_query.dart';
import 'package:fl_query_hooks/fl_query_hooks.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';

class RootLayout extends HookWidget {
  const RootLayout({super.key});

  @override
  Widget build(BuildContext context) {
    final query = useQuery<AuthDTO?, DioException>(
      'auth_cred',
      () async => await AuthRepository().getCredential(),
      onData: (cred) {
        context.go(cred == null ? '/onboarding' : '/home');
      },
      onError: (e) {
        debugPrint('$e');
      },
    );

    if (query.isLoading) return const ScaffoldBusy();
    if (query.hasError && query.error?.response?.statusCode == 500) {
      return _AuthGuardError(query: query);
    }

    return Scaffold(
      body: Center(
        child: Image.asset(
          'assets/launcher/foreground.png',
          height: 96,
          filterQuality: FilterQuality.high,
        ),
      ),
    );
  }
}

class _AuthGuardError extends StatelessWidget {
  const _AuthGuardError({required this.query});

  final Query<AuthDTO?, dynamic> query;

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
              onPressed: () async {
                await query.refresh();
              },
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }
}
