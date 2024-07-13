import 'package:clinic/utils/sizes.dart';
import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';

void showSuccessSheet(
  BuildContext context, {
  required String title,
  required String message,
}) {
  WoltModalSheet.show<Locale>(
    context: context,
    pageListBuilder: (context) => [
      SliverWoltModalSheetPage(
        hasTopBarLayer: true,
        isTopBarLayerAlwaysVisible: true,
        mainContentSlivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(Sizes.p24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  PhosphorIcon(
                    PhosphorIconsDuotone.checkCircle,
                    color: Theme.of(context).colorScheme.primary,
                    size: 32,
                  ),
                  gapH24,
                  Text(
                    title,
                    style: Theme.of(context).textTheme.titleMedium,
                    textAlign: TextAlign.center,
                  ),
                  gapH8,
                  Text(
                    message,
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium!
                        .copyWith(color: Theme.of(context).colorScheme.outline),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    ],
  );
}
