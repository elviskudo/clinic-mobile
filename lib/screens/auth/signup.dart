import 'package:auto_route/auto_route.dart';
import 'package:clinic/app_router.gr.dart';
import 'package:clinic/features/auth/auth.dart';
import 'package:clinic/ui/form/confirmation_password_input.dart';
import 'package:clinic/ui/form/email_input.dart';
import 'package:clinic/ui/form/name_input.dart';
import 'package:clinic/ui/form/password_input.dart';
import 'package:clinic/ui/form/phone_number_input.dart';
import 'package:clinic/ui/notification/toast.dart';
import 'package:clinic/utils/sizes.dart';
import 'package:fl_query_hooks/fl_query_hooks.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

@RoutePage()
class SignupScreen extends StatelessWidget {
  const SignupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(Sizes.p24),
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

class _SignUpForm extends HookWidget {
  const _SignUpForm();

  @override
  Widget build(BuildContext context) {
    final formKey = useMemoized(() => GlobalKey<FormState>());

    final emailCtrl = useTextEditingController();
    final nameCtrl = useTextEditingController();
    final phoneCtrl = useTextEditingController();
    final passwordCtrl = useTextEditingController();
    final confirmPassCtrl = useTextEditingController();

    final mutation = useMutation(
      'signup',
      (
        ({
          String email,
          String name,
          String phone,
          String password,
        }) data,
      ) async =>
          await auth$.read(context).signUp(
                email: data.email,
                name: data.name,
                phone: data.phone,
                password: data.password,
              ),
      refreshQueries: ['auth_credential'],
      onMutate: (_) {
        context.toast.loading(
          title: 'Authentication',
          message: 'Creating your account...',
        );
      },
      onData: (data, _) {
        context.toast.success(
          title: 'Authentication',
          message: 'Your account has been created successfully!',
        );
        context.replaceRoute(const VerificationRoute());
      },
      onError: (ex, _) {
        context.toast.error(
          title: 'Authentication',
          message:
              'Cannot create new account. Check your credential and please try again.',
        );
      },
    );

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
          ),
          gapH24,
          FilledButton(
            onPressed: mutation.isMutating
                ? null
                : () async {
                    if (formKey.currentState!.validate()) {
                      await mutation.mutate((
                        email: emailCtrl.text,
                        name: nameCtrl.text,
                        phone: "+62${phoneCtrl.text.replaceAll('-', '')}",
                        password: passwordCtrl.text,
                      ));
                    }
                  },
            child: const Text('Sign in'),
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
                ..onTap = () => context.pushRoute(const SigninRoute()),
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
