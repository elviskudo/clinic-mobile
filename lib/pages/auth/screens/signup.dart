import 'package:clinic/features/auth/auth.dart';
import 'package:clinic/ui/form/confirmation_password_input.dart';
import 'package:clinic/ui/form/email_input.dart';
import 'package:clinic/ui/form/name_input.dart';
import 'package:clinic/ui/form/password_input.dart';
import 'package:clinic/ui/form/phone_number_input.dart';
import 'package:clinic/ui/notification/notification.dart';
import 'package:clinic/ui/notification/toast.dart';
import 'package:clinic/utils/sizes.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rearch/flutter_rearch.dart';
import 'package:rearch/rearch.dart';

import '../auth_router.dart';

class SignupScreen extends StatelessWidget {
  const SignupScreen({super.key});

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
              'Create an Account',
              style: Theme.of(context)
                  .textTheme
                  .headlineMedium!
                  .copyWith(fontWeight: FontWeight.w600),
            ),
            gapH8,
            Text(
              'Start with make an account and then you can check your health anytime, anywhere!',
              style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
            ),
            gapH24,
            const _SignUpForm(),
            gapH32,
            const _RedirectToSignIn()
          ],
        ),
      ),
    );
  }
}

class _SignUpForm extends RearchConsumer {
  const _SignUpForm();

  @override
  Widget build(BuildContext context, WidgetHandle use) {
    final formKey = use.memo(() => GlobalKey<FormState>());

    final emailCtrl = use.textEditingController();
    final nameCtrl = use.textEditingController();
    final phoneCtrl = use.textEditingController();

    final passwordCtrl = use.textEditingController();
    final confirmPassCtrl = use.textEditingController();

    final (:state, :mutate, clear: _) = use.mutation<void>();
    final future = use(signupAction);

    void signup() {
      if (formKey.currentState!.validate()) {
        return mutate(
          future(
            email: emailCtrl.text,
            name: nameCtrl.text,
            phone: "+62${phoneCtrl.text.replaceAll('-', '')}",
            password: passwordCtrl.text,
          ).then<void>(
            (_) {
              notif.currentState!.context.toast
                  .success(message: 'Registration completed!');
              const VerificationRoute().go(context);
            },
          ),
        );
      }
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (state case AsyncData()) {
      } else if (state case AsyncError()) {
        context.toast.error(
          message: 'Registration failed, check your credential and try again.',
        );
      }
    });

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
          NameInput(
            controller: nameCtrl,
            textInputAction: TextInputAction.next,
          ),
          gapH16,
          PhoneNumberInput(
            controller: phoneCtrl,
            textInputAction: TextInputAction.next,
          ),
          gapH16,
          PasswordInput(
            controller: passwordCtrl,
            textInputAction: TextInputAction.next,
          ),
          gapH16,
          ConfirmationPasswordInput(
            controller: confirmPassCtrl,
            relatedPasswordController: passwordCtrl,
          ),
          gapH24,
          FilledButton(
            onPressed: state is AsyncLoading ? null : signup,
            child: const Text('Create an account'),
          ),
        ],
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
          text: 'Already have an account?',
          children: [
            TextSpan(
              text: '\nSign in',
              recognizer: TapGestureRecognizer()
                ..onTap = () => const SigninRoute().push(context),
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
