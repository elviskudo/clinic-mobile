import 'package:clinic/constants/sizes.dart';
import 'package:clinic/features/auth/auth.dart';
import 'package:clinic/widgets/layouts/auth.dart';
import 'package:clinic/widgets/ui/submit_button.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class SignInScreen extends StatelessWidget {
  const SignInScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        if (didPop) return;
        context.go('/onboarding');
      },
      child: AuthLayout(
        body: ListView(
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

class _SignInForm extends HookConsumerWidget {
  const _SignInForm();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final form = useSignIn(context, ref);

    return AuthForm(
      formKey: form.formKey,
      children: [
        TextFormField(
          autofocus: true,
          controller: form.emailController,
          decoration: InputDecoration(
            label: const Text('Email*'),
            hintText: context.tr('email_field.placeholder'),
          ),
          validator: form.handleEmailValidation,
          keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.next,
        ),
        gapH16,
        TextFormField(
          controller: form.passwordController,
          decoration: InputDecoration(
            label: const Text('Password*'),
            hintText: context.tr('password_field.placeholder'),
            suffixIcon: GestureDetector(
              onTap: form.handlePasswordObscure,
              child: PhosphorIcon(
                form.isObscuredPassword
                    ? PhosphorIcons.eye(PhosphorIconsStyle.duotone)
                    : PhosphorIcons.eyeClosed(
                        PhosphorIconsStyle.duotone,
                      ),
              ),
            ),
          ),
          obscureText: form.isObscuredPassword,
          validator: form.handlePasswordValidation,
          keyboardType: TextInputType.visiblePassword,
          textInputAction: TextInputAction.done,
          onFieldSubmitted: (_) => form.handleSubmit(),
        ),
        gapH24,
        SubmitButton(
          onSubmit: form.handleSubmit,
          disabled: form.isLoading,
          loading: form.isLoading,
          child: Text(context.tr('signin')),
        )
      ],
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
