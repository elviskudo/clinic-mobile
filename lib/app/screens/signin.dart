import 'package:flutter/material.dart';

import '../../constants/sizes.dart';
import '../../context.dart';
import '../../features/auth/view/widgets/form.dart';
import '../../widgets/scaffold_with_l10n_appbar.dart';

class SignInScreen extends StatelessWidget {
  const SignInScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ScaffoldWithL10nAppBar(
      body: ListView(
        padding: const EdgeInsets.all(Sizes.p24),
        shrinkWrap: true,
        children: [
          Text(
            context.locale.pageSignInTitle,
            style: Theme.of(context)
                .textTheme
                .headlineMedium!
                .copyWith(fontWeight: FontWeight.w600),
          ),
          gapH8,
          Text(
            context.locale.pageSignInDescription,
            style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
          ),
          gapH24,
          AuthForm(
            children: [
              FilledButton(
                onPressed: () {},
                child: Text(context.locale.signIn),
              )
            ],
          )
        ],
      ),
    );
  }
}
