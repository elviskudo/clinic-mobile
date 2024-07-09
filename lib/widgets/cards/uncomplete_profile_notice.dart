import 'package:auto_size_text/auto_size_text.dart';
import 'package:clinic/constants/sizes.dart';
import 'package:clinic/features/user/hooks/use_uncomplete_profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:skeletonizer/skeletonizer.dart';

class UncompleteProfileNotice extends HookWidget {
  const UncompleteProfileNotice({super.key});

  @override
  Widget build(BuildContext context) {
    final profile = useUncompleteProfile(context);

    if ((profile.data ?? []).isEmpty) const SizedBox.shrink();

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
                      Skeletonizer(
                        enabled: profile.isLoading,
                        child: Text(
                          'Lengkapi Personal Data',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                      ),
                      gapH8,
                      Skeletonizer(
                        enabled: profile.isLoading,
                        child: const Text(
                            'Segera melengkapi personal data yang masih kosong.'),
                      ),
                    ],
                  ),
                ),
                gapW16,
                SizedBox.square(
                  dimension: 96,
                  child: Card(
                    elevation: 0,
                    color: Theme.of(context).colorScheme.secondaryContainer,
                    child: PhosphorIcon(
                      PhosphorIconsDuotone.userCircleCheck,
                      color: Theme.of(context).colorScheme.primary,
                      size: 40,
                    ),
                  ),
                )
              ],
            ),
            gapH24,
            Skeletonizer(
              enabled: profile.isLoading,
              child: ListTile(
                onTap: () {
                  // context.push('/account/personal');
                },
                title: AutoSizeText(
                  profile.isLoading
                      ? 'Segera lengkapi personal data kamu!'
                      : (profile.data ?? []).join(', '),
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
              ),
            )
          ],
        ),
      ),
    );
  }
}
