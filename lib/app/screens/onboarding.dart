import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../constants/sizes.dart';
import '../../context.dart';
import '../widgets/l10n_dropdown_button.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text(
          'Logo',
          style: Theme.of(context)
              .textTheme
              .titleLarge!
              .copyWith(fontFamily: 'CalSans'),
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: Sizes.p16),
            child: IntrinsicWidth(child: L10nDropdownButton()),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(Sizes.p24),
        child: Center(
          child: IntrinsicWidth(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  context.locale.pageOnboardingTitle('first'),
                  style: Theme.of(context)
                      .textTheme
                      .headlineLarge!
                      .copyWith(color: Theme.of(context).colorScheme.primary),
                ),
                gapH16,
                Text(
                  context.locale.pageOnboardingTitle('first'),
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                gapH24,
                FilledButton(
                  child: Text(context.locale.signIn),
                  onPressed: () {
                    context.push('/auth/signin');
                  },
                ),
                gapH8,
                OutlinedButton(
                  child: Text(context.locale.signUp),
                  onPressed: () {
                    context.push('/auth/signup');
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
