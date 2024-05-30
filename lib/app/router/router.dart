import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../features/auth/auth.dart';
import '../screens/onboarding.dart';
import '../screens/signin.dart';
import '../screens/signup.dart';
import '../screens/verification.dart';
import '../startup/startup.dart';

part 'router.g.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();

@riverpod
GoRouter router(RouterRef ref) {
  // rebuild GoRouter when app startup state changes
  final startup = ref.watch(startupProvider);

  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    debugLogDiagnostics: true,
    redirect: (context, state) {
      if (startup.isLoading || startup.hasError) return '/';

      final path = state.uri.path;

      final authCred = ref.watch(authControllerProvider).requireValue;
      final isAuthenticated = authCred != null ? authCred.isVerified : false;

      if (!isAuthenticated) {
        if (path == '/' || path.startsWith('/app')) {
          if (authCred != null && !authCred.isVerified) {
            return '/auth/verification';
          }

          return path.startsWith('/auth') ? path : '/onboarding';
        }
      } else {
        return path == '/' || path.startsWith('/auth') ? '/app' : path;
      }

      return null;
    },
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
      GoRoute(
        path: '/auth/verification',
        name: 'verification',
        pageBuilder: (context, state) => const MaterialPage(
          child: VerificationScreen(),
        ),
      ),
    ],
  );
}
