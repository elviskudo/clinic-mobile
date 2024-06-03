import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../../../constants/regex.dart';
import '../../../../constants/sizes.dart';
import '../../../../l10n/generated/l10n.dart';
import '../widgets/form.dart';
import '../widgets/layout.dart';

class SignInScreen extends HookWidget {
  const SignInScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final formKey = useMemoized(() => GlobalKey<FormState>());
    final loading = useState(false);

    final email = useTextEditingController.fromValue(TextEditingValue.empty);

    final password = useTextEditingController.fromValue(TextEditingValue.empty);
    final passwordObscure = useState(true);

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
              S.of(context).pageSignInTitle,
              style: Theme.of(context)
                  .textTheme
                  .headlineMedium!
                  .copyWith(fontWeight: FontWeight.w600),
            ),
            gapH8,
            Text(
              S.of(context).pageSignInDescription,
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
                    hintText: S.of(context).inputEmailPlaceholder,
                  ),
                  validator: (str) {
                    if ((str ?? '').isEmpty) {
                      return S.of(context).errorEmailValidationEmpty;
                    } else if (!emailRegex.hasMatch(str ?? '')) {
                      return S.of(context).errorEmailValidationInvalid;
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
                    hintText: S.of(context).inputPasswordPlaceholder,
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
                      return S.of(context).errorPasswordValidationEmpty;
                    } else if ((str ?? '').length < 8 ||
                        passwordRegex.hasMatch(str ?? '')) {
                      return S.of(context).errorPasswordValidationInvalid;
                    }
                    return null;
                  },
                  keyboardType: TextInputType.visiblePassword,
                  textInputAction: TextInputAction.done,
                ),
                gapH24,
                FilledButton(
                  onPressed: loading.value
                      ? null
                      : () async {
                          if (formKey.currentState!.validate()) {
                            formKey.currentState!.reset();
                            loading.value = true;
                            context.go('/app/home');
                            loading.value = false;
                          }
                        },
                  child: loading.value
                      ? const CircularProgressIndicator()
                      : Text(S.of(context).signIn),
                )
              ],
            ),
            gapH32,
            Center(
              child: Text.rich(
                TextSpan(
                  text: S.of(context).pageSignInNoAccount,
                  children: [
                    TextSpan(
                      text: ' ${S.of(context).signUp}',
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
