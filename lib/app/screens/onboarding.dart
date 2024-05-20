import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../constants/sizes.dart';
import '../../context.dart';
import '../../widgets/scaffold_with_l10n_appbar.dart';

class OnboardingScreen extends ConsumerWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ScaffoldWithL10nAppBar(
      body: Padding(
        padding: const EdgeInsets.all(Sizes.p24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Expanded(
              child: Image.asset(
                'assets/images/onboarding_illustration.png',
                height: 180,
                isAntiAlias: true,
                filterQuality: FilterQuality.high,
              ),
            ),
            gapH24,
            Text(
              context.locale.pageOnboardingTitle,
              style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.w600,
                  ),
            ),
            gapH8,
            Text(
              context.locale.pageOnboardingDescription,
              style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
            ),
            gapH24,
            FilledButton(
              child: Text(context.locale.signIn),
              onPressed: () {
                context.push('/auth/signin');
              },
            ),
            gapH8,
            OutlinedButton(
              child: Text(context.locale.signUp),
              onPressed: () {
                context.push('/auth/signup');
              },
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
