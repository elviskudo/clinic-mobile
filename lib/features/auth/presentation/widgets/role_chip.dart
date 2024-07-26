import 'package:clinic/features/auth/auth.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rearch/flutter_rearch.dart';
import 'package:skeletonizer/skeletonizer.dart';

class RoleChip extends RearchConsumer {
  const RoleChip({super.key});

  @override
  Widget build(BuildContext context, WidgetHandle use) {
    final (role, placeholder) = use(role$);

    return Skeletonizer(
      enabled: role == null,
      child: Skeleton.leaf(
        child: Chip(
          label: Text(
            toBeginningOfSentenceCase(role ?? placeholder),
            style: Theme.of(context)
                .textTheme
                .bodySmall!
                .copyWith(color: Theme.of(context).colorScheme.primary),
          ),
          visualDensity: VisualDensity.compact,
          backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(99),
            side: BorderSide(color: Theme.of(context).colorScheme.primary),
          ),
        ),
      ),
    );
  }
}
