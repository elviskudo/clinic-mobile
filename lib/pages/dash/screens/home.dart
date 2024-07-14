import 'package:clinic/features/auth/auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rearch/flutter_rearch.dart';
import 'package:rearch/rearch.dart';

import '../../auth/auth_router.dart';

class HomeScreen extends RearchConsumer {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetHandle use) {
    final (:state, :mutate, clear: _) = use.mutation<void>();
    final future = use(signoutAction);

    void signout() {
      return mutate(
        future().then((_) => const OnboardingRoute().go(context)),
      );
    }

    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FilledButton(
            onPressed: state is AsyncLoading ? null : signout,
            child: const Text('Sign out'),
          ),
        ],
      ),
    );
  }
}
