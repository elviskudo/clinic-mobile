import 'package:clinic/constants/sizes.dart';
import 'package:clinic/features/auth/auth.dart';
import 'package:clinic/widgets/layouts/auth.dart';
import 'package:clinic/widgets/submit_button.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pinput/pinput.dart';

class VerificationScreen extends StatelessWidget {
  const VerificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AuthLayout(
      body: Padding(
        padding: const EdgeInsets.all(Sizes.p24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              context.tr('page_verification_title'),
              style: Theme.of(context)
                  .textTheme
                  .headlineMedium!
                  .copyWith(fontWeight: FontWeight.w600),
            ),
            gapH8,
            Text(
              context.tr('page_verification_desc'),
              style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant),
            ),
            gapH24,
            const _VerificationForm(),
            gapH32,
            const _ResendOtpButton()
          ],
        ),
      ),
    );
  }
}

class _VerificationForm extends HookConsumerWidget {
  const _VerificationForm();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final form = useVerification(context, ref);

    return Form(
      key: form.formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Pinput(
            controller: form.pinputController,
            length: 6,
            pinputAutovalidateMode: PinputAutovalidateMode.onSubmit,
            validator: form.handlePinputValidation,
            onCompleted: (pin) => form.handleSubmit(pin: pin),
          ),
          gapH24,
          SubmitButton(
            onSubmit: form.handleSubmit,
            disabled: form.isLoading,
            loading: form.isLoading,
            child: Text(context.tr('verify')),
          ),
        ],
      ),
    );
  }
}

class _ResendOtpButton extends HookConsumerWidget {
  const _ResendOtpButton();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final resend = useResendOtp(context, ref);

    return Center(
      child: Text.rich(
        TextSpan(
          text: context.tr('page_verification_resend_notice'),
          children: [
            TextSpan(
              text: ' ${context.tr("resend")}',
              recognizer: TapGestureRecognizer()
                ..onTap = resend.enabled ? resend.handleSubmit : null,
              style: TextStyle(
                color: resend.enabled
                    ? Theme.of(context).colorScheme.primary
                    : Theme.of(context).colorScheme.onSurfaceVariant,
                fontWeight: FontWeight.w500,
              ),
            ),
            if (!resend.enabled) ...[
              TextSpan(
                text: ' (${resend.cooldown} s)',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                  fontWeight: FontWeight.w500,
                ),
              )
            ]
          ],
        ),
      ),
    );
  }
}
