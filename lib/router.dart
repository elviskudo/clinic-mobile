import 'package:clinic/pages/account/settings.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'pages/account/credential.dart';
import 'pages/auth/onboarding.dart';
import 'pages/auth/signin.dart';
import 'pages/auth/signup.dart';
import 'pages/auth/verification.dart';
import 'pages/dashboard/account.dart';
import 'pages/dashboard/histories.dart';
import 'pages/dashboard/home.dart';
import 'pages/dashboard/layout.dart';
import 'pages/root.dart';

part 'router.g.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();

final _homeNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'home');
final _historiesNavigatorKey = GlobalKey<NavigatorState>(
  debugLabel: 'histories',
);
final _accountNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'account');

@riverpod
GoRouter router(RouterRef ref) {
  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    debugLogDiagnostics: true,
    routes: [
      GoRoute(
        path: '/',
        pageBuilder: (context, state) => const NoTransitionPage(
          child: RootLayout(),
        ),
      ),
      GoRoute(
        path: '/onboarding',
        pageBuilder: (context, state) => const MaterialPage(
          child: OnboardingPage(),
        ),
      ),
      GoRoute(
        path: '/signin',
        pageBuilder: (context, state) => const MaterialPage(
          child: SigninPage(),
        ),
      ),
      GoRoute(
        path: '/signup',
        pageBuilder: (context, state) => const MaterialPage(
          child: SignupPage(),
        ),
      ),
      GoRoute(
        path: '/verification',
        pageBuilder: (context, state) => const MaterialPage(
          child: VerificationPage(),
        ),
      ),
      StatefulShellRoute(
        builder: (context, state, navigationShell) => navigationShell,
        navigatorContainerBuilder: (context, navigationShell, children) {
          return DashboardLayout(
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
                pageBuilder: (context, state) => const NoTransitionPage(
                  child: HomePage(),
                ),
              ),
            ],
          ),
          StatefulShellBranch(
            navigatorKey: _historiesNavigatorKey,
            routes: [
              GoRoute(
                path: '/histories',
                pageBuilder: (context, state) => const NoTransitionPage(
                  child: HistoriesPage(),
                ),
              ),
            ],
          ),
          StatefulShellBranch(
            navigatorKey: _accountNavigatorKey,
            routes: [
              GoRoute(
                path: '/account',
                pageBuilder: (context, state) => const NoTransitionPage(
                  child: AccountPage(),
                ),
              )
            ],
          ),
        ],
      ),
      GoRoute(
        path: '/account/settings',
        pageBuilder: (context, state) => const MaterialPage(
          child: AccountSettingsPage(),
        ),
      ),
      GoRoute(
        path: '/account/credential',
        pageBuilder: (context, state) => const MaterialPage(
          child: AccountCredentialPage(),
        ),
      ),
    ],
  );
}
