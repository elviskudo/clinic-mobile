import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../constants/sizes.dart';
import '../drivers/local_storage.dart';
import '../l10n/generated/l10n.dart';

class L10nDropdownButton extends ConsumerStatefulWidget {
  const L10nDropdownButton({super.key});

  @override
  ConsumerState<L10nDropdownButton> createState() => _L10nDropdownButtonState();
}

class _L10nDropdownButtonState extends ConsumerState<L10nDropdownButton> {
  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<Locale>(
      value: Locale(Intl.getCurrentLocale()),
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
        padding: const EdgeInsets.symmetric(horizontal: Sizes.p4),
        child: PhosphorIcon(PhosphorIcons.caretDown()),
      ),
      iconSize: 15,
      style: Theme.of(context)
          .textTheme
          .bodySmall!
          .copyWith(fontSize: 12, fontWeight: FontWeight.w600),
      borderRadius: BorderRadius.circular(12),
      items: const [
        DropdownMenuItem(value: Locale('id'), child: Text('ID')),
        DropdownMenuItem(value: Locale('en'), child: Text('EN')),
      ],
      onChanged: (Locale? value) async {
        onLocaleChanged(value ?? const Locale('id'));
      },
    );
  }

  void onLocaleChanged(Locale locale) async {
    await S.load(locale);
    await ref
        .read(sharedStorageProvider)
        .setString('app_locale', locale.languageCode);
  }
}
