import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

import '../../../../constants/sizes.dart';

class AppLayout extends StatefulWidget {
  const AppLayout({
    super.key,
    required this.navigationShell,
    required this.children,
  });

  final StatefulNavigationShell navigationShell;
  final List<Widget> children;

  @override
  State<AppLayout> createState() => _AppLayoutState();
}

class _AppLayoutState extends State<AppLayout> {
  late final PageController _controller;

  @override
  void initState() {
    super.initState();
    _controller = PageController(
      initialPage: widget.navigationShell.currentIndex,
    );
  }

  @override
  void didUpdateWidget(covariant AppLayout oldWidget) {
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
      body: PageView.builder(
        controller: _controller,
        onPageChanged: (index) {
          debugPrint('index: $index, current: ${navigationShell.currentIndex}');

          // Ignore tap events.
          if (index == navigationShell.currentIndex) return;

          navigationShell.goBranch(index, initialLocation: false);
        },
        itemBuilder: (context, index) => children[index],
        itemCount: children.length,
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: Sizes.p16,
          vertical: Sizes.p12,
        ),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceVariant,
        ),
        child: GNav(
          selectedIndex: navigationShell.currentIndex,
          onTabChange: (index) {
            if (index >= 2) return;
            navigationShell.goBranch(
              index,
              initialLocation: index == navigationShell.currentIndex,
            );
          },
          gap: Sizes.p8,
          padding: const EdgeInsets.symmetric(
            horizontal: Sizes.p16,
            vertical: Sizes.p12,
          ),
          color: Theme.of(context).colorScheme.onSecondaryContainer,
          backgroundColor: Theme.of(context).colorScheme.surfaceVariant,
          activeColor: Theme.of(context).colorScheme.onSecondary,
          tabBackgroundColor: Theme.of(context).colorScheme.secondary,
          textStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSecondary,
                fontWeight: FontWeight.w500,
              ),
          tabs: [
            const GButton(
              text: 'Home',
              icon: PhosphorIconsRegular.houseSimple,
            ),
            const GButton(
              text: 'Profile',
              icon: PhosphorIconsRegular.userCircle,
            ),
            GButton(
              onPressed: null,
              iconColor: Theme.of(context).disabledColor,
              text: 'Appoinment',
              icon: PhosphorIconsRegular.calendar,
            ),
            GButton(
              onPressed: null,
              text: 'News',
              iconColor: Theme.of(context).disabledColor,
              icon: PhosphorIconsRegular.userCircle,
            ),
          ],
        ),
      ),
    );
  }
}
