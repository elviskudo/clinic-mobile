import 'package:auto_route/auto_route.dart';
import 'package:clinic/app_router.gr.dart';
import 'package:clinic/features/auth/auth.dart';
import 'package:clinic/features/auth/presentation/auth_store.dart';
import 'package:clinic/ui/form/email_input.dart';
import 'package:clinic/ui/form/password_input.dart';
import 'package:clinic/ui/notification/toast.dart';
import 'package:clinic/utils/sizes.dart';
import 'package:fl_query_hooks/fl_query_hooks.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:toastification/toastification.dart';

@RoutePage()
class SigninScreen extends StatelessWidget {
  const SigninScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(Sizes.p24),
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
    );
  }
}

class _SignInForm extends HookWidget {
  const _SignInForm();

  @override
  Widget build(BuildContext context) {
    final formKey = useMemoized(() => GlobalKey<FormState>());

    final emailCtrl = useTextEditingController();
    final passwordCtrl = useTextEditingController();

    final mutation = useMutation(
      'signin',
      (({String email, String password}) data) async => await auth$
          .read(context)
          .signIn(email: data.email, password: data.password),
      refreshQueries: ['auth_credential'],
      onData: (data, _) {
        toastification.dismissAll();
        context.toast.success(
          title: 'Authentication',
          message: 'Welcome back to Clinic AI!',
        );
        context.replaceRoute(const DashboardRoute());
      },
      onError: (ex, _) {
        debugPrint('$ex');
        toastification.dismissAll();
        context.toast.error(
          title: 'Authentication',
          message:
              'Sign in failed. Check your credential and please try again.',
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
          PasswordInput(controller: passwordCtrl),
          gapH24,
          FilledButton(
            onPressed: mutation.isMutating
                ? null
                : () async {
                    context.toast.loading(
                      title: 'Authentication',
                      message: 'Signing in...',
                    );
                    if (formKey.currentState!.validate()) {
                      await mutation.mutate((
                        email: emailCtrl.text,
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
                ..onTap = () => context.pushRoute(const SignupRoute()),
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
