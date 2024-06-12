import 'dart:async';

import 'package:clinic/constants/sizes.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class VerificationSuccessBottomSheet extends HookWidget {
  const VerificationSuccessBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    useEffect(() {
      final timer = Timer.periodic(
        const Duration(seconds: 5),
        (_) {
          context.go('/');
          if (context.canPop()) {
            context.pop();
          }
        },
      );

      return () => timer.cancel();
    }, []);

    return Card(
      elevation: 0,
      margin: const EdgeInsets.all(Sizes.p24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          PhosphorIcon(
            PhosphorIconsDuotone.checkCircle,
            color: Theme.of(context).colorScheme.primary,
            size: 32,
          ),
          gapH16,
          Text(
            context.tr('verification_success.title'),
            style: Theme.of(context).textTheme.headlineSmall,
            textAlign: TextAlign.center,
          ),
          gapH16,
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: Sizes.p16),
            child: Text(
              context.tr('verification_success.microcopy'),
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
