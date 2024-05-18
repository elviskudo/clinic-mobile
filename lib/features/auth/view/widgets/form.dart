import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../../../constants/sizes.dart';

class AuthForm extends StatelessWidget {
  const AuthForm({super.key, required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {},
                  icon: PhosphorIcon(
                    PhosphorIcons.appleLogo(PhosphorIconsStyle.duotone),
                  ),
                  label: const Text('Apple'),
                ),
              ),
              gapW16,
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {},
                  icon: PhosphorIcon(
                    PhosphorIcons.googleLogo(PhosphorIconsStyle.duotone),
                  ),
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
                'OR',
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
