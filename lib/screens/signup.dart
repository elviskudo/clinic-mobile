import 'package:clinic/constants/regex.dart';
import 'package:clinic/constants/sizes.dart';
import 'package:clinic/data/mutations/signup.dart';
import 'package:clinic/widgets/auth/auth_form.dart';
import 'package:clinic/widgets/auth/auth_layout.dart';
import 'package:clinic/widgets/submit_button.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class SignUpScreen extends HookWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final form = useSignUp(context);

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
              context.tr('page_signup_title'),
              style: Theme.of(context)
                  .textTheme
                  .headlineMedium!
                  .copyWith(fontWeight: FontWeight.w600),
            ),
            gapH8,
            Text(
              context.tr('page_signup_desc'),
              style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
            ),
            gapH24,
            AuthForm(
              formKey: form.key,
              children: [
                TextFormField(
                  controller: form.name,
                  autofocus: true,
                  decoration: InputDecoration(
                    label: Text(context.tr('name_field.label')),
                    hintText: context.tr('name_field.placeholder'),
                  ),
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.name,
                  validator: (str) => (str ?? '').isEmpty
                      ? context.tr('name_field.empty')
                      : null,
                ),
                gapH16,
                TextFormField(
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
                InternationalPhoneNumberInput(
                  countries: const ['ID'],
                  onInputChanged: (val) {
                    if (val.parseNumber().isEmpty) {
                      form.phoneErrorMessage.value =
                          context.tr('phone_field.empty');
                    } else {
                      form.phoneErrorMessage.value = null;
                    }

                    form.phoneNumber.value = val;
                  },
                  onInputValidated: (validated) {
                    if (!validated) {
                      form.phoneErrorMessage.value =
                          context.tr('phone_field.invalid');
                    } else {
                      form.phoneErrorMessage.value = null;
                    }
                  },
                  ignoreBlank: false,
                  initialValue: form.phoneNumber.value,
                  textFieldController: form.phone,
                  errorMessage: form.phoneErrorMessage.value,
                  formatInput: true,
                  inputDecoration: InputDecoration(
                    label: Text('${context.tr('phone_field.label')}*'),
                    hintText: context.tr('phone_field.placeholder'),
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
                  controller: form.password,
                  decoration: InputDecoration(
                    label: const Text('Password*'),
                    helperMaxLines: 5,
                    helperText: context.tr('password_field.criteria'),
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
                                PhosphorIconsStyle.duotone),
                      ),
                    ),
                  ),
                  obscureText: form.passwordObscure.value,
                  validator: (str) {
                    if ((str ?? '').isEmpty) {
                      return context.tr('password_field.empty');
                    } else if ((str ?? '').length < 8 ||
                        !passwordRegex.hasMatch(str ?? '')) {
                      return context.tr('password_field.invalid');
                    }
                    return null;
                  },
                  keyboardType: TextInputType.visiblePassword,
                  textInputAction: TextInputAction.next,
                ),
                gapH16,
                TextFormField(
                  controller: form.confirmationPassword,
                  obscureText: form.confirmationPasswordObscure.value,
                  decoration: InputDecoration(
                    label: Text(
                        '${context.tr('confirmation_password_field.label')}*'),
                    hintText: context.tr('password_field.placeholder'),
                    suffixIcon: GestureDetector(
                      onTap: () {
                        form.confirmationPasswordObscure.value =
                            !form.confirmationPasswordObscure.value;
                      },
                      child: PhosphorIcon(
                        form.confirmationPasswordObscure.value
                            ? PhosphorIcons.eye(PhosphorIconsStyle.duotone)
                            : PhosphorIcons.eyeClosed(
                                PhosphorIconsStyle.duotone),
                      ),
                    ),
                  ),
                  validator: (str) {
                    if ((str ?? '').isEmpty) {
                      return context.tr('password_field.empty');
                    } else if ((str ?? '').length < 8 ||
                        !passwordRegex.hasMatch(str ?? '')) {
                      return context.tr('password_field.invalid');
                    } else if ((str ?? '') != form.password.text) {
                      return context.tr('confirmation_password_field.invalid');
                    }
                    return null;
                  },
                  keyboardType: TextInputType.visiblePassword,
                  textInputAction: TextInputAction.done,
                ),
                gapH24,
                SubmitButton(
                  onSubmit: form.onSubmit,
                  disabled: form.isLoading,
                  loading: form.isLoading,
                  child: Text(context.tr('signup')),
                )
              ],
            ),
            gapH32,
            Center(
              child: Text.rich(
                TextSpan(
                  text: context.tr('page_signup_had_account'),
                  children: [
                    TextSpan(
                      text: ' ${context.tr("signin")}',
                      recognizer: TapGestureRecognizer()
                        ..onTap = () => context.go('/signin'),
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
