import 'package:auto_size_text/auto_size_text.dart';
import 'package:clinic/constants/sizes.dart';
import 'package:clinic/features/auth/auth.dart';
import 'package:clinic/features/clinic/clinic.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class HomeScreen extends HookConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final account = useAccountQuery(context, ref);
    final clinic = useCurrentClinicQuery(ref);

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size(0, 64),
        child: Padding(
          padding: const EdgeInsets.only(top: Sizes.p16),
          child: AppBar(
            title: Padding(
              padding: const EdgeInsets.only(left: Sizes.p8),
              child: PhotoProfile(url: account.data?.imageUrl),
            ),
            actions: const [
              IconButton(
                onPressed: null,
                icon: PhosphorIcon(PhosphorIconsRegular.bellSimple),
              ),
              gapW16,
            ],
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(Sizes.p24),
        shrinkWrap: true,
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AutoSizeText(
                context.tr(
                  'home_greet_title',
                  namedArgs: {
                    'name': account.data?.fullName ?? '',
                    'clinic': clinic.data?.name ?? '',
                  },
                ),
                style: Theme.of(context)
                    .textTheme
                    .headlineMedium!
                    .copyWith(fontWeight: FontWeight.w600),
                minFontSize: 18,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              gapH8,
              Text(context.tr('home_greet_desc')),
            ],
          ),
        ],
      ),
      floatingActionButton: const Padding(
        padding: EdgeInsets.only(bottom: Sizes.p16),
        child: FloatingActionButton(
          onPressed: null,
          elevation: 4,
          child: PhosphorIcon(
            PhosphorIconsRegular.calendarPlus,
          ),
        ),
      ),
    );
  }
}
