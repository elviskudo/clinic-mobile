import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../features/onboarding/data/onboarding_repo.dart';
import '../screens/onboarding.dart';
import '../screens/signin.dart';
import '../screens/signup.dart';
import '../startup/startup.dart';

part 'router.g.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();

@riverpod
GoRouter router(RouterRef ref) {
  // rebuild GoRouter when app startup state changes
  final appStartupState = ref.watch(startupProvider);
  final onboardingState = ref.watch(onboardingRepositoryProvider);

  final initialLocation = appStartupState.isLoading || appStartupState.hasError
      ? '/'
      : onboardingState.requireValue
          ? '/onboarding'
          : '/auth/signin';

  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    debugLogDiagnostics: true,
    initialLocation: initialLocation,
    routes: [
      GoRoute(
        path: '/',
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
        pageBuilder: (context, state) => const MaterialPage(
          child: OnboardingScreen(),
        ),
      ),
      GoRoute(
        path: '/auth/signin',
        name: 'signin',
        pageBuilder: (context, state) => const MaterialPage(
          child: SignInScreen(),
        ),
      ),
      GoRoute(
        path: '/auth/signup',
        name: 'signup',
        pageBuilder: (context, state) => const MaterialPage(
          child: SignUpScreen(),
        ),
      ),
    ],
  );
}
