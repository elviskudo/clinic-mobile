import 'package:clinic/features/auth/auth.dart';
import 'package:clinic/pages/dash/dash_router.dart';
import 'package:clinic/utils/sizes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rearch/flutter_rearch.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:rearch/rearch.dart';

class VerificationSuccessScreen extends RearchConsumer {
  const VerificationSuccessScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetHandle use) {
    final (_, refresh) = use(futureCredential);

    use.callonce(() {
      refresh();
      Future.delayed(const Duration(seconds: 3)).then(
        (_) => const HomeRoute().replace(context),
      );
    });

    return BackButtonListener(
      onBackButtonPressed: () async => false,
      child: PopScope(
        canPop: false,
        child: Scaffold(
          body: Padding(
            padding: const EdgeInsets.all(Sizes.p24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                PhosphorIcon(
                  PhosphorIconsDuotone.checkCircle,
                  color: Theme.of(context).colorScheme.primary,
                  size: 32,
                ),
                gapH24,
                Text(
                  'Verification Success',
                  style: Theme.of(context).textTheme.titleMedium,
                  textAlign: TextAlign.center,
                ),
                gapH8,
                Text(
                  'Your email has been verified, redirecting to application...',
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium!
                      .copyWith(color: Theme.of(context).colorScheme.outline),
                  textAlign: TextAlign.center,
                ),
                gapH24,
                const SizedBox(
                  width: 120,
                  child: LinearProgressIndicator(
                    borderRadius: BorderRadius.all(
                      Radius.circular(99),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
