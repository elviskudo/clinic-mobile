import 'package:auto_size_text/auto_size_text.dart';
import 'package:clinic/constants/sizes.dart';
import 'package:clinic/providers/profile.dart';
import 'package:clinic/widgets/photo_profile.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(profileNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: PhotoProfile(url: profile?.imageUrl),
        actions: const [
          IconButton(
            onPressed: null,
            icon: PhosphorIcon(PhosphorIconsRegular.bellSimple),
          ),
          gapW4,
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(Sizes.p24),
              children: [
                AutoSizeText(
                  context.tr(
                    'home_greet_title',
                    namedArgs: {'name': profile?.fullName ?? ''},
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
