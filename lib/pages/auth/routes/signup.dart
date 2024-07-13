import 'package:clinic/features/auth/auth.dart';
import 'package:clinic/ui/form/confirmation_password_input.dart';
import 'package:clinic/ui/form/email_input.dart';
import 'package:clinic/ui/form/name_input.dart';
import 'package:clinic/ui/form/password_input.dart';
import 'package:clinic/ui/form/phone_number_input.dart';
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
    return PopScope(
      onPopInvoked: (didPop) {
        if (didPop) return;
        OnboardingRoute().go(context);
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

    final (:state, :mutate, :clear) = use.mutation<Credential>();
    final future = use(signupAction);

    void signup() {
      if (formKey.currentState!.validate()) {
        return mutate(
          future(
            email: emailCtrl.text,
            name: nameCtrl.text,
            phone: "+62${phoneCtrl.text.replaceAll('-', '')}",
            password: passwordCtrl.text,
          ),
        );
      }
    }

    use.effect(() {
      if (state case AsyncLoading()) {
        context.toast.loading(message: 'Registering new account...');
      } else if (state case AsyncData()) {
        VerificationRoute().go(context);
        context.toast.success(message: 'Registration completed!');
      } else if (state case AsyncError()) {
        context.toast.error(
          message: 'Registration failed, check your credential and try again.',
        );
      } else {
        context.toast.clear();
      }
      return () => clear();
    }, [state]);

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
          NameInput(controller: nameCtrl),
          gapH16,
          PhoneNumberInput(controller: phoneCtrl),
          gapH16,
          PasswordInput(controller: passwordCtrl),
          gapH16,
          ConfirmationPasswordInput(
            controller: confirmPassCtrl,
            relatedPasswordController: passwordCtrl,
            onSaved: (_) => signup(),
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
                ..onTap = () => SigninRoute().push(context),
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
