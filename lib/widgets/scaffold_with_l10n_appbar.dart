import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../constants/sizes.dart';
import 'l10n_dropdown_button.dart';

class ScaffoldWithL10nAppBar extends ConsumerWidget {
  const ScaffoldWithL10nAppBar({super.key, required this.body});

  final Widget body;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        scrolledUnderElevation: 0,
        forceMaterialTransparency: true,
        title: Text(
          'Logo',
          style: Theme.of(context)
              .textTheme
              .titleLarge!
              .copyWith(fontFamily: 'CalSans'),
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: Sizes.p16),
            child: IntrinsicWidth(child: L10nDropdownButton()),
          ),
        ],
      ),
      body: body,
    );
  }
}
