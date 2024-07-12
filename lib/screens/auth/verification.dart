import 'package:auto_route/auto_route.dart';
import 'package:clinic/app_router.gr.dart';
import 'package:clinic/features/auth/auth.dart';
import 'package:clinic/ui/notification/toast.dart';
import 'package:clinic/utils/sizes.dart';
import 'package:fl_query_hooks/fl_query_hooks.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:form_validator/form_validator.dart';
import 'package:pinput/pinput.dart';
import 'package:toastification/toastification.dart';

import 'auth.dart';

@RoutePage()
class VerificationPage extends StatelessWidget {
  const VerificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        appBar: const AuthPageHeader(automaticallyImplyLeading: false),
        body: ListView(
          padding: const EdgeInsets.all(Sizes.p24),
          shrinkWrap: true,
          children: [
            Text(
              'Verify Your Email',
              style: Theme.of(context)
                  .textTheme
                  .headlineMedium!
                  .copyWith(fontWeight: FontWeight.w600),
            ),
            gapH8,
            Text(
              'Enter the verification code (OTP) that we have sent to your email.',
              style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
            ),
            gapH24,
            const _VerificationForm(),
            gapH32,
            const _ResendOtpButton(),
          ],
        ),
      ),
    );
  }
}

class _VerificationForm extends HookWidget {
  const _VerificationForm();

  @override
  Widget build(BuildContext context) {
    final formKey = useMemoized(() => GlobalKey<FormState>());

    final pinputCtrl = useTextEditingController();

    final mutation = useMutation(
      'email_verification',
      (String pin) async => await auth$.read(context).emailVerification(pin),
      refreshQueries: ['auth_credential'],
      onMutate: (_) {
        context.toast.loading(
          title: 'Authentication',
          message: 'Processing verification request...',
        );
      },
      onData: (data, _) {
        toastification.dismissAll();
        context.toast.success(
          title: 'Authentication',
          message: 'Your email has been verified successfully!',
        );
        context.replaceRoute(const DashboardRoute());
      },
      onError: (ex, _) {
        toastification.dismissAll();
        context.toast.error(
          title: 'Authentication',
          message: 'Cannot verify email address, please try again later.',
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
          Pinput(
            controller: pinputCtrl,
            length: 6,
            pinputAutovalidateMode: PinputAutovalidateMode.onSubmit,
            validator: ValidationBuilder(
              requiredMessage: 'Verification code cannot be empty',
            ).minLength(6, 'Please enter a valid verification code').build(),
            onCompleted: mutation.isMutating
                ? null
                : (pin) async {
                    await mutation.mutate(pin);
                  },
          ),
          gapH24,
          FilledButton(
            onPressed: mutation.isMutating
                ? null
                : () async {
                    if (formKey.currentState!.validate()) {
                      await mutation.mutate(pinputCtrl.text);
                    }
                  },
            child: const Text('Verify'),
          ),
        ],
      ),
    );
  }
}

class _ResendOtpButton extends HookWidget {
  const _ResendOtpButton();

  @override
  Widget build(BuildContext context) {
    final resend = useResendOtp(context);

    return Center(
      child: Text.rich(
        TextSpan(
          text: 'Did\'nt recieve the verification code yet?',
          children: [
            TextSpan(
              text: ' Resend',
              recognizer: TapGestureRecognizer()
                ..onTap =
                    () => resend.enabled ? resend.mutation.mutate(null) : null,
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
        textAlign: TextAlign.center,
      ),
    );
  }
}
