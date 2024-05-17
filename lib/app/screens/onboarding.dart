import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../constants/sizes.dart';
import '../../context.dart';
import '../../widgets/l10n_dropdown_button.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
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
      body: Container(
        padding: const EdgeInsets.all(Sizes.p8).copyWith(bottom: 0),
        color: Theme.of(context).colorScheme.secondaryContainer,
        alignment: Alignment.bottomCenter,
        child: Container(
          padding: const EdgeInsets.all(Sizes.p24),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.background,
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(Sizes.p12),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                context.locale.pageOnboardingTitle('first'),
                style: Theme.of(context).textTheme.headlineLarge!.copyWith(
                      color: Theme.of(context).colorScheme.primary,
                      fontFamily: 'CalSans',
                    ),
              ),
              gapH16,
              Text(
                context.locale.pageOnboardingDescription('first'),
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
    );
  }
}
