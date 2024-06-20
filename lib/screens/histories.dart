import 'package:clinic/constants/sizes.dart';
import 'package:clinic/providers/profile.dart';
import 'package:clinic/widgets/user/photo_profile.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class HistoriesScreen extends ConsumerWidget {
  const HistoriesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(profileNotifierProvider);

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size(0, 64),
        child: Padding(
          padding: const EdgeInsets.only(top: Sizes.p16),
          child: AppBar(
            title: Padding(
              padding: const EdgeInsets.only(left: Sizes.p8),
              child: PhotoProfile(url: profile?.imageUrl),
            ),
          ),
        ),
      ),
      body: const Center(
        child: Text('Histories page'),
      ),
    );
  }
}
