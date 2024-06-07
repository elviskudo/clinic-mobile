import 'package:clinic/constants/sizes.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class L10nSelectorBottomSheet extends StatefulWidget {
  const L10nSelectorBottomSheet({super.key});

  @override
  State<L10nSelectorBottomSheet> createState() =>
      _L10nSelectorBottomSheetState();
}

class _L10nSelectorBottomSheetState extends State<L10nSelectorBottomSheet> {
  void handleChange(Locale? locale) {
    context
        .setLocale(locale ?? const Locale('id'))
        .then((_) => Navigator.pop(context));
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: Sizes.p16),
            child: Text(
              context.tr('language'),
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(
              vertical: Sizes.p8,
              horizontal: Sizes.p16,
            ),
            child: Divider(),
          ),
          RadioListTile(
            value: const Locale('id'),
            title: const Text('Bahasa Indonesia'),
            groupValue: context.locale,
            onChanged: handleChange,
          ),
          RadioListTile(
            value: const Locale('en'),
            title: const Text('English'),
            groupValue: context.locale,
            onChanged: handleChange,
          ),
        ],
      ),
    );
  }
}
