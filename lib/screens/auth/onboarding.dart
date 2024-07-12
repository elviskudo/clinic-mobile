import 'package:auto_route/auto_route.dart';
import 'package:clinic/app_router.gr.dart';
import 'package:clinic/utils/sizes.dart';
import 'package:flutter/material.dart';

@RoutePage()
class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(Sizes.p24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.all(Sizes.p24),
            child: Image.asset(
              'assets/images/onboarding.png',
              width: 200,
              height: 200,
              isAntiAlias: true,
              filterQuality: FilterQuality.high,
            ),
          ),
          gapH48,
          Text(
            'Welcome to Clinic!',
            style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.w600,
                ),
          ),
          gapH8,
          Text(
            'Experience the ease of scheduling medical checkup anytime, anywhere with our app.',
            style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
          ),
          gapH32,
          FilledButton(
            child: const Text('Sign in'),
            onPressed: () {
              context.pushRoute(const SigninRoute());
            },
          ),
          gapH16,
          OutlinedButton(
            child: const Text('Create an Account'),
            onPressed: () {
              context.pushRoute(const SignupRoute());
            },
          ),
        ],
      ),
    );
  }
}
