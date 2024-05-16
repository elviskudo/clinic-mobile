import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:go_router/go_router.dart';

import '../screens/onboarding.dart';
import '../screens/signin.dart';
import '../screens/signup.dart';
import '../startup/startup.dart';
import '../widgets/app_startup.dart';

part 'router.g.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();

@riverpod
GoRouter router(RouterRef ref) {
  // rebuild GoRouter when app startup state changes
  final appStartupState = ref.watch(startupProvider);

  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    debugLogDiagnostics: true,
    redirect: (context, state) {
      // * If the app is still initializing, show the /startup route
      if (appStartupState.isLoading || appStartupState.hasError) {
        return '/startup';
      }
      return '/onboarding';
    },
    routes: [
      GoRoute(
        path: '/startup',
        pageBuilder: (context, state) => NoTransitionPage(
          child: AppStartupWidget(
            // * This is just a placeholder
            // * The loaded route will be managed by GoRouter on state change
            onLoaded: (_) => const SizedBox.shrink(),
          ),
        ),
      ),
      GoRoute(
        path: '/onboarding',
        name: 'onbarding',
        pageBuilder: (context, state) => const NoTransitionPage(
          child: OnboardingScreen(),
        ),
      ),
      GoRoute(
        path: '/signin',
        name: 'signin',
        pageBuilder: (context, state) => const NoTransitionPage(
          child: SignInScreen(),
        ),
      ),
      GoRoute(
        path: '/signup',
        name: 'signup',
        pageBuilder: (context, state) => const NoTransitionPage(
          child: SignUpScreen(),
        ),
      ),
    ],
  );
}
