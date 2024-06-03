import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../constants/sizes.dart';
import '../../../../l10n/generated/l10n.dart';
import '../widgets/layout.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AuthLayout(
      body: Padding(
        padding: const EdgeInsets.all(Sizes.p24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Image.asset(
              'assets/images/onboarding_illustration.png',
              height: 240,
              isAntiAlias: true,
              filterQuality: FilterQuality.high,
            ),
            gapH48,
            Text(
              S.of(context).pageOnboardingTitle,
              style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.w600,
                  ),
            ),
            gapH8,
            Text(
              S.of(context).pageOnboardingDescription,
              style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
            ),
            gapH24,
            FilledButton(
              child: Text(S.of(context).signIn),
              onPressed: () => context.push('/auth/signin'),
            ),
            gapH8,
            OutlinedButton(
              child: Text(S.of(context).signUp),
              onPressed: () => context.push('/auth/signup'),
            ),
            gapH48,
            Center(
              child: Text(
                '© 2024. All rights reserved.',
                style: Theme.of(context).textTheme.labelSmall!.copyWith(
                      color: Theme.of(context).colorScheme.outlineVariant,
                    ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
