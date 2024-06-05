import 'package:clinic/constants/regex.dart';
import 'package:clinic/constants/sizes.dart';
import 'package:clinic/data/mutations/signin.dart';
import 'package:clinic/widgets/auth/auth_form.dart';
import 'package:clinic/widgets/auth/auth_view_layout.dart';
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
    final formKey = useMemoized(() => GlobalKey<FormState>());

    final email = useTextEditingController.fromValue(TextEditingValue.empty);

    final password = useTextEditingController.fromValue(TextEditingValue.empty);
    final passwordObscure = useState(true);

    final mutation = useSignIn(context);

    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        if (didPop) return;
        context.go('/onboarding');
      },
      child: AuthViewLayout(
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
            AuthForm(
              formKey: formKey,
              children: [
                TextFormField(
                  autofocus: true,
                  controller: email,
                  decoration: InputDecoration(
                    label: const Text('Email*'),
                    hintText: context.tr('email_field', gender: 'placeholder'),
                  ),
                  validator: (str) {
                    if ((str ?? '').isEmpty) {
                      return context.tr('email_field', gender: 'empty');
                    } else if (!emailRegex.hasMatch(str ?? '')) {
                      return context.tr('email_field', gender: 'invalid');
                    }
                    return null;
                  },
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                ),
                gapH16,
                TextFormField(
                  controller: password,
                  decoration: InputDecoration(
                    label: const Text('Password*'),
                    helperText: context.tr(
                      'password_field',
                      gender: 'criteria',
                    ),
                    hintText: context.tr(
                      'password_field',
                      gender: 'placeholder',
                    ),
                    suffixIcon: GestureDetector(
                      onTap: () {
                        passwordObscure.value = !passwordObscure.value;
                      },
                      child: PhosphorIcon(
                        passwordObscure.value
                            ? PhosphorIcons.eye(PhosphorIconsStyle.duotone)
                            : PhosphorIcons.eyeClosed(
                                PhosphorIconsStyle.duotone),
                      ),
                    ),
                  ),
                  obscureText: passwordObscure.value,
                  validator: (str) {
                    if ((str ?? '').isEmpty) {
                      return context.tr('password_field', gender: 'empty');
                    } else if ((str ?? '').length < 8 ||
                        passwordRegex.hasMatch(str ?? '')) {
                      return context.tr('email_field', gender: 'invalid');
                    }
                    return null;
                  },
                  keyboardType: TextInputType.visiblePassword,
                  textInputAction: TextInputAction.done,
                ),
                gapH24,
                SubmitButton(
                  onSubmit: () async {
                    if (formKey.currentState!.validate()) {
                      formKey.currentState!.reset();
                      await mutation.mutate(
                        {'email': email.text, 'password': password.text},
                      );
                    }
                  },
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
                        ..onTap = () => context.push('/auth/signup'),
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
