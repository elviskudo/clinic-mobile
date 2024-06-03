import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'features/app/presentation/widgets/layout.dart';
import 'features/auth/presentation/screens/onboarding.dart';
import 'features/auth/presentation/screens/signin.dart';
import 'features/auth/presentation/screens/signup.dart';
import 'features/auth/presentation/screens/verification.dart';
import 'features/app/presentation/screens/home.dart';
import 'features/app/presentation/screens/profile.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _homeNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'home');
final _profileNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'profile');

final goRouter = GoRouter(
  navigatorKey: _rootNavigatorKey,
  debugLogDiagnostics: true,
  initialLocation: '/onboarding',
  routes: [
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
              path: '/app/home',
              name: 'home',
              pageBuilder: (context, state) => const NoTransitionPage(
                child: HomeScreen(),
              ),
            ),
          ],
        ),
        StatefulShellBranch(
          navigatorKey: _profileNavigatorKey,
          routes: [
            GoRoute(
              path: '/app/profile',
              name: 'profile',
              pageBuilder: (context, state) => const NoTransitionPage(
                child: ProfileScreen(),
              ),
            ),
          ],
        ),
      ],
    )
  ],
);
