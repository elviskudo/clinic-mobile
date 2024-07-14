import 'package:auto_size_text/auto_size_text.dart';
import 'package:clinic/features/profile/profile.dart';
import 'package:clinic/utils/sizes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rearch/flutter_rearch.dart';
import 'package:skeletonizer/skeletonizer.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(Sizes.p24),
          shrinkWrap: true,
          children: [
            RearchBuilder(
              builder: (context, use) {
                final (name, placeholder) = use(fullName$);
                return Skeletonizer(
                  enabled: name == null,
                  child: AutoSizeText(
                    'Welcome to Mayou Clinic ${name ?? placeholder}!',
                    style: Theme.of(context).textTheme.headlineSmall,
                    minFontSize: 18,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                );
              },
            ),
            gapH16,
            const Text(
              'How\'s your heath? Let\'s start by making appointment with our profesional doctors!',
            ),
            gapH32,
            const UncompleteProfileNotice(hideWhenComplete: true),
            gapH32,
          ],
        ),
      ),
    );
  }
}
