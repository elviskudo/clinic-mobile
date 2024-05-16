import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../context.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  void redirect(BuildContext context, {required String path}) async {
    context.go(path);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: IntrinsicWidth(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              FilledButton(
                child: Text(context.locale!.signIn),
                onPressed: () {
                  redirect(context, path: '/signin');
                },
              ),
              OutlinedButton(
                child: Text(context.locale!.signUp),
                onPressed: () {
                  redirect(context, path: '/signup');
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
