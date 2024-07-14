import 'package:clinic/features/auth/auth.dart';
import 'package:clinic/ui/container/error.dart';
import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:rearch/rearch.dart';

import 'auth/auth_router.dart' as auth;
import 'dash/dash_router.dart' as dash;
import 'index_router.dart' as root;

final rootNavKey = GlobalKey<NavigatorState>();

GoRouter router(CapsuleHandle use) {
  final (cred, _) = use(cred$);

  return GoRouter(
    routes: [...root.$appRoutes, ...auth.$appRoutes, ...dash.$appRoutes],
    navigatorKey: rootNavKey,
    debugLogDiagnostics: true,
    initialLocation: switch (cred) {
      AsyncData(:final data) => data == null
          ? const auth.OnboardingRoute().location
          : data.isVerified
              ? const dash.HomeRoute().location
              : const auth.VerificationRoute(shouldRequest: true).location,
      _ => '/',
    },
    errorBuilder: (c, s) => ErrorScaffold(error: s.error!),
  );
}

class CupertinoPage extends CustomTransitionPage {
  CupertinoPage({super.key, required super.child})
      : super(
          transitionsBuilder: (
            context,
            primaryRouteAnimation,
            secondaryRouteAnimation,
            child,
          ) {
            return CupertinoPageTransition(
              primaryRouteAnimation: primaryRouteAnimation,
              secondaryRouteAnimation: secondaryRouteAnimation,
              linearTransition: false,
              child: child,
            );
          },
        );
}
