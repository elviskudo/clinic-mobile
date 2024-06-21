import 'package:clinic/constants/sizes.dart';
import 'package:clinic/features/auth/auth.dart';
import 'package:clinic/widgets/layouts/auth.dart';
import 'package:clinic/widgets/submit_button.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

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
            const _SignUpForm(),
            gapH32,
            const _RedirectToSignIn()
          ],
        ),
      ),
    );
  }
}

class _SignUpForm extends HookConsumerWidget {
  const _SignUpForm();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final form = useSignUp(context, ref);

    return AuthForm(
      formKey: form.formKey,
      children: [
        TextFormField(
          controller: form.nameCtrl,
          autofocus: true,
          decoration: InputDecoration(
            label: Text(context.tr('name_field.label')),
            hintText: context.tr('name_field.placeholder'),
          ),
          textInputAction: TextInputAction.next,
          keyboardType: TextInputType.name,
          validator: form.handleNameValidation,
        ),
        gapH16,
        TextFormField(
          controller: form.emailCtrl,
          decoration: InputDecoration(
            label: const Text('Email*'),
            hintText: context.tr('email_field.placeholder'),
          ),
          validator: form.handleEmailValidation,
          keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.next,
        ),
        gapH16,
        InternationalPhoneNumberInput(
          countries: const ['ID'],
          onInputChanged: form.handlePhoneChange,
          onInputValidated: form.handlePhoneValidation,
          ignoreBlank: false,
          initialValue: form.phone,
          textFieldController: form.phoneCtrl,
          errorMessage: form.phoneErr,
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
          controller: form.passwordCtrl,
          decoration: InputDecoration(
            label: const Text('Password*'),
            helperMaxLines: 5,
            helperText: context.tr('password_field.criteria'),
            hintText: context.tr('password_field.placeholder'),
            suffixIcon: GestureDetector(
              onTap: form.handlePasswordObscure,
              child: PhosphorIcon(
                form.isObscuredPassword
                    ? PhosphorIcons.eye(PhosphorIconsStyle.duotone)
                    : PhosphorIcons.eyeClosed(PhosphorIconsStyle.duotone),
              ),
            ),
          ),
          obscureText: form.isObscuredPassword,
          validator: form.handlePasswordValidation,
          keyboardType: TextInputType.visiblePassword,
          textInputAction: TextInputAction.next,
        ),
        gapH16,
        TextFormField(
          controller: form.confirmPassCtrl,
          obscureText: form.isObscuredConfirmPass,
          decoration: InputDecoration(
            label: Text('${context.tr('confirmation_password_field.label')}*'),
            hintText: context.tr('password_field.placeholder'),
            suffixIcon: GestureDetector(
              onTap: form.handleConfirmPassObscure,
              child: PhosphorIcon(
                form.isObscuredConfirmPass
                    ? PhosphorIcons.eye(PhosphorIconsStyle.duotone)
                    : PhosphorIcons.eyeClosed(PhosphorIconsStyle.duotone),
              ),
            ),
          ),
          validator: form.handleConfirmPassValidation,
          keyboardType: TextInputType.visiblePassword,
          textInputAction: TextInputAction.done,
          onFieldSubmitted: (_) => form.handleSubmit(),
        ),
        gapH24,
        SubmitButton(
          onSubmit: form.handleSubmit,
          disabled: form.isLoading,
          loading: form.isLoading,
          child: Text(context.tr('signup')),
        )
      ],
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
          text: context.tr('page_signup_had_account'),
          children: [
            TextSpan(
              text: ' ${context.tr("signin")}',
              recognizer: TapGestureRecognizer()
                ..onTap = () => context.push('/signin'),
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
