import 'package:flutter/material.dart';

class Verification extends StatelessWidget {
  final bool showCallback;

  const Verification({super.key, this.showCallback = false});

  @override
  Widget build(BuildContext context) {
    return showCallback
        ? const _VerificationCallback()
        : const Scaffold(
            body: Center(
              child: Text('Verification page'),
            ),
          );
  }
}

class _VerificationCallback extends StatelessWidget {
  const _VerificationCallback();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('Verification callback page'),
      ),
    );
  }
}
