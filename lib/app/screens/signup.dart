import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../constants/regex.dart';
import '../../constants/sizes.dart';
import '../../context.dart';
import '../../features/auth/view/widgets/form.dart';
import '../../widgets/scaffold_with_l10n_appbar.dart';

class SignUpScreen extends HookConsumerWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formKey = useMemoized(() => GlobalKey<FormState>());

    final name = useTextEditingController.fromValue(TextEditingValue.empty);
    final email = useTextEditingController.fromValue(TextEditingValue.empty);
    final phone = useTextEditingController.fromValue(TextEditingValue.empty);
    final password = useTextEditingController.fromValue(TextEditingValue.empty);
    final confirmationPassword =
        useTextEditingController.fromValue(TextEditingValue.empty);

    final phoneNumber = useState(PhoneNumber(isoCode: 'ID'));
    final phoneErrorMessage = useState<String?>(null);

    final passwordObscure = useState(true);
    final confirmationPasswordObscure = useState(true);

    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        if (didPop) return;
        context.go('/onboarding');
      },
      child: ScaffoldWithL10nAppBar(
        body: ListView(
          shrinkWrap: true,
          padding: const EdgeInsets.all(Sizes.p24),
          children: [
            Text(
              context.locale.signUp,
              style: Theme.of(context)
                  .textTheme
                  .headlineMedium!
                  .copyWith(fontWeight: FontWeight.w600),
            ),
            gapH8,
            Text(
              context.locale.pageSignUpDescription,
              style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
            ),
            gapH24,
            AuthForm(
              formKey: formKey,
              children: [
                TextFormField(
                  controller: name,
                  autofocus: true,
                  decoration: InputDecoration(
                    label: Text('${context.locale.inputNameLabel}*'),
                    hintText: context.locale.inputNamePlaceholder,
                  ),
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.name,
                  validator: (str) => (str ?? '').isEmpty
                      ? context.locale.errorNameValidationEmpty
                      : null,
                ),
                gapH16,
                TextFormField(
                  controller: email,
                  decoration: InputDecoration(
                    label: const Text('Email*'),
                    hintText: context.locale.inputEmailPlaceholder,
                  ),
                  validator: (str) {
                    if ((str ?? '').isNotEmpty) {
                      return emailRegex.hasMatch(str!)
                          ? null
                          : context.locale.errorEmailValidationInvalid;
                    }
                    return context.locale.errorEmailValidationEmpty;
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
                          context.locale.errorPhoneValidationInvalid;
                    }
                    phoneErrorMessage.value = null;
                  },
                  ignoreBlank: false,
                  initialValue: phoneNumber.value,
                  textFieldController: phone,
                  errorMessage: phoneErrorMessage.value,
                  formatInput: true,
                  inputDecoration: InputDecoration(
                    label: Text('${context.locale.inputPhoneLabel}*'),
                    hintText: context.locale.inputPhonePlaceholder,
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
                    hintText: context.locale.inputPasswordPlaceholder,
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
                      return context.locale.errorPasswordValidationEmpty;
                    } else if ((str ?? '').length < 8) {
                      return context.locale.errorPasswordValidationInvalid;
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
                    label: Text(
                        '${context.locale.inputConfirmationPasswordLabel}*'),
                    hintText: context.locale.inputConfirmationPasswordLabel,
                    suffixIcon: GestureDetector(
                      onTap: () {
                        confirmationPasswordObscure.value =
                            !confirmationPasswordObscure.value;
                      },
                      child: PhosphorIcon(
                        confirmationPasswordObscure.value
                            ? PhosphorIcons.eye(PhosphorIconsStyle.duotone)
                            : PhosphorIcons.eyeClosed(
                                PhosphorIconsStyle.duotone),
                      ),
                    ),
                  ),
                  validator: (str) {
                    if ((str ?? '').isEmpty) {
                      return context.locale.errorPasswordValidationEmpty;
                    } else if ((str ?? '').length < 8) {
                      return context.locale.errorPasswordValidationInvalid;
                    } else if ((str ?? '') != password.text) {
                      return context
                          .locale.errorConfirmationPasswordValidationInvalid;
                    }
                    return null;
                  },
                  keyboardType: TextInputType.visiblePassword,
                  textInputAction: TextInputAction.done,
                ),
                gapH24,
                FilledButton(
                  onPressed: () {
                    formKey.currentState!.validate();
                  },
                  child: Text(context.locale.signUp),
                )
              ],
            ),
            gapH32,
            Center(
              child: Text.rich(
                TextSpan(
                  text: context.locale.pageSignUpHadAccount,
                  children: [
                    TextSpan(
                      text: ' ${context.locale.signIn}',
                      recognizer: TapGestureRecognizer()
                        ..onTap = () => context.push('/auth/signin'),
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
