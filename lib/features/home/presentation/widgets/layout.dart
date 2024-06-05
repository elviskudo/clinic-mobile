import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

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
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: navigationShell.currentIndex,
        onTap: (index) {
          navigationShell.goBranch(
            index,
            initialLocation: index == navigationShell.currentIndex,
          );
        },
        selectedItemColor: Theme.of(context).primaryColor,
        unselectedItemColor: Theme.of(context).unselectedWidgetColor,
        showUnselectedLabels: false,
        items: const [
          BottomNavigationBarItem(
            label: 'Home',
            tooltip: 'Home',
            icon: PhosphorIcon(PhosphorIconsRegular.houseSimple),
            activeIcon: PhosphorIcon(PhosphorIconsDuotone.houseSimple),
          ),
          BottomNavigationBarItem(
            label: 'Histories',
            tooltip: 'Histories',
            icon: PhosphorIcon(PhosphorIconsRegular.calendar),
            activeIcon: PhosphorIcon(PhosphorIconsDuotone.calendar),
          ),
          BottomNavigationBarItem(
            label: 'Profile',
            tooltip: 'Profile',
            icon: PhosphorIcon(PhosphorIconsRegular.userCircle),
            activeIcon: PhosphorIcon(PhosphorIconsDuotone.userCircle),
          ),
        ],
      ),
    );
  }
}
