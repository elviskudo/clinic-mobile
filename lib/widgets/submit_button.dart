import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class SubmitButton extends HookWidget {
  const SubmitButton({
    super.key,
    required this.onSubmit,
    required this.child,
  });

  final FutureOr<void> Function() onSubmit;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final loading = useState(false);

    return FilledButton(
      onPressed: loading.value
          ? null
          : () async {
              loading.value = true;
              await onSubmit();
              loading.value = false;
            },
      child: loading.value
          ? SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(
                color: Theme.of(context).disabledColor,
                strokeWidth: 3,
              ),
            )
          : child,
    );
  }
}
