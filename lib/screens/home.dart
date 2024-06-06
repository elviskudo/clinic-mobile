import 'package:clinic/constants/sizes.dart';
import 'package:clinic/data/queries/profile.dart';
import 'package:clinic/widgets/photo_profile.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class HomeScreen extends HookWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final profile = useProfile();

    return Scaffold(
      appBar: AppBar(
        title: PhotoProfile(url: profile.data?.imageUrl),
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
                Text(
                  context.tr(
                    'home_greet_title',
                    namedArgs: {'name': profile.data?.fullName ?? ''},
                  ),
                  style: Theme.of(context)
                      .textTheme
                      .headlineMedium!
                      .copyWith(fontWeight: FontWeight.w600),
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
