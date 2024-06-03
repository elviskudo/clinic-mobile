import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../../../constants/regex.dart';
import '../../../../constants/sizes.dart';
import '../../../../l10n/generated/l10n.dart';
import '../widgets/form.dart';
import '../widgets/layout.dart';

class SignUpScreen extends HookWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final formKey = useMemoized(() => GlobalKey<FormState>());
    final loading = useState(false);

    final name = useTextEditingController.fromValue(TextEditingValue.empty);

    final email = useTextEditingController.fromValue(TextEditingValue.empty);

    final phone = useTextEditingController.fromValue(TextEditingValue.empty);
    final phoneNumber = useState(PhoneNumber(isoCode: 'ID'));
    final phoneErrorMessage = useState<String?>(null);

    final password = useTextEditingController.fromValue(TextEditingValue.empty);
    final passwordObscure = useState(true);

    final confirmationPassword = useTextEditingController.fromValue(
      TextEditingValue.empty,
    );
    final confirmationPasswordObscure = useState(true);

    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        if (didPop) return;
        context.go('/onboarding');
      },
      child: AuthLayout(
        body: ListView(
          shrinkWrap: true,
          padding: const EdgeInsets.all(Sizes.p24),
          children: [
            Text(
              S.of(context).signUp,
              style: Theme.of(context)
                  .textTheme
                  .headlineMedium!
                  .copyWith(fontWeight: FontWeight.w600),
            ),
            gapH8,
            Text(
              S.of(context).pageSignUpDescription,
              style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
            ),
            gapH24,
            AuthForm(formKey: formKey, children: [
              TextFormField(
                controller: name,
                autofocus: true,
                decoration: InputDecoration(
                  label: Text('${S.of(context).inputNameLabel}*'),
                  hintText: S.of(context).inputNamePlaceholder,
                ),
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.name,
                validator: (str) => (str ?? '').isEmpty
                    ? S.of(context).errorNameValidationEmpty
                    : null,
              ),
              gapH16,
              TextFormField(
                controller: email,
                decoration: InputDecoration(
                  label: const Text('Email*'),
                  hintText: S.of(context).inputEmailPlaceholder,
                ),
                validator: (str) {
                  if ((str ?? '').isNotEmpty) {
                    return emailRegex.hasMatch(str!)
                        ? null
                        : S.of(context).errorEmailValidationInvalid;
                  }
                  return S.of(context).errorEmailValidationEmpty;
                },
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
              ),
              gapH16,
              InternationalPhoneNumberInput(
                countries: const ['ID'],
                onInputChanged: (val) {
                  phoneNumber.value = val;
                },
                onInputValidated: (validated) {
                  if (!validated) {
                    phoneErrorMessage.value =
                        S.of(context).errorPhoneValidationInvalid;
                  }
                  phoneErrorMessage.value = null;
                },
                ignoreBlank: false,
                initialValue: phoneNumber.value,
                textFieldController: phone,
                errorMessage: phoneErrorMessage.value,
                formatInput: true,
                inputDecoration: InputDecoration(
                  label: Text('${S.of(context).inputPhoneLabel}*'),
                  hintText: S.of(context).inputPhonePlaceholder,
                ),
                keyboardType: const TextInputType.numberWithOptions(
                  signed: true,
                  decimal: true,
                ),
                inputBorder: const OutlineInputBorder(),
                selectorConfig: const SelectorConfig(
                  selectorType: PhoneInputSelectorType.BOTTOM_SHEET,
                  useBottomSheetSafeArea: true,
                ),
                keyboardAction: TextInputAction.next,
              ),
              gapH16,
              TextFormField(
                controller: password,
                decoration: InputDecoration(
                  label: const Text('Password*'),
                  helperText: S.of(context).inputPasswordDescription,
                  helperMaxLines: 5,
                  hintText: S.of(context).inputPasswordPlaceholder,
                  suffixIcon: GestureDetector(
                    onTap: () {
                      passwordObscure.value = !passwordObscure.value;
                    },
                    child: PhosphorIcon(
                      passwordObscure.value
                          ? PhosphorIcons.eye(PhosphorIconsStyle.duotone)
                          : PhosphorIcons.eyeClosed(PhosphorIconsStyle.duotone),
                    ),
                  ),
                ),
                obscureText: passwordObscure.value,
                validator: (str) {
                  if ((str ?? '').isEmpty) {
                    return S.of(context).errorPasswordValidationEmpty;
                  } else if ((str ?? '').length < 8 ||
                      !passwordRegex.hasMatch(str ?? '')) {
                    return S.of(context).errorPasswordValidationInvalid;
                  }
                  return null;
                },
                keyboardType: TextInputType.visiblePassword,
                textInputAction: TextInputAction.next,
              ),
              gapH16,
              TextFormField(
                controller: confirmationPassword,
                obscureText: confirmationPasswordObscure.value,
                decoration: InputDecoration(
                  label:
                      Text('${S.of(context).inputConfirmationPasswordLabel}*'),
                  hintText: S.of(context).inputConfirmationPasswordLabel,
                  suffixIcon: GestureDetector(
                    onTap: () {
                      confirmationPasswordObscure.value =
                          !confirmationPasswordObscure.value;
                    },
                    child: PhosphorIcon(
                      confirmationPasswordObscure.value
                          ? PhosphorIcons.eye(PhosphorIconsStyle.duotone)
                          : PhosphorIcons.eyeClosed(PhosphorIconsStyle.duotone),
                    ),
                  ),
                ),
                validator: (str) {
                  if ((str ?? '').isEmpty) {
                    return S.of(context).errorPasswordValidationEmpty;
                  } else if ((str ?? '').length < 8) {
                    return S.of(context).errorPasswordValidationInvalid;
                  } else if ((str ?? '') != password.text) {
                    return S
                        .of(context)
                        .errorConfirmationPasswordValidationInvalid;
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
                          context.go('/auth/verification');
                          loading.value = false;
                        }
                      },
                child: loading.value
                    ? const CircularProgressIndicator()
                    : Text(S.of(context).signUp),
              )
            ]),
            gapH32,
            Center(
              child: Text.rich(
                TextSpan(
                  text: S.of(context).pageSignUpHadAccount,
                  children: [
                    TextSpan(
                      text: ' ${S.of(context).signIn}',
                      recognizer: TapGestureRecognizer()
                        ..onTap = () => context.go('/auth/signin'),
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
