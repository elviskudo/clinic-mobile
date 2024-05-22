import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../constants/sizes.dart';
import '../l10n/l10n.dart';

class L10nDropdownButton extends ConsumerWidget {
  const L10nDropdownButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DropdownButtonFormField<Locale>(
      value: ref.watch(appLocaleProvider),
      autofocus: false,
      enableFeedback: true,
      isDense: true,
      isExpanded: false,
      itemHeight: null,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(horizontal: Sizes.p8),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(100)),
        prefixIcon: PhosphorIcon(
          PhosphorIcons.globe(PhosphorIconsStyle.duotone),
          size: 20,
        ),
      ),
      icon: Padding(
        padding: const EdgeInsets.only(right: Sizes.p4),
        child: PhosphorIcon(PhosphorIcons.caretDown()),
      ),
      iconSize: 15,
      style: Theme.of(context)
          .textTheme
          .bodySmall!
          .copyWith(fontSize: 12, fontWeight: FontWeight.w500),
      borderRadius: BorderRadius.circular(12),
      items: const [
        DropdownMenuItem(
          value: Locale('id'),
          child: Padding(
            padding: EdgeInsets.only(right: Sizes.p16),
            child: Text('Indonesia'),
          ),
        ),
        DropdownMenuItem(value: Locale('en'), child: Text('English')),
      ],
      onChanged: (Locale? value) async {
        ref
            .read(appLocaleProvider.notifier)
            .setLocale(value ?? Locale(Intl.getCurrentLocale()));
      },
    );
  }
}
