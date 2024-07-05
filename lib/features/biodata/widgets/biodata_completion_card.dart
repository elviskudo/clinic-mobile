import 'package:auto_size_text/auto_size_text.dart';
import 'package:clinic/constants/sizes.dart';
import 'package:clinic/features/biodata/biodata.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class BiodataCompletionCard extends HookConsumerWidget {
  const BiodataCompletionCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final uncompleteBio = useUncompleteBio(context, ref);

    if (uncompleteBio.isLoading ||
        uncompleteBio.hasError ||
        (uncompleteBio.data ?? []).isEmpty) {
      return const SizedBox.shrink();
    }

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        side: BorderSide(
          color: Theme.of(context).colorScheme.outlineVariant,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(Sizes.p16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Segera selesaikan data yang belum terselesaikan!',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      gapH8,
                      const Text('Lengkapi personal data di profil kamu.'),
                    ],
                  ),
                ),
                gapW16,
                SizedBox.square(
                  dimension: 128,
                  child: Card(
                    elevation: 0,
                    color: Theme.of(context).colorScheme.secondaryContainer,
                    child: PhosphorIcon(
                      PhosphorIconsDuotone.userCircleCheck,
                      color: Theme.of(context).colorScheme.primary,
                      size: 48,
                    ),
                  ),
                )
              ],
            ),
            gapH24,
            ListTile(
              onTap: () {
                context.push('/account/personal');
              },
              title: AutoSizeText(
                (uncompleteBio.data ?? []).join(', '),
                minFontSize: 14,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
              trailing: const Icon(Icons.arrow_right),
              tileColor: Theme.of(context).colorScheme.surface,
              shape: RoundedRectangleBorder(
                side: BorderSide(
                  color: Theme.of(context).colorScheme.outlineVariant,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
            )
          ],
        ),
      ),
    );
  }
}
