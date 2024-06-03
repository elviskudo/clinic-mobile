import 'dart:async';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:go_router/go_router.dart';

import '../../../../constants/sizes.dart';
import '../../../../l10n/generated/l10n.dart';
import '../widgets/layout.dart';

class VerificationScreen extends HookWidget {
  const VerificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final resendInSeconds = useState(60);
    final resendEnabled = useState(false);

    useEffect(() {
      final timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        if (resendInSeconds.value != 0) {
          resendInSeconds.value--;
        } else {
          resendEnabled.value = true;
        }
      });

      return () => timer.cancel();
    }, [resendEnabled, resendInSeconds]);

    final otpCode = useState<List<String>>([]);
    final loading = useState(false);
    final errorMessage = useState('');

    void onSubmit(String value) async {
      errorMessage.value = '';
      if (value.isEmpty || value.length < 6) {
        errorMessage.value = S.of(context).errorVerificationEmpty;
      } else {
        context.go('/app/home');
      }
    }

    return AuthLayout(
      body: Padding(
        padding: const EdgeInsets.all(Sizes.p24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              S.of(context).verification,
              style: Theme.of(context)
                  .textTheme
                  .headlineMedium!
                  .copyWith(fontWeight: FontWeight.w600),
            ),
            gapH8,
            Text(
              S.of(context).pageVerificationDescription,
              style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
            ),
            gapH24,
            OtpTextField(
              showFieldAsBox: true,
              numberOfFields: 6,
              onCodeChanged: (code) {
                if (errorMessage.value.isNotEmpty) {
                  errorMessage.value = '';
                }
                otpCode.value.add(code);
              },
              enabledBorderColor: errorMessage.value.isNotEmpty
                  ? Theme.of(context).colorScheme.error
                  : Theme.of(context).colorScheme.outlineVariant,
              onSubmit: onSubmit,
              focusedBorderColor: Theme.of(context).colorScheme.primary,
            ),
            gapH8,
            if (errorMessage.value.isNotEmpty) ...[
              Text(
                errorMessage.value,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.error,
                ),
              )
            ],
            gapH24,
            FilledButton.icon(
              icon: loading.value
                  ? const Center(child: CircularProgressIndicator())
                  : const SizedBox.shrink(),
              onPressed:
                  loading.value ? null : () => onSubmit(otpCode.value.join('')),
              label: Text(S.of(context).verificationButtonText),
            ),
            gapH32,
            Center(
              child: Text.rich(
                TextSpan(
                  text: S.of(context).pageVerificationResendNotice,
                  children: [
                    TextSpan(
                      text: ' ${S.of(context).resend}',
                      recognizer: TapGestureRecognizer()
                        ..onTap = resendEnabled.value
                            ? () async {
                                resendInSeconds.value = 60;
                                resendEnabled.value = false;
                              }
                            : null,
                      style: TextStyle(
                        color: resendEnabled.value
                            ? Theme.of(context).colorScheme.primary
                            : Theme.of(context).colorScheme.onSurfaceVariant,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    if (!resendEnabled.value) ...[
                      TextSpan(
                        text: ' (${resendInSeconds.value} s)',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                          fontWeight: FontWeight.w500,
                        ),
                      )
                    ]
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
