import 'package:auto_size_text/auto_size_text.dart';
import 'package:clinic/features/profile/profile.dart';
import 'package:clinic/utils/sizes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rearch/flutter_rearch.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:skeletonizer/skeletonizer.dart';

class UncompleteProfileNotice extends RearchConsumer {
  const UncompleteProfileNotice({super.key, this.hideWhenComplete = false});

  final bool hideWhenComplete;

  @override
  Widget build(BuildContext context, WidgetHandle use) {
    final (data, placeholder) = use(profileText$);

    if (hideWhenComplete && data == null) return const SizedBox.shrink();

    final bool isUncomplete = data == null || data.isNotEmpty;

    return Card(
      elevation: 0,
      margin: EdgeInsets.zero,
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
                        'Lengkapi Personal Data',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      gapH8,
                      Text(
                        isUncomplete
                            ? 'Segera melengkapi personal data yang masih kosong.'
                            : 'Personal data kamu sudah terlengkapi!',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
                gapW16,
                SizedBox.square(
                  dimension: 72,
                  child: Card(
                    elevation: 0,
                    color: Theme.of(context).colorScheme.secondaryContainer,
                    child: PhosphorIcon(
                      PhosphorIconsDuotone.userCircleCheck,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                )
              ],
            ),
            gapH16,
            Skeletonizer(
              enabled: data == null,
              child: ListTile(
                onTap: () {},
                visualDensity: VisualDensity.compact,
                title: AutoSizeText(
                  data ?? placeholder,
                  minFontSize: 12,
                  maxFontSize: 14,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
                trailing: Skeleton.leaf(
                  child: isUncomplete
                      ? const Icon(Icons.arrow_right)
                      : const Icon(Icons.check),
                ),
                tileColor: isUncomplete
                    ? Theme.of(context).colorScheme.surface
                    : Theme.of(context).colorScheme.tertiaryContainer,
                textColor: isUncomplete
                    ? Theme.of(context).colorScheme.onSurface
                    : Theme.of(context).colorScheme.onTertiaryContainer,
                iconColor: isUncomplete
                    ? Theme.of(context).colorScheme.onSurface
                    : Theme.of(context).colorScheme.onTertiaryContainer,
                shape: RoundedRectangleBorder(
                  side: BorderSide(
                    color: isUncomplete
                        ? Theme.of(context).colorScheme.outlineVariant
                        : Theme.of(context).colorScheme.tertiaryFixedDim,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
