import 'package:clinic/features/auth/auth.dart';
import 'package:clinic/pages/dash/dash_router.dart';
import 'package:clinic/ui/form/email_input.dart';
import 'package:clinic/ui/form/password_input.dart';
import 'package:clinic/ui/notification/toast.dart';
import 'package:clinic/utils/sizes.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rearch/flutter_rearch.dart';
import 'package:rearch/rearch.dart';

import 'auth_router.dart';

class SigninScreen extends StatelessWidget {
  const SigninScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BackButtonListener(
      onBackButtonPressed: () async {
        const OnboardingRoute().go(context);
        return false;
      },
      child: PopScope(
        canPop: false,
        onPopInvoked: (didPop) {
          if (didPop) return;
          const OnboardingRoute().go(context);
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Hi, Welcome!',
              style: Theme.of(context)
                  .textTheme
                  .headlineMedium!
                  .copyWith(fontWeight: FontWeight.w600),
            ),
            gapH8,
            Text(
              'Hello, how are you? not feeling great? Don\'t worry we got you covered, check your health easily!',
              style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
            ),
            gapH24,
            const _SignInForm(),
            gapH32,
            const _RedirectToSignUp()
          ],
        ),
      ),
    );
  }
}

class _SignInForm extends RearchConsumer {
  const _SignInForm();

  @override
  Widget build(BuildContext context, WidgetHandle use) {
    final formKey = use.memo(() => GlobalKey<FormState>());

    final emailCtrl = use.textEditingController();
    final passwordCtrl = use.textEditingController();

    final (:state, :mutate, clear: _) = use.mutation<void>();
    final future = use(signinAction);

    void signin() {
      if (formKey.currentState!.validate()) {
        return mutate(
          future(
            email: emailCtrl.text,
            password: passwordCtrl.text,
          ).then(
            (data) {
              context.toast.success(
                message: data.isVerified
                    ? 'Welcome back to Clinic AI!'
                    : 'Looks like your account is not verified yet.',
              );
              data.isVerified
                  ? const HomeRoute().go(context)
                  : const VerificationRoute(shouldRequest: true).go(context);
            },
          ).catchError(
            (_) {
              context.toast.error(
                message: 'Sign in failed, check your credential and try again.',
              );
            },
          ),
        );
      }
    }

    return Form(
      key: formKey,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          EmailInput(
            controller: emailCtrl,
            autofocus: true,
            textInputAction: TextInputAction.next,
          ),
          gapH16,
          PasswordInput(controller: passwordCtrl),
          gapH24,
          FilledButton(
            onPressed: state is AsyncLoading ? null : signin,
            child: const Text('Sign in'),
          ),
        ],
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
          text: 'Don\'t have an account yet?',
          children: [
            TextSpan(
              text: '\nCreate an account',
              recognizer: TapGestureRecognizer()
                ..onTap = () => const SignupRoute().push(context),
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}
