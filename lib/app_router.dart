import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:state_beacon/state_beacon.dart';

import 'app_router.gr.dart';

@AutoRouterConfig()
class AppRouter extends $AppRouter {
  AppRouter(this.context);

  final BuildContext context;

  @override
  List<AutoRoute> get routes {
    return [
      AutoRoute(
        path: '/',
        page: RootRoute.page,
      ),
      AutoRoute(
        path: '/auth',
        page: AuthRoute.page,
        children: [
          AutoRoute(
            path: 'onboarding',
            page: OnboardingRoute.page,
            initial: true,
          ),
          AutoRoute(
            path: 'signin',
            page: SigninRoute.page,
          ),
          AutoRoute(
            path: 'signup',
            page: SignupRoute.page,
          ),
        ],
      ),
      AutoRoute(
        path: '/verification',
        page: VerificationRoute.page,
      ),
      AutoRoute(
        path: '/dashboard',
        page: DashboardRoute.page,
      )
    ];
  }
}

final router = Ref.scoped((context) => AppRouter(context));
