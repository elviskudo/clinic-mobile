import 'package:clinic/constants/regex.dart';
import 'package:clinic/constants/sizes.dart';
import 'package:clinic/data/mutations/signin.dart';
import 'package:clinic/widgets/auth/auth_form.dart';
import 'package:clinic/widgets/auth/auth_layout.dart';
import 'package:clinic/widgets/submit_button.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class SignInScreen extends HookWidget {
  const SignInScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final form = useSignIn(context);

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
                  color: Theme.of(context).colorScheme.onSurfaceVariant),
            ),
            gapH24,
            AuthForm(
              formKey: form.key,
              children: [
                TextFormField(
                  autofocus: true,
                  controller: form.email,
                  decoration: InputDecoration(
                    label: const Text('Email*'),
                    hintText: context.tr('email_field.placeholder'),
                  ),
                  validator: (str) {
                    if ((str ?? '').isEmpty) {
                      return context.tr('email_field.empty');
                    } else if (!emailRegex.hasMatch(str ?? '')) {
                      return context.tr('email_field.invalid');
                    }
                    return null;
                  },
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                ),
                gapH16,
                TextFormField(
                  controller: form.password,
                  decoration: InputDecoration(
                    label: const Text('Password*'),
                    hintText: context.tr('password_field.placeholder'),
                    suffixIcon: GestureDetector(
                      onTap: () {
                        form.passwordObscure.value =
                            !form.passwordObscure.value;
                      },
                      child: PhosphorIcon(
                        form.passwordObscure.value
                            ? PhosphorIcons.eye(PhosphorIconsStyle.duotone)
                            : PhosphorIcons.eyeClosed(
                                PhosphorIconsStyle.duotone,
                              ),
                      ),
                    ),
                  ),
                  obscureText: form.passwordObscure.value,
                  validator: (str) {
                    if ((str ?? '').isEmpty) {
                      return context.tr('password_field.empty');
                    }
                    return null;
                  },
                  keyboardType: TextInputType.visiblePassword,
                  textInputAction: TextInputAction.done,
                ),
                gapH24,
                SubmitButton(
                  onSubmit: form.handleSubmit,
                  disabled: form.isLoading,
                  loading: form.isLoading,
                  child: Text(context.tr('signin')),
                )
              ],
            ),
            gapH32,
            Center(
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
            )
          ],
        ),
      ),
    );
  }
}
