import 'dart:async';

import 'package:clinic/features/auth/auth.dart' as auth;
import 'package:clinic/ui/notification/toast.dart';
import 'package:clinic/utils/sizes.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rearch/flutter_rearch.dart';
import 'package:form_validator/form_validator.dart';
import 'package:pinput/pinput.dart';
import 'package:rearch/rearch.dart';

import '../auth_router.dart';

class VerificationScreen extends StatelessWidget {
  const VerificationScreen({
    super.key,
    this.shouldRequest = false,
  });

  final bool shouldRequest;

  @override
  Widget build(BuildContext context) {
    return BackButtonListener(
      onBackButtonPressed: () async => false,
      child: PopScope(
        canPop: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
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
            _ResendOtpButton(shouldRequest: shouldRequest),
          ],
        ),
      ),
    );
  }
}

class _VerificationForm extends RearchConsumer {
  const _VerificationForm();

  @override
  Widget build(BuildContext context, WidgetHandle use) {
    final formKey = use.memo(() => GlobalKey<FormState>());

    final pinputCtrl = use.textEditingController();

    final (:state, :mutate, clear: _) = use.mutation<void>();
    final future = use(auth.emailVerificationAction);

    void verify({String? pin}) {
      if (formKey.currentState!.validate()) {
        return mutate(
          future(pin ?? pinputCtrl.text).then<void>(
            (_) {
              const VerificationSuccessRoute().replace(context);
            },
          ).catchError(
            (_) {
              context.toast.error(
                message: 'Cannot verify email address, please try again later.',
              );
            },
          ),
        );
      }
    }

    return Form(
      key: formKey,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Pinput(
            autofocus: true,
            controller: pinputCtrl,
            length: 6,
            pinputAutovalidateMode: PinputAutovalidateMode.onSubmit,
            validator: ValidationBuilder(
              requiredMessage: 'Verification code cannot be empty',
            ).minLength(6, 'Please enter a valid verification code').build(),
            onCompleted:
                state is AsyncLoading ? null : (pin) => verify(pin: pin),
          ),
          gapH24,
          FilledButton(
            onPressed: state is AsyncLoading ? null : () => verify(),
            child: const Text('Verify'),
          ),
        ],
      ),
    );
  }
}

class _ResendOtpButton extends RearchConsumer {
  const _ResendOtpButton({this.shouldRequest = false});

  final bool shouldRequest;

  @override
  Widget build(BuildContext context, WidgetHandle use) {
    var (cooldown, setCooldown) = use.state(60);
    final (enabled, setEnabled) = use.state(false);

    final (state: _, :mutate, clear: _) = use.mutation<void>();
    final future = use(auth.resendEmailVerificationCodeAction);

    void resend() {
      setCooldown(60);
      setEnabled(false);

      mutate(
        future.then(
          (_) {
            nativeToast('Verification code has been sent to your email.');
          },
        ).catchError(
          (_) {
            nativeToast(
              'Failed to send verification code, please try again later.',
            );
          },
        ),
      );
    }

    use.callonce(() {
      if (shouldRequest) {
        resend();
      }
    });

    use.effect(() {
      final timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        if (cooldown != 0) {
          setCooldown(cooldown--);
        } else {
          setEnabled(true);
        }
      });

      return () => timer.cancel();
    }, [enabled, cooldown]);

    return Center(
      child: Text.rich(
        TextSpan(
          text: 'Did\'nt recieve the verification code yet?',
          children: [
            TextSpan(
              text: ' Resend',
              recognizer: TapGestureRecognizer()
                ..onTap = enabled ? resend : null,
              style: TextStyle(
                color: enabled
                    ? Theme.of(context).colorScheme.primary
                    : Theme.of(context).colorScheme.onSurfaceVariant,
                fontWeight: FontWeight.w500,
              ),
            ),
            if (!enabled) ...[
              TextSpan(
                text: ' ($cooldown s)',
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
