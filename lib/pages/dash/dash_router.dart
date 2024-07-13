import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

part 'dash_router.g.dart';

final _dashboardNavKey = GlobalKey<NavigatorState>();

@TypedStatefulShellRoute<DashboardRoute>(
  branches: <TypedStatefulShellBranch<StatefulShellBranchData>>[
    TypedStatefulShellBranch<HomeBranch>(
      routes: [TypedGoRoute<HomeRoute>(path: '/app/home')],
    ),
    TypedStatefulShellBranch<AppointmentBranch>(
      routes: [TypedGoRoute<AppointmentRoute>(path: '/app/appointment')],
    ),
    TypedStatefulShellBranch<AccountBranch>(
      routes: [TypedGoRoute<AccountRoute>(path: '/app/account')],
    ),
  ],
)
class DashboardRoute extends StatefulShellRouteData {
  @override
  Widget builder(
    BuildContext context,
    GoRouterState state,
    StatefulNavigationShell navigationShell,
  ) {
    return navigationShell;
  }

  static const String $restorationScopeId = 'dashboardRestorationScopeId';

  static Widget $navigatorContainerBuilder(
    BuildContext context,
    StatefulNavigationShell navigationShell,
    List<Widget> children,
  ) {
    return children[0];
  }
}

class HomeBranch extends StatefulShellBranchData {
  static final GlobalKey<NavigatorState> $parentNavigatorKey = _dashboardNavKey;
  static const String $restorationScopeId = 'dashboardRestorationScopeId';
}

class HomeRoute extends GoRouteData {
  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return NoTransitionPage(
      child: Scaffold(
        body: Center(
          child: const Text('hello').tr(),
        ),
      ),
    );
  }
}

class AppointmentBranch extends StatefulShellBranchData {
  static final GlobalKey<NavigatorState> $parentNavigatorKey = _dashboardNavKey;
  static const String $restorationScopeId = 'dashboardRestorationScopeId';
}

class AppointmentRoute extends GoRouteData {
  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return const NoTransitionPage(
      child: Scaffold(
        body: Center(
          child: Text('Medical Records'),
        ),
      ),
    );
  }
}

class AccountBranch extends StatefulShellBranchData {
  static final GlobalKey<NavigatorState> $parentNavigatorKey = _dashboardNavKey;
  static const String $restorationScopeId = 'dashboardRestorationScopeId';
}

class AccountRoute extends GoRouteData {
  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return const NoTransitionPage(
      child: Scaffold(
        body: Center(
          child: Text('Medical Records'),
        ),
      ),
    );
  }
}
