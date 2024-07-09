import 'package:clinic/constants/sizes.dart';
import 'package:clinic/features/auth/hooks/use_verification.dart';
import 'package:clinic/widgets/submit_button.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:form_validator/form_validator.dart';
import 'package:pinput/pinput.dart';

class VerificationForm extends HookWidget {
  const VerificationForm({super.key});

  @override
  Widget build(BuildContext context) {
    final form = useVerification(context);

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
            validator:
                ValidationBuilder(localeName: context.locale.languageCode)
                    .required()
                    .minLength(6, context.tr('verification_invalid'))
                    .build(),
            onCompleted: (pin) => form.submit(pin: pin),
          ),
          gapH24,
          SubmitButton(
            onSubmit: form.submit,
            disabled: form.isLoading,
            loading: form.isLoading,
            child: Text(context.tr('verify')),
          ),
        ],
      ),
    );
  }
}
