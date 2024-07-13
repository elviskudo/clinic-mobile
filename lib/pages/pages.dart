import 'package:clinic/features/auth/auth.dart';
import 'package:clinic/ui/container/error.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:rearch/rearch.dart';

import 'auth/auth_router.dart' as auth;
import 'dash/dash_route.dart' as dash;
import 'index_router.dart' as root;

final rootNavKey = GlobalKey<NavigatorState>();

GoRouter router(CapsuleHandle use) {
  return GoRouter(
    routes: [...root.$appRoutes, ...auth.$appRoutes, ...dash.$appRoutes],
    navigatorKey: rootNavKey,
    initialLocation: '/',
    errorBuilder: (c, s) => ErrorScaffold(error: s.error!),
    redirect: (context, state) async {
      return switch (await use(fetchCredential)) {
        null => state.matchedLocation.startsWith('/app')
            ? auth.OnboardingRoute().location
            : state.matchedLocation,
        Credential(:final isVerified) => isVerified
            ? dash.HomeRoute().location
            : auth.OnboardingRoute().location,
      };
    },
  );
}
