import 'package:flutter/material.dart';

Future showBusyDialog(BuildContext context) {
  return showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) => const _ModalDialogBusy(),
  );
}

class _ModalDialogBusy extends StatelessWidget {
  const _ModalDialogBusy();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }
}
