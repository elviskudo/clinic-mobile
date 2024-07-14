import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';

Future<Locale?> showL10nBottomSheet(BuildContext context) async {
  return await WoltModalSheet.show<Locale>(
    context: context,
    useRootNavigator: true,
    useSafeArea: true,
    pageListBuilder: (context) => [
      SliverWoltModalSheetPage(
        hasTopBarLayer: true,
        isTopBarLayerAlwaysVisible: true,
        topBarTitle: Text(
          'Choose Language',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        mainContentSlivers: [
          SliverList.list(
            children: [
              RadioListTile(
                title: const Text('Bahasa Indonesia'),
                value: const Locale('id'),
                groupValue: context.locale,
                onChanged: (val) {
                  context.setLocale(val ?? context.deviceLocale);
                  Navigator.pop(context, val);
                },
              ),
              RadioListTile(
                title: const Text('English'),
                value: const Locale('en'),
                groupValue: context.locale,
                onChanged: (val) {
                  context.setLocale(val ?? context.deviceLocale);
                  Navigator.pop(context, val);
                },
              ),
            ],
          ),
        ],
      ),
    ],
  );
}
