import 'package:clinic/features/auth/auth.dart';
import 'package:clinic/ui/container/error.dart';
import 'package:clinic/ui/container/splash.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rearch/flutter_rearch.dart';
import 'package:go_router/go_router.dart';
import 'package:rearch/rearch.dart';

import 'auth/auth_router.dart' as auth;
import 'dash/dash_router.dart' as dash;

part 'index_router.g.dart';

@TypedGoRoute<RootRoute>(path: '/')
class RootRoute extends GoRouteData {
  const RootRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const _RootLayout();
  }
}

class _RootLayout extends RearchConsumer {
  const _RootLayout();

  @override
  Widget build(BuildContext context, WidgetHandle use) {
    final (cred, _) = use(cred$);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (cred case AsyncData(:final data)) {
        if (data == null || !data.isVerified) {
          const auth.OnboardingRoute().go(context);
        } else {
          const dash.HomeRoute().go(context);
        }
      }
    });

    return switch (cred) {
      AsyncData() => const PlaceholderScaffold(),
      AsyncError(:final error) => ErrorScaffold(error: error),
      AsyncLoading() => const PlaceholderScaffold(),
    };
  }
}
