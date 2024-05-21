import 'package:flutter/material.dart';
import 'package:websafe_svg/websafe_svg.dart';

import '../../../../constants/sizes.dart';
import '../../../../l10n/generated/l10n.dart';

class AuthForm extends StatelessWidget {
  const AuthForm({super.key, required this.formKey, required this.children});

  final GlobalKey<FormState> formKey;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: null,
                  icon: WebsafeSvg.asset('assets/icons/apple.svg', height: 16),
                  label: const Text('Apple'),
                ),
              ),
              gapW16,
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: null,
                  icon: WebsafeSvg.asset('assets/icons/google.svg', height: 16),
                  label: const Text('Google'),
                ),
              ),
            ],
          ),
          gapH24,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Expanded(child: Divider()),
              gapW8,
              Text(
                S.of(context).or.toUpperCase(),
                style: Theme.of(context)
                    .textTheme
                    .bodySmall!
                    .copyWith(color: Theme.of(context).dividerColor),
              ),
              gapW8,
              const Expanded(child: Divider()),
            ],
          ),
          gapH24,
          ...children
        ],
      ),
    );
  }
}
