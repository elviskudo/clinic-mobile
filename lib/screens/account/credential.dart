import 'package:clinic/constants/regex.dart';
import 'package:clinic/constants/sizes.dart';
import 'package:clinic/data/mutations/profile.dart';
import 'package:clinic/widgets/submit_button.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class AccountCredentialScreen extends HookConsumerWidget {
  const AccountCredentialScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formKey = useMemoized(() => GlobalKey<FormState>());

    final password = useTextEditingController();
    final confirmation = useTextEditingController();

    final passwordObscure = useState(false);
    final confirmationObscure = useState(false);

    final changePassword = useChangePassword(
      context,
      ref,
      onData: () {
        formKey.currentState!.reset();
      },
    );

    return Scaffold(
      appBar: AppBar(title: Text(context.tr('account'))),
      body: SafeArea(
        child: ListView(
          shrinkWrap: true,
          children: [
            Text(
              'Password',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: password,
                    decoration: InputDecoration(
                      label: Text('${context.tr("new_password_field.label")}*'),
                      helperMaxLines: 5,
                      helperText: context.tr('new_password_field.criteria'),
                      hintText: context.tr('new_password_field.placeholder'),
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
                        return context.tr('new_password_field.empty');
                      } else if ((str ?? '').length < 8 ||
                          !passwordRegex.hasMatch(str ?? '')) {
                        return context.tr('new_password_field.invalid');
                      }
                      return null;
                    },
                    keyboardType: TextInputType.visiblePassword,
                    textInputAction: TextInputAction.next,
                  ),
                  gapH16,
                  TextFormField(
                    controller: confirmation,
                    obscureText: confirmationObscure.value,
                    decoration: InputDecoration(
                      label: Text(
                        '${context.tr('confirmation_password_field.label')}*',
                      ),
                      hintText: context.tr('password_field.placeholder'),
                      suffixIcon: GestureDetector(
                        onTap: () {
                          confirmationObscure.value =
                              !confirmationObscure.value;
                        },
                        child: PhosphorIcon(
                          confirmationObscure.value
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
                      } else if ((str ?? '') != password.text) {
                        return context
                            .tr('confirmation_password_field.invalid');
                      }
                      return null;
                    },
                    keyboardType: TextInputType.visiblePassword,
                    textInputAction: TextInputAction.done,
                  ),
                  gapH24,
                  SubmitButton(
                    onSubmit: () async {
                      if (formKey.currentState!.validate()) {
                        await changePassword.mutate({
                          'password': password.text,
                          'confirmPassword': confirmation.text,
                        });
                      }
                    },
                    child: const Text('Submit'),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
