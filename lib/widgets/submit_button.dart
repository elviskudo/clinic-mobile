import 'package:flutter/material.dart';

class SubmitButton extends StatelessWidget {
  const SubmitButton({
    super.key,
    required this.onSubmit,
    required this.child,
    this.disabled = false,
    this.loading = false,
  });

  final void Function() onSubmit;
  final Widget child;
  final bool disabled;
  final bool loading;

  @override
  Widget build(BuildContext context) {
    return FilledButton(
      onPressed: loading || disabled ? null : onSubmit,
      child: loading
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
