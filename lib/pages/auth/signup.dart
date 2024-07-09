import 'package:clinic/constants/sizes.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'layout.dart';

class SignupPage extends StatelessWidget {
  const SignupPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AuthLayout(
      body: PopScope(
        canPop: false,
        onPopInvoked: (didPop) {
          if (didPop) return;
          context.go('/onboarding');
        },
        child: ListView(
          shrinkWrap: true,
          padding: const EdgeInsets.all(Sizes.p24),
          children: [
            Text(
              context.tr('page_signup_title'),
              style: Theme.of(context)
                  .textTheme
                  .headlineMedium!
                  .copyWith(fontWeight: FontWeight.w600),
            ),
            gapH8,
            Text(
              context.tr('page_signup_desc'),
              style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
            ),
            gapH24,
            gapH32,
            const _RedirectToSignIn()
          ],
        ),
      ),
    );
  }
}

class _RedirectToSignIn extends StatelessWidget {
  const _RedirectToSignIn();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text.rich(
        TextSpan(
          text: context.tr('page_signup_had_account'),
          children: [
            TextSpan(
              text: ' ${context.tr("signin")}',
              recognizer: TapGestureRecognizer()
                ..onTap = () => context.push('/signin'),
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
