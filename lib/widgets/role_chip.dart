import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class RoleChip extends StatelessWidget {
  const RoleChip({super.key, required this.role});

  final String role;

  @override
  Widget build(BuildContext context) {
    return Chip(
      label: Text(
        toBeginningOfSentenceCase(role),
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
    );
  }
}
