import 'package:clinic/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class SuccessBottomSheet extends StatelessWidget {
  const SuccessBottomSheet({
    super.key,
    required this.title,
    required this.subtitle,
  });

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
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
            title,
            style: Theme.of(context).textTheme.headlineSmall,
            textAlign: TextAlign.center,
          ),
          gapH16,
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: Sizes.p16),
            child: Text(
              subtitle,
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
