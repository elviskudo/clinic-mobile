import 'dart:async';

import 'package:fl_query_hooks/fl_query_hooks.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:go_router/go_router.dart';
import 'package:native_toast/native_toast.dart';

import '../../../../constants/sizes.dart';
import '../../../../di/locator.dart';
import '../../../../l10n/generated/l10n.dart';
import '../../../../widgets/submit_button.dart';
import '../../data/auth_repo.dart';
import '../../models/verification/verification_request_body.dart';
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
    final errorMessage = useState('');

    final mutation =
        useMutation<void, dynamic, VerificationRequestBody, dynamic>(
      'auth/verification',
      (reqBody) => locator.get<AuthRepository>().verification(reqBody),
      onData: (result, recovery) {
        context.go('/app/home');
      },
      onError: (error, recoveryData) {
        NativeToast().makeText(message: S.of(context).verificationError);
      },
      refreshQueries: ['profile'],
    );

    void onSubmit(String value) async {
      errorMessage.value = '';
      if (value.isEmpty || value.length < 6) {
        errorMessage.value = S.of(context).errorVerificationEmpty;
      } else {
        await mutation.mutate(
          VerificationRequestBody(
            otpCode: value,
          ),
        );
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
            SubmitButton(
              onSubmit: () => onSubmit(otpCode.value.join('')),
              child: Text(S.of(context).verificationButtonText),
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
                                locator.get<AuthRepository>().resendOtp();
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
