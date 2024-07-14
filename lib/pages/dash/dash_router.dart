import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'screens/home.dart';

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
  const DashboardRoute();

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
    return Scaffold(
      body: IndexedStack(
        index: navigationShell.currentIndex,
        children: children,
      ),
    );
  }
}

class HomeBranch extends StatefulShellBranchData {
  static final GlobalKey<NavigatorState> $parentNavigatorKey = _dashboardNavKey;
  static const String $restorationScopeId = 'dashboardRestorationScopeId';
}

class HomeRoute extends GoRouteData {
  const HomeRoute();

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return NoTransitionPage(
      key: state.pageKey,
      child: const HomeScreen(),
    );
  }
}

class AppointmentBranch extends StatefulShellBranchData {
  static final GlobalKey<NavigatorState> $parentNavigatorKey = _dashboardNavKey;
  static const String $restorationScopeId = 'dashboardRestorationScopeId';
}

class AppointmentRoute extends GoRouteData {
  const AppointmentRoute();

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return NoTransitionPage(
      key: state.pageKey,
      child: const Scaffold(
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
  const AccountRoute();

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return NoTransitionPage(
      key: state.pageKey,
      child: const Scaffold(
        body: Center(
          child: Text('Medical Records'),
        ),
      ),
    );
  }
}
