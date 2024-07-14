import 'package:clinic/pages/pages.dart';
import 'package:clinic/ui/l10n/l10n_chooser.dart';
import 'package:clinic/utils/sizes.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import 'screens/onboarding.dart';
import 'screens/signin.dart';
import 'screens/signup.dart';
import 'screens/verification.dart';

part 'auth_router.g.dart';

@TypedGoRoute<OnboardingRoute>(path: '/auth/onboarding')
class OnboardingRoute extends GoRouteData {
  const OnboardingRoute();

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return CupertinoPage(
      key: state.pageKey,
      child: const _AuthLayout(
        child: OnboardingScreen(),
      ),
    );
  }
}

@TypedGoRoute<SigninRoute>(path: '/auth/signin')
class SigninRoute extends GoRouteData {
  const SigninRoute();

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return CupertinoPage(
      key: state.pageKey,
      child: const _AuthLayout(
        child: SigninScreen(),
      ),
    );
  }
}

@TypedGoRoute<SignupRoute>(path: '/auth/signup')
class SignupRoute extends GoRouteData {
  const SignupRoute();

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return CupertinoPage(
      key: state.pageKey,
      child: const _AuthLayout(
        child: SignupScreen(),
      ),
    );
  }
}

@TypedGoRoute<VerificationRoute>(path: '/auth/verification')
class VerificationRoute extends GoRouteData {
  const VerificationRoute({this.shouldRequest = false});

  final bool shouldRequest;

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return CupertinoPage(
      key: state.pageKey,
      child: _AuthLayout(
        child: VerificationScreen(shouldRequest: shouldRequest),
      ),
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
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(Sizes.p24),
          shrinkWrap: true,
          children: [
            child,
            gapH48,
            Center(
              child: Text(
                '© 2024. All Rights Reserverd.',
                style: Theme.of(context)
                    .textTheme
                    .labelSmall!
                    .copyWith(color: Theme.of(context).colorScheme.outline),
              ),
            ),
          ],
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
