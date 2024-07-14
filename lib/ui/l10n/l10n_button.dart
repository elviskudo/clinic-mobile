import 'package:clinic/ui/l10n/l10n_bottom_sheet.dart';
import 'package:clinic/utils/sizes.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class L10nButton extends StatelessWidget {
  const L10nButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => showL10nBottomSheet(context),
      child: Chip(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(99),
          side: BorderSide(color: Theme.of(context).colorScheme.tertiary),
        ),
        backgroundColor:
            Theme.of(context).colorScheme.tertiaryContainer.withOpacity(0.4),
        label: Row(
          children: [
            PhosphorIcon(
              PhosphorIconsDuotone.globe,
              color: Theme.of(context).colorScheme.tertiary,
              size: 15,
            ),
            gapW8,
            Text(
              context.locale.languageCode == 'id' ? 'Indonesia' : 'English',
              style: Theme.of(context)
                  .textTheme
                  .labelSmall!
                  .copyWith(color: Theme.of(context).colorScheme.tertiary),
            ),
          ],
        ),
      ),
    );
  }
}
