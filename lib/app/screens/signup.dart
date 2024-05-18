import 'package:flutter/material.dart';

import '../../constants/sizes.dart';
import '../../context.dart';
import '../../features/auth/view/widgets/form.dart';
import '../../widgets/scaffold_with_l10n_appbar.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ScaffoldWithL10nAppBar(
      body: ListView(
        shrinkWrap: true,
        padding: const EdgeInsets.all(Sizes.p24),
        children: [
          Text(
            context.locale.signUp,
            style: Theme.of(context)
                .textTheme
                .headlineMedium!
                .copyWith(fontWeight: FontWeight.w600),
          ),
          gapH8,
          Text(
            context.locale.pageSignUpDescription,
            style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
          ),
          gapH24,
          AuthForm(
            children: [
              FilledButton(
                onPressed: () {},
                child: Text(context.locale.signUp),
              )
            ],
          )
        ],
      ),
    );
  }
}
