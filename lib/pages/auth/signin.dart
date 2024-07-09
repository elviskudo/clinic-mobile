import 'package:clinic/constants/sizes.dart';
import 'package:clinic/widgets/forms/auth/signin_form.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'layout.dart';

class SigninPage extends StatelessWidget {
  const SigninPage({super.key});

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
          padding: const EdgeInsets.all(Sizes.p24),
          shrinkWrap: true,
          children: [
            Text(
              context.tr('page_signin_title'),
              style: Theme.of(context)
                  .textTheme
                  .headlineMedium!
                  .copyWith(fontWeight: FontWeight.w600),
            ),
            gapH8,
            Text(
              context.tr('page_signin_desc'),
              style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant),
            ),
            gapH24,
            const SigninForm(),
            gapH32,
            const _RedirectToSignUp()
          ],
        ),
      ),
    );
  }
}

class _RedirectToSignUp extends StatelessWidget {
  const _RedirectToSignUp();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text.rich(
        TextSpan(
          text: context.tr('page_signin_no_account'),
          children: [
            TextSpan(
              text: ' ${context.tr('signup')}',
              recognizer: TapGestureRecognizer()
                ..onTap = () => context.push('/signup'),
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
