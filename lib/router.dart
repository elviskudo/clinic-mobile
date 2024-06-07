import 'package:clinic/screens/account_settings.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'screens/account.dart';
import 'screens/histories.dart';
import 'screens/home.dart';
import 'screens/onboarding.dart';
import 'screens/signin.dart';
import 'screens/signup.dart';
import 'screens/verification.dart';
import 'widgets/app_layout.dart';
import 'widgets/auth/auth_guard.dart';

part 'router.g.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();

final _homeNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'home');
final _historiesNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'home');
final _accountNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'account');

@riverpod
GoRouter router(RouterRef ref) {
  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    debugLogDiagnostics: true,
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        name: 'auth',
        pageBuilder: (context, state) => const NoTransitionPage(
          child: AuthGuard(),
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
        path: '/signin',
        name: 'signin',
        pageBuilder: (context, state) => const MaterialPage(
          child: SignInScreen(),
        ),
      ),
      GoRoute(
        path: '/signup',
        name: 'signup',
        pageBuilder: (context, state) => const MaterialPage(
          child: SignUpScreen(),
        ),
      ),
      GoRoute(
        path: '/verification',
        name: 'verification',
        pageBuilder: (context, state) => const MaterialPage(
          child: VerificationScreen(),
        ),
      ),
      StatefulShellRoute(
        builder: (context, state, navigationShell) => navigationShell,
        navigatorContainerBuilder: (context, navigationShell, children) {
          return AppLayout(
            navigationShell: navigationShell,
            children: children,
          );
        },
        branches: [
          StatefulShellBranch(
            navigatorKey: _homeNavigatorKey,
            routes: [
              GoRoute(
                path: '/home',
                name: 'home',
                pageBuilder: (context, state) => const NoTransitionPage(
                  child: HomeScreen(),
                ),
              ),
            ],
          ),
          StatefulShellBranch(
            navigatorKey: _historiesNavigatorKey,
            routes: [
              GoRoute(
                path: '/histories',
                name: 'histories',
                pageBuilder: (context, state) => const NoTransitionPage(
                  child: HistoriesScreen(),
                ),
              ),
            ],
          ),
          StatefulShellBranch(
            navigatorKey: _accountNavigatorKey,
            routes: [
              GoRoute(
                path: '/account',
                name: 'account',
                pageBuilder: (context, state) => const NoTransitionPage(
                  child: AccountScreen(),
                ),
                routes: [
                  GoRoute(
                    path: 'settings',
                    name: 'account_settings',
                    pageBuilder: (context, state) => const MaterialPage(
                      child: AccountSettingsScreen(),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    ],
  );
}
