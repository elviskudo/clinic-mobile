import 'package:clinic/pages/pages.dart';
import 'package:clinic/ui/l10n/l10n_button.dart';
import 'package:clinic/utils/sizes.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'screens/onboarding.dart';
import 'screens/signin.dart';
import 'screens/signup.dart';
import 'screens/verification.dart';
import 'screens/verification_success.dart';

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
        automaticallyImplyLeading: false,
        child: VerificationScreen(shouldRequest: shouldRequest),
      ),
    );
  }
}

@TypedGoRoute<VerificationSuccessRoute>(path: '/auth/verification/success')
class VerificationSuccessRoute extends GoRouteData {
  const VerificationSuccessRoute();

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return CupertinoPage(
      key: state.pageKey,
      child: const VerificationSuccessScreen(),
    );
  }
}

class _AuthLayout extends StatelessWidget {
  const _AuthLayout({
    required this.child,
    this.automaticallyImplyLeading = true,
  });

  final Widget child;
  final bool automaticallyImplyLeading;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _AuthPageHeader(
        automaticallyImplyLeading: automaticallyImplyLeading,
      ),
      resizeToAvoidBottomInset: true,
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
  const _AuthPageHeader({this.automaticallyImplyLeading = true});

  final bool automaticallyImplyLeading;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      titleSpacing: Sizes.p8,
      scrolledUnderElevation: 0,
      elevation: 0,
      automaticallyImplyLeading: automaticallyImplyLeading,
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
      actions: const [L10nButton(), gapW24],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(64);
}
