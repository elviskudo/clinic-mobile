import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../../../constants/sizes.dart';
import '../../../../l10n/generated/l10n.dart';
import '../../../../widgets/photo_profile.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const PhotoProfile(),
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
                  'Good morning',
                  style: Theme.of(context)
                      .textTheme
                      .headlineMedium!
                      .copyWith(fontWeight: FontWeight.w600),
                ),
                gapH8,
                Text(S.of(context).pageHomeMicrocopyDesc),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: const Padding(
        padding: EdgeInsets.only(bottom: Sizes.p16),
        child: FloatingActionButton.extended(
          onPressed: null,
          label: Text('Add Appoinment'),
          elevation: 4,
          icon: PhosphorIcon(
            PhosphorIconsRegular.calendarPlus,
          ),
        ),
      ),
    );
  }
}
