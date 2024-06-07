import 'package:clinic/constants/sizes.dart';
import 'package:clinic/widgets/auth/auth_layout.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';

class OnboardingScreen extends HookWidget {
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
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(Sizes.p24),
                child: Image.asset(
                  'assets/images/onboarding_illustration.png',
                  width: 200,
                  height: 200,
                  isAntiAlias: true,
                  filterQuality: FilterQuality.high,
                ),
              ),
            ),
            gapH48,
            Text(
              context.tr('page_onboarding_title'),
              style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.w600,
                  ),
            ),
            gapH8,
            Text(
              context.tr('page_onboarding_desc'),
              style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
            ),
            gapH24,
            FilledButton(
              child: Text(context.tr('signin')),
              onPressed: () => context.push('/signin'),
            ),
            gapH8,
            OutlinedButton(
              child: Text(context.tr('signup')),
              onPressed: () => context.push('/signup'),
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
