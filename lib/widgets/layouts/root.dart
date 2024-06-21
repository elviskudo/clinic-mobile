import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class RootLayout extends StatefulWidget {
  const RootLayout({
    super.key,
    required this.navigationShell,
    required this.children,
  });

  final StatefulNavigationShell navigationShell;
  final List<Widget> children;

  @override
  State<RootLayout> createState() => _RootLayoutState();
}

class _RootLayoutState extends State<RootLayout> {
  late final PageController _controller;

  @override
  void initState() {
    super.initState();
    _controller = PageController(
      initialPage: widget.navigationShell.currentIndex,
    );
  }

  @override
  void didUpdateWidget(covariant RootLayout oldWidget) {
    super.didUpdateWidget(oldWidget);
    final navigationShell = widget.navigationShell;
    final page = _controller.page ?? _controller.initialPage;
    final index = page.round();

    debugPrint('index: $index, current: ${navigationShell.currentIndex}');
    // Ignore swipe events.
    if (index == navigationShell.currentIndex) return;

    _controller.animateToPage(
      widget.navigationShell.currentIndex,
      duration: const Duration(milliseconds: 150),
      curve: Curves.linear,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final navigationShell = widget.navigationShell;
    final children = widget.children;

    return Scaffold(
      body: SafeArea(
        child: PageView.builder(
          controller: _controller,
          onPageChanged: (index) {
            if (index == navigationShell.currentIndex) return;
            navigationShell.goBranch(index, initialLocation: false);
          },
          itemBuilder: (context, index) => children[index],
          itemCount: children.length,
        ),
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
            label: context.tr('home'),
            tooltip: context.tr('home'),
            icon: const PhosphorIcon(PhosphorIconsRegular.houseSimple),
            selectedIcon: PhosphorIcon(
              PhosphorIconsDuotone.houseSimple,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          NavigationDestination(
            label: context.tr('histories'),
            tooltip: context.tr('histories'),
            icon: const PhosphorIcon(
              PhosphorIconsRegular.clockCounterClockwise,
            ),
            selectedIcon: PhosphorIcon(
              PhosphorIconsDuotone.clockCounterClockwise,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          NavigationDestination(
            label: context.tr('account'),
            tooltip: context.tr('account'),
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
