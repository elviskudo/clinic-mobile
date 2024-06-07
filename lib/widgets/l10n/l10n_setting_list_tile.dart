import 'package:clinic/widgets/l10n/l10n_selector_bottom_sheet.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class L10nSettingListTile extends StatelessWidget {
  const L10nSettingListTile({super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      dense: true,
      leading: PhosphorIcon(
        PhosphorIconsRegular.globe,
        color: Theme.of(context).colorScheme.primary,
      ),
      title: Text(context.tr('lang_tile_title')),
      subtitle: Text(
        context.locale.languageCode == 'id' ? 'Bahasa indonesia' : 'English',
      ),
      trailing: PhosphorIcon(
        PhosphorIconsRegular.caretRight,
        color: Theme.of(context).hintColor,
      ),
      onTap: () {
        showModalBottomSheet(
          context: context,
          showDragHandle: true,
          builder: (context) => const L10nSelectorBottomSheet(),
        );
      },
    );
  }
}
