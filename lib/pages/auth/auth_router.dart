import 'package:clinic/pages/pages.dart';
import 'package:clinic/ui/l10n/l10n_chooser.dart';
import 'package:clinic/utils/sizes.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import 'routes/onboarding.dart';
import 'routes/signin.dart';
import 'routes/signup.dart';
import 'routes/verification.dart';

part 'auth_router.g.dart';

@TypedShellRoute<AuthRoute>(
  routes: <TypedGoRoute<GoRouteData>>[
    TypedGoRoute<OnboardingRoute>(path: '/onboarding'),
    TypedGoRoute<SigninRoute>(path: '/signin'),
    TypedGoRoute<SignupRoute>(path: '/signup'),
    TypedGoRoute<VerificationRoute>(path: '/verification'),
  ],
)
class AuthRoute extends ShellRouteData {
  static final GlobalKey<NavigatorState> $navigatorKey = rootNavKey;

  @override
  Widget builder(BuildContext context, GoRouterState state, Widget navigator) {
    return _AuthLayout(child: navigator);
  }
}

class OnboardingRoute extends GoRouteData {
  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return CupertinoPage(
      child: const OnboardingScreen(),
    );
  }
}

class SigninRoute extends GoRouteData {
  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return CupertinoPage(
      child: const SigninScreen(),
    );
  }
}

class SignupRoute extends GoRouteData {
  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return CupertinoPage(
      child: const SignupScreen(),
    );
  }
}

class VerificationRoute extends GoRouteData {
  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return CupertinoPage(
      child: const VerificationScreen(),
    );
  }
}

class _AuthLayout extends StatelessWidget {
  const _AuthLayout({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const _AuthPageHeader(),
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(Sizes.p24),
            height: MediaQuery.of(context).size.height,
            child: child,
            // Center(
            //   child: Text(
            //     '© 2024. All Rights Reserverd.',
            //     style: Theme.of(context)
            //         .textTheme
            //         .labelSmall!
            //         .copyWith(color: Theme.of(context).colorScheme.outline),
            //   ),
            // ),
          ),
        ),
      ),
    );
  }
}

class _AuthPageHeader extends StatelessWidget implements PreferredSizeWidget {
  const _AuthPageHeader();

  @override
  Widget build(BuildContext context) {
    return AppBar(
      titleSpacing: Sizes.p8,
      scrolledUnderElevation: 0,
      elevation: 0,
      backgroundColor: Theme.of(context).colorScheme.surface,
      title: Row(
        children: [
          Image.asset(
            'assets/images/clinic_ai.png',
            filterQuality: FilterQuality.high,
            height: 48,
          ),
          Text(
            'Clinic AI',
            style: Theme.of(context)
                .textTheme
                .bodyMedium!
                .copyWith(fontWeight: FontWeight.w600),
          ),
        ],
      ),
      actions: [
        GestureDetector(
          onTap: () => showL10nChooser(context),
          child: Chip(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(99),
              side: BorderSide(color: Theme.of(context).colorScheme.tertiary),
            ),
            backgroundColor: Theme.of(context)
                .colorScheme
                .tertiaryContainer
                .withOpacity(0.4),
            label: Row(
              children: [
                PhosphorIcon(
                  PhosphorIconsDuotone.globe,
                  color: Theme.of(context).colorScheme.tertiary,
                  size: 15,
                ),
                gapW8,
                Text(
                  context.locale.languageCode == 'id' ? 'Indonesia' : 'English',
                  style: Theme.of(context)
                      .textTheme
                      .labelSmall!
                      .copyWith(color: Theme.of(context).colorScheme.tertiary),
                ),
              ],
            ),
          ),
        ),
        gapW24,
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(64);
}
