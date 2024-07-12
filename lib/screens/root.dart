import 'package:auto_route/auto_route.dart';
import 'package:clinic/app_router.gr.dart';
import 'package:clinic/features/auth/auth.dart';
import 'package:fl_query_hooks/fl_query_hooks.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

@RoutePage()
class RootScreen extends HookWidget {
  const RootScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final q = useQuery<Credential?, dynamic>(
      'auth_credential',
      () async => auth$.read(context).refresh(),
      onData: (data) => context.replaceRoute(
        data != null || (data?.isVerified ?? false)
            ? const DashboardRoute()
            : const OnboardingRoute(),
      ),
      onError: (_) => context.replaceRoute(const OnboardingRoute()),
    );

    if (q.isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return const _StartupPlaceholder();
  }
}

class _StartupPlaceholder extends StatelessWidget {
  const _StartupPlaceholder();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image.asset(
          'assets/images/clinic_ai.png',
          width: 80,
          height: 80,
          filterQuality: FilterQuality.high,
        ),
      ),
    );
  }
}
