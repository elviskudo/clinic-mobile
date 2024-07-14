import 'package:clinic/features/auth/auth.dart';
import 'package:clinic/features/profile/profile.dart';
import 'package:clinic/pages/dash/screens/account.dart';
import 'package:clinic/pages/dash/screens/appointments.dart';
import 'package:clinic/utils/sizes.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../pages.dart';
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
    return _DashboardLayout(
      navigationShell: navigationShell,
      children: children,
    );
  }
}

class _DashboardLayout extends StatelessWidget {
  const _DashboardLayout({
    required this.navigationShell,
    required this.children,
  });

  final StatefulNavigationShell navigationShell;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: navigationShell.currentIndex != 2
          ? PreferredSize(
              preferredSize: const Size(0, 64),
              child: Padding(
                padding: const EdgeInsets.only(top: Sizes.p16),
                child: AppBar(
                  title: const Padding(
                    padding: EdgeInsets.only(left: Sizes.p8),
                    child: Row(
                      children: [
                        PhotoProfile(),
                        gapW16,
                        RoleChip(),
                      ],
                    ),
                  ),
                ),
              ),
            )
          : null,
      body: IndexedStack(
        index: navigationShell.currentIndex,
        children: children,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: navigationShell.currentIndex,
        onDestinationSelected: (index) {
          navigationShell.goBranch(
            index,
            initialLocation: index == navigationShell.currentIndex,
          );
        },
        destinations: [
          NavigationDestination(
            label: 'Home',
            tooltip: 'Home',
            icon: const PhosphorIcon(PhosphorIconsRegular.houseSimple),
            selectedIcon: PhosphorIcon(
              PhosphorIconsDuotone.houseSimple,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          NavigationDestination(
            label: 'Appointments',
            tooltip: 'Appointments',
            icon: const PhosphorIcon(
              PhosphorIconsRegular.clockCounterClockwise,
            ),
            selectedIcon: PhosphorIcon(
              PhosphorIconsDuotone.clockCounterClockwise,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          NavigationDestination(
            label: 'Account',
            tooltip: 'Account',
            icon: const PhosphorIcon(PhosphorIconsRegular.userCircle),
            selectedIcon: PhosphorIcon(
              PhosphorIconsDuotone.userCircle,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        ],
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
    return CupertinoPage(
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
    return CupertinoPage(
      key: state.pageKey,
      child: const AppointmentsScreen(),
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
    return CupertinoPage(
      key: state.pageKey,
      child: const AccountScreen(),
    );
  }
}
